class PhysicsIntegrator extends BaseObject;

simulated function linearPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector acceleration);
simulated function angularPhysicsUpdate(PhysicsStateInterface physicsState, float delta, vector rotationalAcceleration);

defaultproperties
{
}