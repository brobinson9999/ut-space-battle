class StrategicCameraStrategy extends CameraStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var Contact focusContact;
  var vector focusLocation;
  var rotator cameraRotation;
  var float cameraDistance;
  
  var vector cameraRotationDirection;

  simulated function positionCamera(SpaceGameplayInterfaceConcreteBase interface) {
    if (focusContact != none) {
      focusLocation = focusContact.getContactLocation();
    }

    interface.cameraRotation = cameraRotation;
    interface.cameraLocation = focusLocation + ((cameraRotationDirection CoordRot cameraRotation) * cameraDistance);
  }

  simulated function cleanup() {
    focusContact = none;
    
    super.cleanup();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  cameraRotationDirection=(X=-1)
//  cameraRotationDirection=(X=-1,Z=0.5)
}