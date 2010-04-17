class ChaseCameraStrategy extends CameraStrategy;

// Should probably become a decorator at some point... so any camera strategy can be used with it.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var Contact                                 focusContact;

var Ship                                    cameraShip;
var AIPilot                                 chaseCameraShipPilot;
var Sector                                  chaseCameraSector;
var vector                                  chaseCameraRelativeLocation;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function positionCamera(SpaceGameplayInterfaceConcreteBase interface) {
  local AIPilot pilot;
  local Ship chaseCameraShip;
  local vector smoothedPosition;
  local Ship chasedShip;

  pilot = getCameraShipPilot();
  chaseCameraShip = getCameraShip();

  pilot.interceptTarget_Contact = focusContact;

  if (focusContact != none) {
    pilot.chasedContactLocation = focusContact.getContactLocation();

    chasedShip = focusContact.getOwnedShip();
    if (chasedShip != none)
      pilot.chasedContactRotation = chasedShip.desiredrotation;

    pilot.chasedContactRadius = focusContact.estimateContactRadius();
    pilot.chasedContactVelocity = focusContact.getContactVelocity();
  }

  pilot.cameraShip();
  myAssert(chaseCameraShip.getGameSimulation() != none, "chaseCameraShip.getGameSimulation() == none");
  chaseCameraShip.updateShip();

  if (focusContact != none) {
    // smoothed position is a blend between the camera ship's position and where the camera ship "should" be - kind of
    smoothedPosition = ((chaseCameraRelativeLocation + focusContact.getContactLocation()) * 0.9) + (chaseCameraShip.getShipLocation() * 0.1);
  } else {
    smoothedPosition = (interface.cameraLocation * 0.9) + (chaseCameraShip.getShipLocation() * 0.1);
  }

  interface.cameraRotation = chaseCameraShip.rotation;
  interface.cameraLocation = smoothedPosition;

  if (focusContact != none) {
    chaseCameraRelativeLocation = (interface.cameraLocation - focusContact.getContactLocation());
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function AIPilot getCameraShipPilot() {
  if (chaseCameraShipPilot == none) {
    chaseCameraShipPilot = AIPilot(allocateObject(class'AIPilot'));
    chaseCameraShipPilot.set_Ship(getCameraShip());
  }

  return chaseCameraShipPilot;
}

simulated function Ship getCameraShip() {
  local ShipFactory cameraShipFactory;
  
  if (cameraShip == none) {
    cameraShipFactory = getCameraShipFactory();
    cameraShip = SpaceGameSimulation(getGameSimulation()).createShip_OpenSpace(none, getChaseCameraSector(), vect(0,0,0), cameraShipFactory);
    cameraShipFactory.cleanup();
  }

  return cameraShip;
}

simulated function Sector getChaseCameraSector() {
  if (chaseCameraSector == none)
    chaseCameraSector = SpaceGameSimulation(getGameSimulation()).createNewSector();

  return chaseCameraSector;
}

simulated protected function ShipFactory getCameraShipFactory() { 
  return ShipFactory(allocateObject(class'CameraShipFactory'));
}

simulated function cleanup() {
  if (chaseCameraShipPilot != none) {
    chaseCameraShipPilot.cleanup();
    chaseCameraShipPilot = none;
  }
  
  if (cameraShip != none) {
    cameraShip.shipCritical(none);
    cameraShip.destroyTimeElapsed();
    cameraShip.cleanup();
    cameraShip = none;    
  }
  
  focusContact = none;
  
  if (chaseCameraSector != none) {
    chaseCameraSector.cleanup();
    chaseCameraSector = none;
  }

  super.cleanup();
}

  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}