class ShipControlMapper extends BaseObject abstract;

simulated function updateControls(float deltaTime, rotator currentRotation, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange);
simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration);
simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration);

simulated function rotator getWeaponFireRotation(rotator currentRotation);

defaultproperties
{
}
