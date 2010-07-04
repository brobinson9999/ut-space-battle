class DogAutoCannon extends DogWeapon;

function fireWeapon(FlyingDog firer) {
  local vector fireLocation;
  local rotator fireRotation;
  local PlayerController PC;

  fireLocation = firer.getFireLocation();
  fireRotation = firer.getWeaponFireRotation();

  firer.spawn(class'ImperialAutocannonProjectile', firer, , fireLocation, fireRotation);

  // Play firing noise
  firer.playSound(sound'ONSVehicleSounds-S.TankFire01', SLOT_None,,,,, false);
  PC = PlayerController(firer.Controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");}

defaultproperties
{
  reloadTime=0.25
}
