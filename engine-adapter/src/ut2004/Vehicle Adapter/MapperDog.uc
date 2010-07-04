class MapperDog extends ImprovedDragIntegratorDog abstract;

var class<ShipControlMapper> controlMapperClass;
var ShipControlMapper controlMapper;

simulated function ShipControlMapper getControlMapper() {
  if (controlMapper == none) {
    controlMapper = createControlMapper();
  }
  
  return controlMapper;
}

simulated function ShipControlMapper createControlMapper() {
  return new controlMapperClass;
}

simulated function receivedRotationInput(float deltaTime, float yawChange, float pitchChange, float rollChange) {
  local ShipControlMapper localMapper;
  
  localMapper = getControlMapper();
  localMapper.updateControls(deltaTime, rotation, yawChange, pitchChange, rollChange);
  
  shipSteering = localMapper.getShipSteering(deltaTime, getPhysicsState(), maximumRotationalAcceleration);
}

simulated function rotator getWeaponFireRotation() {
  return getControlMapper().getWeaponFireRotation(rotation);
}

simulated function destroyed() {
  if (controlMapper != none) {
    controlMapper.cleanup();
    controlMapper = none;
  }
  
  super.destroyed();
}

defaultProperties
{
  controlMapperClass=class'AimingShipControlMapper'
}
