class ShipControlMapper extends BaseObject abstract;

simulated function updateControls(float deltaTime, rotator currentRotation, float yawChange, float pitchChange, float rollChange);
simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration);

simulated function rotator getWeaponFireRotation(rotator currentRotation);

defaultproperties
{
}
