class Pilot extends DefaultShipController;

var Ship pilotShip;

simulated function updateLinear();
simulated function updateAngular();

simulated function setPilotShip(Ship NewShip) {
  if (pilotShip != none) {
    pilotShip.pilot = none;
  }

  pilotShip = newShip;

  if (pilotShip != none) {
    pilotShip.pilot = self;
  }
}

simulated function User getShipOwner(Ship other) {
  if (other == none)
    return none;
  else
    return other.getShipOwner();
}

simulated function bool isFriendly(Ship other)
{
  local User shipOwner, otherOwner;

  shipOwner = getShipOwner(pilotShip);
  if (shipOwner == none) return false;

  otherOwner = getShipOwner(other);
  if (otherOwner == none) return false;

  return shipOwner.isFriendly(otherOwner);
}

simulated function bool isHostile(Ship other)
{
  local User shipOwner, otherOwner;

  shipOwner = getShipOwner(pilotShip);
  if (shipOwner == none) return false;

  otherOwner = getShipOwner(other);
  if (otherOwner == none) return false;

  return shipOwner.isHostile(otherOwner);
}

simulated function cleanup() {
  setPilotShip(none);

  super.Cleanup();
}
  
defaultproperties
{
}