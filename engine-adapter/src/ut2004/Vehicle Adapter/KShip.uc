class KShip extends VehicleAdapter;


// Used for Karma forces pileup
// Add to these variables to apply force and torque to the ship.
var vector extraForce, extraTorque;

var float rollAccumulator;

// Amount of roll change for every click of the mouse wheel.
var float rollUnit;

// Maximum linear thrust the ship can apply.
var float maximumRotationalAcceleration;
var float maximumThrust;

var rangevector maximumThrust3d;
var rangevector maximumRotationalAcceleration3d;

// Desired torque on the ship - relative to it's current rotation.
var vector shipSteering;

// Desired linear thrust to apply to the ship - not relative to it's current rotation.
var vector shipThrust;

simulated function setInitialState() {
  super.setInitialState();

  // don't disable my tick!
  enable('tick');
}


simulated event drivingStatusChanged() {
  super.drivingStatusChanged();

  // don't disable my tick!
  enable('tick');
}

function KDriverEnter(Pawn P) {
  super.KDriverEnter(p);
  
  if (PlayerController(controller) != none)
    controller.gotoState(landMovementState);
  
  // Don't let the PC change our physics when they get in.
  if (physics != default.physics)
    setPhysics(default.physics);
}

simulated function prevWeapon() {
  rollAccumulator -= rollUnit;
}

simulated function nextWeapon() {
  rollAccumulator += rollUnit;
}

simulated function updateRocketAcceleration(float deltaTime, float yawChange, float pitchChange) {
  // / 6000 because the aForward, etc. are 6000 by default when the appropriate button is pressed.
  shipThrust = (((vect(1,0,0) * PlayerController(Controller).aForward) + (vect(0,1,0) * PlayerController(Controller).aStrafe) + (vect(0,0,1) * PlayerController(Controller).aUp)) / 6000) >> rotation;
  if (vsize(shipThrust) > 1)
    shipThrust = normal(shipThrust);

  receivedRawRotationInput(deltaTime, yawChange, pitchChange, rollAccumulator);
  rollAccumulator = 0;
}

// This function allows a subclass to modify the inputs, eg by applying smoothing or acceleration.
simulated function receivedRawRotationInput(float deltaTime, float yawChange, float pitchChange, float rollChange) {
  receivedRotationInput(deltaTime, yawChange, pitchChange, rollChange);
}

simulated function receivedRotationInput(float deltaTime, float yawChange, float pitchChange, float rollChange);

simulated function rotator getControlRotation() {
  return rotation;
}

simulated function tick(float delta)
{
  super.tick(delta);

  if (controller == none) {
    shipThrust = vect(0,0,0);
    shipSteering = vect(0,0,0);
  }

  if(!KIsAwake() && controller != none)
    KWake();
    
  updateExtraForce(delta);
}

simulated function updateExtraForce(float delta)
{
  local vector worldForward, worldDown, worldLeft;
 
  worldForward = vect(1, 0, 0) >> getControlRotation();
  worldDown = vect(0, 0, -1) >> getControlRotation();
  worldLeft = vect(0, -1, 0) >> getControlRotation();
 
  ExtraForce = ExtraForce + shipThrust * maximumThrust * delta; // Speed
  ExtraTorque = ExtraTorque - worldDown * shipSteering.x * delta; // Yaw
  ExtraTorque = ExtraTorque - worldLeft * -shipSteering.y * delta; // Pitch
  ExtraTorque = ExtraTorque + worldForward * -shipSteering.z * delta; // Roll
}

simulated event KApplyForce(out vector Force, out vector Torque)
{
  // This actually does the applying of the piled up force
  Force = ExtraForce;
  Torque = ExtraTorque;
  ExtraForce = vect(0,0,0);
  ExtraTorque = vect(0,0,0);
}

DefaultProperties
{
  landMovementState=PlayerSpaceFlying

//  rollUnit=1024
  rollUnit=2048
  
  maximumRotationalAcceleration=10000
  maximumThrust=2500

  maximumThrust3d=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
  maximumRotationalAcceleration3d=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))

  bEdShouldSnap=True
  bStatic=False
  bShadowCast=False
  bCollideActors=True
  bCollideWorld=False
  bProjTarget=True
  bBlockActors=True
  bBlockNonZeroExtentTraces=True
  bBlockZeroExtentTraces=True
  bWorldGeometry=False
  bBlockKarma=True
  bAcceptsProjectors=True
  bCanBeBaseForPawns=True

  RemoteRole=ROLE_SimulatedProxy
  bNetInitialRotation=True
  bAlwaysRelevant=True
}
