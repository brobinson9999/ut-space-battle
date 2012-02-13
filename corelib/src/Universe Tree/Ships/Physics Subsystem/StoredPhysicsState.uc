class StoredPhysicsState extends PhysicsStateInterface;

var private vector storedLocation;
var private vector storedVelocity;
var private rotator storedRotation;
var private vector storedRotationVelocity;

simulated function vector getLocation() {
  return storedLocation;
}

simulated function setLocation(vector newValue) {
  storedLocation = newValue;
}

simulated function vector getVelocity() {
  return storedVelocity;
}

simulated function setVelocity(vector newValue) {
  storedVelocity = newValue;
}

simulated function rotator getRotation() {
  return storedRotation;
}

simulated function setRotation(rotator newValue) {
  storedRotation = newValue;
}

simulated function vector getRotationVelocity() {
  return storedRotationVelocity;
}

simulated function setRotationVelocity(vector newValue) {
  storedRotationVelocity = newValue;
}

defaultproperties
{
}