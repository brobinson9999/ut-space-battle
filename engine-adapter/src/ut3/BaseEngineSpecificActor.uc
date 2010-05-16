class BaseEngineSpecificActor extends Actor placeable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated event FellOutOfWorld(class<DamageType> dmgType) {}
simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal ) {}
simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp) {}
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal) {}

// Not sure about this one. Maybe unsafe to prevent destruction in this case?
//simulated event OutsideWorldBounds() {}

simulated function WorldInfo getLevel() {
  return WorldInfo;
}

simulated function log(coerce string LogMessage) {
  `log(LogMessage);
}

simulated function TransientParticleSystemRenderable spawnTransientEffect(ParticleSystem effectTemplate, vector effectLocation, rotator effectRotation, float effectLifetime, float effectScale, actor effectBase)
{
  local TransientParticleSystemRenderable result;

  result = spawn(class'TransientParticleSystemRenderable',,,effectLocation, effectRotation);

  if (effectLifetime > 0)
    result.maxLifetime = effectLifetime;

  result.setScale(effectScale);

  if (effectBase != none)
    result.setBase(effectBase);

  result.setTemplate(effectTemplate);

  result.initializeTransientParticleSystemRenderable();

  return result;
}

simulated function ParticleSystemComponent spawnParticleSystem(ParticleSystem effectTemplate, vector spawnLocation, rotator spawnRotation)
{
  local ParticleSystemComponent effectInstance;

  effectInstance = worldInfo.myEmitterPool.spawnEmitter(effectTemplate, spawnLocation, spawnRotation);

  return effectInstance;
}

simulated function triggerEvent(name eventName, Actor other, Pawn eventInstigator) {
  local BaseActor a;

  if (eventName == '')
    return;

  foreach dynamicActors(class'BaseActor', a)
    if (a.tag == eventName)
      a.trigger(other, eventInstigator);
}

simulated function trigger(Actor other, Pawn eventInstigator);

simulated static function float getGlobalDrawscaleFactor() {
  return class'UnrealEngineCanvasObject'.static.getGlobalDrawscaleFactor();
}

simulated static function float getGlobalPositionScaleFactor() {
  return class'UnrealEngineCanvasObject'.static.getGlobalPositionScaleFactor();
}

defaultproperties
{
}