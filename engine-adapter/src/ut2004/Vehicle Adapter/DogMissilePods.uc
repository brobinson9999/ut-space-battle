class DogMissilePods extends DogWeapon;

var float lockAim;

var array<vector> fireOffsets;
var int fireOffset;

simulated function incrementFireOffset() {
  fireOffset = (fireOffset + 1) % fireOffsets.length;
}

simulated function vector getWeaponFireDirection(FlyingDog firer) {
  return vector(firer.rotation);
}

function vector getWeaponFireLocation(FlyingDog firer) {
  return firer.location + (fireOffsets[fireOffset] coordRot firer.rotation);
}


simulated function fireWeapon(FlyingDog firer) {
  local vector fireLocation;
  local vector fireDirection;
  local PlayerController PC;
  local TauRocketPodProjectile rocket;
  local float bestAim, bestDist;

  fireLocation = getWeaponFireLocation(firer);
  fireDirection = getWeaponFireDirection(firer);

  rocket = firer.spawn(class'TauRocketPodProjectile', firer, , fireLocation, rotator(fireDirection + Vrand() * 0.05));
  if (firer.controller != none) {
    if (AIController(firer.controller) != None)
      rocket.HomingTarget = firer.controller.enemy;
    else
    {
      bestAim = lockAim;
      rocket.homingTarget = firer.controller.pickTarget(bestAim, bestDist, vector(firer.getWeaponFireRotation()), fireLocation, 100000);
    }
  }

  // Play firing noise
  firer.playSound(sound'WeaponSounds.RocketLauncher.RocketLauncherFire', SLOT_None,,,,, false);
  PC = PlayerController(firer.Controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");
    
  incrementFireOffset();
}


defaultproperties
{
  reloadTime=0.25
  lockAim=0.975
  
//  texture'Crosshairs.HUD.Crosshair_Triad1' or 2 or 3
}
