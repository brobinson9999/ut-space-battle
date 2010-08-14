class ShipReferencePhysicsState extends PhysicsStateInterface;

var private Ship storedReference;

simulated function setReference(Ship newReference) {
  storedReference = newReference;
}

simulated function vector getLocation() {
  return storedReference.getShipLocation();
}

simulated function setLocation(vector newValue) {
  storedReference.setShipLocation(newValue);
}

simulated function vector getVelocity() {
  return storedReference.getShipVelocity();
}

simulated function setVelocity(vector newValue) {
  storedReference.setShipVelocity(newValue);
}

simulated function rotator getRotation() {
  return storedReference.getShipRotation();
}

simulated function setRotation(rotator newValue) {
  storedReference.setShipRotation(newValue);
}

simulated function vector getRotationVelocity() {
  return storedReference.getShipRotationalVelocity();
}

simulated function setRotationVelocity(vector newValue) {
  storedReference.setShipRotationalVelocity(newValue);
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