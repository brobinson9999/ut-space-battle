class BasePartRenderableBase extends PartRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var array<vector>                     trailOffsets;

  var float                             cameraShakeMagnitudeDamaged;
  var float                             cameraShakeMagnitudeCritical;
  var float                             cameraShakeMagnitudeDestroyed;
  
  var array<PartRenderableObserver>     observers;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function addObserver(PartRenderableObserver other) {
  observers[observers.length] = other;
}

simulated function bool removeObserver(PartRenderableObserver other) {
  local int i;

  for (i=0;i<observers.length;i++) {
    if (observers[i] == other) {
      observers.remove(i,1);
      return true;
    }
  }

  return false;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function clearObservers() {
  while (observers.length > 0) {
    observers[0].observedCleanup();
    observers.remove(0,1);
  }
}

simulated function setupObservers();

simulated function PartRenderableObserver addNewObserver(class<PartRenderableObserver> newObserverClass) {
  local PartRenderableObserver newObserver;
  
  newObserver = spawn(newObserverClass);
  propogateGlobals(newObserver);
  newObserver.setObserved(self);
  addObserver(newObserver);
  
  return newObserver;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setPart(Part newPart) {
  super.setPart(newPart);

  setScale(newPart.physicalScale * getGlobalDrawscaleFactor());

  clearObservers();
  setupObservers();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************


simulated function class<ProjectileRenderable> getProjectileRenderableClass(WeaponTechnology weaponTechnology) {
  local string techName;
  
  techName = weaponTechnology.friendlyName;
  if (techName == "Skymine Launcher" || techName == "Heavy Skymine Launcher")
    return class'SkymineProjectileRenderable';
  else if (techName == "ASMD Paladin Cannon")
    return class'HeavyShockProjectileRenderable';
  else if (techName == "Shock Cannon" || techName == "Shock Cannon Battery")
    return class'LightShockBeamRenderable';
  else if (techName == "Heavy Shock Cannon")
    return class'InstagibBeamRenderable';
  else if (techName == "Pulse Cannon" || techName == "Precision Pulse Cannon")
    return class'LaserBoltProjectileRenderable';
  else if (techName == "Plasma Autocannon" || techName == "Heavy Plasma Cannon" || techName == "Long Range Autocannon" || techName == "Autocannon Battery")
    return class'MantaProjectileRenderable';
  else if (techName == "Burst Rocket")
    return class'RPGProjectileRenderable';
  else if (techName == "Powderkeg Missile" || techName == "Bombardment Missile")
    return class'FlakProjectileRenderable';
  else
    return none;
}


simulated function notifyPartFiredWeapon(Projectile projectile) {
  local int i;
  local object newRenderData;
  local ProjectileRenderable projectileRenderData;
  local class<ProjectileRenderable> renderableClass;

  for (i=0;i<observers.length;i++)
    observers[i].partFiredWeapon(projectile);

  renderableClass = getProjectileRenderableClass(ShipWeapon(part).localTechnology);
  if (renderableClass != none)
    newRenderData = spawn(renderableClass,,,projectile.startLocation,Rotator(projectile.endLocation - projectile.startLocation));

  projectileRenderData = ProjectileRenderable(newRenderData);

  if (projectileRenderData != none) {
    propogateGlobals(projectileRenderData);
    projectileRenderData.setProjectile(projectile);
    projectileRenderData.initialize();

    projectileRenderData.notifyProjectileFired(self);
  }
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function notifyPartDamaged()
{
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].partDamaged();

  super.notifyPartDamaged();
}

simulated function notifyPartRepaired() {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].partRepaired();

  super.notifyPartRepaired();
}

simulated function notifyShipCritical()
{
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].shipCritical();

  super.notifyShipCritical();
}

simulated function notifyShipDestroyed()
{
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].shipDestroyed();

  super.notifyShipDestroyed();
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  clearObservers();

  super.cleanup();
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  cameraShakeMagnitudeDamaged=100
  cameraShakeMagnitudeCritical=200
  cameraShakeMagnitudeDestroyed=350
}