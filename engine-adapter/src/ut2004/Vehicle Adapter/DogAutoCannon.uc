class DogAutoCannon extends DogWeapon;

function fireWeapon(FlyingDog firer) {
  local vector fireLocation, fireDirection;
  local PlayerController PC;

  fireLocation = getWeaponFireLocation(firer);
  fireDirection = getWeaponFireDirection(firer);

  // Play firing noise
  firer.playSound(sound'ONSVehicleSounds-S.TankFire01', SLOT_None,,,,, false);
  PC = PlayerController(firer.Controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");

  firer.spawn(class'ImperialAutocannonProjectile', none, , fireLocation, rotator(fireDirection + (vrand() * 0.005)));
}

defaultproperties
{
  reloadTime=0.25
}
