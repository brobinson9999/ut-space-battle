class MapperDog extends ImprovedDragIntegratorDog;

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

simulated function receivedProcessedInput(float deltaTime, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange) {
  local ShipControlMapper localMapper;
  
  localMapper = getControlMapper();
  localMapper.updateControls(deltaTime, rotation, fwdChange, strafeChange, upChange, yawChange, pitchChange, rollChange);
  
  shipSteering = localMapper.getShipSteering(deltaTime, getPhysicsState(), maximumRotationalAcceleration);
  shipThrust = localMapper.getShipThrust(deltaTime, getPhysicsState(), maximumThrust);
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
