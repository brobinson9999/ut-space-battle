class ShipCommon extends BaseObject;

// This class contains functionality for an abstract ship. It can be composed with another
// ship class that interacts more concretely with the engine. Calls should be made into
// this class, while this class will use the ShipObserver to send out any necessary callbacks.

// Variables to hold ship systems.
var array<ShipSystem>           systems;
var array<ShipWeapon>           weapons;
var array<ShipLaunchBay>        launchBays;
var private DockingSubsystem    dockingSubsystem;

var private PhysicsIntegrator physicsIntegrator;
var private PhysicsStateInterface physicsState;

// DEBUGGING
var bool bCleanedUp;

var array<ShipObserver> shipObservers;

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

simulated function PhysicsStateInterface getPhysicsState() {
  if (physicsState == none) {
    setPhysicsState(PhysicsStateInterface(allocateObject(class'StoredPhysicsState')));
  }

  return physicsState;
}

simulated function setPhysicsState(PhysicsStateInterface newPhysicsState) {
  physicsState = newPhysicsState;
}

simulated function PhysicsIntegrator getPhysicsIntegrator() {
  if (physicsIntegrator == none) {
    setPhysicsIntegrator(PhysicsIntegrator(allocateObject(class'DefaultPhysicsIntegrator')));
  }
  
  return physicsIntegrator;
}

simulated function setPhysicsIntegrator(PhysicsIntegrator newPhysicsIntegrator) {
  physicsIntegrator = newPhysicsIntegrator;
}

simulated function addSystem(ShipSystem newSystem) {
  systems[systems.length] = newSystem;
//  newSystem.addedToShip(self);
}
  
simulated function removeSystem(ShipSystem oldSystem) {
  local int i;
  
  for (i=0;i<systems.length;i++) {
    if (systems[i] == oldSystem) {
      systems.remove(i, 1);
//      oldSystem.removedFromShip(self);
      break;
    }
  }
}
  
simulated function updateShip(float delta) {
  local int i;
  local vector linearAcceleration;
  local vector rotationalAcceleration;
//  local float maxRotationalAccelerationRate;

  myAssert(!bCleanedUp, "ShipCommon.updateShip when bCleanedUp");

  for (i=systems.length-1;i>=0;i--)
    systems[i].updateShipSystem();

  // Update Linear movement.
  // linearAcceleration = ???;
  getPhysicsIntegrator().linearPhysicsUpdate(getPhysicsState(), delta, linearAcceleration);

  // Update Angular movement.
  // rotationalAcceleration = ???;
  getPhysicsIntegrator().angularPhysicsUpdate(getPhysicsState(), delta, rotationalAcceleration);  

  // If the difference in desiredRotation and rotation is less than some quantity, I can just stop the ship at the exact rotation I want.
  // I need enough rotational acceleration to both stop my rotational velocity, and to move by the desired amount.
  // This is not perfect since it doesn't take into account current rotational velocity that could be leveraged to get there faster.
//  if (2 * vsize(copyRotToVect(smallestRotatorMagnitude(desiredRotation uncoordRot rotation))) + vsize(rotationalVelocity) < maxRotationalAccelerationRate) {
//    getPhysicsState().setRotation(desiredRotation);
//    getPhysicsState().setRotationVelocity(vect(0,0,0));
//  } else {
//    getPhysicsIntegrator().angularPhysicsUpdate(getPhysicsState(), delta, rotationalAcceleration);
//  }

//  if (partShip(Self) != none)
//    debugMSG("desiredRotationRate: "$pilot.desiredRotationRate$" rotation remaining: "$vsize(copyRotToVect(smallestRotatorMagnitude(desiredRotation uncoordRot rotation)))$" maxRotationalAccelerationRate "$maxRotationalAccelerationRate);
}

simulated function shipCritical(object instigator) {
  local int i;
  
  for (i=systems.length-1;i>=0;i--)
    if (systems[i].bEnabled)
      systems[i].disableSystem();
      
  // This needs to be on the observer.
//  if (SpaceGameSimulation(getGameSimulation()) != none)
//    SpaceGameSimulation(getGameSimulation()).notifyShipKilled(self, instigator);

//  setShipOwner(none);

//  destroyEvent = getClock().addAlarm(getCurrentTime() + 5, self);
//  destroyEvent.callback = destroyTimeElapsed;
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
/*
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
  
  DesiredVelocity_RelativeTo = None;

  if (dockingSubsystem != none) {
    dockingSubsystem.cleanup();
    dockingSubsystem = none;
  }*/

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

//  pilot = none;
  
  bCleanedUp = true;

  super.cleanup();
}
/*
simulated function Ship cloneShip()
{
  local ShipCommon clone;

  clone = ShipCommon(allocateObject(self.class));
  initializeClonedShip(clone);

  return clone;
}

simulated function initializeClonedShip(ShipCommon clone)
{
  local int i;
  
  clone.acceleration          = acceleration;
  clone.rotationRate          = rotationRate;
  clone.radius                = radius;
  clone.shipTypeName          = shipTypeName;
  
  for (i=0;i<systems.length;i++)
    clone.addSystem(systems[i].cloneSystem());
}
*/
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

/*

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

// getOutermostDockee: -> ShipCommon
// Returns this ship if it is not docked in another ship. If it is docked in another ship, that ship's "outermost carrier" is returned.
simulated function ShipCommon getOutermostDockee() {
  local Ship dockedTo;
  
  dockedTo = getDockedTo();
  if (dockedTo == none)
    return self;
  else
    return dockedTo.getOutermostDockee();
}
*/

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float detection_Strength_Against(Contact other);

defaultproperties
{
}