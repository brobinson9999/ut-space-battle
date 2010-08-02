class SmoothedFlyingDog extends AttachingFlyingDog;

var DefaultFloatSmoother yawSmoother;
var DefaultFloatSmoother pitchSmoother;

simulated function receivedRawInput(float deltaTime, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange) {
  if (yawSmoother == none)
    yawSmoother = new class'DefaultFloatSmoother';
  if (pitchSmoother == none)
    pitchSmoother = new class'DefaultFloatSmoother';
    
  yawSmoother.addRawValue(yawChange);
  pitchSmoother.addRawValue(pitchChange);
  
  receivedProcessedInput(deltaTime, fwdChange, strafeChange, upChange, yawSmoother.getSmoothedValue(), pitchSmoother.getSmoothedValue(), rollChange);
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
  
  super.destroyed();
}


defaultproperties
{
}
