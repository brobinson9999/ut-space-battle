class ConventionalAircraftControlMapper extends ShipControlMapper;

// Desired rotation torque is reduced each tick. This factor controls how rapidly old inputs decay.
var float turnDecayTime;
// Amount of rotation torque to apply for a given amount of mouse movement.
var float turnSensitivity;
var vector shipSteering;
var vector shipThrust;

var float steeringFireDirectionModifier;

simulated function updateControls(float deltaTime, rotator currentRotation, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange) {
  if (deltaTime >= turnDecayTime)
    shipSteering = vect(0,0,0);
  else
    shipSteering *= (turnDecayTime-deltaTime) / turnDecayTime;

  shipSteering.x = fclamp(shipSteering.x + (yawChange * turnSensitivity), -1, 1);
  shipSteering.y = fclamp(shipSteering.y + (pitchChange * turnSensitivity), -1, 1);
//  shipSteering.z = fclamp(shipSteering.z + (yawChange * turnSensitivity), -1, 1);

  shipThrust = capVector(((vect(1,0,0) * fwdChange) + (vect(0,1,0) * strafeChange) + (vect(0,0,1) * upChange)), 1) coordRot currentRotation;
}

simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration) {
  return shipSteering * vect(0,1,1);
}

simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration) {
  return shipThrust;
}

function rotator getWeaponFireRotation(rotator currentRotation) {
  return rotator(vector(copyVectToRot(shipSteering * vect(1,1,0) * steeringFireDirectionModifier)) >> currentRotation);
}

defaultProperties
{
  turnDecayTime=0.5

  turnSensitivity=0.0001

  steeringFireDirectionModifier=3500
}
