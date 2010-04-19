class ShipReferencePhysicsState extends PhysicsStateInterface;

var private Ship storedReference;

simulated function setReference(Ship newReference) {
  storedReference = newReference;
}

simulated function vector getLocation() {
  return storedReference.shipLocation;
}

simulated function setLocation(vector newValue) {
  storedReference.shipLocation = newValue;
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
  storedReference.rotation = newValue;
}

simulated function float getRotationVelocity() {
  return storedReference.lastRotationSpeed;
}

simulated function setRotationVelocity(float newValue) {
  storedReference.lastRotationSpeed = newValue;
}

simulated function cleanup() {
  setReference(none);
  super.cleanup();
}

defaultproperties
{
}