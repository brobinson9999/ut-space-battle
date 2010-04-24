class Ship extends BaseObject;

// lastUpdatedTime is the time that the ship's updateShip() method was called.
var private float lastUpdatedTime;

// Tracks the user that owns the ship.
var private User shipOwner;

// Friendly name for display purposes.
var string shipTypeName;

// Tracks Ship objects which are held in this ship's cargo bay.
var private DockingSubsystem    dockingSubsystem;


var array<ShipSystem>           systems;
var array<ShipWeapon>           weapons;
var array<ShipLaunchBay>        launchBays;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var Pilot pilot;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var PhysicsIntegrator physicsIntegrator;
var PhysicsStateInterface physicsState;

var float                       radius;
var float                       acceleration;

var rotator                     rotation;
var rotator                     desiredRotation;

var float                       rotationRate;       // Rotational Acceleration.
var float                       lastRotationSpeed;  // Rotational "Speed".

var vector                      shipLocation;
var vector                      velocity;

var Sector sector;
var array<ShipObserver> shipObservers;

var bool bCleanedUp;
var QueuedEvent destroyEvent;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var bool bUseDesiredVelocity;

var vector DesiredVelocity;
var vector DesiredLocation;
var vector desiredAcceleration;

var Contact DesiredVelocity_RelativeTo;
var Contact DesiredLocation_RelativeTo;

// temporary
simulated function SpaceWorker_Ship getShipWorker() {
  if (AIPilot(pilot) != none)
    return AIPilot(pilot).getPilotShipWorker();
  else
    return none;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PhysicsStateInterface getPhysicsState() {
  if (physicsState == none) {
    physicsState = PhysicsStateInterface(allocateObject(class'ShipReferencePhysicsState'));
    ShipReferencePhysicsState(physicsState).setReference(self);
  }

  return physicsState;
}

simulated function PhysicsIntegrator getPhysicsIntegrator() {
  if (physicsIntegrator == none) {
    physicsIntegrator = PhysicsIntegrator(allocateObject(class'DefaultPhysicsIntegrator'));
  }
  
  return physicsIntegrator;
}

simulated function vector getShipLocation() {
  return shipLocation;
}

simulated function setShipLocation(vector newLocation) {
  shipLocation = newLocation;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setShipOwner(User other)
{
  if (shipOwner != none)
    shipOwner.userLostShip(self);

  shipOwner = other;

  if (shipOwner != none)
    shipOwner.userGainedShip(self);
}
  
simulated function User getShipOwner() {
  return shipOwner;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function addSystem(ShipSystem newSystem) {
    systems[systems.length] = newSystem;
    newSystem.addedToShip(self);
  }
  
  simulated function removeSystem(ShipSystem oldSystem) {
    local int i;
    
    for (i=0;i<systems.length;i++) {
      if (systems[i] == oldSystem) {
        systems.remove(i, 1);
        oldSystem.removedFromShip(self);
        break;
      }
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function addShipObserver(ShipObserver newObserver) {
    shipObservers[shipObservers.length] = newObserver;
  }
  
  simulated function removeShipObserver(ShipObserver oldObserver) {
    local int i;
    
    for (i=0;i<shipObservers.length;i++) {
      if (shipObservers[i] == oldObserver) {
        shipObservers.remove(i, 1);
        break;
      }
    }
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setSector(Sector newSector) {
  if (shipOwner != none)
    shipOwner.getOrCreateSectorPresenceForSector(newSector);
  sector = newSector;
}

simulated function changeSector(Sector newSector) {
  // Set New Sector. Sectors handle the changing of RenderData.
  if (sector != none)
    sector.shipLeftSector(self);
  if (newSector != none)
    newSector.shipEnteredSector(self);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initializeShip() {
  // I don't like having an initialization function for the ship, but this has to go somewhere.
  lastUpdatedTime = getCurrentTime();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function updateShip()
{
  local int i;
  local float delta;

  // Find Elapsed time. Abort if no change.
  if (lastUpdatedTime == getCurrentTime()) return;
  delta = getCurrentTime() - lastUpdatedTime;
  lastUpdatedTime = getCurrentTime();

  myAssert(!bCleanedUp, "Ship update when bCleanedUp");

  for (i=systems.length-1;i>=0;i--)
    systems[i].updateShipSystem();

  // Update Linear movement.
  if (Pilot != None) Pilot.UpdateLinear();
  getPhysicsIntegrator().linearPhysicsUpdate(getPhysicsState(), delta, normal(desiredAcceleration) * fmin(acceleration, vsize(desiredAcceleration)), bUseDesiredVelocity, desiredVelocity);

  // Update Angular movement.
  // The pilot is updated for it's angular movement AFTER the linear physics has been updated, so it can set it's desired rotation based on it's new position rather than the position from
  // before the linear update. Hopefully this allows for a little better tracking of targets at high speed.
  if (Pilot != None) Pilot.UpdateAngular();
  getPhysicsIntegrator().angularPhysicsUpdate(getPhysicsState(), delta, desiredRotation, rotationRate);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function applyDamage(float quantity, object instigator);
//simulated function repair(float quantity);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function shipCritical(object instigator)
{
  local int i;
  
  for (i=systems.length-1;i>=0;i--)
    if (systems[i].bEnabled)
      systems[i].disableSystem();
      
  if (SpaceGameSimulation(getGameSimulation()) != none)
    SpaceGameSimulation(getGameSimulation()).notifyShipKilled(self, instigator);

  setShipOwner(none);

  destroyEvent = getClock().addAlarm(getCurrentTime() + 5, self);
  destroyEvent.callback = destroyTimeElapsed;
//    destroyTime = getCurrentTime() + 5;
}

simulated function destroyTimeElapsed() {
  cleanup();
}

// destroys the ship if necessary and cleans the ship up immediately
simulated function cleanupShipNOW() {
  shipCritical(none);
  destroyTimeElapsed();
  cleanup();
}

simulated function reset() {
  super.reset();
  bCleanedUp = false;
}

simulated function cleanup()
{
  myAssert(!bCleanedUp, "Ship cleanup when bCleanedUp");

  if (destroyEvent != none) {
    if (getClock() != none)
      getClock().removeAlarm(destroyEvent);
    destroyEvent = none;
  }

  // 20090210: Should this be after or before it leaves the sector? It's not "destroyed" until it leaves, but the game might want to know where the ship was before it was destroyed.
  if (SpaceGameSimulation(getGameSimulation()) != none)
    SpaceGameSimulation(getGameSimulation()).notifyShipDestroyed(self);

  if (sector != none)
    sector.shipLeftSector(self);

  if (Sector != None) {
    Sector.ShipLeftSector(Self);
    Sector = None;
  }

  setShipOwner(None);
  DesiredVelocity_RelativeTo = None;

  if (dockingSubsystem != none) {
    dockingSubsystem.cleanup();
    dockingSubsystem = none;
  }

  if (physicsIntegrator != none) {
    physicsIntegrator.cleanup();
    physicsIntegrator = none;
  }

  if (physicsState != none) {
    physicsState.cleanup();
    physicsState = none;
  }
  
  if (Weapons.Length > 0)
    Weapons.Remove(0,Weapons.Length);

  while (launchBays.length > 0)
    removeLaunchBay(launchBays[0]);

  while (systems.length > 0)
    removeSystem(systems[0]);

  while (shipObservers.length > 0)
    removeShipObserver(shipObservers[0]);

  pilot = none;
  
  bCleanedUp = true;

  super.cleanup();
}

simulated function Ship cloneShip()
{
  local Ship clone;

  clone = Ship(allocateObject(self.class));
  initializeClonedShip(clone);

  return clone;
}

simulated function initializeClonedShip(Ship clone)
{
  local int i;
  
  clone.acceleration          = acceleration;
  clone.rotationRate          = rotationRate;
  clone.radius                = radius;
  clone.shipTypeName          = shipTypeName;
  
  for (i=0;i<systems.length;i++)
    clone.addSystem(systems[i].cloneSystem());
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated protected function DockingSubsystem getDockingSubsystem() {
  if (dockingSubsystem == none) {
    dockingSubsystem = DockingSubsystem(allocateObject(class'DefaultDockingSubsystem'));
  }

  return dockingSubsystem;
}

simulated function addLaunchBay(ShipLaunchBay launchBay) {
  launchBays[launchBays.length] = launchBay;
}

simulated function removeLaunchBay(ShipLaunchBay launchBay) {
  local int i;
  
  for (i=0;i<launchBays.length;i++)
    if (launchBays[i] == launchBay) {
      launchBays.remove(i,1);
      return;
    }
    
  myAssert(false, "Ship.removeLaunchBay attempted to remove a launch bay that was not in it's list of bays");
}

simulated function Ship getDockedTo() {
  // Checks first to see if there is a docking subystem, so we don't create it unecessarily.
  if (dockingSubsystem == none)
    return none;
  else
    return getDockingSubsystem().getDockedTo();
}

simulated function addCargo(Ship newCargo) {
  getDockingSubsystem().addCargo(newCargo);
}

simulated function removeCargo(Ship oldCargo) {
  getDockingSubsystem().removeCargo(oldCargo);
}
  
simulated function bool attemptDock(Ship dockee) {
  return getDockingSubsystem().attemptDock(self, dockee);
}

simulated function bool acceptDock(Ship docker) {
  return getDockingSubsystem().acceptDock(docker, self);
}

simulated function bool attemptUndock() {
  return getDockingSubsystem().attemptUndock(self, getDockedTo());
}

// getOutermostDockee: -> Ship
// Returns this ship if it is not docked in another ship. If it is docked in another ship, that ship's "outermost carrier" is returned.
simulated function Ship getOutermostDockee() {
  local Ship dockedTo;
  
  dockedTo = getDockedTo();
  if (dockedTo == none)
    return self;
  else
    return dockedTo.getOutermostDockee();
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float detection_Strength_Against(Contact other);

defaultproperties
{
}