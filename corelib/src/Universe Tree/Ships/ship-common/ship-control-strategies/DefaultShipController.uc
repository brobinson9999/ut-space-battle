class DefaultShipController extends ShipControlStrategy;

var bool bUseDesiredVelocity;
var vector desiredVelocity;
var vector desiredAcceleration;

var bool bUseDesiredRotation;
var rotator desiredRotation;
var bool bUseDesiredRotationRate;
var vector desiredRotationRate;
var vector desiredRotationalAcceleration;

var float useRotationRateFactor;

simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration) {
  if (bUseDesiredVelocity)
    desiredAcceleration = getDesiredChangeRate(deltaTime, desiredVelocity - physicsState.getVelocity());
  
  return desiredAcceleration;
}

simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration) {
  if (bUseDesiredRotation)
    desiredRotationRate = getDesiredChangeRateWithAcceleration(deltaTime, smallestVRotatorMagnitude(copyRotToVect(desiredRotation unCoordRot physicsState.getRotation())), maximumRotationalAcceleration * useRotationRateFactor);

  if (bUseDesiredRotationRate || bUseDesiredRotation)
    desiredRotationalAcceleration = getDesiredChangeRate(deltaTime, smallestVRotatorMagnitude(desiredRotationRate - physicsState.getRotationVelocity()));
    
  return desiredRotationalAcceleration;
}

simulated function vector getDesiredChangeRate(float delta, vector desiredChange) {
  if (delta == 0)
    return desiredChange;
  else
    return normal(desiredChange) * (vsize(desiredChange) / delta);
}

simulated function vector getDesiredChangeRateWithAcceleration(float delta, vector desiredChange, float maximumDeceleration) {
  return normal(desiredChange) * sqrt(2 * vsize(desiredChange) * maximumDeceleration);
}

defaultproperties
{
  useRotationRateFactor=0.9
}