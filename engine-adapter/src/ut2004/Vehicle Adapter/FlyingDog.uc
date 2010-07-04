class FlyingDog extends KShip placeable CacheExempt;

// This class holds the behaviour for the vehicle, aside from anything to do with it's physics or controls.

// triggers used to get into the FlyingDog
var const vector  FrontTriggerOffset;
var SVehicleTrigger  FLTrigger, FRTrigger;

// Maximum speed at which you can get in the vehicle.
var (FlyingDog) float TriggerSpeedThresh;
var bool      TriggerState; // true for on, false for off.

// Destroyed Buggy
var (FlyingDog) class<Actor>  DestroyedEffect;
var (FlyingDog) sound         DestroyedSound;

var float   fireInterval, altFireInterval;
var vector  weaponFireOffset;

var array<DogWeapon> weapons;

simulated function createWeapons();

simulated function PostNetBeginPlay()
{
  local vector RotX, RotY, RotZ;

  Super.PostNetBeginPlay();

  createWeapons();
  
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

simulated event destroyed()
{
  while (weapons.length > 0) {
    if (weapons[0].bFiring)
      weapons[0].setFiring(false, self);
    weapons[0].cleanup();
    weapons.remove(0,1);
  }
  
 // Clean up random stuff attached to the car
  if(Level.NetMode != NM_Client)
  {
    FLTrigger.Destroy();
    FRTrigger.Destroy();
  }

  super.destroyed();

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

function rotator getWeaponFireRotation();

simulated function drawCrosshair(Canvas canvas) {
  drawPredictedHitLocationCrosshair(canvas, getFireLocation(), vector(getWeaponFireRotation()), crosshairTexture);
}

simulated function drawPredictedHitLocationCrosshair(Canvas canvas, vector fireLocation, vector fireDirection, Material localCrosshairTexture) {
  local vector startTrace, endTrace;
  local vector hitLocation, hitNormal;
  local vector drawPosition;
  
  startTrace = fireLocation;
  endTrace = startTrace + (fireDirection * 100000);
  
  trace(hitLocation, hitNormal, endTrace, startTrace, true);
  
  drawPosition = canvas.worldToScreen(hitLocation);
  
  Canvas.DrawColor = CrosshairColor;
  Canvas.DrawColor.A = 255;
  Canvas.Style = ERenderStyle.STY_Alpha;

  Canvas.SetPos(drawPosition.x-CrosshairX, drawPosition.y-CrosshairY);
  Canvas.DrawTile(localCrosshairTexture, CrosshairX*2.0+1, CrosshairY*2.0+1, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
}


simulated function vector getFireLocation() {
  return location + (weaponFireOffset >> rotation);
}


function vehicleFire(bool bWasAltFire) {
  super.vehicleFire(bWasAltFire);

  // Client can't do firing
  if(Role != ROLE_Authority)
    return;

  if (!bWasAltFire) {
    if (weapons.length > 0 && weapons[0] != none) {
      weapons[0].setFiring(true, self);
      weapons[0].tick(0, self);
    }
  } else {
    if (weapons.length > 1 && weapons[1] != none) {
      weapons[1].setFiring(true, self);
      weapons[1].tick(0, self);
    }
  }
}

function vehicleCeaseFire(bool bWasAltFire) {
  super.vehicleCeaseFire(bWasAltFire);

  // Client can't do firing
  if(Role != ROLE_Authority)
    return;

  if (!bWasAltFire) {
    if (weapons.length > 0 && weapons[0] != none) {
      weapons[0].setFiring(false, self);
      weapons[0].tick(0, self);
    }
  } else {
    if (weapons.length > 1 && weapons[1] != none) {
      weapons[1].setFiring(false, self);
      weapons[1].tick(0, self);
    }
  }
}


simulated function Tick(float Delta)
{
  local int i;
  Local float VMag;

  Super.Tick(Delta);

  // Weapons (run on server and replicated to client)
  if(Role == ROLE_Authority)
  {
    if ((controller != none && controller.bFire > 0) != bWeaponIsFiring) {
      if (bWeaponIsFiring)
        clientVehicleCeaseFire(false);
      else
        fire();
    }
    
    if ((controller != none && controller.bAltFire > 0) != bWeaponIsAltFiring) {
      if (bWeaponIsAltFiring)
        clientVehicleCeaseFire(true);
      else
        altFire();
    }

    for (i=0;i<weapons.length;i++)
      weapons[i].tick(delta, self);
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

function takeDamage(int Damage, Pawn instigatedBy, Vector hitlocation,
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
//  BeamEffectClass=class'mONSMASCannonBeamEffect'

  DestroyedEffect=class'XEffects.RocketExplosion'
  DestroyedSound=sound'WeaponSounds.P1RocketLauncherAltFire'

  FrontTriggerOffset=(X=0,Y=165,Z=10)

  TriggerSpeedThresh=40

  // Weaponry
  fireInterval=2
  altFireInterval=1
//  weaponFireOffset=(X=0,Y=0,Z=80)
  weaponFireOffset=(X=15,Y=40,Z=-10)
  
  // Driver positions
  ExitPositions(0)=(X=0,Y=200,Z=100)
  ExitPositions(1)=(X=0,Y=-200,Z=100)
  ExitPositions(2)=(X=350,Y=0,Z=100)
  ExitPositions(3)=(X=-350,Y=0,Z=100)

  DrivePos=(X=-165,Y=0,Z=-100)

  Health=300
  HealthMax=300

  SoundRadius=255
}
