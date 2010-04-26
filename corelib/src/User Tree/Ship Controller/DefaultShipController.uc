class DefaultShipController extends ShipController;

var bool bUseDesiredVelocity;
var vector desiredVelocity;
var vector desiredAcceleration;

var bool bUseDesiredRotation;
var rotator desiredRotation;
var bool bUseDesiredRotationRate;
var vector desiredRotationRate;
var vector desiredRotationalAcceleration;

var float useRotationRateFactor;

simulated function vector getDesiredAcceleration(Ship ship, float delta) {
  if (bUseDesiredVelocity)
    desiredAcceleration = getDesiredChangeRate(delta, desiredVelocity - ship.getPhysicsState().getVelocity());
  
  return desiredAcceleration;
}

simulated function vector getDesiredRotationalAcceleration(Ship ship, float delta) {
  if (bUseDesiredRotation)
    desiredRotationRate = getDesiredChangeRateWithAcceleration(delta, copyRotToVect(smallestRotatorMagnitude(desiredRotation unCoordRot ship.getPhysicsState().getRotation())), ship.rotationRate * useRotationRateFactor);

  if (bUseDesiredRotationRate || bUseDesiredRotation)
    desiredRotationalAcceleration = getDesiredChangeRate(delta, copyRotToVect(smallestRotatorMagnitude(copyVectToRot(desiredRotationRate - ship.getPhysicsState().getRotationVelocity()))));
    
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