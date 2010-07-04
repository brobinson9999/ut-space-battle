class ImperialThunderboltFighter extends ManualFlightDog;

simulated function createWeapons() {
  weapons[0] = new class'DogAutoCannon';
  weapons[1] = new class'DogMissilePods';
}

defaultproperties
{
  linearDrag=0.75
  linearDrag3D=(X=(Min=3,Max=0.5),Y=(Min=3,Max=3),Z=(Min=1.5,Max=1.5))

  rotationalDrag=0.5
  rotationalDrag3D=(X=(Min=3,Max=3),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
}
