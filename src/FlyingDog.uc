class FlyingDog extends CommonFlyingDog;

//var vector  weaponFireOffset;
var float fireArc;

var private array<DogWeapon> weapons;

simulated function createWeapons();

simulated function array<DogWeapon> getWeapons() {
  return weapons;
}

simulated function addWeapon(DogWeapon newWeapon) {
  weapons[weapons.length] = newWeapon;
}

simulated function postBeginPlay() {
  super.postBeginPlay();
  
  createWeapons();
}

simulated event destroyed()
{
  while (weapons.length > 0) {
    weapons[0].cleanup();
    weapons.remove(0,1);
  }
  
  super.destroyed();
}

simulated function drawCrosshair(Canvas canvas) {
  local int i;
  
//  super.drawCrosshair(canvas);
  
  for (i=0;i<weapons.length;i++)
    weapons[i].drawCrosshair(canvas, self);
}

//simulated function vector getFireLocation() {
//  return location + (weaponFireOffset >> rotation);
//}

function vehicleFire(bool bWasAltFire) {
  super.vehicleFire(bWasAltFire);

  // Client can't do firing
  if(Role != ROLE_Authority)
    return;

  if (!bWasAltFire) {
    if (weapons.length > 0 && weapons[0] != none) {
      weapons[0].setFiring(true, self);
      weapons[0].tick(0, self);
    }
  } else {
    if (weapons.length > 1 && weapons[1] != none) {
      weapons[1].setFiring(true, self);
      weapons[1].tick(0, self);
    }
  }
}

function vehicleCeaseFire(bool bWasAltFire) {
  super.vehicleCeaseFire(bWasAltFire);

  // Client can't do firing
  if(Role != ROLE_Authority)
    return;

  if (!bWasAltFire) {
    if (weapons.length > 0 && weapons[0] != none) {
      weapons[0].setFiring(false, self);
      weapons[0].tick(0, self);
    }
  } else {
    if (weapons.length > 1 && weapons[1] != none) {
      weapons[1].setFiring(false, self);
      weapons[1].tick(0, self);
    }
  }
}

simulated function Tick(float Delta)
{
  local int i;

  Super.Tick(Delta);

  // Weapons (run on server and replicated to client)
  if(Role == ROLE_Authority)
  {
    if ((controller != none && controller.bFire > 0) != bWeaponIsFiring) {
      if (bWeaponIsFiring)
        clientVehicleCeaseFire(false);
      else
        fire();
    }

    if ((controller != none && controller.bAltFire > 0) != bWeaponIsAltFiring) {
      if (bWeaponIsAltFiring)
        clientVehicleCeaseFire(true);
      else
        altFire();
    }

    for (i=0;i<weapons.length;i++)
      weapons[i].tick(delta, self);
  }
}

// no radius damage for driver at this time..
function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, vector HitLocation);

defaultproperties
{
  fireArc=512
}
