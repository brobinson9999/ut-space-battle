class CommandingWorkerDecorator extends SpaceWorker_CommandDecorator;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var User                        user;
var Sector                      sector;
var SectorPresence              sectorPresence;

var float                       performanceFactor;
var float                       performanceFactorMinUpdateTime;
var ThrottledPeriodicAlarm      selfUpdateAlarm;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initialize()
{
//  setupNextUpdateEvent();
  getSelfUpdateAlarm().setPeriod(1);
  super.initialize();
}

//simulated function setupNextUpdateEvent()
//{
//  local float updateTime;
//
//  // If performanceFactor == 0 then the timer is disabled.
//  if (performanceFactor == 0) return;
//
//  updateTime = FMax(performanceFactorMinUpdateTime, getPerformanceThrottleFactor() * performanceFactor);
//
//  setTimer(updateTime);
//}

simulated function ThrottledPeriodicAlarm getSelfUpdateAlarm() {
  if (selfUpdateAlarm == none) {
    selfUpdateAlarm = ThrottledPeriodicAlarm(allocateObject(class'ThrottledPeriodicAlarm'));
    selfUpdateAlarm.throttleMultiplier = performanceFactor;
    selfUpdateAlarm.minimumPeriod = performanceFactorMinUpdateTime;
    selfUpdateAlarm.callBack = updateSelf;
  }
  
  return selfUpdateAlarm;
}

//simulated function timerElapsed()
//{
//  timerEvent = None;
//
//  updateSelf();
//
//  setupNextUpdateEvent();
//}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Update event on a timer. This update event does not propogate to the decorated object, while the normal update does. Using this instead
// of the regular update on the timer prevents all objects lower in the chain of decorators from being updated any time one is.
simulated function updateSelf();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup()
{
  user = none;
  sector = none;
  sectorPresence = none;

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
  performanceFactor=0
  performanceFactorMinUpdateTime=0
}