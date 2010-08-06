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

simulated function vector getRotationVelocity() {
  return storedReference.rotationalVelocity;
}

simulated function setRotationVelocity(vector newValue) {
  storedReference.rotationalVelocity = newValue;
}

simulated function cleanup() {
  setReference(none);
  super.cleanup();
}

simulated static function ShipReferencePhysicsState createNewShipReferencePhysicsState(Ship newShip) {
  local ShipReferencePhysicsState result;
  
  result = ShipReferencePhysicsState(newShip.allocateObject(class'ShipReferencePhysicsState'));
  result.setReference(newShip);
    
  return result;
}

defaultproperties
{
}