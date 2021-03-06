class SpaceGameplayInterfaceEngineSpecific extends SpaceGameplayInterfaceConcrete;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var Sound orderFailedSound, orderIssuedSound;
  
// UT2004 Specific Parts of the Interface.

  simulated function playOrderFailedSound() {
    playInterfaceSound(orderFailedSound);
  }
  
  simulated function playOrderIssuedSound(class<SpaceTask> orderClass) {
    playInterfaceSound(orderIssuedSound);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  orderFailedSound=Sound'2K4MenuSounds.Generic.msfxDrag'
  orderIssuedSound=Sound'AssaultSounds.TargetCycle01'
}