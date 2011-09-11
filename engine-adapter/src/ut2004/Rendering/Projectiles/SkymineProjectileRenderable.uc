class SkymineProjectileRenderable extends ScalableEmitterProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function impact()
  {
    local ScalableEmitter shockBallExplosion;
    
    updateLocation();

    shockBallExplosion = spawn(class'ShockBallExplosion',,,location, rotRand());
    if (shockBallExplosion != none && projectile != none)
      shockBallExplosion.setScale(projectile.projectileBlastRadius * getGlobalDrawscaleFactor());

    super.impact();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  DragClass=class'ShockProjectileDragee'

  fireShakeMagnitude=25
  fireEffect=class'ShockProjMuzFlash3rd'
  fireSound=(soundObject=Sound'WeaponSounds.ShockRifle.ShockRifleAltFire')

  impactShakeMagnitude=75
}
