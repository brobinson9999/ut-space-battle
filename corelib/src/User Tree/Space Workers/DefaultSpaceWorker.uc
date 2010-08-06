class DefaultSpaceWorker extends SpaceWorker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Tasks that the worker is assigned to.
  var array<PotentialTaskWorkerAssignment> assignments;

  var object        Assigned_Task_Target;
  var class<SpaceTask>   Assigned_Task_Type;
  var float         Assigned_Task_Bias_Weight;

  var float         persistenceModifierBase;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function addTask(SpaceTask task)
  {
    local PotentialTaskWorkerAssignment newPotentialAssignment;
    
    newPotentialAssignment = newPotentialAssignmentFor(task);
    assignments[assignments.length] = newPotentialAssignment;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function removeTask(SpaceTask task)
  {
    local int i;
    
    for (i=0;i<assignments.length;i++)
      if (assignments[i].task == task)
      {
        freeAndCleanupObject(assignments[i]);
        assignments.remove(i,1);
        break;
      }
  }

  simulated function removeAssignment(PotentialTaskWorkerAssignment assignment)
  {
    local int i;
    
    freeAndCleanupObject(assignment);

    for (i=0;i<assignments.length;i++)
      if (assignments[i] == assignment) {
        assignments.remove(i,1);
        break;
      }
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function PotentialTaskWorkerAssignment newPotentialAssignmentFor(SpaceTask task)
  {
    local PotentialTaskWorkerAssignment result;
    
    result = PotentialTaskWorkerAssignment(allocateObjectWithoutPropogation(class'PotentialTaskWorkerAssignment'));
    result.task = task;
    result.worker = self;
    
    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function array<PotentialTaskWorkerAssignment> getPotentialAssignments()
  {
    return assignments;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function evaluatePotentialAssignment(PotentialTaskWorkerAssignment assignment)
  {
    assignment.effectiveness = Evaluate_Effectiveness_Against(assignment.task);
    assignment.estimatedTimeToComplete = estimateTimeToComplete(assignment.task);
    assignment.estimatedDowntime = estimateDowntime(assignment.task);
    assignment.unmodifiedAssignmentPriority = (assignment.effectiveness * assignment.task.priority) - assignment.cost;
    assignment.assignmentPriority = assignment.unmodifiedAssignmentPriority;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function notifyAllocation(PotentialTaskWorkerAssignment assignment)
  {
    local int i;

    // Check if this assignment is for this worker.
    if (assignment.worker == self)
      recieve_Assignment_To(assignment.task);

    // Reduce the priority of other assignments in response.
    for (i=0;i<assignments.length;i++)
      modifyPriorityForAssignment(assignment, assignments[i]);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setTaskPreference(class<SpaceTask> Task_Class, object New_Target, float BiasWeight)
  {
    Assigned_Task_Type = Task_Class;
    Assigned_Task_Target = New_Target;
    Assigned_Task_Bias_Weight = BiasWeight;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // A task was just assigned to someone - give this worker the chance to change it's rating in response.
  simulated function modifyPriorityForAssignment(PotentialTaskWorkerAssignment assigned, PotentialTaskWorkerAssignment other)
  {
    // If this was assigned to me, zero out all other options.
    if (assigned.worker == self)
    {
      if (assigned.task != other.task)
        other.assignmentPriority = 0;
    } else {
      // Default is to reduce priority.
      if (assigned.task == other.task)
//        other.assignmentPriority *= 1;
        other.assignmentPriority *= 0.85;
//        other.assignmentPriority *= getAdditionalImpactFactor(assigned, other);
    }
  }
  
  // I think this still needs improvement. I think this model may break down when more than two workers are considered.
  simulated function float getAdditionalImpactFactor(PotentialTaskWorkerAssignment assigned, PotentialTaskWorkerAssignment other)
  {
    local float deltaDowntime;
    local float workAmount; // how much work there is to do.
    local float assignedRate; // the rate at which the assigned does work
    local float otherRate; // the rate at which this worker does work
    local float combinedRate; // the rate at which both workers can do work.
    local float remainingWorkAmount;
    
    if (assigned.estimatedTimeToComplete == 0 && other.estimatedTimeToComplete == 0)
      return 0.95;
      
    workAmount = 1;
    assignedRate = workAmount / assigned.estimatedTimeToComplete;
    otherRate = workAmount / other.estimatedTimeToComplete;
    combinedRate = assignedRate + otherRate;
    
    // How much sooned the assigned worker will get there than this worker.
    deltaDowntime = other.estimatedDowntime - assigned.estimatedDowntime;
    if (deltaDowntime >= 0) {
      // How much work will be left by the time both workers are started. If <= 0 this worker can't contribute at all.
      remainingWorkAmount = workAmount - (deltaDowntime * assignedRate);
      if (remainingWorkAmount <= 0)
        return 0;
      
      // I guess the factor can be what proportion of the work amount remains?
      // Relative speed at working I think is already captured in the effectiveness rating.
      // That still doesn't seem correct since any number of workers with identical arrival times can then be assigned.
      // I believe that I still have to factor in the rate.
      return (remainingWorkAmount / workAmount) * (otherRate / combinedRate);
    } else {
      remainingWorkAmount = workAmount - (abs(deltaDowntime) * otherRate);
      return 0.95;
    }
    
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function removeExpiredTasks()
  {
    local int i;
    
    super.removeExpiredTasks();

    for (i=assignments.length-1;i>=0;i--)
      if (!assignments[i].task.is_Relevant())
        removeAssignment(assignments[i]);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function copyTasks(SpaceWorker otherWorker) {
    local int i;

    for (i=0;i<assignments.length;i++)
      otherWorker.addTask(assignments[i].task);
  }
  
  simulated function clearTasks() {
    while (assignments.length > 0) {
      removeTask(assignments[0].task);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup() {
    clearTasks();
    setTaskPreference(none, none, 0);
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  persistenceModifierBase=1.1
}