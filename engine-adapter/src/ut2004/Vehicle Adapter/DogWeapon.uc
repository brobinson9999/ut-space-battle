class DogWeapon extends BaseObject;

var float reloadTime, reloadTimeRemaining; 
var vector weaponFireOffset;
var bool bFiring;

simulated function setFiring(bool bNewFiring, FlyingDog firer) {
  bFiring = bNewFiring;
}

simulated function tick(float delta, FlyingDog firer) {
  reloadTimeRemaining = FMax(reloadTimeRemaining - delta, 0);
  
  while (bFiring && reloadTimeRemaining <= 0) {
    fireWeapon(firer);
    
    reloadTimeRemaining += reloadTime;
  }
}

simulated function fireWeapon(FlyingDog firer);

simulated function vector getWeaponFireLocation(FlyingDog firer) {
  return firer.location;
}

simulated function vector getWeaponFireDirection(FlyingDog firer) {
  return vector(firer.getWeaponFireRotation());
}

simulated function drawCrosshair(Canvas canvas, FlyingDog firer) {
//  firer.drawPredictedHitLocationCrosshair(canvas, getWeaponFireLocation(firer), getWeaponFireDirection(firer), firer.crosshairTexture);
}

simulated function cleanup() {
  setFiring(false, none);
  
  super.cleanup();
}

defaultproperties
{
}
