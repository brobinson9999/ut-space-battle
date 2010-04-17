class InterfaceInputObserver extends InputObserver;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var SpaceGameplayInterface Interface;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool KeyEvent(string Key, string Action, float Delta)
  {
    return Interface.KeyEvent(Key, Action, Delta);
  }

  simulated function Cleanup()
  {
    Interface = None;
    
    Super.Cleanup();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}