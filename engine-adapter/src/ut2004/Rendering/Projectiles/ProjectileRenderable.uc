class ProjectileRenderable extends BaseRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var Projectile projectile;
var private ProjectileRenderableProjectileObserver projectileObserver;
var vector worldLocation;

var class<actor>  fireEffect;
var Sound         fireSound;
var float         fireSoundBaseVolume;
var float         fireSoundBaseRadius;

var float         fireShakeMagnitude;

var float         impactShakeMagnitude;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initialize();

simulated function ProjectileRenderableProjectileObserver getProjectileObserver() {
  if (projectileObserver == none) {
    projectileObserver = new class'ProjectileRenderableProjectileObserver';
  }

  return projectileObserver;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function tick(float delta)
{
  updateLocation();

  super.tick(delta);
}

simulated function updateLocation() {
  if (projectile != none)
    setWorldLocation(projectile.getProjectileLocation());
}

simulated function setWorldLocation(vector newWorldLocation) {
  if (worldLocation != location) {
    worldLocation = newWorldLocation;

    setLocation(worldLocation * getGlobalPositionScaleFactor());
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float getEffectScale() {
  return sqrt(projectile.damage);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function impact() {
  if (impactShakeMagnitude > 0)
    cameraShake(location, impactShakeMagnitude * getEffectScale() * getGlobalDrawscaleFactor());
}

simulated function missed();

simulated function notifyProjectileFired(actor renderableFiredFrom) {
  local rotator fireEffectRotation;
  local actor fireEffectInstance;

  if (renderableFiredFrom != none) {
    if (fireEffect != none)  {
      fireEffectRotation = rotator(projectile.endLocation - projectile.startLocation);
      fireEffectRotation.roll = FRand() * 65535;
      fireEffectInstance = spawn(fireEffect,,,renderableFiredFrom.location, fireEffectRotation);
      fireEffectInstance.setBase(renderableFiredFrom);

      // some effects display when triggered and they expect to be kept around...
      // I don't want to bother with that for now so I will just trigger them once and give them a limited lifespan so they clean themselves up.
      // but don't do this for my scalableemitters because that shuts them down.
      // wish I had written down which effects need this...
      if (ScalableEmitter(fireEffectInstance) == none) {
        fireEffectInstance.trigger(self, none);
        fireEffectInstance.lifespan = 5;
      }
    }

    if (fireSound != none) {
      renderableFiredFrom.playSound(fireSound,,transientSoundVolume * fireSoundBaseVolume * getEffectScale() * getGlobalDrawscaleFactor(),,transientSoundRadius * fireSoundBaseRadius * getEffectScale() * getGlobalPositionScaleFactor());
    }

    if (fireShakeMagnitude > 0)
      cameraShake(renderableFiredFrom.location, fireShakeMagnitude);
  }
}

// Removes the renderable from the game simulation. The actor can continue to exist.
simulated function tearOffGameSim() {
  setProjectile(none);
}

simulated function setProjectile(Projectile newProjectile) {
  if (projectileObserver != none)
    projectileObserver.cleanup();
  projectile = newProjectile;
  if (newProjectile != none)
    getProjectileObserver().initialize(newProjectile, self);
}

simulated function notifyCameraLeftSector() {
  destroy();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  setProjectile(none);
  projectileObserver = none;

  super.cleanup();
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  transientSoundVolume=1
  transientSoundRadius=1
  fireSoundBaseVolume=5
  fireSoundBaseRadius=300
}
