class KShip extends VehicleAdapter;

// Used for Karma forces pileup
// Add to these variables to apply force and torque to the ship.
var vector extraForce, extraTorque;

// Amount to increment/decrement shipSteering.roll for every click of the mouse wheel.
var float rollUnit;
// Desired rotation torque is reduced each tick. This factor controls how rapidly old inputs decay.
var float turnDecayTime;
// Amount of rotation torque to apply for a given amount of mouse movement.
var float turnSensitivity;
// Maximum amount of rotation torque that can be accumulated.
var float maximumTurnRate;
// Maximum linear thrust the ship can apply.
var float maximumThrust;

// Desired torque on the ship - relative to it's current rotation.
var rotator shipSteering;
// Desired linear thrust to apply to the ship - not relative to it's current rotation.
var vector shipThrust;

/*
// Ship replication vars and functions, thanks daid!
struct StructShipState
{
  var KRBVec  ChassisPosition;
  var Quat    ChassisQuaternion;
  var KRBVec  ChassisLinVel;
  var KRBVec  ChassisAngVel;
 
  var rotator serverSteering;
  var vector  serverThrust;

  var bool    bNewState; // Set to true whenever a new state is received and should be processed
};
 
var KRigidBodyState ChassisState;
var StructShipState ShipState; // This is replicated to the ship, and processed to update all the parts.
var bool bNewShipState; // Indicated there is new data processed, and chassis RBState should be updated.
 
var float NextNetUpdateTime;  // Next time we should force an update of vehicles state.
var() float MaxNetUpdateInterval;
 
var int AVar;//Just for replication, else the ShipState doesn't get replicated

replication
{
  unreliable if(Role == ROLE_Authority)
    ShipState, AVar;
}
 
simulated event VehicleStateReceived()
{
  if(!ShipState.bNewState)
    return;
 
  // Get root chassis info
  ChassisState.Position = ShipState.ChassisPosition;
  ChassisState.Quaternion = ShipState.ChassisQuaternion;
  ChassisState.LinVel = ShipState.ChassisLinVel;
  ChassisState.AngVel = ShipState.ChassisAngVel;
 
  // Update control inputs
  shipSteering = ShipState.serverSteering;
  shipThrust = ShipState.serverThrust;
 
  // Update flags
  ShipState.bNewState = false;
  bNewShipState = true;
}
 
simulated event bool KUpdateState(out KRigidBodyState newState)
{
  // This should never get called on the server - but just in case!
  if(Role == ROLE_Authority || !bNewShipState)
    return false;
 
  // Apply received data as new position of ship chassis.
  newState = ChassisState;
  bNewShipState = false;
 
  return true;
}
 
function PackState()
{
  local vector chassisPos, chassisLinVel, chassisAngVel;
  local vector oldPos, oldLinVel;
  local KRigidBodyState localChassisState;
 
  // Get chassis state.
  KGetRigidBodyState(localChassisState);
 
  chassisPos = KRBVecToVector(localChassisState.Position);
  chassisLinVel = KRBVecToVector(localChassisState.LinVel);
  chassisAngVel = KRBVecToVector(localChassisState.AngVel);
 
  // Last position we sent
  oldPos = KRBVectoVector(ShipState.ChassisPosition);
  oldLinVel = KRBVectoVector(ShipState.ChassisLinVel);
 
  // See if state has changed enough, or enough time has passed, that we 
  // should send out another update by updating the state struct.
  if( !KIsAwake() )
  {
    return; // Never send updates if physics is at rest
  }
 
  if( VSize(oldPos - chassisPos) > 5 ||
    VSize(oldLinVel - chassisLinVel) > 1 ||
    abs(shipState.serverSteering.yaw - shipSteering.yaw) > 0.1 ||
    abs(shipState.serverSteering.pitch - shipSteering.pitch) > 0.1 ||
    abs(shipState.serverSteering.roll - shipSteering.roll) > 0.1 ||
    VSize(shipState.serverThrust - shipThrust) > 1 ||
    Level.TimeSeconds > NextNetUpdateTime )
  {
    NextNetUpdateTime = Level.TimeSeconds + MaxNetUpdateInterval;
  }
  else
  {
    return;
  }
 
  ShipState.ChassisPosition = localChassisState.Position;
  ShipState.ChassisQuaternion = localChassisState.Quaternion;
  ShipState.ChassisLinVel = localChassisState.LinVel;
  ShipState.ChassisAngVel = localChassisState.AngVel;
 
  shipState.serverSteering = shipSteering;
  shipState.serverThrust = shipThrust;
 
  // This flag lets the client know this data is new.
  ShipState.bNewState = true;
  //Make sure ShipState gets replicated
  AVar++;
  if (AVar > 10)
    AVar=0;
}
 */
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
  shipSteering.roll = fclamp(shipSteering.roll - (rollUnit * turnSensitivity), -maximumTurnRate, maximumTurnRate);
}

simulated function nextWeapon() {
  shipSteering.roll = fclamp(shipSteering.roll + (rollUnit * turnSensitivity), -maximumTurnRate, maximumTurnRate);
}

simulated function updateRocketAcceleration(float deltaTime, float yawChange, float pitchChange) {
  if (deltaTime >= turnDecayTime)
    shipSteering = rot(0,0,0);
  else
    shipSteering *= (turnDecayTime-deltaTime) / turnDecayTime;
  
  // / 6000 because the aForward, etc. are 6000 by default when the appropriate button is pressed.
  shipThrust = (((vect(1,0,0) * PlayerController(Controller).aForward) + (vect(0,1,0) * PlayerController(Controller).aStrafe) + (vect(0,0,1) * PlayerController(Controller).aUp)) / 6000) >> getControlRotation();
  if (vsize(shipThrust) > 1)
    shipThrust = normal(shipThrust);

  shipSteering.yaw = fclamp(shipSteering.yaw + (yawChange * turnSensitivity), -maximumTurnRate, maximumTurnRate);
  shipSteering.pitch = fclamp(shipSteering.pitch + (pitchChange * turnSensitivity), -maximumTurnRate, maximumTurnRate);
}

simulated function rotator getControlRotation() {
  return rotation;
}

  
simulated function tick(float delta)
{
  super.tick(delta);

  if (controller == none) {
    shipThrust = vect(0,0,0);
    shipSteering = rot(0,0,0);
  }

  if(!KIsAwake() && controller != none)
    KWake();
    
//  if(Role == ROLE_Authority && Level.NetMode != NM_StandAlone)
//    PackState();

  updateExtraForce(delta);
}

simulated function updateExtraForce(float delta)
{
  local vector worldForward, worldDown, worldLeft;
 
  worldForward = vect(1, 0, 0) >> getControlRotation();
  worldDown = vect(0, 0, -1) >> getControlRotation();
  worldLeft = vect(0, -1, 0) >> getControlRotation();
 
  ExtraForce = ExtraForce + shipThrust * maximumThrust * delta; // Speed
  ExtraTorque = ExtraTorque - worldDown * shipSteering.yaw * delta; // Yaw
  ExtraTorque = ExtraTorque - worldLeft * -shipSteering.pitch * delta; // Pitch
  ExtraTorque = ExtraTorque + worldForward * -shipSteering.roll * delta; // Roll
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

  rollUnit=1024
  
  turnDecayTime=0.5
  turnSensitivity=0.5
  maximumTurnRate=5000
  maximumThrust=2500

  Physics=PHYS_Karma
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
