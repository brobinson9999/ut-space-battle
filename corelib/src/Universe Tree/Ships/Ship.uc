class Ship extends BaseObject;

// lastUpdatedTime is the time that the ship's updateShip() method was called.
var private float lastUpdatedTime;

// Tracks the user that owns the ship.
var private User shipOwner;

// Friendly name for display purposes.
var string shipTypeName;

var private array<ShipSystem>           systems;
var array<ShipWeapon>           weapons;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var Pilot pilot;
var protected SpaceWorker_Ship shipWorker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var float                       radius;
var float                       acceleration;
var float                       rotationRate;       // Rotational Acceleration.

// TODO Move these to physics state.
var rotator                     rotation;
var vector                      rotationalVelocity;
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
// ** Things Delegated to ShipCommon

var private ShipCommon shipCommon;

simulated function ShipCommon getShipCommon() {
  if (shipCommon == none)
    setShipCommon(ShipCommon(allocateObject(class'ShipCommon')));

  return shipCommon;
}

simulated function setShipCommon(ShipCommon newShipCommon) {
  // clean anything out of old shipCommon here...
  if (shipCommon != none) {
    shipCommon.cleanup();
  }
  
  shipCommon = newShipCommon;

  if (shipCommon != none) {
    shipCommon.setPhysicsState(class'ShipReferencePhysicsState'.static.createNewShipReferencePhysicsState(self));
    shipCommon.setPhysicsIntegrator(PhysicsIntegrator(allocateObject(class'DefaultPhysicsIntegrator')));
    shipCommon.setShipControlStrategy(class'ShipReferenceShipControlStrategy'.static.createNewShipReferenceShipControlStrategy(self));
  }
}

simulated function PhysicsStateInterface getPhysicsState() {
  return getShipCommon().getPhysicsState();
}

simulated function PhysicsIntegrator getPhysicsIntegrator() {
  return getShipCommon().getPhysicsIntegrator();
}

simulated function addLaunchBay(ShipLaunchBay launchBay) {
  getShipCommon().addLaunchBay(launchBay);
}

simulated function removeLaunchBay(ShipLaunchBay launchBay) {
  getShipCommon().removeLaunchBay(launchBay);
}

simulated function Ship getDockedTo() {
  return getShipCommon().getDockedTo();
}

simulated function addCargo(Ship newCargo) {
  getShipCommon().addCargo(newCargo);
}

simulated function removeCargo(Ship oldCargo) {
  getShipCommon().removeCargo(oldCargo);
}
  
simulated function bool attemptDock(Ship dockee) {
  return getShipCommon().attemptDock(self, dockee);
}

simulated function bool acceptDock(Ship docker) {
  return getShipCommon().acceptDock(docker, self);
}

simulated function bool attemptUndock() {
  return getShipCommon().attemptUndock(self);
}

simulated function array<ShipLaunchBay> getLaunchBays() {
  return getShipCommon().getLaunchBays();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Things delegated elsewhere

simulated function vector getShipLocation() {
  return getPhysicsState().getLocation();
}

simulated function setShipLocation(vector newLocation) {
  getPhysicsState().setLocation(newLocation);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Things directly stored

simulated function SpaceWorker_Ship getShipWorker() {
  return shipWorker;
}

simulated function setShipWorker(SpaceWorker_Ship newWorker) {
  shipWorker = newWorker;
}

simulated function User getShipOwner() {
  return shipOwner;
}

simulated function setShipOwner(User other)
{
  if (shipOwner != none)
    shipOwner.userLostShip(self);

  shipOwner = other;

  if (shipOwner != none)
    shipOwner.userGainedShip(self);
}

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

  getShipCommon().maximumLinearAcceleration = acceleration;
  getShipCommon().maximumRotationalAcceleration = rotationRate;
  getShipCommon().updateShipPhysics(delta);
}

simulated function vector getLinearAcceleration(float delta) {
  if (pilot != none) {
    pilot.updateLinear();
    return pilot.getDesiredAcceleration(getPhysicsState(), delta);
  } else {
    return vect(0,0,0);
  }
}

simulated function vector getRotationalAcceleration(float delta) {
  if (pilot != none) {
    pilot.updateAngular();
    // TODO The pilot should be deciding this.
    pilot.bUseDesiredRotation = true;

    rotationalVelocity = normal(copyRotToVect(getDesiredRotation() unCoordRot rotation)) * vsize(rotationalVelocity);
    return pilot.getDesiredRotationalAcceleration(getPhysicsState(), rotationRate, delta);
  } else {
    return vect(0,0,0);
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function applyDamage(float quantity, object instigator);

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

  setShipWorker(none);
  setShipOwner(none);
  
  setShipCommon(none);

  if (Weapons.Length > 0)
    Weapons.Remove(0,Weapons.Length);

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

simulated function float detection_Strength_Against(Contact other);

// TODO This is used by the Contact class. Contact needs to be changed so that this is no longer necessary!
simulated function vector tempEstimateAcceleration() {
  return capVector(pilot.desiredVelocity - getPhysicsState().getVelocity(), acceleration);
}

simulated function rotator getDesiredRotation() {
  return pilot.desiredRotation;
}

defaultproperties
{
}