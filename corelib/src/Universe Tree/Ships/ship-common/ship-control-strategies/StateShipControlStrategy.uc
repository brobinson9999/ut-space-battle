class StateShipControlStrategy extends ShipControlStrategy;

var private ShipControlStrategy currentState;

simulated function setState(ShipControlStrategy newState) {
  currentState = newState;
}

simulated function ShipControlStrategy getState() {
  return currentState;
}

// (gen-proxy "getShipSteering" "currentState" "vector" ((:NAME "deltaTime" :TYPE "float") (:NAME "physicsState" :TYPE "PhysicsStateInterface") (:NAME "maximumRotationalAcceleration" :TYPE "float")))
simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration) {
  return currentState.getShipSteering(deltaTime, physicsState, maximumRotationalAcceleration);
}

// (gen-proxy "getShipThrust" "currentState" "vector" ((:NAME "deltaTime" :TYPE "float") (:NAME "physicsState" :TYPE "PhysicsStateInterface") (:NAME "maximumAcceleration" :TYPE "float")))
simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration) {
  return currentState.getShipThrust(deltaTime, physicsState, maximumAcceleration);
}
