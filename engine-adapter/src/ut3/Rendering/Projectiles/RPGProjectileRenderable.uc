class RPGProjectileRenderable extends ParticleSystemProjectileRenderable;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	DrunkenRateMin=10000
	DrunkenRateMax=20000
	DrunkenMagnitudeMin=10
	DrunkenMagnitudeMax=100

	fireShakeMagnitude=100
	fireTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_MuzzleFlash'
	fireSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Fire_Cue'

	trailTemplate=ParticleSystem'VH_SPMA.Effects.P_VH_SPMA_MiniProjectile'
//	trailTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Contrail'

	impactShakeMagnitude=200
	explosionTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_MissileExplosion'
	explosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
}
