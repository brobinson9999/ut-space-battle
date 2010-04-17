class SpaceWorker extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initialize();

simulated function updateWorker();

// New task is available or old task is no longer available.
simulated function addTask(SpaceTask task);
simulated function removeTask(SpaceTask task);
simulated function clearTasks();

// Event called from ship or lower AI.
simulated function completedTask(SpaceTask task);
simulated function gaveUpTask(SpaceTask task);

// Gets a list of potential assignments.
simulated function array<PotentialTaskWorkerAssignment> getPotentialAssignments();

simulated function evaluatePotentialAssignment(PotentialTaskWorkerAssignment assignment);

simulated function notifyAllocation(PotentialTaskWorkerAssignment assignment);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float estimateTimeToComplete(SpaceTask task);
simulated function float estimateDowntime(SpaceTask task);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Used for workers which may have some kind of sub-workers.
simulated function addWorker(SpaceWorker other);
simulated function removeWorker(SpaceWorker other);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setTaskPreference(class<SpaceTask> Task_Class, object New_Target, float BiasWeight);

// A task was just assigned to someone - give this worker the chance to change it's rating in response.
simulated function modifyPriorityForAssignment(PotentialTaskWorkerAssignment assigned, PotentialTaskWorkerAssignment other);

simulated function float Evaluate_Effectiveness_Against(SpaceTask Task);
simulated function float Evaluate_Cost_Against(SpaceTask Task);

simulated function bool Is_Relevant() {
  return true;
}

simulated function Recieve_Assignment_To(SpaceTask Task);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function removeExpiredTasks();

// Used for workers which may have some kind of sub-workers.
simulated function removeExpiredWorkers();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}