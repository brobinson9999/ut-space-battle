class BaseRenderable extends Renderable;

struct SoundSettings {
  var SoundCue soundObject;
};

simulated function playSoundStruct(SoundSettings soundStruct, float volume, float radius, optional Actor soundOrigin) {
  if (soundOrigin == none)
    soundOrigin = self;
    
  soundOrigin.playSound(soundStruct.soundObject);
}

simulated function trigger(Actor other, Pawn eventInstigator);

simulated function ScalableEmitter spawnScaledEffect(class<ScalableEmitter> emitterClass, optional float scaleFactor) {
  local ScalableEmitter result;

  result = spawn(emitterClass, self,, location, rotation);
  if (result != none) {
    if (scaleFactor == 0) scaleFactor = 1;
    result.setScale((drawScale / default.drawScale) * scaleFactor);
    result.setBase(self);
  }

  return result;
}

defaultproperties
{
  bBlockActors=false
  bCollideWorld=false
  bCollideActors=false
  bProjTarget=false
}