class DefaultPhysicsIntegrator extends PhysicsIntegrator;

simulated function linearPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector acceleration, optional bool bUseDesiredVelocity, optional vector desiredVelocity) {
  staticLinearPhysicsUpdate(physicsState, delta, acceleration, bUseDesiredVelocity, desiredVelocity);
}

simulated static function staticLinearPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector acceleration, optional bool bUseDesiredVelocity, optional vector desiredVelocity) {
  local vector desiredVelocityChange;
  local float desiredVelocityChangeSize;
  local float timeSegmentLength;
  
  bUseDesiredVelocity = false;
  
  // If a desiredVelocity is specified, set desiredAcceleration and subdivide the update as appropriate.
  if (bUseDesiredVelocity) {
    desiredVelocityChange = desiredVelocity - physicsState.getVelocity();
    desiredVelocityChangeSize = vSize(desiredVelocityChange);
    if (desiredVelocityChangeSize == 0) {
      staticLinearPhysicsUpdate_2(physicsState, delta, vect(0,0,0));
    } else if (desiredVelocityChangeSize <= (vsize(acceleration) * delta)) {
      timeSegmentLength = vsize(acceleration) / desiredVelocityChangeSize;
      staticLinearPhysicsUpdate_2(physicsState, timeSegmentLength, desiredVelocityChangeSize * normal(desiredVelocityChange));
      physicsState.setVelocity(desiredVelocity); // just to make sure it is exactly right
      staticLinearPhysicsUpdate_2(physicsState, delta - timeSegmentLength, vect(0,0,0));
    } else {
      staticLinearPhysicsUpdate_2(physicsState, delta, vsize(acceleration) * normal(desiredVelocityChange));
    }
  } else {
    staticLinearPhysicsUpdate_2(physicsState, delta, acceleration);
  }
}

simulated static function staticLinearPhysicsUpdate_2(PhysicsStateInterface physicsState, float delta, vector acceleration) {
  local vector currentVelocity, newVelocity;

  currentVelocity = physicsState.getVelocity();
  newVelocity = currentVelocity + (delta * acceleration);
  physicsState.setLocation(physicsState.getLocation() + ((newVelocity + currentVelocity) * 0.5 * delta));
  physicsState.setVelocity(newVelocity);
}

simulated function angularPhysicsUpdate(PhysicsStateInterface physicsState, float delta, rotator desiredRotation, float rotationRate) {
  staticAngularPhysicsUpdate(physicsState, delta, desiredRotation, rotationRate);
}

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

defaultproperties
{
}