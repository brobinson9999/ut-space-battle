class IntegratorDog extends SmoothedFlyingDog;

var float rotationalDrag;
var float linearDrag;

var private ShipCommon shipCommon;

simulated function ShipCommon getShipCommon() {
  if (shipCommon == none)
    setShipCommon(new class'ShipCommon');

  return shipCommon;
}

simulated function setShipCommon(ShipCommon newShipCommon) {
  // clean anything out of old shipCommon here...
  if (shipCommon != none) {
    shipCommon.cleanup();
  }
  
  shipCommon = newShipCommon;

  if (shipCommon != none) {
    shipCommon.setPhysicsState(class'ActorReferencePhysicsState'.static.createNewActorReferencePhysicsState(self));
    shipCommon.setPhysicsIntegrator(new class'DefaultPhysicsIntegrator');
  }
}

simulated function PhysicsStateInterface getPhysicsState() {
  return getShipCommon().getPhysicsState();
}

simulated function PhysicsIntegrator getPhysicsIntegrator() {
  return getShipCommon().getPhysicsIntegrator();
}

simulated function destroyed() {
  setShipCommon(none);

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
//  local PhysicsIntegrator integrator;
  local PhysicsStateInterface physState;
  
  super.updateRocketAcceleration(delta, yawChange, pitchChange);

  physState = getPhysicsState();
  applyDrag(physState, delta);

  getShipCommon().maximumLinearAcceleration = maximumThrust;
  getShipCommon().maximumRotationalAcceleration = maximumRotationalAcceleration;
  getShipCommon().updateShipPhysics(delta);

  applyPhysicsStateToPawn(physState);
}

simulated function applyPhysicsStateToPawn(PhysicsStateInterface physState) {
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

simulated function vector multiplyRangeVector(vector base, rangevector multiplier) {
  local vector result;
  
  result.x = multiplyRange(base.x, multiplier.x);
  result.y = multiplyRange(base.y, multiplier.y);
  result.z = multiplyRange(base.z, multiplier.z);
  
  return result;
}

simulated function float multiplyRange(float base, range multiplier) {
  if (base > 0)
    return base * multiplier.max;
  else
    return base * multiplier.min;
}

simulated function vector applyRangeToVector(vector base, float multiplierScalar, rangevector multiplierRange, rotator relativeRotation) {
  local vector fwdBase;

  if (relativeRotation == rot(0,0,0))
    fwdBase = base;
  else
    fwdBase = base << relativeRotation;
    
  fwdBase = addVectorsWithoutCrossingZero(fwdBase, -multiplyRangeVector(fwdBase * multiplierScalar, multiplierRange));
  
  if (relativeRotation == rot(0,0,0))
    return fwdBase;
  else
    return fwdBase >> relativeRotation;

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
