class CommonFlyingDog extends KShip;

// triggers used to get into the FlyingDog
var const vector  FrontTriggerOffset;
var SVehicleTrigger  FLTrigger, FRTrigger;

// Maximum speed at which you can get in the vehicle.
var (FlyingDog) float TriggerSpeedThresh;
var bool      TriggerState; // true for on, false for off.

// Destroyed Buggy
var (FlyingDog) class<Actor>  DestroyedEffect;
var (FlyingDog) sound         DestroyedSound;

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

function rotator getWeaponFireRotation() {
  return rotator(vector(class'BaseObject'.static.copyVectToRot(getShipSteering() * 10)) >> rotation);
}

simulated function vector getFireLocation();

simulated function drawCrosshair(Canvas canvas) {
  drawPredictedHitLocationCrosshair(canvas, getFireLocation(), vector(getWeaponFireRotation()), crosshairTexture);
}

simulated function drawPredictedHitLocationCrosshair(Canvas canvas, vector fireLocation, vector fireDirection, Material localCrosshairTexture) {
  local vector startTrace, endTrace;
  local vector hitLocation, hitNormal;
  
  startTrace = fireLocation;
  endTrace = startTrace + (fireDirection * 100000);
  
  trace(hitLocation, hitNormal, endTrace, startTrace, true);
  
  drawLocationCrosshair(canvas, hitLocation, localCrosshairTexture);
}

simulated function drawLocationCrosshair(Canvas canvas, vector drawLocation, Material localCrosshairTexture) {
  local vector drawScreenPosition;
  
  drawScreenPosition = canvas.worldToScreen(drawLocation);
  
  Canvas.DrawColor = CrosshairColor;
  Canvas.DrawColor.A = 255;
  Canvas.Style = ERenderStyle.STY_Alpha;

  Canvas.SetPos(drawScreenPosition.x-(CrosshairTexture.USize/4), drawScreenPosition.y-(CrosshairTexture.VSize/4));
  Canvas.DrawTile(localCrosshairTexture, CrosshairTexture.USize/2, CrosshairTexture.VSize/2, 0.0, 0.0, CrosshairTexture.USize/2, CrosshairTexture.VSize/2);
}

simulated function Tick(float Delta)
{
  Local float VMag;

  Super.Tick(Delta);

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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
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
  DrawType=DT_Mesh
  Mesh=SkeletalMesh'AS_VehiclesFull_M.SpaceFighter_Skaarj'
  DrawScale=1

  DestroyedEffect=class'XEffects.RocketExplosion'
  DestroyedSound=sound'WeaponSounds.P1RocketLauncherAltFire'

  FrontTriggerOffset=(X=0,Y=165,Z=10)

  TriggerSpeedThresh=40

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
