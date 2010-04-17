class MantaProjectileRenderable extends ParticleSystemProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	// the muzzle flash looks a bit off - the particle system itself is not centered.
	fireShakeMagnitude=50
	fireTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Gun_MuzzleFlash'
	fireSound=SoundCue'A_Vehicle_Manta.SoundCues.A_Vehicle_Manta_Fire'
	
	trailTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Projectile'

	impactShakeMagnitude=75
  explosionTemplate = ParticleSystem'VH_Manta.Effects.PS_Manta_Gun_Impact'
  explosionSound=SoundCue'A_Vehicle_Manta.SoundCues.A_Vehicle_Manta_Shot'
}
