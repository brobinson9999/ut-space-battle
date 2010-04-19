class IntegratorDog extends FlyingDog placeable;

var PhysicsIntegrator physicsIntegrator;
var PhysicsStateInterface physicsState;

simulated function PhysicsStateInterface getPhysicsState() {
  if (physicsState == none) {
    physicsState = new class'ActorReferencePhysicsState';
    ActorReferencePhysicsState(physicsState).setReference(self);
  }

  return physicsState;
}

simulated function PhysicsIntegrator getPhysicsIntegrator() {
  if (physicsIntegrator == none) {
    physicsIntegrator = new class'DefaultPhysicsIntegrator';
  }
  
  return physicsIntegrator;
}

simulated function destroyed() {
  if (physicsIntegrator != none) {
    physicsIntegrator.cleanup();
    physicsIntegrator = none;
  }

  if (physicsState != none) {
    physicsState.cleanup();
    physicsState = none;
  }

  super.destroyed();
}

final static operator(23) rotator coordRot(rotator A, rotator B)
{
  local vector X, Y, Z;

  if (A == Rot(0,0,0))
    return B;

  if (B == Rot(0,0,0))
    return A;

  GetAxes(A, X, Y, Z);

  X = X >> B;
  Y = Y >> B;
  Z = Z >> B;

  return OrthoRotation(X, Y, Z);
}

simulated function updateRocketAcceleration(float delta, float yawChange, float pitchChange) {
  super.updateRocketAcceleration(delta, yawChange, pitchChange);

  getPhysicsIntegrator().linearPhysicsUpdate(getPhysicsState(), delta, shipThrust * maximumThrust, false, vect(0,0,0));
  getPhysicsIntegrator().angularPhysicsUpdate(getPhysicsState(), delta, shipSteering coordRot getControlRotation(), 10000);

  // PlayerController will tamper with velocity, based on acceleration - it will call:
  //   Pawn.Velocity = Pawn.Acceleration * Pawn.AirSpeed * 0.001;
  // So I will compensate by setting acceleration.
  acceleration = velocity / (airspeed * 0.001);
  
  // Take complete control on Rotation
  bRotateToDesired  = true;
  bRollToDesired    = true;
  DesiredRotation   = getPhysicsState().getRotation();
  SetRotation( getPhysicsState().getRotation() );
}

defaultproperties
{
  Physics=PHYS_Projectile
  // This can be anything, as long as it is non-zero
  AirSpeed=10000

  bCollideActors=True
  bCollideWorld=True
  bProjTarget=True
  bBlockActors=True
  bBlockNonZeroExtentTraces=True
  bBlockZeroExtentTraces=True
  bBlockKarma=True
}
