class OldFlyingDog extends CommonFlyingDog;

// Weapon
var       float FireCountdown;

var (FlyingDog) float   FireInterval;
var (FlyingDog) vector  weaponFireOffset;

function rotator getWeaponFireRotation() {
  return rotator(vector(class'BaseObject'.static.copyVectToRot(shipSteering * 10)) >> rotation);
}

simulated function vector getFireLocation() {
  return location + (weaponFireOffset >> rotation);
}

function fireWeapons(bool bWasAltFire)
{
  local vector FireLocation;
  local PlayerController PC;
  local rotator fireRotation;
  
  // Client can't do firing
  if(Role != ROLE_Authority)
    return;

  FireLocation = getFireLocation();

  while(FireCountdown <= 0)
  {
    fireRotation = getWeaponFireRotation();
    if(!bWasAltFire)
    {
      spawn(class'PROJ_TurretSkaarjPlasma', self, , FireLocation, fireRotation);

      // Play firing noise
      PlaySound(Sound'ONSVehicleSounds-S.Laser02', SLOT_None,,,,, false);
      PC = PlayerController(Controller);
      if (PC != None && PC.bEnableWeaponForceFeedback)
        PC.ClientPlayForceFeedback("RocketLauncherFire");
    }
    else
    {
      spawn(class'PROJ_SpaceFighter_Rocket', self, , FireLocation, rotator(vector(fireRotation) + Vrand() * 0.05));

      // Play firing noise
      PlaySound(Sound'AssaultSounds.HnShipFire01', SLOT_None,,,,, false);
      PC = PlayerController(Controller);
      if (PC != None && PC.bEnableWeaponForceFeedback)
        PC.ClientPlayForceFeedback("RocketLauncherFire");
    }

    FireCountdown += FireInterval;
  }
}

// Fire a rocket (if we've had time to reload!)
function VehicleFire(bool bWasAltFire)
{
  Super.VehicleFire(bWasAltFire);

  if(FireCountdown < 0)
  {
    FireCountdown = 0;
    fireWeapons(bWasAltFire);
  }
}

simulated function Tick(float Delta)
{
  Super.Tick(Delta);

  // Weapons (run on server and replicated to client)
  if(Role == ROLE_Authority)
  {
    // Countdown to next shot
    FireCountdown -= Delta;

    // This is for sustained barrages.
    // Primary fire takes priority
    if(bVehicleIsFiring)
      fireWeapons(false);
    else if(bVehicleIsAltFiring)
      fireWeapons(true);
  }
}

defaultproperties
{
  Physics=PHYS_Karma
  Begin Object Class=KarmaParamsRBFull Name=KParams0
    KActorGravScale=0
    KInertiaTensor(0)=20
    KInertiaTensor(1)=0
    KInertiaTensor(2)=0
    KInertiaTensor(3)=30
    KInertiaTensor(4)=0
    KInertiaTensor(5)=48
    KCOMOffset=(X=0.8,Y=0.0,Z=-0.7)
    KStartEnabled=True
    KFriction=1.6
    KLinearDamping=1
    KAngularDamping=10
    bKNonSphericalInertia=False
    bHighDetailOnly=False
    bClientOnly=False
    bKDoubleTickRate=True
    Name="KParams0"
  End Object
  KParams=KarmaParams'KParams0'

  // Weaponry
  FireInterval=0.1
  weaponFireOffset=(X=0,Y=0,Z=80)
}
