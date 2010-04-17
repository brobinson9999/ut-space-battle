class DefaultSpaceSchedulerStrategy extends SpaceSchedulerStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function allocateWorkers(SchedulerSpaceWorker client, array<SpaceWorker> workers)
  {
    local int i;
    local array<PotentialTaskWorkerAssignment> workerAssignments;
    
    // Get worker assignments.
    workerAssignments = getPotentialSubworkerAssignments(workers);

    // Assign initial priorities.
    for (i=0;i<workerAssignments.length;i++)
      workerAssignments[i].worker.evaluatePotentialAssignment(workerAssignments[i]);
    
    // Run allocation algorithm.
    allocatePotentialAssignments(client, workerAssignments);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function array<PotentialTaskWorkerAssignment> getPotentialSubworkerAssignments(array<SpaceWorker> workers)
  {
    local int i, j;
    local array<PotentialTaskWorkerAssignment> result;
    local array<PotentialTaskWorkerAssignment> subresult;
    
    // Iterate through all workers.    
    for (i=0;i<workers.length;i++)
    {
      // Get Results for this worker.
      subresult = workers[i].getPotentialAssignments();
      
      // Append.
      for (j=0;j<subresult.length;j++)
        result[result.length] = subresult[j];
    }
    
    // Return the result.
    return result;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function allocatePotentialAssignments(SchedulerSpaceWorker allocationClient, array<PotentialTaskWorkerAssignment> potentialAssignments)
  {
    local int i;
    local int bestIndex;
    local float bestPriority;
    local PotentialTaskWorkerAssignment bestAssignment;
    local PotentialTaskWorkerAssignment thisAssignment;

  //  local int iterations;
  //  local int totalCount;
  //  totalCount = potentialAssignments.length;

    // Loop until break.
    while (true)
    {
      // Find highest.
      bestPriority = 0;
      bestAssignment = None;
      for (i=potentialAssignments.length-1;i>=0;i--)
      {
        thisAssignment = potentialAssignments[i];
        if (thisAssignment.assignmentPriority == 0)
        {
          // Remove elements with zero priority. (performance optimization)
          potentialAssignments.remove(i,1);

          // If the best index is past this element we have to shift the index so it still points at the same element.
          if (bestIndex >= i)
            bestIndex--;
        }
        else if (thisAssignment.assignmentPriority > 0 && (thisAssignment.assignmentPriority > bestPriority || bestAssignment == None))
        {
          bestIndex = i;
          bestAssignment = thisAssignment;
          bestPriority = bestAssignment.assignmentPriority;
        }
      }

      // End if nothing was selected.
      if (bestAssignment == None)
        break;

      // Notify of selection.
      allocationClient.notifyAllocation(bestAssignment);

      // Remove highest.
      potentialAssignments.Remove(bestIndex,1);
    }
  }



// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}