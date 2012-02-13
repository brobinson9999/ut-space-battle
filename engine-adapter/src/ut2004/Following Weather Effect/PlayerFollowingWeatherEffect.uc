class PlayerFollowingWeatherEffect extends Emitter;

var float maxParticleDistance;
var float spawnRangeFactor;

simulated function tick(float delta) {
  local vector cameraLocation;
  local int i;
  
  super.tick(delta);
  
  cameraLocation = getCameraLocation();
  setLocation(cameraLocation);
  
  for (i=0;i<emitters.length;i++)
    moveParticles(emitters[i], cameraLocation);
}

simulated function moveParticles(ParticleEmitter particleEmitter, vector cameraLocation) {
  local int i;

  particleEmitter.sphereRadiusRange.min = maxParticleDistance * spawnRangeFactor;
  particleEmitter.sphereRadiusRange.max = maxParticleDistance;
  for (i=0;i<particleEmitter.activeParticles;i++) {
    if (vsize(particleEmitter.particles[i].location - cameraLocation) > maxParticleDistance)
      particleEmitter.particles[i].location = cameraLocation + (((1-spawnRangeFactor) + (frand() * spawnRangeFactor)) * vrand() * maxParticleDistance);
  }
}

simulated function vector getCameraLocation() {
  local PlayerController pc;
  
  pc = level.getLocalPlayerController();
  if (pc.pawn != none)
    return pc.pawn.location;
  else
    return pc.location;
}

defaultproperties
{
  spawnRangeFactor=0.5
  maxParticleDistance=1000

  autoDestroy=false
  autoReset=false
  
  bNoDelete=false
  bBlockActors=False
  RemoteRole=ROLE_None
  Physics=PHYS_None
  bHardAttach=True
}
