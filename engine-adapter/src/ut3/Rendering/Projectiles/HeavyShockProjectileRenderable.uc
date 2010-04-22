class HeavyShockProjectileRenderable extends ParticleSystemProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  fireShakeMagnitude=250
  fireSound=(soundObject=SoundCue'A_Vehicle_Paladin.SoundCues.A_Vehicle_Paladin_Fire')
  fireTemplate=ParticleSystem'VH_Paladin.Effects.P_VH_Paladin_Muzzleflash'

  trailTemplate=ParticleSystem'VH_Paladin.Effects.P_VH_Paladin_PrimaryProj'

  impactShakeMagnitude=500
  explosionTemplate=ParticleSystem'VH_Paladin.Particles.P_VH_Paladin_ProximityExplosion'
  explosionSound=SoundCue'A_Vehicle_Paladin.SoundCues.A_Vehicle_Paladin_ComboExplosion'
}
