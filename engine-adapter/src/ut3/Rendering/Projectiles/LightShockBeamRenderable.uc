class LightShockBeamRenderable extends BeamRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	fireShakeMagnitude=15
  beamTemplate=ParticleSystem'WP_Shockrifle.Particles.P_WP_Shockrifle_Beam'
  fireSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_FireCue'
  
	impactShakeMagnitude=35
  impactTemplate=ParticleSystem'WP_Shockrifle.Particles.P_Shockrifle_Instagib_Impact_Blue'
  impactSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_InstagibImpactCue'
}
