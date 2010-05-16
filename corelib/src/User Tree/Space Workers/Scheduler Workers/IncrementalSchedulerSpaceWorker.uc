class IncrementalSchedulerSpaceWorker extends DefaultSchedulerSpaceWorker;

// Does incremental allocations instead of doing them all at once.

var float budgetPerUpdate;

simulated function allocateWorkers() {
  local IncrementalSchedulerStrategy incrementalSchedulerStrategy;
  
  incrementalSchedulerStrategy = IncrementalSchedulerStrategy(getSchedulerStrategy());
  if (incrementalSchedulerStrategy != none)
    incrementalSchedulerStrategy.setAllocationBudgetDelta(budgetPerUpdate);

  super.allocateWorkers();
}

defaultproperties
{
  performanceFactor=0.3
  performanceFactorMinUpdateTime=0.1
  budgetPerUpdate=60
}