class BaseRenderable extends Renderable;

simulated function ScalableEmitter spawnScaledEffect(class<ScalableEmitter> emitterClass, optional float scaleFactor) {
  local ScalableEmitter result;

  result = spawn(emitterClass, self,, location, rotation);
  if (result != none) {
    if (scaleFactor == 0) scaleFactor = 1;
    // not sure about this * 0.25... maybe it shouldn't be there.
    result.setScale((drawScale / default.drawScale) * scaleFactor * 0.25 * getGlobalDrawscaleFactor());
    result.setBase(self);
  }

  return result;
}

defaultproperties
{
  bBlockActors=false
  bBlockKarma=false
  bBlockPlayers=false
  bCollideWorld=false
  bCollideActors=false
  bBlockNonZeroExtentTraces=false
  bBlockZeroExtentTraces=false
  bProjTarget=false
}