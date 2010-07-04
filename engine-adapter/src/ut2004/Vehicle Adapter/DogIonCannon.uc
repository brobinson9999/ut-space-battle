class DogIonCannon extends DogWeapon;

function fireWeapon(FlyingDog firer) {
  local PlayerController PC;

  firer.setBeamDuration(1);

  // Play firing noise
  firer.playSound(Sound'ONSVehicleSounds-S.Laser02', SLOT_None,,,,, false);
  PC = PlayerController(firer.controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");
}

defaultproperties
{
  reloadTime=2
}
