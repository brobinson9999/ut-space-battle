class AutoTaskCommandingWorkerDecorator extends SensingCommandingWorkerDecorator;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Automatically creates and sets up attack and defense tasks based on new sensor contacts, and removes these tasks when the contacts
// are lost.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var float defensePriorityFactor;

// Tasks that this worker has created. When this worker is cleaned up, these tasks are cleaned up too.
var array<SpaceTask> createdTasks;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function gainedContact(Contact other)
{
  local Task_Attack newAttackTask;
  local Task_Defense newDefenseTask;
  local int otherCurrentCondition;
  local int otherOptimalCondition;

  if (other.isFriendly()) {
    // Create a defense task.
    other.estimateTargetCondition(otherCurrentCondition, otherOptimalCondition);
    if (otherOptimalCondition > 3)
    {
      newDefenseTask = Task_Defense(allocateObject(class'Task_Defense'));
      newDefenseTask.target = other;
      newDefenseTask.priority = (other.estimateContactRadius() / other.estimateTargetVulnerability()) * defensePriorityFactor;
      addTask(newDefenseTask);
      createdTasks[createdTasks.length] = newDefenseTask;
    }
  } else if (other.isHostile()) {
    // Create an attack task.
    newAttackTask = Task_Attack(allocateObject(class'Task_Attack'));
    newAttackTask.target = other;
    newAttackTask.priority = other.estimateContactRadius();
    addTask(newAttackTask);
    createdTasks[createdTasks.length] = newAttackTask;
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Remove the contact from our list.
simulated function lostContact(Contact other)
{
  local int i;
  local SpaceTask associatedTask;

  // Remove any tasks associated with this item.
  for (i=assignments.length-1;i>=0;i--)
  {
    associatedTask = assignments[i].task;

    if (isContactTargetForTask(other, associatedTask))
      removeTask(associatedTask);
  }
}

simulated function bool isContactTargetForTask(Contact other, SpaceTask associatedTask)
{
   return ((Task_Attack(associatedTask)   != None && Task_Attack(associatedTask).target   == other)       ||
           (Task_Defense(associatedTask)  != None && Task_Defense(associatedTask).target  == other)       ||
           (Task_Patrol(associatedTask)   != None && Task_Patrol(associatedTask).target   == other));
}
 
simulated function cleanup() {
  while (createdTasks.length > 0) {
    createdTasks[0].cleanup();
    createdTasks.remove(0,1);
  }

  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  defensePriorityFactor=1
}