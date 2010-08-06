class InstagibBeamRenderable extends BeamRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  fireShakeMagnitude=75
  beamTemplate=ParticleSystem'WP_Shockrifle.Particles.P_Shockrifle_Instagib_Beam_Blue'
  fireSound=(soundObject=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_InstagibFireCue')

  impactShakeMagnitude=150
  impactTemplate=ParticleSystem'WP_Shockrifle.Particles.P_Shockrifle_Instagib_Impact_Blue'
  impactSound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_InstagibImpactCue'
}
