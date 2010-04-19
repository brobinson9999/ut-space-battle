class ActorReferencePhysicsState extends PhysicsStateInterface;

var private Actor storedReference;
var private float rotationVelocity;

simulated function setReference(Actor newReference) {
  storedReference = newReference;
}

simulated function vector getLocation() {
  return storedReference.location;
}

simulated function setLocation(vector newValue) {
  if (newValue != getLocation())
    storedReference.setLocation(newValue);
}

simulated function vector getVelocity() {
  return storedReference.velocity;
}

simulated function setVelocity(vector newValue) {
  storedReference.velocity = newValue;
}

simulated function rotator getRotation() {
  return storedReference.rotation;
}

simulated function setRotation(rotator newValue) {
  if (newValue != getRotation())
    storedReference.setRotation(newValue);
}

simulated function float getRotationVelocity() {
  return rotationVelocity;
}

simulated function setRotationVelocity(float newValue) {
  rotationVelocity = newValue;
}

simulated function cleanup() {
  setReference(none);
  super.cleanup();
}

defaultproperties
{
}