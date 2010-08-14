class DistanceOnlySensorSimulationStrategy extends SensorSimulationStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var float gainContactDistance;
  var float loseContactDistance;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function updateContacts(SectorPresence sensorClient, array<Contact> contacts) {
  local int i;

  for (i=0;i<contacts.length;i++)
    updateContact(sensorClient, contacts[i]);
}

simulated function updateContact(SectorPresence sensorClient, Contact contact) {
  local float closestDistance;
    
  closestDistance = getDistanceToContact(sensorClient, contact);

  // Drop contacts for ships that no longer exist.
  if (contact.getSensorSignature() == 0) {
    contact.contactRadius = 1000000;
    sensorClient.lostContact(contact);
    return;
  }
  
  if (contact.bContactKnown) {
    if (closestDistance >= loseContactDistance) {
      contact.contactRadius = 1000000;
      sensorClient.lostContact(contact);
    }
  } else {
    if (closestDistance <= gainContactDistance) {
      contact.contactRadius = 0;
      sensorClient.gainedContact(contact);
    }
  }
}

simulated function float getDistanceToContact(SectorPresence sensorClient, Contact contact) {
  local int i;
  local float closestDistance;
  local float thisDistance;
  local vector contactPosition;
  
  // Always zero for own ships.
  if (contact.estimateContactUser() == sensorClient.user)
    return 0;

  contactPosition = contact.getContactSourceLocation();
  
  // Start with a long enough distances that it won't be detected.
  closestDistance = loseContactDistance + gainContactDistance + 10000000;
  
  for (i=0;i<sensorClient.user.ships.length;i++) {
    if (sensorClient.user.ships[i].sector == sensorClient.sector) {
      thisDistance = VSize(sensorClient.user.ships[i].getShipLocation() - contactPosition);
      closestDistance = FMin(thisDistance, closestDistance);
    }
  }
  
  return closestDistance;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
//  loseContactDistance=50000
//  gainContactDistance=45000
//  loseContactDistance=100000
  gainContactDistance=90000
  loseContactDistance=90000
}