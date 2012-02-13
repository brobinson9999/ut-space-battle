class ShipPartLaunchBay extends ShipLaunchBay;

var private Part part;

simulated function setPart(Part newPart) {
  part = newPart;
}

simulated function bool canLaunch(Ship shipToLaunch, Ship launchFrom) {
  myAssert(part != none, "ShipPartLaunchBay.canLaunch part == none");

  return part.bOnline;
}

simulated function launchShip(Ship shipToLaunch, Ship launchFrom)
{
  myAssert(part != none, "ShipPartLaunchBay.launchShip part == none");
  myAssert(part.ship != none, "ShipPartLaunchBay.launchShip part.ship == none");
  myAssert(shipToLaunch != none, "ShipPartLaunchBay.launchShip shipToLaunch == none");
  myAssert(shipToLaunch.getGameSimulation() != none, "ShipPartLaunchBay.launchShip shipToLaunch.getGameSimulation() == none");

  launchFrom.removeCargo(shipToLaunch);

  // Bring it up to date.
  shipToLaunch.updateShip();

  shipToLaunch.setShipLocation(part.getPartLocation() + VRand() * 5);
  shipToLaunch.changeShipSector(launchFrom.getShipSector());
  shipToLaunch.setShipVelocity(launchFrom.getShipVelocity());
}

simulated function cleanup() {
  part = none;
  
  super.cleanup();
}

defaultproperties
{
}