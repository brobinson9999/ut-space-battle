class FixedRelativePositionCameraStrategy extends CameraStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var vector relativePosition;
  var bool bRelativePositionScaledByRadius;
  var bool bFaceDesiredRotation;

  simulated function positionCamera(SpaceGameplayInterfaceConcreteBase interface) {
    local float positionScalar;
  
    if (interface.playerShip == none)
      return;
      
    if (bRelativePositionScaledByRadius)
      positionScalar = interface.playerShip.radius;
    else
      positionScalar = 1;
    
    if (bFaceDesiredRotation)
      interface.cameraRotation = interface.playerShip.desiredRotation;
    else
      interface.cameraRotation = interface.playerShip.rotation;
      
    interface.cameraLocation = interface.playerShip.getShipLocation() + ((relativePosition * positionScalar) coordRot interface.cameraRotation);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}