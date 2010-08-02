class SpaceGameplayInterfaceCameraShaker extends CameraShaker;

var SpaceGameplayInterface sgi;

simulated function cameraShake(vector shakeOrigin, float shakeMagnitude) {
  sgi.cameraShake(shakeOrigin, shakeMagnitude);
}

simulated function cleanup() {
  sgi = none;
  
  super.cleanup();
}

defaultproperties
{
}