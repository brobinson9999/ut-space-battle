class DogMissilePods extends DogWeapon;

var float lockAim;

function fireWeapon(FlyingDog firer) {
  local vector fireLocation;
  local rotator fireRotation;
  local PlayerController PC;
  local PROJ_SpaceFighter_Rocket rocket;
  local float bestAim, bestDist;

  fireLocation = firer.getFireLocation();
  fireRotation = firer.getWeaponFireRotation();

  rocket = firer.spawn(class'PROJ_SpaceFighter_Rocket', firer, , fireLocation, rotator(vector(fireRotation) + Vrand() * 0.05));
  if (firer.controller != none) {
    if (AIController(firer.controller) != None)
      // only homes on vehicles...
      rocket.HomingTarget = Vehicle(firer.controller.enemy);
    else
    {
      bestAim = lockAim;
      rocket.homingTarget = Vehicle(firer.controller.pickTarget(bestAim, bestDist, vector(fireRotation), fireLocation, 100000));
    }
  }

  // Play firing noise
  firer.playSound(Sound'AssaultSounds.HnShipFire01', SLOT_None,,,,, false);
  PC = PlayerController(firer.Controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");
}

function vector getWeaponFireOffset() {
  return vect(0,0,0);
}

defaultproperties
{
  reloadTime=1
  lockAim=0.975
}
