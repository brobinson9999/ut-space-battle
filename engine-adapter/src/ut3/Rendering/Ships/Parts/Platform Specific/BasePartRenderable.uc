class BasePartRenderable extends BasePartRenderableBase;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var class<PersistentParticleSystemRenderable>			thrustTrailClass;
  var class<PersistentParticleSystemRenderable>			damagedTrailClass;
  var class<PersistentParticleSystemRenderable>			criticalTrailClass;

  var ParticleSystem 																partExplosionTemplate;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setupObservers() {
	local int i;
	local ThrustTrailFXObserver thrustTrailObserver;
	local ExplosionFXObserver explosionObserver;
	local TrailFXObserver trailObserver;

	for (i=0;i<trailOffsets.length;i++) {
		thrustTrailObserver = ThrustTrailFXObserver(addNewObserver(class'ThrustTrailFXObserver'));
		thrustTrailObserver.trailOffset = trailOffsets[i];
		thrustTrailObserver.trailClass = thrustTrailClass;
		thrustTrailObserver.emitterScaleFactor = 4;
	}
	
	explosionObserver = ExplosionFXObserver(addNewObserver(class'DamagedExplosionFXObserver'));
	explosionObserver.emitterClass = partExplosionTemplate;
	explosionObserver.emitterScaleFactor = 2;
	explosionObserver.cameraShakeMagnitude = cameraShakeMagnitudeDamaged * part.physicalScale;
	explosionObserver.effectSounds[explosionObserver.effectSounds.length] = SoundCue'A_Vehicle_SPMA.SoundCues.A_Vehicle_SPMA_Explode';
//  explosionObserver.effectSounds[explosionObserver.effectSounds.length] = sound'weaponSounds.BExplosion2';
//  explosionObserver.effectSounds[explosionObserver.effectSounds.length] = sound'weaponSounds.BExplosion3';
	trailObserver = TrailFXObserver(addNewObserver(class'DamagedTrailFXObserver'));
	trailObserver.trailClass = damagedTrailClass;
	trailObserver.emitterScaleFactor = 0.5;

	explosionObserver = ExplosionFXObserver(addNewObserver(class'CriticalExplosionFXObserver'));
	explosionObserver.emitterClass = partExplosionTemplate;
	explosionObserver.emitterScaleFactor = 5;
	explosionObserver.effectSounds[explosionObserver.effectSounds.length] = SoundCue'A_Vehicle_Manta.SoundCues.A_Vehicle_Manta_Explode';
	explosionObserver.cameraShakeMagnitude = cameraShakeMagnitudeCritical * part.physicalScale;
	trailObserver = TrailFXObserver(addNewObserver(class'CriticalTrailFXObserver'));
	trailObserver.trailClass = criticalTrailClass;
	trailObserver.emitterScaleFactor = 0.5;

	explosionObserver = ExplosionFXObserver(addNewObserver(class'DestroyedExplosionFXObserver'));
	explosionObserver.emitterClass = partExplosionTemplate;
	explosionObserver.emitterScaleFactor = 10;
	explosionObserver.effectSounds[explosionObserver.effectSounds.length] = SoundCue'A_Vehicle_Cicada.SoundCues.A_Vehicle_Cicada_Explode';
	explosionObserver.effectSounds[explosionObserver.effectSounds.length] = SoundCue'A_Vehicle_Goliath.SoundCues.A_Vehicle_Goliath_Explode';
	explosionObserver.cameraShakeMagnitude = cameraShakeMagnitudeDestroyed * part.physicalScale;
}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

/*
  simulated function createThrustTrails() {
		local int i;

		if (thrustTrailClass == none)
			return;
			
		for (i=0;i<trailOffsets.length;i++) {
			if (thrustTrails.length-1 < i || thrustTrails[i] == none) {
				thrustTrails[i] = spawn(thrustTrailClass, self,, location + ((trailOffsets[i] * drawscale * drawscale3D) CoordRot rotation), rotation);
				if (thrustTrails[i] != none) {
					thrustTrails[i].setBase(self);
					thrustTrails[i].setDrawscale(drawScale * 4);
				}
			}
		}
  }
*/
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  bHidden=false

	thrustTrailClass=class'FighterTrail'
	damagedTrailClass=class'SmokeTrail'
	criticalTrailClass=class'criticalTrail'
	
  partExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_GeneralExplosion'
  // ExplosionSound - SoundCue'A_Vehicle_Cicada.SoundCues.A_Vehicle_Cicada_Explode'
}