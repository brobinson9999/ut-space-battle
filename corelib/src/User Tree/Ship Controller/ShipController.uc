class ShipController extends BaseObject;

simulated function vector getDesiredAcceleration(PhysicsStateInterface physicsState, float delta);
simulated function vector getDesiredRotationalAcceleration(PhysicsStateInterface physicsState, float shipRotationRate, float delta);

defaultproperties
{
}