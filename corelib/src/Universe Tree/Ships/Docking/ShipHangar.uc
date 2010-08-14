class ShipHangar extends Part;

var ShipPartLaunchBay launchBay;

simulated function ShipLaunchBay getLaunchBay() {
  if (launchBay != none) {
    launchBay = ShipPartLaunchBay(allocateObject(class'ShipPartLaunchBay'));
    launchBay.setPart(self);
  }
    
  return launchBay;
}

simulated function launchShip(Ship other)
{
  myAssert(other != none, "ShipHangar launchShip other == none");
  myAssert(other.getGameSimulation() != none, "ShipHangar launchShip other.getGameSimulation() == none");

  ship.removeCargo(other);

  // Bring it up to date.
  other.updateShip();

  other.setShipLocation(getPartLocation() + VRand() * 5);
  other.ChangeSector(Ship.Sector);
  other.setShipVelocity(ship.getShipVelocity());
}

simulated function cleanup() {
  if (launchBay != none) {
    launchBay.cleanup();
    launchBay = none;
  }
  
  super.cleanup();
}

defaultproperties
{
}