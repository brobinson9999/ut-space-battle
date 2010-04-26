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

//  local float tickRotationSize;
//  local vector tickRotationVector;

  local rotator oldRotation, newRotation;
  
//  local vector rotationalAccelerationVector;
  
//  rotation = physicsState.getRotation();
  lastRotationVelocity = physicsState.getRotationVelocity();
  newRotationVelocity = lastRotationVelocity + rotationalAcceleration;
  averageRotationVelocity = (lastRotationVelocity + newRotationVelocity) / 2;
  physicsState.setRotationVelocity(newRotationVelocity);
  
  if (averageRotationVelocity != vect(0,0,0)) {
    // more hacks
//    oldRotation = physicsState.getRotation();
    
//    newRotation = (averageRotationVelocity * delta) coordRot oldRotation;
//smallestRotatorMagnitude(desiredRotation unCoordRot rotation);
//    // hack
////    averageRotationVelocity = copyVectToRot(normal(copyRotToVect(newRotationVelocity)) * vsize(copyRotToVect(averageRotationVelocity)));
    oldRotation = physicsState.getRotation();
    newRotation = copyVectToRot(averageRotationVelocity * delta) coordRot oldRotation;
////    newRotationVelocity = (newRotation uncoordRot oldRotation);
////    physicsState.setRotationVelocity(newRotationVelocity);

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

//  result = oldRotationalVelocity;
//  result = copyVectToRot(copyRotToVect(oldRotationalVelocity) coordRot (newRotation uncoordRot oldRotation));
  result = oldRotationalVelocity coordRot (newRotation uncoordRot oldRotation);
  
//  log("getNewRotationalVelocity("$oldRotationalVelocity$" "$oldRotation$" "$newRotation$") = "$result);
//  log("(newRotation uncoordRot oldRotation) = "$(newRotation uncoordRot oldRotation));
  return result;
  
  // pitch causes yaw to become roll
  // roll causes yaw/pitch to change
}

/*
simulated static function staticAngularPhysicsUpdate(PhysicsStateInterface physicsState, float delta, rotator desiredRotation, float rotationRate) {
  // Rotation "Speed".
  local float AverageRotationSpeed;
  local float NewRotationSpeed;
  local float DesiredRotationSpeed;
  local float TickRotationAcceleration;
  local float DesiredMaintainenceRotationSpeed;               // Allows ships to maintain a certain "Rotation Speed" even when not rotating, to give them more agility. Unrealistic, but perhaps useful.

  // Variables for calculating this tick's rotation.
  local rotator DeltaRotation;
  local vector DeltaRotationVector;
  local float DeltaRotationSize;
  local float TickRotationSize;
  local vector TickRotationVector;
  local rotator TickRotation;

  local rotator rotation;
  local float lastRotationSpeed;
  
  rotation = physicsState.getRotation();
  lastRotationSpeed = physicsState.getRotationVelocity();
  
  // Only calculate rotation distance if we are not already at the desired rotation.
  if (Rotation == DesiredRotation)
  {
    // No desired rotation.
    DeltaRotationSize = 0;
  } else {
    // Measure the rotation distance.
    DeltaRotation = smallestRotatorMagnitude(DesiredRotation UnCoordRot Rotation);
    DeltaRotationVector.X = DeltaRotation.Yaw;
    DeltaRotationVector.Y = DeltaRotation.Pitch;
    DeltaRotationVector.Z = DeltaRotation.Roll;

    DeltaRotationSize = VSize(DeltaRotationVector);
  }

  // Set desired maintainence speed.
  // 20081109: I am still undecided about whether they should have any of this "maintainence" speed. This helps a ship that is not rotating to be "on it's toes" regarding rotation.
  // This helps for instance when a ship is a approaching another, then needs to suddenly turn to strafe.
  DesiredMaintainenceRotationSpeed = 0;
//    DesiredMaintainenceRotationSpeed = RotationRate * 0.1;

  // Get rotation speed.
  if (DeltaRotationSize == 0)
    DesiredRotationSpeed = DesiredMaintainenceRotationSpeed;
  else
    DesiredRotationSpeed = sqrt(2 * DeltaRotationSize * RotationRate) + DesiredMaintainenceRotationSpeed;

  TickRotationAcceleration = RotationRate * Delta;

  // Get new rotation speed.
  if (DesiredRotationSpeed >= LastRotationSpeed)
    NewRotationSpeed = FMin(LastRotationSpeed + TickRotationAcceleration, DesiredRotationSpeed);
  else
    NewRotationSpeed = FMax(LastRotationSpeed - TickRotationAcceleration, DesiredRotationSpeed);

  // Get average rotation speed - capped at desired as we don't necessarily have to spread rotation over the entire tick.
  if (DesiredRotationSpeed >= LastRotationSpeed)
    AverageRotationSpeed = FMin((LastRotationSpeed + NewRotationSpeed) / 2, DesiredRotationSpeed);
  else
    AverageRotationSpeed = FMax((LastRotationSpeed + NewRotationSpeed) / 2, DesiredRotationSpeed);

  // Update LastRotationSpeed now that we have the new average.
  lastRotationSpeed = NewRotationSpeed;
  physicsState.setRotationVelocity(lastRotationSpeed);
  
  if (AverageRotationSpeed == 0)
  {
    physicsState.setRotation(rotation);
  } else {
    TickRotationSize = AverageRotationSpeed * Delta;

    // Do Rotation.
    if (DeltaRotationSize <= TickRotationSize)
    {
      physicsState.setRotation(desiredRotation);
    } else {
      TickRotationVector = DeltaRotationVector * (TickRotationSize / DeltaRotationSize);
      TickRotation.Yaw = TickRotationVector.X;
      TickRotation.Pitch = TickRotationVector.Y;
      TickRotation.Roll = TickRotationVector.Z;
      physicsState.setRotation(tickRotation CoordRot rotation);
    }
  }
}
*/

defaultproperties
{
}