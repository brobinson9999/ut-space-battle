class ImperialThunderboltFighter extends ManualFlightDog;

simulated function createWeapons() {
  weapons[0] = new class'DogAutoCannon';
  weapons[1] = new class'ImperialTwinLascannon';
}

simulated function drawCrosshair(Canvas canvas) {
  super.drawCrosshair(canvas);

  drawLocationCrosshair(canvas, location + vector(getWeaponFireRotation()) * 2500, texture'Crosshairs.HUD.Crosshair_Cross5');
}

defaultproperties
{
  VehiclePositionString="flying a Thunderbolt"
  VehicleNameString="Imperial Thunderbolt Fighter"

  maximumThrust=2500
//  maximumThrust3d=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
//  maximumThrust3d=(X=(Min=3,Max=0.5),Y=(Min=3,Max=3),Z=(Min=1.5,Max=1.5))

  linearDrag=0.75
//  linearDrag3D=(X=(Min=3,Max=0.5),Y=(Min=3,Max=3),Z=(Min=1.5,Max=1.5))

  maximumRotationalAcceleration=10000
//  maximumRotationalAcceleration3d=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
//  maximumRotationalAcceleration3d=(X=(Min=3,Max=3),Y=(Min=1,Max=1),Z=(Min=1,Max=1))

  rotationalDrag=0.5
//  rotationalDrag3D=(X=(Min=3,Max=3),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
}
