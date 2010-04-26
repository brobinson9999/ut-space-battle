class IntegratorDog extends FlyingDog placeable;

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
  integrator.linearPhysicsUpdate(physState, delta, shipThrust * maximumThrust);
  integrator.angularPhysicsUpdate(physState, delta, physState.copyRotToVect(shipSteering));

  if (rotationalDrag > 0)
    physState.setRotationVelocity(physState.getRotationVelocity() * fmax(0, (rotationalDrag-delta)/rotationalDrag));
  if (linearDrag > 0)
    physState.setVelocity(physState.getVelocity() * fmax(0, (linearDrag-delta)/linearDrag));
  
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

defaultproperties
{
  rotationalDrag=1
  linearDrag=2

  turnSensitivity=0.05
  maximumTurnRate=100

//  Physics=PHYS_Projectile
  Physics=PHYS_Flying
  // AirSpeed can be anything, as long as it is non-zero
  AirSpeed=10000

  bCollideActors=True
  bCollideWorld=True
  bProjTarget=True
  bBlockActors=True
  bBlockNonZeroExtentTraces=True
  bBlockZeroExtentTraces=True
  bBlockKarma=True
}
