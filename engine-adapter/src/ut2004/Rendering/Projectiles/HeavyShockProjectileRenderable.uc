class HeavyShockProjectileRenderable extends ScalableEmitterProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function createDragees()
  {
    local Actor dragee;
    local vector StreakSize;
    
    dragee = spawn(dragClass,,,location, rotation);

    streakSize.Y = sqrt(projectile.damage) * 0.25;
    streakSize.Z = streakSize.Z;
    streakSize.X = VSize(projectile.endLocation - projectile.startLocation) / (projectile.endTime - projectile.startTime) * 0.001;
    dragee.setDrawscale3D(streakSize * getGlobalDrawscaleFactor());

    dragees[dragees.Length] = dragee;
  }
  
  simulated function impact()
  {
    updateLocation();

    spawn(class'ONSShockTankShockExplosion',,,location, rotRand());

    super.impact();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  dragClass=class'HeavyShockProjectileDragee'

  fireShakeMagnitude=250
  fireEffect=class'OnslaughtBP.ONSShockTankMuzzleFlash'
  fireSound=sound'ONSBPSounds.ShockTank.ShockBallFire'

  impactShakeMagnitude=500
}
