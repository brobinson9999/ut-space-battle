// A dummy weapon to suppress "WhatToDoNext with no weapon" warnings.
class WeaponAdapter extends Weapon;

// These functions get called externally and their default implementation causes errors without other dependencies being present.
simulated function clientWeaponSet(bool bPossiblySwitch);
simulated function bringUp(optional Weapon prevWeapon);
simulated function timer();
simulated function bool isFiring();
function holderDied();

defaultproperties
{
  bCanThrow = false
}