class ImperialTwinLascannon extends DogWeapon;

function fireWeapon(FlyingDog firer) {
  local vector start, end, hitLocation, hitNormal;
  local actor other;
  local float damage;
  local PlayerController PC;
  local HB_BeamEffect hb;

  start = getWeaponFireLocation(firer);
  end = start + (60000 * getWeaponFireDirection(firer));

  other = firer.trace(hitLocation, hitNormal, end, start, true);

  if (other == none)
    hitLocation = end;
  else {
    damage = 150;
    if (damage > 0)
      other.takeDamage(damage, firer.instigator, hitLocation, vect(0,0,0), class'DamTypeMASCannon');
  }

  // Play firing noise
  firer.playSound(sound'ONSVehicleSounds-S.TankFire01', SLOT_None,,,,, false);
  PC = PlayerController(firer.Controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");
    
  hb = firer.spawn(class'HB_BeamEffect',,, start, rotator(end - start));
  hb.setDrawScale(2);
  hb.hitLocation = hitLocation;
  hb.setupBeam();
}

defaultproperties
{
  reloadTime=0.5
}
