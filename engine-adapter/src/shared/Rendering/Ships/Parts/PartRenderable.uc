class PartRenderable extends BaseRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var Part part;

  var rotator rotationOffset;
  var vector locationOffset;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setPart(Part newPart) {
    part = newPart;
  }
  
  simulated function initialize();
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function clearPartRenderData() {
    destroy();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup()
  {
    part = none;
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setRenderLocation(vector newLocation) {
    setLocation(newLocation);
  }
  
  simulated function setRenderRotation(rotator newRotation) {
    setRotation(newRotation);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function FiredWeapon();
  simulated function notifyPartDamaged();
  simulated function notifyPartRepaired();
  simulated function notifyShipCritical();
  simulated function notifyShipDestroyed();
  simulated function notifyPartFiredWeapon(Projectile projectile);
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}