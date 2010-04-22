class BeamRenderable extends ProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Beams longer than this will be reduced to this length. The engine can only draw beams so long. I am not sure what the length is, this value is just a guess that seems to work ok.
  // It is possible that it might not actually be the beam's length, maybe it is a range the endpoint has to be in. I haven't tested too extensively.
  const maxBeamLength = 1000000;
  
  var ParticleSystem beamTemplate;
  var ParticleSystem impactTemplate;
//  var SoundCue  fireSound;
  var SoundCue  impactSound;

  var actor firedFrom;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function notifyProjectileFired(actor renderableFiredFrom) {
    super.notifyProjectileFired(renderableFiredFrom);
    
    if (renderableFiredFrom == none) return;

    if (fireSound.soundObject != none)
      playSoundStruct(fireSound,1,1,renderableFiredFrom);

    firedFrom = renderableFiredFrom;
  }

  // Set drawtype and other rendering parameters.
  simulated function spawnEmitters(actor renderableFiredFrom, vector start, vector end) {
    local ParticleSystemComponent beamInstance;
    local TransientParticleSystemRenderable transientRenderable;
    
    // the engine won't render a beam greater than a certain length, so shorten the beam if necessary.
    if (vSize(end - start) > maxBeamLength)
      end = start + (normal(end - start) * maxBeamLength);
      
    if (beamTemplate != none) {
      transientRenderable = spawnTransientEffect(beamTemplate, start, rotator(end - start), 0, drawScale, renderableFiredFrom);

      beamInstance = transientRenderable.getInstance();
      beamInstance.SetVectorParameter('ShockBeamEnd', end);
    }
  }


// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function impact() {
    local vector start, end;
    
    start = projectile.startLocation;
    end = projectile.endLocation;
    
    spawnEmitters(firedFrom, start, end);

    if (impactTemplate != none)
      spawnTransientEffect(impactTemplate, end, rotator(end-start), 0, drawScale, none);

    super.impact();

    destroy();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function missed() {
    local vector start, end;

    start = projectile.startLocation;
    end = projectile.endLocation + ((projectile.endLocation - projectile.startLocation) * 10);
    
    spawnEmitters(firedFrom, start, end);

    super.missed();
    
    destroy();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}
