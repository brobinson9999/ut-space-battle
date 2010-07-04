class IntegratorDog extends SmoothedFlyingDog abstract;

var PhysicsIntegrator physicsIntegrator;
var PhysicsStateInterface physicsState;
var float rotationalDrag;
var float linearDrag;

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


// seems to get this call when I'm NOT in the vehicle, but doesn't get the call when I am.
simulated function hitWall( vector HitNormal, actor HitWall ) {
  log("hitWall "$hitWall);
  super.hitWall(hitNormal, hitWall);
}

simulated function Landed( vector HitNormal ) {
  log("Landed "$HitNormal);
  super.Landed(hitNormal);
}

simulated function Touch( Actor Other ) {
  log("Touch "$Other);
  super.Touch(Other);
}

simulated function Bump( Actor Other ) {
  log("Bump "$Other);
  super.Bump(Other);
}

simulated function  bool EncroachingOn( actor Other ) {
  log("EncroachingOn "$Other);
  return super.EncroachingOn(Other);
}
simulated function  EncroachedBy( actor Other ) {
  log("EncroachedBy "$Other);
  super.EncroachedBy(Other);
}
simulated function  RanInto( Actor Other ) {
  log("RanInto "$Other);
  super.RanInto(Other);
}

simulated function updateRocketAcceleration(float delta, float yawChange, float pitchChange) {
  local PhysicsIntegrator integrator;
  local PhysicsStateInterface physState;
  
  super.updateRocketAcceleration(delta, yawChange, pitchChange);

  integrator = getPhysicsIntegrator();
  physState = getPhysicsState();
  applyDrag(physState, delta);
  integrator.linearPhysicsUpdate(physState, delta, shipThrust * maximumThrust);
  integrator.angularPhysicsUpdate(physState, delta, class'BaseObject'.static.capVector(shipSteering, 1) * maximumRotationalAcceleration);

  
  // PlayerController will tamper with velocity, based on acceleration - it will call:
  //   Pawn.Velocity = Pawn.Acceleration * Pawn.AirSpeed * 0.001;
  // So I will compensate by setting acceleration.
  acceleration = velocity / (airspeed * 0.001);
  
  // Take complete control on rotation.
  bRotateToDesired = true;
  bRollToDesired = true;
  desiredRotation = physState.getRotation();
  setRotation(physState.getRotation());
}

simulated function vector addVectorsWithoutCrossingZero(vector a, vector b) {
  local vector result;
  
  result.x = addFloatsWithoutCrossingZero(a.x, b.x);
  result.y = addFloatsWithoutCrossingZero(a.y, b.y);
  result.z = addFloatsWithoutCrossingZero(a.z, b.z);
  
  return result;
}

simulated function float addFloatsWithoutCrossingZero(float a, float b) {
  if (a > 0)
    return FMax(0, a + b);
  else
    return FMin(0, a + b);
}

simulated function applyDrag(PhysicsStateInterface physState, float delta) {
  if (rotationalDrag > 0)
    physState.setRotationVelocity(addVectorsWithoutCrossingZero(physState.getRotationVelocity(), rotationalDrag * delta * -physState.getRotationVelocity()));
  if (linearDrag > 0)
    physState.setVelocity(addVectorsWithoutCrossingZero(physState.getVelocity(), linearDrag * delta * -physState.getVelocity()));
}

defaultproperties
{
  DrawType=DT_Mesh
  Mesh=SkeletalMesh'AS_VehiclesFull_M.SpaceFighter_Skaarj'
  DrawScale=1

  // AirSpeed can be anything, as long as it is non-zero
  airSpeed=10000
  physics=PHYS_Flying
  rotationalDrag=0.5
  linearDrag=0.75

  bCollideActors=True
  bCollideWorld=True
  bProjTarget=True
  bBlockActors=True
  bBlockNonZeroExtentTraces=True
  bBlockZeroExtentTraces=True
  bBlockKarma=True
}
