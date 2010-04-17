class MantaProjectileRenderable extends ScalableEmitterProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var int fragmentCountMin;
  var int fragmentCountMax;
  var float fragmentVelocityFactor;
  var float fragmentScaleFactor;
  var float fragmentFadeRate;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float getDrageeScale() {
    return super.getDrageeScale() * 1.15;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function impact()  {
    local int i;
    local int fragmentCount;
    
    updateLocation();

    fragmentCount = rand(fragmentCountMax - fragmentCountMin) + fragmentCountMin;
    for (i=0;i<fragmentCount;i++)
      spawnFragment();
    
    super.impact();
  }
  
  simulated function spawnFragment() {
    local vector fragmentVelocity;
    local MantaProjectileDragee fragment;
    
    fragmentVelocity = (VRand() * vsize(projectile.getVelocity()) * FRand() * fragmentVelocityFactor);

    fragment = MantaProjectileDragee(spawn(dragClass,,,location,rotator(fragmentVelocity)));
    fragment.setScale(drageeScale * fragmentScaleFactor * getGlobalDrawscaleFactor());
    fragment.startFading(fragmentFadeRate, fragmentVelocity);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  dragClass=class'MantaProjectileDragee'
  
  fragmentCountMin=5
  fragmentCountMax=10
  fragmentVelocityFactor=0.12
  fragmentScaleFactor=1
  fragmentFadeRate=1.5
  
  fireShakeMagnitude=50
  fireEffect=class'LinkMuzFlashProj3rd'
  fireSound=Sound'WeaponSounds.PulseRifle.PulseRifleFire'

  impactShakeMagnitude=75
}
