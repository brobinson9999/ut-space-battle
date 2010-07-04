class TauBarracuda extends AimingIntegratorDog;

simulated function createWeapons() {
  weapons[0] = new class'DogIonCannon';
  weapons[1] = new class'DogMissilePods';
}

simulated function postBeginPlay() {
  super.postBeginPlay();
  
  addTurret("UTTD.UTTDMinigunTurret", vect(150,200,-75));
  addTurret("UTTD.UTTDMinigunTurret", vect(150,-200,-75));
}

defaultproperties
{
  linearDrag=0.75
  linearDrag3D=(X=(Min=2,Max=0.75),Y=(Min=2,Max=2),Z=(Min=1.5,Max=1.5))

  rotationalDrag=0.5
  rotationalDrag3D=(X=(Min=1.25,Max=1.25),Y=(Min=0.75,Max=0.75),Z=(Min=1,Max=1))
}
