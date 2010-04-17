class DefaultDockingSubsystem extends DockingSubsystem;

var private array<Ship> cargo;
var Ship dockedTo;

// getDockedTo: -> Ship
// Returns the ship that this docking subsystem's ship is docked to.
simulated function Ship getDockedTo() {
  return dockedTo;
}

// addCargo: Ship Ship ->
// Adds the specified cargo to the specified ship's cargo hold.
simulated function addCargo(Ship newCargo) {
  cargo[cargo.length] = newCargo;
}

// removeCargo: Ship Ship ->
// Removes the specified cargo from the specified ship's cargo hold.
simulated function removeCargo(Ship oldCargo) {
  local int i;

  for (i=0;i<cargo.Length;i++)
    if (cargo[i] == oldCargo) {
      cargo.remove(i,1);
      return;
    }

  myAssert(false, "DefaultDockingSubsystem.removeCargo oldCargo was not found in cargo collection");
}

// attemptDock: Ship Ship -> boolean
// Called by the ship requesting to dock.
// Requests permision for the docker to dock with the dockee.
// If accepted, the docker docks with the dockee and true is returned. Otherwise, false is returned.
simulated function bool attemptDock(Ship docker, Ship dockee) {
  if (dockee.acceptDock(docker)) {
    dockAttemptSuccessful(docker, dockee);
    return true;
  } else {
    dockAttemptUnsuccessful(docker, dockee);
    return false;
  }
}

// acceptDock: Ship Ship -> boolean
// Called by the ship being docked to.
// If true is returned, the docker docked successfully.
// If false is returns, the dock attempt was unsuccessful.
simulated function bool acceptDock(Ship docker, Ship dockee) {
  dockee.addCargo(docker);
  return true;
}

// dockAttemptSuccessful: Ship Ship ->
// Called by the ship attempting to dock if the dock attempt succeeded.
simulated function dockAttemptSuccessful(Ship docker, Ship dockee) {
  docker.changeSector(none);
  dockedTo = dockee;
}

// dockAttemptUnsuccessful: Ship Ship ->
// Called by the ship attempting to dock if the dock attempt failed.
simulated function dockAttemptUnsuccessful(Ship docker, Ship dockee);

// attemptUndock: Ship Ship -> bool
// Called by the docker when it wants to undock.
// If true is returned, the ship undocked succesfully.
// If false is returned, the undock attempt was unsuccessful.
simulated function bool attemptUndock(Ship docker, Ship dockee) {
  local int i;
  local array<ShiplaunchBay> candidateLaunchBays;

  for (i=0;i<dockee.launchBays.length;i++)
    if (dockee.launchBays[i].canLaunch(docker, dockee))
      candidateLaunchBays[candidateLaunchBays.length] = dockee.launchBays[i];

  if (candidateLaunchBays.length > 0) {
    candidateLaunchBays[rand(candidateLaunchBays.length)].launchShip(docker, dockee);
    undockAttemptSuccessful(docker, dockee);
    return true;
  } else {
    undockAttemptUnsuccessful(docker, dockee);
    return false;
  }
}

// undockAttemptSuccessful: Ship Ship ->
// Called by the ship attempting to undock if the undock attempt succeeded.
simulated function undockAttemptSuccessful(Ship docker, Ship dockee) {
  dockedTo = none;
}

// dockAttemptUnsuccessful: Ship Ship ->
// Called by the ship attempting to undock if the undock attempt failed.
simulated function undockAttemptUnsuccessful(Ship docker, Ship dockee);

// cleanup: ->
// This function can be called in any state. After it returns, the object is safe to discard (for garbage collection) or to put into an object pool.
simulated function cleanup() {
  dockedTo = none;

  while (cargo.length > 0)
  {
    myAssert(!cargo[0].bCleanedUp, "DefaultDockingSubsystem.cleanup !cargo[0].bCleanedUp");

    cargo[0].cleanup();
    cargo.remove(0,1);
  }
  
  super.cleanup();
}

defaultproperties
{
}