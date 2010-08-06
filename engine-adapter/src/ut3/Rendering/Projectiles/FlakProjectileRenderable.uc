class FlakProjectileRenderable extends ParticleSystemProjectileRenderable;
  
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

  fireShakeMagnitude=150
  fireTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_MuzzleFlash'
  fireSound=(soundObject=SoundCue'A_Weapon_Avril.WAV.A_Weapon_AVRiL_Fire01Cue')
  
  trailTemplate=ParticleSystem'VH_SPMA.Effects.P_VH_SPMA_PrimaryProjectile'
//  trailTemplate=ParticleSystem'VH_Cicada.Effects.P_VH_Cicada_Contrail'

  impactShakeMagnitude=500
  explosionTemplate=ParticleSystem'VH_SPMA.Effects.P_VH_SPMA_Primary_Shell_InAir_Explo'
  explosionSound=SoundCue'A_Weapon_Avril.WAV.A_Weapon_AVRiL_Impact01Cue'
}
