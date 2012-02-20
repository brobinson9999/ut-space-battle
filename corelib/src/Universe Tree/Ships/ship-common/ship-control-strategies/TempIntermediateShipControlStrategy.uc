class TempIntermediateShipControlStrategy extends ShipControlStrategy;

var vector shipSteering;
var vector thrustDir;
var float thrustThrottle;
var float intertialCompensationFactor;

simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration);

simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration) {
  return getNewFreeFlightAcceleration(deltaTime, maximumAcceleration, physicsState.getVelocity(), thrustDir, thrustThrottle, intertialCompensationFactor);
}

simulated static function vector getNewFreeFlightAcceleration(float deltaTime, float shipAcceleration, vector currentVelocity, vector desiredThrustDir, float inputThrottle, float inertialCompensationFactor) {
  local vector forwardDesiredVelocity;
  local vector inertialCompensationDesiredVelocity;
  local vector newDesiredVelocity;

  if (shipAcceleration == 0)
    return vect(0,0,0);

  forwardDesiredVelocity = currentVelocity + (desiredThrustDir * inputThrottle * shipAcceleration);
  inertialCompensationDesiredVelocity = desiredThrustDir * (vsize(currentVelocity) + (inputThrottle * shipAcceleration));

  newDesiredVelocity = (inertialCompensationDesiredVelocity * inertialCompensationFactor) + (forwardDesiredVelocity * (1-inertialCompensationFactor));

  return capVector(newDesiredVelocity - currentVelocity, 1);
}

defaultproperties
{
}
