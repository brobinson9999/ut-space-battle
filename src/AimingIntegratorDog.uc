class AimingIntegratorDog extends MapperDog;

/*
simulated function ShipControlMapper createControlMapper() {
  local AimingShipControlMapper result;
  
  result = AimingShipControlMapper(super.createControlMapper());
  result.desiredAim = rotation;
  
  return result;
}
*/

defaultproperties
{
  controlMapperClass=class'AimingShipControlMapper'
}
