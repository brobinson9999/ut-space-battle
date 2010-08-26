class ShipControlStrategy extends BaseObject abstract;

simulated function vector getShipSteering(float deltaTime, PhysicsStateInterface physicsState, float maximumRotationalAcceleration);
simulated function vector getShipThrust(float deltaTime, PhysicsStateInterface physicsState, float maximumAcceleration);

defaultproperties
{
}
