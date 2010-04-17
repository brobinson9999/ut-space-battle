class IncrementalSchedulerStrategy extends SpaceSchedulerStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	var float allocationBudget;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function setAllocationBudgetDelta(float delta) {
		allocationBudget += delta;
	}
	
	simulated function allocateWorkers(SchedulerSpaceWorker client, array<SpaceWorker> workers);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}