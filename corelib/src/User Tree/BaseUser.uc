class BaseUser extends User;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function CommandingWorkerDecorator defaultSectorCommandAI() {
  return SectorCommandAIFor(SpaceGameSimulation(getGameSimulation()).getGlobalSector());
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Issue_Manual_Orders(array<SpaceWorker> Orderees, class<SpaceTask> Task_Class, object New_Target)
{
  local int i;

  for (i=0;i<Orderees.Length;i++)
    Issue_Manual_Order(Orderees[i], Task_Class, New_Target);
}

simulated function Issue_Manual_Order(SpaceWorker Orderee, class<SpaceTask> Task_Class, object New_Target)
{
  Orderee.setTaskPreference(Task_Class, New_Target, 1000000);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function array<SpaceWorker> workersFromContacts(array<Contact> workerContacts) {
  local int i;
  local array<SpaceWorker> workers;
  local Ship contactShip;

  for (i=0;i<workerContacts.length;i++) {
    contactShip = workerContacts[i].getOwnedShip();

    if (contactShip != none && contactShip.getShipWorker() != none)
      workers[workers.Length] = contactShip.getShipWorker();
  }

  return workers;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function array<Contact> filterContactsForDesignation(string designation, array<Contact> inputContacts) {
  local array<Contact> result;

  result = inputContacts;

  if (designation ~= "owned") {
    result = filterContacts_Owned(result);
  }

  if (designation ~= "friendly") {
    result = filterContacts_Friendly(result);
  }

  if (designation ~= "hostile") {
    result = filterContacts_Hostile(result);
  }

  return result;
}

simulated function array<Contact> filterContacts_Owned(array<Contact> inputContacts)
{
  local int i;
  local Contact thisContact;
  local array<Contact> result;

  for (i=0;i<inputContacts.length;i++) {
    thisContact = inputContacts[i];
    if (thisContact.estimateContactUser() == self)
      result[result.length] = thisContact;
  }

  return result;
} 

simulated function array<Contact> filterContacts_Friendly(array<Contact> inputContacts)
{
  local int i;
  local Contact thisContact;
  local array<Contact> result;

  for (i=0;i<inputContacts.length;i++) {
    thisContact = inputContacts[i];
    if (thisContact.isFriendly())
      result[result.length] = thisContact;
  }

  return result;
} 

simulated function array<Contact> filterContacts_Hostile(array<Contact> inputContacts)
{
  local int i;
  local Contact thisContact;
  local array<Contact> result;

  for (i=0;i<inputContacts.length;i++) {
    thisContact = inputContacts[i];
    if (thisContact.isHostile())
      result[result.length] = thisContact;
  }

  return result;
} 

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function array<Contact> getContactsForDesignation(string designation) {
  local array<Contact> result;
  local Contact designationIDMatch;

  designationIDMatch = Contact_With_ID(designation);
  if (designationIDMatch != none)
    result[result.length] = designationIDMatch;

  return result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Contact Contact_With_ID(string CandidateID)
{
  local int i;
  local array<Contact> PotentialCandidates;

  PotentialCandidates = DefaultSectorCommandAI().SectorPresence.KnownContacts;
  for (i=0;i<PotentialCandidates.Length;i++)
  {
    if (PotentialCandidates[i].ContactID ~= CandidateID)
      return PotentialCandidates[i];
  }

  return None;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Contact contactWithShip(Ship CandidateShip)
{
  local int i;
  local array<Contact> potentialCandidates;

  potentialCandidates = defaultSectorCommandAI().sectorPresence.knownContacts;
  for (i=0;i<potentialCandidates.length;i++) {
    if (potentialCandidates[i].getOwnedShip() == candidateShip) {
      return potentialCandidates[i];
    }
  }

  return none;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function scuttleWorkers(array<SpaceWorker> workers) {
  local int i;

  for (i=0;i<workers.length;i++)
    scuttleWorker(workers[i]);
}

simulated function scuttleWorker(SpaceWorker worker) {
  local Ship workerShip;
  
  if (SpaceWorker_Ship(worker) != none) {
    workerShip = SpaceWorker_Ship(worker).ship;
    if (workerShip != none) {
//      workerShip.instigator = self;
      workerShip.applyDamage(10000000, self);
//      workerShip.instigator = none;
    }
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function SpaceTechnology technologyFromID(string technologyID) {
  local int i;

  for (i=0;i<Technologies.Length;i++) {
    if (Technologies[i].Identifier ~= TechnologyID) {
      return Technologies[i];
    }
  }

  return None;
}

// Still used a few places.
simulated function ShipBlueprint blueprintFromID(string shipID)
{
  local int i;

  for (i=0;i<Blueprints.Length;i++)
    if (Blueprints[i].Identifier ~= ShipID)
      return Blueprints[i];

  return None;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}