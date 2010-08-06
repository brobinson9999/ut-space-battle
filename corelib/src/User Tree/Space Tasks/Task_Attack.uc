class Task_Attack extends SpaceTask;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var Contact       target;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Recieve_Assignment_To(SpaceWorker Worker)
  {
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool Is_Relevant()
  {
    if (target == none)
      return false;
      
    if (target.getSensorSignature() == 0)
      return false;
    
    if (!target.isHostile())
      return false;
      
    return true;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Cleanup()
  {
    Target = None;
    
    Super.Cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}