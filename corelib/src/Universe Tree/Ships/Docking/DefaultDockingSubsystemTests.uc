class DefaultDockingSubsystemTests extends AutomatedTest;

simulated function runTests() {
  local Ship docker;
  local Ship dockee;
  local Ship cargo;

  docker = Ship(allocateObject(class'Ship'));
  dockee = Ship(allocateObject(class'Ship'));
  cargo = Ship(allocateObject(class'Ship'));

  myAssert(docker.getOutermostDockee() == docker, "docker is not initially docked");
  myAssert(docker.attemptDock(dockee), "attempting dock");
  myAssert(docker.getOutermostDockee() == dockee, "docker is now docked inside of dockee");
  // causes error - and I don't have a way to catch that error at this time.
//  myAssert(!dockee.attemptUndock(), "attempting undock with wrong parameter");
  myAssert(!docker.attemptUndock(), "attempting undock with no launch bays");

  // should assert internally if it fails
  dockee.addCargo(cargo);
  dockee.removeCargo(cargo);

  myAssert(dockee.launchBays.length == 0, "dockee has no launch bays");
  dockee.addLaunchBay(DefaultShipLaunchBay(allocateObject(class'DefaultShipLaunchBay')));
  myAssert(dockee.launchBays.length == 1, "dockee now has one launch bay");
  expectAssertFail("DefaultShipLaunchBay.launchShip shipToLaunch.getGameSimulation() == none");
  myAssert(docker.attemptUndock(), "attempting undock");
  myAssert(docker.getOutermostDockee() == docker, "docker is no longer docked");

  dockee.removeLaunchBay(dockee.launchBays[0]);
  myAssert(dockee.launchBays.length == 0, "launch bay removed from dockee");
}