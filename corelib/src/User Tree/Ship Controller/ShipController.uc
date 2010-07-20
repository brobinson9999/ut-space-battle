class ShipController extends BaseObject;

simulated function vector getDesiredAcceleration(PhysicsStateInterface physicsState, float delta);
simulated function vector getDesiredRotation(PhysicsStateInterface physicsState, float shipRotationRate, float delta);

defaultproperties
{
}