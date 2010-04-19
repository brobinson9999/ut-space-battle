class FlyingDog extends KShip placeable CacheExempt;

// triggers used to get into the FlyingDog
var const vector  FrontTriggerOffset;
var SVehicleTrigger  FLTrigger, FRTrigger;

// Maximum speed at which you can get in the vehicle.
var (FlyingDog) float TriggerSpeedThresh;
var bool      TriggerState; // true for on, false for off.

// Destroyed Buggy
var (FlyingDog) class<Actor>  DestroyedEffect;
var (FlyingDog) sound         DestroyedSound;

// Weapon
var       float FireCountdown;

var (FlyingDog) float   FireInterval;
var (FlyingDog) vector  weaponFireOffset;

simulated function PostNetBeginPlay()
{
  local vector RotX, RotY, RotZ;

  Super.PostNetBeginPlay();

  GetAxes(Rotation,RotX,RotY,RotZ);

  // Only have triggers on server
  if(Level.NetMode != NM_Client)
  {
    // Create triggers for gettting into the FlyingDog
    FLTrigger = spawn(class'SVehicleTrigger', self,, Location + FrontTriggerOffset.X * RotX + FrontTriggerOffset.Y * RotY + FrontTriggerOffset.Z * RotZ);
    FLTrigger.SetBase(self);
    FLTrigger.SetCollision(true, false, false);

    FRTrigger = spawn(class'SVehicleTrigger', self,, Location + FrontTriggerOffset.X * RotX - FrontTriggerOffset.Y * RotY + FrontTriggerOffset.Z * RotZ);
    FRTrigger.SetBase(self);
    FRTrigger.SetCollision(true, false, false);

    TriggerState = true;
  }

  // If this is not 'authority' version - don't destroy it if there is a problem.
  // The network should sort things out.
  if(Role != ROLE_Authority) {
    KarmaParams(KParams).bDestroyOnSimError = False;
  }
}

simulated event Destroyed()
{
  // Clean up random stuff attached to the car
  if(Level.NetMode != NM_Client)
  {
    FLTrigger.Destroy();
    FRTrigger.Destroy();
  }

  Super.Destroyed();

  // Trigger destroyed sound and effect
  if(Level.NetMode != NM_DedicatedServer)
  {
    spawn(DestroyedEffect, self, , Location );
    PlaySound(DestroyedSound);
  }
}

function KDriverEnter(Pawn p)
{
  Super.KDriverEnter(p);

  p.bHidden = True;
  ReceiveLocalizedMessage(class'Vehicles.BulldogMessage', 1);
}

function bool KDriverLeave(bool bForceLeave)
{
  local Pawn OldDriver;

  OldDriver = Driver;

  // If we succesfully got out of the car, make driver visible again.
  if( Super.KDriverLeave(bForceLeave) )
  {
    OldDriver.bHidden = false;
    AmbientSound = None;
    return true;
  }
  else
    return false;
}

function fireWeapons(bool bWasAltFire)
{
  local vector FireLocation;
  local PlayerController PC;
  
  // Client can't do firing
  if(Role != ROLE_Authority)
    return;

  FireLocation = Location + (weaponFireOffset >> Rotation);

  while(FireCountdown <= 0)
  {
    if(!bWasAltFire)
    {
      spawn(class'PROJ_TurretSkaarjPlasma', self, , FireLocation, rotation);

      // Play firing noise
      PlaySound(Sound'ONSVehicleSounds-S.Laser02', SLOT_None,,,,, false);
      PC = PlayerController(Controller);
      if (PC != None && PC.bEnableWeaponForceFeedback)
        PC.ClientPlayForceFeedback("RocketLauncherFire");
    }
    else
    {
      spawn(class'PROJ_SpaceFighter_Rocket', self, , FireLocation, rotator(vector(rotation) + Vrand() * 0.05));

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
  Local float VMag;

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

  // Dont have triggers on network clients.
  if(Level.NetMode != NM_Client)
  {
    // If vehicle is moving, disable collision for trigger.
    VMag = VSize(Velocity);

    if(VMag < TriggerSpeedThresh && TriggerState == false)
    {
      FLTrigger.SetCollision(true, false, false);
      FRTrigger.SetCollision(true, false, false);
      TriggerState = true;
    }
    else if(VMag > TriggerSpeedThresh && TriggerState == true)
    {
      FLTrigger.SetCollision(false, false, false);
      FRTrigger.SetCollision(false, false, false);
      TriggerState = false;
    }
  }
}

// Really simple at the moment!
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation,
            Vector momentum, class<DamageType> damageType)
{
  // Avoid damage healing the car!
  if(Damage < 0)
    return;

  if(damageType == class'DamTypeSuperShockBeam')
    Health -= 100; // Instagib doesn't work on vehicles
  else
    Health -= 0.5 * Damage; // Weapons do less damage

  // The vehicle is dead!
  if(Health <= 0)
  {
    if ( Controller != None )
    {
      if( Controller.bIsPlayer )
      {
        ClientKDriverLeave(PlayerController(Controller)); // Just to reset HUD etc.
        Controller.PawnDied(self); // This should unpossess the controller and let the player respawn
      }
      else
        Controller.Destroy();
    }

    Destroy(); // Destroy the vehicle itself (see Destroyed below)
  }

    //KAddImpulse(momentum, hitlocation);
}

// AI Related code
function Actor GetBestEntry(Pawn P)
{
  if ( VSize(P.Location - FLTrigger.Location) < VSize(P.Location - FRTrigger.Location) )
    return FLTrigger;
  return FRTrigger;
}

defaultproperties
{
  DrawType=DT_StaticMesh
  StaticMesh=StaticMesh'BulldogMeshes.Simple.S_Chassis'

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

  DrawScale=0.4
  drawScale3D=(x=-1,y=1,z=1)

  DestroyedEffect=class'XEffects.RocketExplosion'
  DestroyedSound=sound'WeaponSounds.P1RocketLauncherAltFire'

  FrontTriggerOffset=(X=0,Y=165,Z=10)

  TriggerSpeedThresh=40

  // Weaponry
  FireInterval=0.1
  weaponFireOffset=(X=0,Y=0,Z=80)

  // Driver positions
  ExitPositions(0)=(X=0,Y=200,Z=100)
  ExitPositions(1)=(X=0,Y=-200,Z=100)
  ExitPositions(2)=(X=350,Y=0,Z=100)
  ExitPositions(3)=(X=-350,Y=0,Z=100)

  DrivePos=(X=-165,Y=0,Z=-100)

  Health=800
  HealthMax=800

  SoundRadius=255
}
