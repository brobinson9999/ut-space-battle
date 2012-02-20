class ShipBlueprint extends ShipFactory;

var string identifier;
var private string friendlyName;

var ShipFactory shipFactory;

simulated function Ship createShip() {
  local Ship result;
  
  myAssert(shipFactory != none, "ShipBlueprint.createShip shipFactory != none");

  result = shipFactory.createShip();
  result.shipTypeName = friendlyName;
  
  return result;
}

simulated function getFriendlyName(string newFriendlyName) {
  friendlyName = newFriendlyName;
}

simulated function setFriendlyName(string newFriendlyName) {
  friendlyName = newFriendlyName;
}

simulated function cleanup() {
  if (shipFactory != none) {
    shipFactory.cleanup();
    shipFactory = none;
  }
  
  super.cleanup();
}

defaultproperties
{
}