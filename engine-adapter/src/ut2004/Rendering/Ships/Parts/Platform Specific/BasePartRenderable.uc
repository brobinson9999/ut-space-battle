class BasePartRenderable extends BasePartRenderableBase;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var class<ScalableEmitter>            thrustTrailClass;
var class<ScalableEmitter>            damagedTrailClass;
var class<ScalableEmitter>            criticalTrailClass;

var float                             baseSoundPitchAdjust;
var float                             soundPitchRangeAdjust;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setupObservers() {
  local int i;
  local ThrustTrailFXObserver thrustTrailObserver;
  local ExplosionFXObserver explosionObserver;
  local TrailFXObserver trailObserver;

  for (i=0;i<trailOffsets.length;i++) {
    thrustTrailObserver = ThrustTrailFXObserver(addNewObserver(class'ThrustTrailFXObserver'));
    thrustTrailObserver.trailOffset = trailOffsets[i];
    thrustTrailObserver.trailClass = thrustTrailClass;
  }
  
  explosionObserver = ExplosionFXObserver(addNewObserver(class'DamagedExplosionFXObserver'));
  explosionObserver.emitterClass = class'FX_SmokeDebrisExplosion';
  explosionObserver.cameraShakeMagnitude = cameraShakeMagnitudeDamaged * part.physicalScale;
  explosionObserver.effectSounds[explosionObserver.effectSounds.length] = sound'weaponSounds.BExplosion1';
  explosionObserver.effectSounds[explosionObserver.effectSounds.length] = sound'weaponSounds.BExplosion2';
  explosionObserver.effectSounds[explosionObserver.effectSounds.length] = sound'weaponSounds.BExplosion3';
  trailObserver = TrailFXObserver(addNewObserver(class'DamagedTrailFXObserver'));
  trailObserver.trailClass = damagedTrailClass;
  
  explosionObserver = ExplosionFXObserver(addNewObserver(class'CriticalExplosionFXObserver'));
  explosionObserver.emitterClass = class'FX_SpaceFighter_Explosion';
  explosionObserver.cameraShakeMagnitude = cameraShakeMagnitudeCritical * part.physicalScale;
  trailObserver = TrailFXObserver(addNewObserver(class'CriticalTrailFXObserver'));
  trailObserver.trailClass = criticalTrailClass;

  explosionObserver = ExplosionFXObserver(addNewObserver(class'DestroyedExplosionFXObserver'));
  explosionObserver.cameraShakeMagnitude = cameraShakeMagnitudeDestroyed * part.physicalScale;
  explosionObserver.emitterClass = class'FX_SpaceFighter_Explosion';
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setScale(float newScale) {
    transientSoundVolume = default.transientSoundVolume * sqrt(newScale);   
    transientSoundRadius = default.transientSoundRadius * sqrt(newScale);   
    soundVolume = default.soundVolume * sqrt(newScale);   
    soundRadius = default.soundRadius * sqrt(newScale);   
  
    super.setScale(newScale);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function tick(float delta) {
    if (part != none && part.ship != none && part.ship.getShipPilot() != none) {
      soundPitch = (64 - (baseSoundPitchAdjust * sqrt(part.ship.getShipRadius()))) + (soundPitchRangeAdjust * FMin(1, VSize(part.ship.getShipPilot().desiredAcceleration) / part.ship.getShipMaximumAcceleration()));
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
/*
  SoundsPartImpacted(0)     =Sound'WeaponSounds.BArmorHit'
  SoundsPartImpacted(1)     =Sound'WeaponSounds.ImpactHammerFire'
  SoundsPartImpacted(2)     =Sound'WeaponSounds.ImpactHammerAltFire'
*/

  thrustTrailClass=class'FX_SpaceFighter_Trail_Blue'
  damagedTrailClass=class'FX_BillowingSmoke'
  criticalTrailClass=class'FX_SpaceFighter_ShotDownEmitter'
  
  AmbientSound=Sound'AssaultSounds.HnSpaceShipEng01'
  SoundRadius=300
  SoundVolume=255

  baseSoundPitchAdjust=1
  soundPitchRangeAdjust=20
  
  DrawType=DT_StaticMesh
  Drawscale=1

  bHidden=false
  bUnlit=false

  bBlockNonZeroExtentTraces=true
  bBlockZeroExtentTraces=true
}