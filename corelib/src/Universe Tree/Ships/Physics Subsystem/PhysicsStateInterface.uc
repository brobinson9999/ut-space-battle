class PhysicsStateInterface extends BaseObject;

simulated function vector getLocation();
simulated function setLocation(vector newValue);

simulated function vector getVelocity();
simulated function setVelocity(vector newValue);

simulated function rotator getRotation();
simulated function setRotation(rotator newValue);

simulated function vector getRotationVelocity();
simulated function setRotationVelocity(vector newValue);

defaultproperties
{
}