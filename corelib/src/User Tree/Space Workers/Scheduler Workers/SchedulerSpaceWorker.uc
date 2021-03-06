class SchedulerSpaceWorker extends CompositeSpaceWorker;

var private SpaceSchedulerStrategy schedulerStrategy;

var float performanceFactor;
var private float performanceFactorMinUpdateTime;
var private ThrottledPeriodicAlarm selfUpdateAlarm;

simulated function setSchedulerStrategy(SpaceSchedulerStrategy newAlgorithm) {
  schedulerStrategy = newAlgorithm;
}

simulated function SpaceSchedulerStrategy getSchedulerStrategy() {
  return schedulerStrategy;
}

simulated function initializeWorker()
{
  getSelfUpdateAlarm().setPeriod(0.5);
  super.initializeWorker();
}

simulated function ThrottledPeriodicAlarm getSelfUpdateAlarm() {
  if (selfUpdateAlarm == none) {
    selfUpdateAlarm = ThrottledPeriodicAlarm(allocateObject(class'ThrottledPeriodicAlarm'));
    selfUpdateAlarm.throttleMultiplier = performanceFactor;
    selfUpdateAlarm.minimumPeriod = performanceFactorMinUpdateTime;
    selfUpdateAlarm.callBack = updateSelf;
  }
  
  return selfUpdateAlarm;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function updateWorker()
  {
    updateSelf();
    
    super.updateWorker();
  }
  
  simulated function updateSelf()
  {
    removeExpiredWorkers();
    removeExpiredTasks();
    
    allocateWorkers();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function allocateWorkers() {
    getSchedulerStrategy().allocateWorkers(self, workers);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function notifyAllocation(PotentialTaskWorkerAssignment assignment) {
    local int i;
    
    for (i=0;i<workers.length;i++)
      workers[i].notifyAllocation(assignment);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function addWorker(SpaceWorker other) {
    super.addWorker(other);
    
    // Make sure the worker's tasks are in sync with the composite's tasks.
    other.clearTasks();
    copyTasks(other);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup()
  {
    if (schedulerStrategy != None) {
      schedulerStrategy.cleanup();
      schedulerStrategy = None;
    }

    if (selfUpdateAlarm != none) {
      selfUpdateAlarm.cleanup();
      selfUpdateAlarm = none;
    }
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  performanceFactor=1
  performanceFactorMinUpdateTime=0.1
}