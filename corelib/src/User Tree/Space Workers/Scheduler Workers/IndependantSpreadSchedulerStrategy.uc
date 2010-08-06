class IndependantSpreadSchedulerStrategy extends IncrementalSchedulerStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// *** Assigns each worker to the tasks that worker is best for, irrespective of what any other workers are doing.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // A factor to introduce some randomness into the assignments. (reduces the effectiveness for lower difficulty levels)
  var float randomnessFactor;

  var int workerIndex;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function allocateWorkers(SchedulerSpaceWorker allocationClient, array<SpaceWorker> workers)
  {
    local int i;
    local int allocationCount;
    
    if (workers.length == 0) {
      allocationBudget = 0;
      return;
    }
    
    if (allocationBudget < 0)
      return;
      
    allocationCount = workers.length;
    for (i=0;i<allocationCount;i++) {
      workerIndex++;
      if (workerIndex >= workers.length)
        workerIndex = 0;

      allocationBudget -= allocateWorker(allocationClient, workers[workerIndex]);
      
      if (allocationBudget <= 0)
        return;
    }
    
    // If we made it here, we allocated everything without using our entire budget - just reset any unused portion.
    allocationBudget = 0;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function int allocateWorker(SchedulerSpaceWorker allocationClient, SpaceWorker worker)
  {
    local int i;
    local float bestPriority;
    local PotentialTaskWorkerAssignment bestAssignment;
    local PotentialTaskWorkerAssignment thisAssignment;
    local array<PotentialTaskWorkerAssignment> potentialAssignments;
    local int allocationCost;
    
    potentialAssignments = worker.getPotentialAssignments();
    allocationCost = potentialAssignments.length;
    
    for (i=0;i<potentialAssignments.length;i++) {
      worker.evaluatePotentialAssignment(potentialAssignments[i]);
      potentialAssignments[i].unmodifiedAssignmentPriority *= (1 + ((FRand()-0.5) * 2 * randomnessFactor));
      potentialAssignments[i].assignmentPriority = potentialAssignments[i].unmodifiedAssignmentPriority;
    }
      
    for (i=0;i<potentialAssignments.length;i++) {
      thisAssignment = potentialAssignments[i];
      if (thisAssignment.assignmentPriority > 0 && (thisAssignment.assignmentPriority > bestPriority || bestAssignment == None)) {
        bestAssignment = thisAssignment;
        bestPriority = bestAssignment.assignmentPriority;
      }
    }
    
    if (bestAssignment != none)
      allocationClient.notifyAllocation(bestAssignment);
      
    return allocationCost;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  workerIndex=-1
}