class VehicleAdapter extends Vehicle;

// Simple 'driving-in-rings' logic.
//var (KVehicle) bool   bAutoDrive;

// The factory that created this vehicle.
//var        KVehicleFactory  ParentFactory;

// Weapon system
var       bool  bVehicleIsFiring, bVehicleIsAltFiring;

const         FilterFrames = 5;
var       vector  CameraHistory[FilterFrames];
var       int   NextHistorySlot;
var       bool  bHistoryWarmup;

// Crosshair
var config Color CrosshairColor;
var config float CrosshairX, CrosshairY;
var config Texture CrosshairTexture;


function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation,
            Vector momentum, class<DamageType> damageType)
{
  Super.TakeDamage(Damage,instigatedBy,HitLocation,Momentum,DamageType);
}

// You got some new info from the server (ie. VehicleState has some new info).
event VehicleStateReceived();

// Called when a parameter of the overall articulated actor has changed (like PostEditChange)
// The script must then call KUpdateConstraintParams or Actor Karma mutators as appropriate.
simulated event KVehicleUpdateParams();

// The pawn Driver has tried to take control of this vehicle
function bool TryToDrive(Pawn P)
{
  if ( P.bIsCrouched || (P.Controller == None) || (Driver != None) || !P.Controller.bIsPlayer )
    return false;

    if ( !P.IsHumanControlled() || !P.Controller.IsInState('PlayerDriving') )
  {
    KDriverEnter(P);
    return true;
  }

  return false;
}

// Events called on driver entering/leaving vehicle

simulated function ClientKDriverEnter(PlayerController pc)
{
  pc.myHUD.bCrosshairShow = false;
  pc.myHUD.bShowWeaponInfo = false;
  pc.myHUD.bShowPoints = false;

  pc.bBehindView = true;
  pc.bFreeCamera = true;

    pc.SetRotation(rotator( vect(-1, 0, 0) >> Rotation ));
}

function KDriverEnter(Pawn P)
{
  local PlayerController PC;
  local Controller C;

  // Set pawns current controller to control the vehicle pawn instead
  Driver = P;

  // Move the driver into position, and attach to car.
  Driver.SetCollision(false, false);
  Driver.bCollideWorld = false;
  Driver.bPhysicsAnimUpdate = false;
  Driver.Velocity = vect(0,0,0);
  Driver.SetPhysics(PHYS_None);
  Driver.SetBase(self);

  // Disconnect PlayerController from Driver and connect to KVehicle.
  C = P.Controller;
  p.Controller.Unpossess();
  Driver.SetOwner(C); // This keeps the driver relevant.
  C.Possess(self);

  PC = PlayerController(C);
  if ( PC != None )
  {
    PC.ClientSetViewTarget(self); // Set playercontroller to view the vehicle

    // Change controller state to driver
    PC.GotoState('PlayerDriving');

    ClientKDriverEnter(PC);
  }
}

simulated function ClientKDriverLeave(PlayerController pc)
{
  pc.bBehindView = false;
  pc.bFreeCamera = false;
  // This removes any 'roll' from the look direction.
  //exitLookDir = Vector(pc.Rotation);
  //pc.SetRotation(Rotator(exitLookDir));

    pc.myHUD.bCrosshairShow = pc.myHUD.default.bCrosshairShow;
  pc.myHUD.bShowWeaponInfo = pc.myHUD.default.bShowWeaponInfo;
  pc.myHUD.bShowPoints = pc.myHUD.default.bShowPoints;

  // Reset the view-smoothing
  NextHistorySlot = 0;
  bHistoryWarmup = true;
}

// Called from the PlayerController when player wants to get out.
function bool KDriverLeave(bool bForceLeave)
{
  local PlayerController pc;
  local int i;
  local bool havePlaced;
  local vector HitLocation, HitNormal, tryPlace;

  // Do nothing if we're not being driven
  if(Driver == None)
    return false;

  // Before we can exit, we need to find a place to put the driver.
  // Iterate over array of possible exit locations.

  if (!bRemoteControlled)
    {

      Driver.bCollideWorld = true;
      Driver.SetCollision(true, true);

      havePlaced = false;
      for(i=0; i < ExitPositions.Length && havePlaced == false; i++)
      {
          //Log("Trying Exit:"$i);

          tryPlace = Location + (ExitPositions[i] >> Rotation);

          // First, do a line check (stops us passing through things on exit).
          if( Trace(HitLocation, HitNormal, tryPlace, Location, false) != None )
              continue;

          // Then see if we can place the player there.
          if( !Driver.SetLocation(tryPlace) )
              continue;

          havePlaced = true;
      }

      // If we could not find a place to put the driver, leave driver inside as before.
      if(!havePlaced && !bForceLeave)
      {
          Log("Could not place driver.");

          Driver.bCollideWorld = false;
          Driver.SetCollision(false, false);

          return false;
      }
  }

  pc = PlayerController(Controller);
  ClientKDriverLeave(pc);

  // Reconnect PlayerController to Driver.
  pc.Unpossess();
  pc.Possess(Driver);

  pc.ClientSetViewTarget(Driver); // Set playercontroller to view the persone that got out

  Controller = None;

  Driver.PlayWaiting();
  Driver.bPhysicsAnimUpdate = Driver.Default.bPhysicsAnimUpdate;

  // Do stuff on client
  //pc.ClientSetBehindView(false);
  //pc.ClientSetFixedCamera(true);

  if (!bRemoteControlled)
    {

      Driver.Acceleration = vect(0, 0, 24000);
    Driver.SetPhysics(PHYS_Falling);
    Driver.SetBase(None);
  }

  // Car now has no driver
  Driver = None;

  // Put brakes on before you get out :)
    Throttle=0;
    Steering=0;

  // Stop firing when you get out!
  bVehicleIsFiring = false;
  bVehicleIsAltFiring = false;

    return true;
}

// Special calc-view for vehicles
simulated function bool SpecialCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
  local vector CamLookAt, HitLocation, HitNormal;
  local PlayerController pc;
  local int i, averageOver;

  pc = PlayerController(Controller);

  // Only do this mode we have a playercontroller viewing this vehicle
  if(pc == None || pc.ViewTarget != self)
    return false;

  ViewActor = self;

  if (PC.bBehindView)
    CamLookAt = Location + (vect(-100, 0, 200) >> Rotation);
  else
    CamLookAt = Location;

  //////////////////////////////////////////////////////
  // Smooth lookat position over a few frames.
  CameraHistory[NextHistorySlot] = CamLookAt;
  NextHistorySlot++;

  if(bHistoryWarmup)
    averageOver = NextHistorySlot;
  else
    averageOver = FilterFrames;

  CamLookAt = vect(0, 0, 0);
  for(i=0; i<averageOver; i++)
    CamLookAt += CameraHistory[i];

  CamLookAt /= float(averageOver);

  if(NextHistorySlot == FilterFrames)
  {
    NextHistorySlot = 0;
    bHistoryWarmup=false;
  }
  //////////////////////////////////////////////////////

  if (PC.bBehindView) {
    CameraLocation = CamLookAt + (vect(-600, 0, 0) >> CameraRotation);

    if( Trace( HitLocation, HitNormal, CameraLocation, CamLookAt, false, vect(10, 10, 10) ) != None )
    {
      CameraLocation = HitLocation;
    }
  } else {
    CameraLocation = CamLookAt;
  }
  
  return true;
}

simulated function drawCrosshair(Canvas canvas) {
  //if (IsLocallyControlled() && ActiveWeapon < Weapons.length && Weapons[ActiveWeapon] != None && Weapons[ActiveWeapon].bShowAimCrosshair && Weapons[ActiveWeapon].bCorrectAim)
  //{
    Canvas.DrawColor = CrosshairColor;
    Canvas.DrawColor.A = 255;
    Canvas.Style = ERenderStyle.STY_Alpha;

    Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
    Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0+1, CrosshairY*2.0+1, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
  //}
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    
    drawCrosshair(canvas);

    PC = PlayerController(Controller);
  if (PC != None && !PC.bBehindView && HUDOverlay != None)
  {
        if (!Level.IsSoftwareRendering())
        {
        CameraRotation = PC.Rotation;
        SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
        HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
        HUDOverlay.SetRotation(CameraRotation);
        Canvas.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1, 170));
      }
  }
  else
        ActivateOverlay(False);
}

simulated function Destroyed()
{
  // If there was a driver in the vehicle, destroy him too
  if ( Driver != None )
    Driver.Destroy();

  Super.Destroyed();
}

simulated event Tick(float deltaSeconds)
{
}

// Includes properties from KActor
defaultproperties
{
  Steering=0
  Throttle=0

  ExitPositions(0)=(X=0,Y=0,Z=0)

  DrivePos=(X=0,Y=0,Z=0)
  DriveRot=()

  bHistoryWarmup = true

  bEdShouldSnap=True
  bStatic=False
  bShadowCast=False

  bCollideActors=True
  bCollideWorld=False
  bProjTarget=True
  bBlockActors=True
  bBlockNonZeroExtentTraces=True
  bBlockZeroExtentTraces=True
  bBlockKarma=True

  bAcceptsProjectors=True
  bCanBeBaseForPawns=True

  bWorldGeometry=False

  bAlwaysRelevant=True
  RemoteRole=ROLE_SimulatedProxy
  bNetInitialRotation=True

  bSpecialCalcView=True
  bSpecialHUD=true

  CrosshairColor=(R=0,G=255,B=0,A=255)
  CrosshairX=32
  CrosshairY=32
  CrosshairTexture=Texture'ONSInterface-TX.tankBarrelAligned'
}
