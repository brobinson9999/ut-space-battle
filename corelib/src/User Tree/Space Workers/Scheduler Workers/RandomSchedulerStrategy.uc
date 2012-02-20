class RandomSchedulerStrategy extends SpaceSchedulerStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// *** Assigns each worker to a totally random task, as long as they have non-zero effectiveness against that task.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function allocateWorkers(SchedulerSpaceWorker allocationClient, array<SpaceWorker> workers)
	{
		local int i;
		local PotentialTaskWorkerAssignment resultAssignment;
    local array<PotentialTaskWorkerAssignment> resultAssignments; 
    
		for (i=0;i<workers.length;i++) {
			resultAssignment = getAssignmentForWorker(workers[i]);
			if (resultAssignment != none)
				resultAssignments[resultAssignments.length] = resultAssignment;
		}

		for (i=0;i<resultAssignments.length;i++)
			allocationClient.notifyAllocation(resultAssignments[i]);
	}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function PotentialTaskWorkerAssignment getAssignmentForWorker(SpaceWorker worker)
	{
		local int i;
    local array<PotentialTaskWorkerAssignment> potentialAssignments;
    
    potentialAssignments = worker.getPotentialAssignments();

    for (i=potentialAssignments.length-1;i>=0;i--) {
    	worker.evaluatePotentialAssignment(potentialAssignments[i]);
    	if (potentialAssignments[i].assignmentPriority == 0)
    		potentialAssignments.remove(i,1);
    }
    	
		if (potentialAssignments.length == 0)
			return none;
		else
			return potentialAssignments[rand(potentialAssignments.length)];
	}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}