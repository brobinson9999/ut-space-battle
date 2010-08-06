class DogIonCannon extends DogWeapon;

var float beamDuration;
var class<Emitter>              BeamEffectClass;
var Emitter                     Beam;

var float beamFireDuration;
var float damagePerSecond;

var material reticleOnTarget, reticleOffTarget;

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
    setBeamDuration(0, none);
}

simulated function vector getWeaponFireDirection(FlyingDog firer) {
  local vector fireDirection, start, end, hitLocation, hitNormal;
  
  // determine the ideal fire angle to hit the spot that the ship's "aim" is pointing at.
  fireDirection = vector(firer.getWeaponFireRotation());
  start = firer.location;
  end = start + (60000 * fireDirection);
  firer.trace(hitLocation, hitNormal, end, start, true);
  
  // adjust for fire arc
  return class'ShipWeapon'.static.getBestFireDirection(normal(hitLocation - getWeaponFireLocation(firer)), vector(firer.rotation), firer.fireArc);
}

simulated function drawCrosshair(Canvas canvas, FlyingDog firer) {
  local vector fireDirection, start, end, hitLocation, hitNormal;
  local actor other;
  local Material crosshairTexture;

  fireDirection = getWeaponFireDirection(firer);
  start = getWeaponFireLocation(firer);
  end = start + (60000 * fireDirection);
  
  other = firer.trace(hitLocation, hitNormal, end, start, true);
  if (Pawn(other) != none)
    crosshairTexture = reticleOnTarget;
  else
    crosshairTexture = reticleOffTarget;
  
  firer.drawLocationCrosshair(canvas, hitLocation, crosshairTexture);
}

simulated function setBeamDuration(float newDuration, FlyingDog firer) {
  local Vector Start, End, HitLocation, HitNormal;
  local Actor Other;
  local float damage;

  if (newDuration <= 0) {
    if (beam != none) {
      beam.destroy();
      beam = none;
    }
    beamDuration = 0;
    return;
  }
  
  start = getWeaponFireLocation(firer);
  end = start + (60000 * getWeaponFireDirection(firer));

  other = firer.trace(hitLocation, hitNormal, end, start, true);

  if (other == none)
    hitLocation = end;
  else {
    damage = fmax(0, (beamDuration - newDuration) * damagePerSecond);
    if (damage > 0)
      other.takeDamage(damage, firer.instigator, hitLocation, vect(0,0,0), class'DamTypeMASCannon');
    firer.spawn(class'RocketExplosion',,, hitLocation, rotrand());
  }

  if (beam == none) {
    beam = firer.Spawn(beamEffectClass,,, start, rotator(start - hitLocation));
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

function vector getWeaponFireLocation(FlyingDog firer) {
  return firer.location + (vect(15, 40, -10) coordRot firer.rotation);
}

defaultproperties
{
  beamFireDuration=1
  damagePerSecond=600
  reloadTime=2

  BeamEffectClass=class'mONSMASCannonBeamEffect'
  
  reticleOnTarget=texture'ONSInterface-TX.avrilReticle'
  reticleOffTarget=texture'ONSInterface-TX.avrilReticleTrack'
}
