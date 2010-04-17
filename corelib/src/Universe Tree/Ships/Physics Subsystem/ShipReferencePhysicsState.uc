class ShipReferencePhysicsState extends PhysicsStateInterface;

var Ship storedShip;

simulated function vector getLocation() {
  return storedShip.shipLocation;
}

simulated function setLocation(vector newValue) {
  storedShip.shipLocation = newValue;
}

simulated function vector getVelocity() {
  return storedShip.velocity;
}

simulated function setVelocity(vector newValue) {
  storedShip.velocity = newValue;
}

simulated function rotator getRotation() {
  return storedShip.rotation;
}

simulated function setRotation(rotator newValue) {
  storedShip.rotation = newValue;
}

simulated function float getRotationVelocity() {
  return storedShip.lastRotationSpeed;
}

simulated function setRotationVelocity(float newValue) {
  storedShip.lastRotationSpeed = newValue;
}

simulated function cleanup() {
  storedShip = none;
  super.cleanup();
}

defaultproperties
{
}