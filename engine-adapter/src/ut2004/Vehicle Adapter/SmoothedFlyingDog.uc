class SmoothedFlyingDog extends AttachingFlyingDog placeable;

var DefaultFloatSmoother yawSmoother;
var DefaultFloatSmoother pitchSmoother;

simulated function receivedRawRotationInput(float deltaTime, float yawChange, float pitchChange, float rollChange) {
  if (yawSmoother == none)
    yawSmoother = new class'DefaultFloatSmoother';
  if (pitchSmoother == none)
    pitchSmoother = new class'DefaultFloatSmoother';
    
  yawSmoother.addRawValue(yawChange);
  pitchSmoother.addRawValue(pitchChange);
  
  receivedRotationInput(deltaTime, yawSmoother.getSmoothedValue(), pitchSmoother.getSmoothedValue(), rollChange);
}

simulated function destroyed() {
  if (yawSmoother != none) {
    yawSmoother.cleanup();
    yawSmoother = none;
  }

  if (pitchSmoother != none) {
    pitchSmoother.cleanup();
    pitchSmoother = none;
  }
}


defaultproperties
{
}
