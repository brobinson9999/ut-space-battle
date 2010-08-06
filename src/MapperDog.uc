class MapperDog extends ImprovedDragIntegratorDog;

var class<ShipControlMapper> controlMapperClass;

simulated function ShipControlMapper getControlMapper() {
  if (getShipCommon().getShipControlStrategy() == none)
    getShipCommon().setShipControlStrategy(createControlMapper());
  
  return ShipControlMapper(getShipCommon().getShipControlStrategy());
}

simulated function ShipControlMapper createControlMapper() {
  return new controlMapperClass;
}

simulated function receivedProcessedInput(float deltaTime, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange) {
  local ShipControlMapper localMapper;
  
  localMapper = getControlMapper();
  localMapper.updateControls(deltaTime, rotation, fwdChange, strafeChange, upChange, yawChange, pitchChange, rollChange);
  
//  shipSteering = localMapper.getShipSteering(deltaTime, getPhysicsState(), maximumRotationalAcceleration);
//  shipThrust = localMapper.getShipThrust(deltaTime, getPhysicsState(), maximumThrust);
}

simulated function rotator getWeaponFireRotation() {
  return getControlMapper().getWeaponFireRotation(rotation);
}

defaultProperties
{
  controlMapperClass=class'AimingShipControlMapper'
}
