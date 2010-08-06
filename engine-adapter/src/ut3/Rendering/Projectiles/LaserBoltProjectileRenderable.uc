class LaserBoltProjectileRenderable extends ParticleSystemProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// See UTProj_LinkPlasma - there are properties for color that can be set here.

defaultproperties
{
  // the muzzle flash looks a bit off - the particle system itself is not centered.
  fireShakeMagnitude=50
  fireTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Gun_MuzzleFlash'
  fireSound=(soundObject=SoundCue'A_Vehicle_Manta.SoundCues.A_Vehicle_Manta_Fire')
  
  trailTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'

  impactShakeMagnitude=75
  explosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
  explosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
}
