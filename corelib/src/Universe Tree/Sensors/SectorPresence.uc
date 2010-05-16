class SectorPresence extends BaseObject;

// Represents the presence of a user in a sector and stores data relevant to that relationship. Examples include owned ships and contacts.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var User                        user;
  var Sector                      sector;

  var array<Ship>                 ownedShips;
  var array<Contact>              allContacts;
  var array<Contact>              knownContacts;
  var array<Contact>              unknownContacts;
  
  var float                       performanceFactor;
  var float                       performanceFactorMinUpdateTime;

  var ThrottledPeriodicAlarm      selfUpdateAlarm;
  
  var SensorSimulationStrategy    sensorSimulationStrategy;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setSensorSimulationStrategy(SensorSimulationStrategy newSensorSimulationStrategy) {
    SensorSimulationStrategy = newSensorSimulationStrategy;
  }
  
  simulated function SensorSimulationStrategy getSensorSimulationStrategy() {
    if (SensorSimulationStrategy == none)
      createSensorSimulationStrategy(getSensorSimulationStrategyClass());

    return SensorSimulationStrategy;
  }
  
  simulated function createSensorSimulationStrategy(class<SensorSimulationStrategy> sensorSimulationStrategyClass) {
    local SensorSimulationStrategy newSimulation;

    newSimulation = SensorSimulationStrategy(allocateObject(sensorSimulationStrategyClass));
    setSensorSimulationStrategy(newSimulation);
  }
  
  simulated function class<SensorSimulationStrategy> getSensorSimulationStrategyClass() {
    return class'DefaultSensorSimulationStrategy';
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initialize()
{
  if (SensorSimulationStrategy == none)
    getSensorSimulationStrategy();

  getSelfUpdateAlarm().setPeriod(0.5);
}

simulated function ThrottledPeriodicAlarm getSelfUpdateAlarm() {
  if (selfUpdateAlarm == none) {
    selfUpdateAlarm = ThrottledPeriodicAlarm(allocateObject(class'ThrottledPeriodicAlarm'));
    selfUpdateAlarm.throttleMultiplier = performanceFactor;
    selfUpdateAlarm.minimumPeriod = performanceFactorMinUpdateTime;
    selfUpdateAlarm.callBack = updateSectorPresence;
  }
  
  return selfUpdateAlarm;
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function updateSectorPresence()
{
  updateContacts();
}

simulated function updateContacts()
{
  if (SensorSimulationStrategy != none)
    SensorSimulationStrategy.updateContacts(self, allContacts);
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function notifyShipEnteredSector(Ship newShip)
  {
    // Add to ownedShips list if it is owned by this user.
    if (newShip.getShipOwner() == user)
      ownedShips[ownedShips.length] = newShip;
  
    createContactForShip(newShip);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function notifyShipLeftSector(Ship oldShip)
  {
    local int i;
    local Contact shipContact;
    
    shipContact = getContactForShip(oldShip);
    if (shipContact != none)
      removeShipFromContact(shipContact);

    // See if it is one of ours.
    if (oldShip.getShipOwner() == user)
    {
      // Remove from ownedShips List.
      for (i=0;i<ownedShips.length;i++)
        if (ownedShips[i] == oldShip)
        {
          ownedShips.remove(i,1);
          break;
        }

      // Remove Sector Presence if no ownedShips remain.
      if (ownedShips.length == 1)
        sector.removeSectorPresence(self);
    }
  }
  
  // Remove the ship from my contact with the specified ship - it is gone now.
  simulated function removeShipFromContact(Contact other) {
    other.setShip(none);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Contact getContactForShip(Ship other) {
    local int i;

    // "cheating" here slightly. contactShip shouldn't be accessible directly...
    for (i=0;i<allContacts.Length;i++)
      if (allContacts[i].contactShip == other)
        return allContacts[i];
        
    return none;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Contact createContactForShip(Ship newContactShip)
  {
    local Contact newContact;

    newContact = Contact(allocateObject(class'Contact'));
    newContact.setContactOwner(user);
    newContact.initialize(newContactShip, sector, newContactShip.getShipLocation());
    
    allContacts[allContacts.length] = newContact;
    
    unknownContacts[unknownContacts.length] = newContact;
    if (SensorSimulationStrategy != none)
      SensorSimulationStrategy.updateContact(self, newContact);
      
    return newContact;
  }
  
  // remove the contact from our list.
  simulated function removeContact(Contact oldContact)
  {
    local int i;
    
    // cleanup.
    oldContact.cleanup();

    // remove oldContact from the list.
    for (i=0;i<allContacts.Length;i++)
      if (allContacts[i] == oldContact)
      {
        allContacts.remove(i,1);
        break;
      }

    // remove oldContact from the list.
    for (i=0;i<knownContacts.Length;i++)
      if (knownContacts[i] == oldContact)
      {
        knownContacts.remove(i,1);
        break;
      }

    // remove oldContact from the list.
    for (i=0;i<unknownContacts.Length;i++)
      if (unknownContacts[i] == oldContact)
      {
        unknownContacts.remove(i,1);
        break;
      }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
  
  simulated function float getDetectionStrengthForContact(Contact Other)
  {
    local int i;
    local float Total;
    
    for (i=0;i<ownedShips.Length;i++)
      Total += ownedShips[i].Detection_Strength_Against(Other);
      
    return Total;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function gainedContact(Contact newContact)
  {
    local int i;
    
    newContact.bContactKnown = true;
    
    for (i=0;i<unknownContacts.length;i++)
      if (unknownContacts[i] == newContact) {
        unknownContacts.remove(i,1);
        break;
      }
    
    knownContacts[knownContacts.length] = newContact;
    
    SpaceGameSimulation(getGameSimulation()).userGainedContact(user, newContact);
  }
  
  simulated function lostContact(Contact oldContact)
  {
    local int i;
    
    oldContact.bContactKnown = false;
    
    for (i=0;i<knownContacts.length;i++)
      if (knownContacts[i] == oldContact) {
        knownContacts.remove(i,1);
        break;
      }
    
    unknownContacts[unknownContacts.length] = oldContact;
    
    SpaceGameSimulation(getGameSimulation()).userLostContact(user, oldContact);

    if (oldContact.getSensorSignature() == 0)
      removeContact(oldContact);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Changed diplomatic status, so update contacts.
  // Currently we just "lose" and then "regain" all our known contacts.
  // This gives AIs the chance to adjust. There is probrably a better way to deal with this.
  simulated function changedDiplomaticStatusWith(User otherUser) {
    local int i;
    local array<Contact> knownContactsCopy;
    
    knownContactsCopy = knownContacts;
    
    for (i=0;i<knownContactsCopy.length;i++) {
      if (knownContactsCopy[i].estimateContactUser() == otherUser)
        lostContact(knownContactsCopy[i]);
    }

    for (i=0;i<knownContactsCopy.length;i++) {
      if (knownContactsCopy[i].estimateContactUser() == otherUser)
        gainedContact(knownContactsCopy[i]);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup()
  {
    while (allContacts.length > 0) {
      allContacts[0].cleanup();
      allContacts.remove(0,1);
    }
    
    if (ownedShips.length > 0) ownedShips.remove(0, ownedShips.length);
    if (knownContacts.length > 0) knownContacts.remove(0, knownContacts.length);
    if (unknownContacts.length > 0) unknownContacts.remove(0, unknownContacts.length);
    
    sector = none;
    user = none;
    
    if (sensorSimulationStrategy != none) {
      sensorSimulationStrategy.cleanup();
      sensorSimulationStrategy = none;
    }
    
    if (selfUpdateAlarm != none) {
      selfUpdateAlarm.cleanup();
      selfUpdateAlarm = none;
    }
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  performanceFactor=1
  performanceFactorMinUpdateTime=0.3
}