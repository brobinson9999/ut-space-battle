class DefaultSchedulerSpaceWorker extends SchedulerSpaceWorker;

var class<SpaceSchedulerStrategy> schedulerStrategyClass;

simulated function SpaceSchedulerStrategy getSchedulerStrategy() {
  local SpaceSchedulerStrategy superResult;
  
  superResult = super.getSchedulerStrategy();
  if (superResult == none)  {
    setSchedulerStrategy(SpaceSchedulerStrategy(allocateObject(schedulerStrategyClass)));
    superResult = super.getSchedulerStrategy();
  }

  return superResult;
}

defaultproperties
{
  schedulerStrategyClass=class'DefaultSpaceSchedulerStrategy'
}