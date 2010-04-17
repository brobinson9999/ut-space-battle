class Contact extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Represents a sensor contact on something. This is part of the sector simulation but is accessible to the user. It represents the user's
// means of accessing information about the sector.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var Ship                        contactShip;          // The ship this contact is for.
var vector                      lastKnownLocation;    // Last known location of contact.

var float                       radius;               // Radius of sphere around contact. 0 if pinpointed.

var vector                      locationOffsetNormal; // Normal of offset.

var Sector                      sector;

var string                      contactID;

var bool                        bContactKnown;

var array<ShipObserver>         contactObservers;     

var User                        contactOwner;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Initialize(Ship newContactShip, Sector NewSector, vector DetectionPosition)
{
  ContactID = "C"$newSector.hackCounter;
  newSector.hackCounter++;

  Sector = NewSector;
  setShip(newContactShip);

  lastKnownLocation = DetectionPosition;
}

simulated function setContactOwner(User newOwner) {
  contactOwner = newOwner;
}

simulated function User getContactOwner() {
  return contactOwner;
} 

simulated function setShip(Ship newShip) {
  if (contactShip != none)
    lastKnownLocation = getContactSourceLocation();

  contactShip = newShip;

  if (contactShip != none)
    lastKnownLocation = getContactSourceLocation();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function vector getContactSourceLocation()
{
  if (contactShip != None)
    return contactShip.getShipLocation();
  else  
    return lastKnownLocation;
}

simulated function vector getContactLocation()
{
  return getContactSourceLocation() + (locationOffsetNormal * radius);
}

simulated function rotator getContactSourceRotation() {
  if (contactShip == none)
    return rot(0,0,0);
  else
    return contactShip.rotation;
}

simulated function vector getContactVelocity()
{
  if (contactShip == None)
    return Vect(0,0,0);

  return contactShip.Velocity;
}

simulated function vector getContactAcceleration()
{
  local vector VDiff;

  if (contactShip == None)
    return Vect(0,0,0);

  VDiff = contactShip.desiredVelocity - contactShip.velocity;

  return contactShip.acceleration * Normal(vDiff);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function addContactObserver(ShipObserver newObserver) {
  contactObservers[contactObservers.length] = newObserver;
}

simulated function removeContactObserver(ShipObserver oldObserver) {
  local int i;

  for (i=contactObservers.length-1;i>=0;i--) {
    if (contactObservers[i] == oldObserver) {
      contactObservers.remove(i, 1);
      break;
    }
  }
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function bool isFriendly() {
  local User estimatedUser;

  estimatedUser = estimateContactUser();
  if (estimatedUser == none)
    return false;

  return contactOwner.isFriendly(estimatedUser);
}

simulated function bool isHostile() {
  local User estimatedUser;

  estimatedUser = estimateContactUser();
  if (estimatedUser == none)
    return false;

  return contactOwner.isHostile(estimatedUser);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float estimateContactRadius() {
  if (contactShip != none)
    return contactShip.radius;
  else
    return 100;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float getSensorSignature() {
  myAssert(contactShip == none || !contactShip.bCleanedUp, "Contact estimateTargetCondition contactShip != none but contactShip.bCleanedUp");

  if (contactShip == none)
    return 0;

  return contactShip.radius;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// The owner of the thing this contact represents.
simulated function User estimateContactUser() {
  if (contactShip != none)
    return contactShip.getShipOwner();
  else
    return none;
}

simulated function string estimateContactType() {
  if (contactShip != none)
    return contactShip.shipTypeName;
  else
    return "Unknown";
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Returns the ship, but only if it is owned by the contact owner. In other words, the contact owner can't use this to get a reference to
// another User's ships.
simulated function Ship getOwnedShip() {
  if (contactShip == none || contactShip.getShipOwner() != contactOwner)
    return none;
  else
    return contactShip;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function estimateTargetCondition(out int currentCondition, out int optimalCondition) {
  if (PartShip(contactShip) != none) {
    currentCondition = PartShip(contactShip).numPartsOnline;
    optimalCondition = PartShip(contactShip).parts.length;
  } else {
    myAssert(contactShip == none || !contactShip.bCleanedUp, "Contact estimateTargetCondition contactShip != none but contactShip.bCleanedUp");
    if (contactShip == none)
      currentCondition = 0;
    else
      currentCondition = 1;
    optimalCondition = 1;
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// I don't like this - armor should probably just be part of the target's health.
simulated function float estimateTargetVulnerability() {
  if (DefaultShip(contactShip) != none)
    return FMax(0.01, DefaultShip(contactShip).armor);
  else
    return 1;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup()
{
  while (contactObservers.length > 0) {
    errorMessage("contact.cleanup with remaining observer: "$contactObservers[contactObservers.length-1]);
    removeContactObserver(contactObservers[contactObservers.length-1]);
  }

  setContactOwner(none);
  sector = none;
  contactShip = none;

  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  radius=10000
}