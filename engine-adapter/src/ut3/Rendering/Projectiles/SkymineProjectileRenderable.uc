class SkymineProjectileRenderable extends ParticleSystemProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	fireShakeMagnitude=25
	FireTemplate=ParticleSystem'VH_SPMA.Effects.P_VH_SPMA_SecondGin_MF'
	FireSound=SoundCue'A_Vehicle_Hellbender.SoundCues.A_Vehicle_Hellbender_BallFire'
	
	TrailTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball'

	impactShakeMagnitude=75
	ExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Explo'
	ExplosionSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_ComboExplosionCue'
	
	Drawscale=1
}
