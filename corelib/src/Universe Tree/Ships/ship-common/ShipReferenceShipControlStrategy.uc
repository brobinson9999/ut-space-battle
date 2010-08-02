class ShipReferenceShipControlStrategy extends ShipControlStrategy;

var Ship ship;

simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration) {
  return ship.getRotationalAcceleration(deltaTime);
}

simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration) {
  return ship.getLinearAcceleration(deltaTime);
}

simulated function cleanup() {
  ship = none;

  super.cleanup();
}

simulated static function ShipReferenceShipControlStrategy createNewShipReferenceShipControlStrategy(Ship newShip) {
  local ShipReferenceShipControlStrategy result;
  
  result = ShipReferenceShipControlStrategy(newShip.allocateObject(class'ShipReferenceShipControlStrategy'));
  result.ship = newShip;
    
  return result;
}


defaultproperties
{
}
