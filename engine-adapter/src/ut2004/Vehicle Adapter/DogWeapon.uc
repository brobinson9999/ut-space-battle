class DogWeapon extends BaseObject;

var float reloadTime, reloadTimeRemaining; 
var vector weaponFireOffset;
var bool bFiring;

function fireWeapon(FlyingDog firer);

function tick(float delta, FlyingDog firer) {
  reloadTimeRemaining = FMax(reloadTimeRemaining - delta, 0);
  
  while (bFiring && reloadTimeRemaining <= 0) {
    fireWeapon(firer);
    
    reloadTimeRemaining += reloadTime;
  }
}

defaultproperties
{
}
