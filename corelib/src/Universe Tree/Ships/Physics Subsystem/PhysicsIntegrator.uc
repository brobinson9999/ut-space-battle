class PhysicsIntegrator extends BaseObject;

simulated function linearPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector acceleration, optional bool bUseDesiredVelocity, optional vector desiredVelocity);
simulated function angularPhysicsUpdate(PhysicsStateInterface physicsState, float delta, rotator desiredRotation, float rotationRate);

defaultproperties
{
}