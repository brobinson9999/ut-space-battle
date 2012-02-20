class DefaultSensorSimulationStrategy extends SensorSimulationStrategy;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var float gainContactRadius;
  var float loseContactRadius;
  
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
  local float newRadius;
    
  // Update Contact.
  newRadius = getNewContactRadius(sensorClient, contact);
  contact.contactRadius = newRadius;

  // Update client.
  if (contact.bContactKnown) {
    if (newRadius >= loseContactRadius)
      sensorClient.lostContact(contact);
  } else {
    if (newRadius <= gainContactRadius)
      sensorClient.gainedContact(contact);
  }
}

simulated function float getNewContactRadius(SectorPresence sensorClient, Contact contact) {
  local float newRadius;
  local float detectionStrength;
    
  // Always zero for own ships.
  if (contact.estimateContactUser() == sensorClient.user) {
    newRadius = 0;
  } else {
    detectionStrength = sensorClient.getDetectionStrengthForContact(contact);

    if (detectionStrength > 0)
      newRadius = 1 / detectionStrength;
    else
      newRadius = 1000000;
  }

  return newRadius;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  loseContactRadius=1000
  gainContactRadius=500
}