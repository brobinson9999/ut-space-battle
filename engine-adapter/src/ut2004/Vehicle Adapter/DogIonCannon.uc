class DogIonCannon extends DogWeapon;

var float beamDuration;
var class<Emitter>              BeamEffectClass;
var Emitter                     Beam;

var float beamFireDuration;
var float damagePerSecond;

simulated function fireWeapon(FlyingDog firer) {
  local PlayerController PC;

  setBeamDuration(beamFireDuration, firer);

  // Play firing noise
  firer.playSound(Sound'ONSVehicleSounds-S.Laser02', SLOT_None,,,,, false);
  PC = PlayerController(firer.controller);
  if (PC != None && PC.bEnableWeaponForceFeedback)
    PC.ClientPlayForceFeedback("RocketLauncherFire");
}

simulated function setFiring(bool bNewFiring, FlyingDog firer) {
  super.setFiring(bNewFiring, firer);
  
  if (!bFiring && beamDuration > 0)
    setBeamDuration(0, firer);
}

simulated function setBeamDuration(float newDuration, FlyingDog firer) {
  local Vector X, Start, End, HitLocation, HitNormal;
  local Actor Other;
  local float damage;

  if (newDuration <= 0) {
    if (beam != none)
      beam.destroy();
    beamDuration = 0;
    return;
  }
  
  X = Vector(firer.getWeaponFireRotation());
  start = firer.getFireLocation();
  End = Start + (60000 * X);

  Other = firer.Trace(HitLocation, HitNormal, End, Start, True);

  if (Other == None)
    HitLocation = End;
  else {
    damage = fmax(0, (beamDuration - newDuration) * damagePerSecond);
    if (damage > 0)
      other.TakeDamage(damage, firer.Instigator, HitLocation, vect(0,0,0), class'DamTypeMASCannon');
    firer.spawn(class'RocketExplosion',,, hitLocation, rotrand());
  }

  if (beam == none) {
//    beam = firer.Spawn(beamEffectClass,,, start, rotator(start - hitLocation));
  } else {
    beam.setRotation(rotator(start - HitLocation));
    beam.setLocation(start);
  }
  if (beam != none) {
    BeamEmitter(beam.emitters[1]).beamDistanceRange.Min = VSize(start - HitLocation);
    BeamEmitter(beam.emitters[1]).beamDistanceRange.Max = VSize(start - HitLocation);
  }
  
  beamDuration = newDuration;  
}

function tick(float delta, FlyingDog firer) {
  super.tick(delta, firer);
  
  if (beamDuration > 0)
    setBeamDuration(beamDuration - delta, firer);
}

simulated function cleanup() {
  myAssert(beam == none || beamDuration > 0, "beam exists at cleanup only if beamDuration > 0");

  if (beamDuration > 0)
    setBeamDuration(0, none);
  
  myAssert(beam == none, "beam cleaned up after setting beamDuration to 0");

  super.cleanup();
}

function vector getWeaponFireOffset() {
  return vect(15, 40, -10);
}

defaultproperties
{
  beamFireDuration=1
  damagePerSecond=600
  reloadTime=2

  BeamEffectClass=class'mONSMASCannonBeamEffect'
}
