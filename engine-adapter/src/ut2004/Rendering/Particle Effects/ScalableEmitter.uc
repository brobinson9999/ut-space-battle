class ScalableEmitter extends Emitter;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var float currentScale;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// doesn't account for "global scale" - the caller must specify that.
simulated function setScale(float newScale) {
  local int i;
  local float scaleFactor;
  
  scaleFactor = newScale / currentScale;
  currentScale = newScale;
  
  for (i=0;i<emitters.length;i++)
    scaleEmitter(emitters[i], scaleFactor);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function scaleEmitter(ParticleEmitter emitter, float scaleFactor) {
  // Scaling functions common to all emitters.
  scaleGeneralEmitter(emitter, scaleFactor);

  // Specific to emitter type.
  if (SpriteEmitter(emitter) != none)
    scaleSpriteEmitter(SpriteEmitter(emitter), scaleFactor);
  else if (TrailEmitter(emitter) != none)
    scaleTrailEmitter(TrailEmitter(emitter), scaleFactor);
  else if (MeshEmitter(emitter) != none)
    scaleMeshEmitter(MeshEmitter(emitter), scaleFactor);
  else if (BeamEmitter(emitter) != none)
    scaleBeamEmitter(BeamEmitter(emitter), scaleFactor);
  else if (SparkEmitter(emitter) != none)
    scaleSparkEmitter(SparkEmitter(emitter), scaleFactor);
  else
    log("Tried to scale unknown type of emitter: "$emitter);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function scaleGeneralEmitter(ParticleEmitter emitter, float scaleFactor) {
  // Size.
  scaleRangeVector(emitter.startSizeRange, scaleFactor);

  // Location.
  scaleRange(emitter.sphereRadiusRange, scaleFactor);
  emitter.startLocationOffset *= scaleFactor;

  // Velocity.
  scaleRange(emitter.startVelocityRadialRange, scaleFactor);
  scaleRangeVector(emitter.startVelocityRange, scaleFactor);
  emitter.acceleration *= scaleFactor;

  // Scale Sound.
  soundRadius *= scaleFactor;
  soundVolume *= scaleFactor;
  transientSoundRadius *= scaleFactor;
  transientSoundVolume *= scaleFactor;
}

simulated function scaleSpriteEmitter(SpriteEmitter emitter, float scaleFactor) {
}

simulated function scaleTrailEmitter(TrailEmitter emitter, float scaleFactor) {
}

simulated function scaleMeshEmitter(MeshEmitter emitter, float scaleFactor) {
}

simulated function scaleBeamEmitter(BeamEmitter emitter, float scaleFactor) {
}

simulated function scaleSparkEmitter(SparkEmitter emitter, float scaleFactor) {
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function scaleRange(out range other, float scaleFactor) {
  other.min *= scaleFactor;
  other.max *= scaleFactor;
}

simulated function scaleRangeVector(out rangevector other, float scaleFactor) {
  scaleRange(other.x, scaleFactor);
  scaleRange(other.y, scaleFactor);
  scaleRange(other.z, scaleFactor);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  currentScale=1
  drawScale=1

  bNoDelete=false
}