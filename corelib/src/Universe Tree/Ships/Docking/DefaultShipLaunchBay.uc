class DefaultShipLaunchBay extends ShipLaunchBay;

simulated function bool canLaunch(Ship shipToLaunch, Ship launchFrom) {
  return true;
}

simulated function launchShip(Ship shipToLaunch, Ship launchFrom)
{
  myAssert(shipToLaunch != none, "DefaultShipLaunchBay.launchShip shipToLaunch == none");
  myAssert(shipToLaunch.getGameSimulation() != none, "DefaultShipLaunchBay.launchShip shipToLaunch.getGameSimulation() == none");

  launchFrom.removeCargo(shipToLaunch);

  // The ship that we are about to launch may not have been updated while it was docked.
  shipToLaunch.updateShip();

  shipToLaunch.setShipLocation(launchFrom.getShipLocation());
  shipToLaunch.changeSector(launchFrom.sector);
  shipToLaunch.velocity = launchFrom.velocity;
}

defaultproperties
{
}