class FlakProjectileRenderable extends DrunkenProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var Actor Trailer;
var Actor Trailer2;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function initializeProjectileRenderable() {
    super.initializeProjectileRenderable();
    
    setDrawscale(sqrt(projectile.damage) * 0.25);

    trailer = Spawn(class'FlakGlow', self);
    trailer.SetBase(self);

    trailer2 = Spawn(class'ONSAvrilSmokeTrail', Self,, Location, Rotation);
    trailer2.SetBase(self);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function DestroyTrails()
{
  if (Trailer != None)
      Trailer.Destroy();
  if (Emitter(Trailer2) != None)
    Emitter(Trailer2).Kill();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Destroyed()
{
  DestroyTrails();

  Super.Destroyed();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function ProcessTouch (Actor Other, vector HitLocation) {}
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated ) { return true; }
simulated event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType) {}
simulated singular event Touch(Actor Other) {}
simulated singular event HitWall(vector HitNormal, actor Wall) {}
simulated function bool CheckMaxEffectDistance(PlayerController P, vector SpawnLocation) { return true; }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function impact()
  {
    updateLocation();

    spawnScaledEffect(class'FX_FireballExplosion');

    super.impact();
  }
  
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

  Physics=PHYS_Rotating
  bFixedRotationDir=True
  RotationRate=(Roll=180000)

  bHidden=false
  DrawType=DT_StaticMesh
  StaticMesh=StaticMesh'WeaponStaticMesh.FlakShell'
  Skins(0)=texture'NewFlakSkin'
  DrawScale=1.0

  AmbientGlow=100

  AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
  SoundRadius=100
  SoundVolume=255

  fireShakeMagnitude=150
  fireEffect=class'FlakMuzFlash3rd'
  fireSound=(soundObject=Sound'WeaponSounds.FlakCannon.FlakCannonAltFire')

  impactShakeMagnitude=500
}
