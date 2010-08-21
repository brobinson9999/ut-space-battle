class Pilot extends DefaultShipController;

var Ship pilotShip;

simulated function updateLinear();
simulated function updateAngular();

simulated function vector getDesiredAcceleration(PhysicsStateInterface physicsState, float delta) {
  updateLinear();
  return super.getDesiredAcceleration(physicsState, delta);
}

simulated function vector getDesiredRotationalAcceleration(PhysicsStateInterface physicsState, float shipRotationRate, float delta) {
  updateAngular();
  return super.getDesiredRotationalAcceleration(physicsState, shipRotationRate, delta);
}

simulated function rotator getDesiredRotation() {
  return desiredRotation;
}

simulated function setPilotShip(Ship newShip) {
  if (pilotShip != none) {
    pilotShip.setShipPilot(none);
  }

  pilotShip = newShip;

  if (pilotShip != none) {
    pilotShip.setShipPilot(self);
    desiredRotation = pilotShip.getPhysicsState().getRotation();
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