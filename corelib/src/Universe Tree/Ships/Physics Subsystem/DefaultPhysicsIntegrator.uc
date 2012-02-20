class DefaultPhysicsIntegrator extends PhysicsIntegrator;

simulated function linearPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector acceleration) {
  staticLinearPhysicsUpdate(physicsState, delta, acceleration);
}

simulated static function staticLinearPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector acceleration) {
  local vector currentVelocity, newVelocity;

  currentVelocity = physicsState.getVelocity();
  newVelocity = currentVelocity + (delta * acceleration);
  physicsState.setLocation(physicsState.getLocation() + ((newVelocity + currentVelocity) * 0.5 * delta));
  physicsState.setVelocity(newVelocity);
}

simulated function angularPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector rotationalAcceleration) {
  staticAngularPhysicsUpdate(physicsState, delta, rotationalAcceleration);
}

simulated static function staticAngularPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector rotationalAcceleration) {
  local vector lastRotationVelocity, newRotationVelocity, averageRotationVelocity;
  local rotator oldRotation, newRotation;

  lastRotationVelocity = physicsState.getRotationVelocity();
  newRotationVelocity = lastRotationVelocity + (delta * rotationalAcceleration);
  averageRotationVelocity = (lastRotationVelocity + newRotationVelocity) / 2;
  physicsState.setRotationVelocity(newRotationVelocity);

  if (averageRotationVelocity != vect(0,0,0)) {
    oldRotation = physicsState.getRotation();
    newRotation = copyVectToRot(averageRotationVelocity * delta) coordRot oldRotation;

    physicsState.setRotation(newRotation);
  }
}

simulated static function rotator getNewRotationalVelocity(rotator oldRotationalVelocity, rotator oldRotation, rotator newRotation) {
  local rotator result;
  local rotator oldRoll, newRoll;

  oldRoll = oldRotation;
  oldRoll.yaw = 0; oldRoll.pitch = 0;

  newRoll = newRotation;
  newRoll.yaw = 0; newRoll.pitch = 0;

  result = oldRotationalVelocity coordRot (newRotation uncoordRot oldRotation);

  return result;
}

defaultproperties
{
}