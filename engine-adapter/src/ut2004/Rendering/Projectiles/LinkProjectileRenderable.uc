class LinkProjectileRenderable extends MovingProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Set drawtype and other rendering parameters.
  simulated function initializeProjectileRenderable() {
    local vector streakSize;
    
    super.initializeProjectileRenderable();
    
    streakSize.Y = projectile.damage * 1;
    streakSize.Z = StreakSize.Y;
    streakSize.X = VSize(projectile.endLocation - projectile.startLocation) / (projectile.endTime - projectile.startTime) * 0.001;
    setDrawscale3D(streakSize * getGlobalDrawscaleFactor());
  }
  
  simulated function Impact()  {
    updateLocation();

    spawn(class'FX_SmallFirePuff',,,location, rotRand());
    
    super.impact();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  bHidden=false

  AmbientGlow=217
  bDynamicLight=true
  LightType=LT_Steady
  LightEffect=LE_QuadraticNonIncidence
  LightRadius=3
  LightBrightness=255
  LightHue=100
  LightSaturation=100
  Physics=PHYS_Rotating
  bFixedRotationDir=True
  RotationRate=(Roll=180000)
  DrawType=DT_StaticMesh
  StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
  Drawscale=1
  Style=STY_Additive
  AmbientSound=Sound'WeaponSounds.ShockRifle.LinkGunProjectile'
  SoundRadius=50
  SoundVolume=255
  
  fireShakeMagnitude=50
  fireEffect=class'LinkMuzFlashProj3rd'
  fireSound=(soundObject=Sound'WeaponSounds.PulseRifle.PulseRifleFire')

  impactShakeMagnitude=75
}
