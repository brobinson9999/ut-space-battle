class PersistentParticleSystemRenderable extends ScalableEmitter;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var ParticleSystem effectTemplate;
var ParticleSystemComponent effectInstance;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function activateSystem() {
  if (effectInstance != none || effectTemplate == none)
    return;

  // remove limit
  // TODO: Move this to a more appropriate place.
  worldInfo.myEmitterPool.maxActiveEffects = 0;
  
  effectInstance = worldInfo.myEmitterPool.spawnEmitterCustomLifetime(effectTemplate);
  effectInstance.setAbsolute(false, false, false);
  effectInstance.setLODLevel(WorldInfo.bDropDetail ? 1 : 0);
  effectInstance.onSystemFinished = myOnParticleSystemFinished;
  effectInstance.bUpdateComponentInTick = true;
  attachComponent(effectInstance);
}

simulated function deactivateSystem() {
  if (effectInstance == none)
    return;

  effectInstance.deactivateSystem();
  detachComponent(effectInstance);
  worldInfo.myEmitterPool.onParticleSystemFinished(effectInstance);
  effectInstance = none;
}

// could be improved with angle detection (camera.rotation dot camera.location - otherLocation) and varying distances depending on the size of the effect.
simulated function bool effectIsVisible(vector otherLocation) {
  return true;
  
  if (worldInfo.netMode == NM_DedicatedServer)
    return false;
  
  return nearestCameraDistance(otherLocation) < (100000 * drawScale * vsize(drawScale3D));
}

// gets the distance to the nearest camera. 
simulated function float nearestCameraDistance(vector otherLocation) {
  local float bestDistance;
  local PlayerController camera;
  
  bestDistance = 100000000;
  foreach localPlayerControllers(class'PlayerController', camera)
    bestDistance = FMin(bestDistance, vsize(camera.location - otherLocation));
    
  return bestDistance;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function tick(float Delta)
{
  if (effectIsVisible(location))
    activateSystem();
  else
    deactivateSystem();
  
  super.tick(delta);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function myOnParticleSystemFinished(ParticleSystemComponent PSC)
{
  if (PSC == effectInstance)
    deactivateSystem();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Destroyed()
{
  deactivateSystem();
  
  super.destroyed();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated singular event touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal ) {}
simulated singular event hitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp) {}
simulated function processTouch(Actor Other, Vector HitLocation, Vector HitNormal) {}
simulated function bool effectIsRelevant(vector SpawnLocation, bool bForceDedicated, optional float CullDistance) { return true; }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  bCollideActors = false
  bCollideWorld = false
  bProjTarget = false

  bHidden=false
}
