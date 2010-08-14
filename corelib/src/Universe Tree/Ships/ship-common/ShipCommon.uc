class ShipCommon extends BaseObject;

// This class contains functionality for an abstract ship. It can be composed with another
// ship class that interacts more concretely with the engine. Calls should be made into
// this class, while this class will use the ShipObserver to send out any necessary callbacks.

var private array<ShipLaunchBay> launchBays;
var private DockingSubsystem dockingSubsystem;

var private PhysicsIntegrator physicsIntegrator;
var private PhysicsStateInterface physicsState;
var private ShipControlStrategy shipControlStrategy;

var float maximumLinearAcceleration;
var float maximumRotationalAcceleration;

var array<ShipObserver> shipObservers;

// DEBUGGING
var bool bCleanedUp;


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

simulated function array<ShipObserver> getShipObservers() {
  return shipObservers;
}

simulated function PhysicsStateInterface getPhysicsState() {
  return physicsState;
}

simulated function setPhysicsState(PhysicsStateInterface newPhysicsState) {
  physicsState = newPhysicsState;
}

simulated function PhysicsIntegrator getPhysicsIntegrator() {
  return physicsIntegrator;
}

simulated function setPhysicsIntegrator(PhysicsIntegrator newPhysicsIntegrator) {
  physicsIntegrator = newPhysicsIntegrator;
}

simulated function ShipControlStrategy getShipControlStrategy() {
  return shipControlStrategy;
}

simulated function setShipControlStrategy(ShipControlStrategy newShipControlStrategy) {
  shipControlStrategy = newShipControlStrategy;
}

simulated function array<ShipLaunchBay> getLaunchBays() {
  return launchBays;
}
  
simulated function updateShip(float delta) {
  myAssert(!bCleanedUp, "ShipCommon.updateShip when bCleanedUp");

  updateShipPhysics(delta);
}

simulated function float getMaximumLinearAcceleration() {
  return maximumLinearAcceleration;
}

simulated function float getShipMaximumRotationalAcceleration() {
  return maximumRotationalAcceleration;
}

simulated function vector getLinearAcceleration(float delta) {
  return capVector(getShipControlStrategy().getShipThrust(delta, getPhysicsState(), getMaximumLinearAcceleration()), getMaximumLinearAcceleration());
}

simulated function vector getRotationalAcceleration(float delta) {
  return capVector(getShipControlStrategy().getShipSteering(delta, getPhysicsState(), getShipMaximumRotationalAcceleration()), getShipMaximumRotationalAcceleration());
}

simulated function updateShipPhysics(float delta) {
  local PhysicsIntegrator integrator;
  local PhysicsStateInterface physState;
  
  physState = getPhysicsState();
  integrator = getPhysicsIntegrator();
  integrator.linearPhysicsUpdate(physState, delta, getLinearAcceleration(delta));
  integrator.angularPhysicsUpdate(physState, delta, getRotationalAcceleration(delta));  
}

simulated function reset() {
  super.reset();
  bCleanedUp = false;
}

simulated function cleanup()
{
  myAssert(!bCleanedUp, "Ship cleanup when bCleanedUp");

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
  
  if (shipControlStrategy != none) {
    shipControlStrategy.cleanup();
    shipControlStrategy = none;
  }
  
  while (launchBays.length > 0)
    removeLaunchBay(launchBays[0]);

  while (shipObservers.length > 0)
    removeShipObserver(shipObservers[0]);

  bCleanedUp = true;

  super.cleanup();
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
  
simulated function bool attemptDock(Ship docker, Ship dockee) {
  return getDockingSubsystem().attemptDock(docker, dockee);
}

simulated function bool acceptDock(Ship docker, Ship dockee) {
  return getDockingSubsystem().acceptDock(docker, dockee);
}

simulated function bool attemptUndock(Ship docker) {
  return getDockingSubsystem().attemptUndock(docker, getDockedTo());
}

defaultproperties
{
}