class TauBarracuda extends MapperDog;

var array<actor> turrets;

simulated function createWeapons() {
  local DogMissilePods missilePods;

  weapons[0] = new class'DogIonCannon';
  
  missilePods = new class'DogMissilePods';
  weapons[1] = missilePods;
  
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(10,60,0);
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(10,-60,0);
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(8,70,0);
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(8,-70,0);

  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(6,80,0);
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(6,-80,0);
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(4,90,0);
  missilePods.fireOffsets[missilePods.fireOffsets.length] = vect(4,-90,0);
}

simulated function postBeginPlay() {
  super.postBeginPlay();
  
  turrets[turrets.length] = addTurret("UTTD.UTTDMinigunTurret", vect(150,200,-75));
  turrets[turrets.length] = addTurret("UTTD.UTTDMinigunTurret", vect(150,-200,-75));
}

simulated function destroyed() {
  while (turrets.length > 0) {
    if (turrets[0] != none && !turrets[0].bDeleteMe)
      turrets[0].destroy();
    turrets.remove(0,1);
  }
  
  super.destroyed();
}

simulated function drawCrosshair(Canvas canvas) {
  super.drawCrosshair(canvas);

  drawLocationCrosshair(canvas, location + vector(AimingShipControlMapper(getControlMapper()).desiredAim) * 2500, texture'Crosshairs.HUD.Crosshair_Pointer');
}

defaultproperties
{
  VehiclePositionString="flying a Barracuda"
  VehicleNameString="Tau Barracuda"

  maximumThrust=2500
//  maximumThrust3d=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
//  maximumThrust3d=(X=(Min=2,Max=0.75),Y=(Min=2,Max=2),Z=(Min=1.5,Max=1.5))

  linearDrag=0.75
//  linearDrag3D=(X=(Min=2,Max=0.75),Y=(Min=2,Max=2),Z=(Min=1.5,Max=1.5))

  maximumRotationalAcceleration=10000
//  maximumRotationalAcceleration3d=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
//  maximumRotationalAcceleration3d=(X=(Min=1.25,Max=1.25),Y=(Min=0.75,Max=0.75),Z=(Min=1,Max=1))

  rotationalDrag=0.5
//  rotationalDrag3D=(X=(Min=1.25,Max=1.25),Y=(Min=0.75,Max=0.75),Z=(Min=1,Max=1))

  controlMapperClass=class'AimingShipControlMapper'
}
