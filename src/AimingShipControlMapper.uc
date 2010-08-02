class AimingShipControlMapper extends ShipControlMapper;

var bool bInitialAimSet;
var rotator desiredAim;
var float aimSensitivity;
var vector shipThrust;

var DefaultShipController shipController;

simulated function DefaultShipController getShipController() {
  if (shipController == none) {
    shipController = new class'DefaultShipController';
    shipController.bUseDesiredRotation = true;

    // I have some benefit of drag to work with.
    shipController.useRotationRateFactor = 1.1;
  }
  
  return shipController;
}

simulated function cleanup() {
  if (shipController != none) {
    shipController.cleanup();
    shipController = none;
  }
  
  super.cleanup();
}

simulated function rotator getDesiredAim(rotator currentRotation) {
  if (!bInitialAimSet)
    setDesiredAim(currentRotation);
  
  return desiredAim;
}

simulated function setDesiredAim(rotator newAim) {
  desiredAim = newAim;
  bInitialAimSet = true;
}

simulated function updateControls(float deltaTime, rotator currentRotation, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange) {
  local rotator aimRotChange;

  aimRotChange.yaw = yawChange * aimSensitivity;
  aimRotChange.pitch = pitchChange * aimSensitivity;
  aimRotChange.roll = rollChange;
  
  setDesiredAim((aimRotChange + (getDesiredAim(currentRotation) unCoordRot currentRotation)) coordRot currentRotation);

  shipThrust = capVector(((vect(1,0,0) * fwdChange) + (vect(0,1,0) * strafeChange) + (vect(0,0,1) * upChange)), 1) coordRot currentRotation;
}

simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration) {
  local DefaultShipController localShipController;
  
  if (maximumRotationalAcceleration == 0)
    return vect(0,0,0);

  localShipController = getShipController();
  localShipController.desiredRotation = desiredAim;

  return localShipController.getDesiredRotationalAcceleration(physicsState, maximumRotationalAcceleration, deltaTime) / maximumRotationalAcceleration;
}

simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration) {
  return shipThrust;
}

simulated function rotator getWeaponFireRotation(rotator currentRotation) {
  return desiredAim;
}

defaultProperties
{
  aimSensitivity=0.25
}
