class ShipControlMapper extends ShipControlStrategy abstract;

simulated function updateControls(float deltaTime, rotator currentRotation, float fwdChange, float strafeChange, float upChange, float yawChange, float pitchChange, float rollChange);
simulated function rotator getWeaponFireRotation(rotator currentRotation);

defaultproperties
{
}
