class SpaceWorker_Squad extends CompositeSpaceWorker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function addWorker(SpaceWorker other)
  {
    super.addWorker(other);
    
    // Make sure the worker's tasks are in sync with the composite's tasks.
    // 20090101: Don't think that squads need this necessarily, since they use the squad's tasks.
    other.clearTasks();
    copyTasks(other);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float Evaluate_Effectiveness_Against(SpaceTask Task)
  {
    local int i;
    local float result;
    
    for (i=0;i<workers.length;i++)
      result += workers[i].Evaluate_Effectiveness_Against(Task);
      
    return Result;
  }

  simulated function float Evaluate_Cost_Against(SpaceTask Task)
  {
    local int i;
    local float result;
    
    for (i=0;i<workers.length;i++)
      result += workers[i].Evaluate_Cost_Against(Task);
      
    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function int getMemberCount()
  {
    return workers.length;
  }
  
  simulated function array<SpaceWorker> getMemberList()
  {
    return workers;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool is_Relevant()
  {
    return (getMemberCount() > 0);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Recieve_Assignment_To(SpaceTask Task)
  {
    local int i;
    
    for (i=0;i<workers.length;i++)
      workers[i].Recieve_Assignment_To(Task);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup()
  {
    cleanupWorkers();
    
    Super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanupWorkers()
  {
    local int i;
    
    for (i=workers.length-1;i>=0;i--)
      if (!workers[i].is_Relevant())
        removeWorker(workers[i]);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}