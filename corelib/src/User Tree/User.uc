class User extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var string                      DisplayName;

var array<Ship>                           ships;
var array<SectorPresence>                 sectorPresences;
var array<CommandingWorkerDecorator>      sectorCommandAIs;

var protected UserForeignPolicy foreignPolicy;
var protected bool bCreatedOwnForeignPolicy;

var array<SpaceTechnology>      Technologies;
var array<ShipBlueprint>        Blueprints;

var float                       performanceFactor;
var ThrottledPeriodicAlarm      selfUpdateAlarm;


var float                       AISkillLevel;

var array<UserSensorObserver>   sensorObservers;

var private Task_Idle idleTask;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initializeUser() {
  // Random performance factor - spaces out updates for multiple users created at the same time.
  performanceFactor *= (0.95 + (FRand() * 0.05));
  getSelfUpdateAlarm().setPeriod(0.5);
}

simulated function ThrottledPeriodicAlarm getSelfUpdateAlarm() {
  if (selfUpdateAlarm == none) {
    selfUpdateAlarm = ThrottledPeriodicAlarm(allocateObject(class'ThrottledPeriodicAlarm'));
    selfUpdateAlarm.throttleMultiplier = performanceFactor;
    selfUpdateAlarm.callBack = updateUser;
  }
  
  return selfUpdateAlarm;
}

simulated function updateUser();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanupShips() {
  local int i;
  
  // Ships remove themselves when they clean themselves up.
  for (i=ships.length-1;i>=0;i--) {
    ships[i].cleanupShipNOW();
  }
}

simulated function cleanupTechnologiesBlueprints() {
  while (technologies.length > 0) {
    technologies[0].cleanup();
    technologies.remove(0,1);
  }

  while (blueprints.length > 0) {
    blueprints[0].cleanup();
    blueprints.remove(0,1);
  }
}

simulated function cleanup() {
  displayName = "";

  cleanupShips();
  
  while (sectorCommandAIs.length > 0) {
    sectorCommandAIs[0].cleanup();
    sectorCommandAIs.remove(0,1);
  }

  while (sectorPresences.length > 0) {
    sectorPresences[0].sector.removeSectorPresence(sectorPresences[0]);
  }

  cleanupTechnologiesBlueprints();
  
  if (foreignPolicy != none) {
    if (bCreatedOwnForeignPolicy) {
      foreignPolicy.cleanup();
      bCreatedOwnForeignPolicy = false;
    }
    setForeignPolicy(none);
  }

  if (idleTask != none) {
    idleTask.cleanup();
    idleTask = none;
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

simulated function bool receivedUserConsoleCommand(string command);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setForeignPolicy(UserForeignPolicy newPolicy) {
  foreignPolicy = newPolicy;
}

simulated protected function UserForeignPolicy getForeignPolicy() {
  if (foreignPolicy == none) {
    setForeignPolicy(UserForeignPolicy(allocateObject(class'ExplicitUserForeignPolicy')));
    bCreatedOwnForeignPolicy = true;
  }
  
  return foreignPolicy;
}

simulated function bool isFriendly(User otherUser) {
  return getForeignPolicy().isFriendly(self, otherUser);
}

simulated function bool isHostile(User otherUser) {
  return getForeignPolicy().isHostile(self, otherUser);
}

simulated function setFriendly(User otherUser) {
  myAssert(ExplicitUserForeignPolicy(getForeignPolicy()) != none, "tried to set friendly but foreign policy is not explicit");
  ExplicitUserForeignPolicy(getForeignPolicy()).setFriendly(self, otherUser);
  changedDiplomaticStatusWith(otherUser);
}

simulated function setHostile(User otherUser) {
  myAssert(ExplicitUserForeignPolicy(getForeignPolicy()) != none, "tried to set hostile but foreign policy is not explicit");
  ExplicitUserForeignPolicy(getForeignPolicy()).setHostile(self, otherUser);
  changedDiplomaticStatusWith(otherUser);
}

simulated function changedDiplomaticStatusWith(User otherUser) {
  local int i;

  for (i=0;i<sectorPresences.length;i++)
    sectorPresences[i].changedDiplomaticStatusWith(otherUser);
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function SpaceTechnology NewTechnology(class<SpaceTechnology> TechClass)
{
  local SpaceTechnology X;

  X = SpaceTechnology(allocateObject(TechClass));

  AddTechnology(X);

  return X;
}

simulated function AddTechnology(SpaceTechnology X)
{
  Technologies[Technologies.Length] = X;
}

simulated function RemoveTechnology(SpaceTechnology X)
{
  local int i;

  // Cleanup.
  X.Cleanup();

  // Remove from List.
  for (i=0;i<Technologies.Length;i++)
    if (Technologies[i] == X)
    {
      Technologies.Remove(i,1);
      break;
    }
}

  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function SectorPresence createSectorPresenceFor(User presenceUser, Sector presenceSector) {
  local int i;
  local SectorPresence newSectorPresence;

  newSectorPresence = SectorPresence(allocateObject(class'SectorPresence'));
  newSectorPresence.createSensorSimulationStrategy(SpaceGameSimulation(getGameSimulation()).getSensorSimulationStrategyClass());
  newSectorPresence.user = presenceUser;
  newSectorPresence.sector = presenceSector;

  presenceUser.Gained_Sector_Presence(newSectorPresence);

  presenceSector.sectorPresences[presenceSector.sectorPresences.Length] = newSectorPresence;

  newSectorPresence.initializeSectorPresence();

  // Notify the new sector presence of any existing ships.
  for (i=0;i<presenceSector.ships.length;i++)
    newSectorPresence.notifyShipEnteredSector(presenceSector.ships[i]);

  return newSectorPresence;
}

simulated function SectorPresence getOrCreateSectorPresenceForSector(Sector sector) {
  local SectorPresence result;

  result = getSectorPresenceForSector(sector);
  if (result == none)
    result = createSectorPresenceFor(self, sector);
//    result = SpaceGameSimulation(getGameSimulation()).createSectorPresenceFor(self, sector);
  return result;
}

simulated function SectorPresence getSectorPresenceForSector(Sector sector)
{
  local int i;

  for (i=0;i<SectorPresences.Length;i++)
    if (SectorPresences[i].Sector == sector)
      return SectorPresences[i];

  return None;
}

simulated function CommandingWorkerDecorator sectorCommandAIFor(Sector sector)
{
  local int i;

  for (i=0;i<SectorCommandAIs.Length;i++)
    if (SectorCommandAIs[i].Sector == sector)
      return SectorCommandAIs[i];

  return None;
}

simulated function bool sectorPresenceExistsFor(Sector sector)
{
  local int i;

  for (i=0;i<sectorPresences.length;i++)
    if (sectorPresences[i].sector == sector)
      return true;

  return false;
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Gained_Sector_Presence(SectorPresence other)
{
  local CommandingWorkerDecorator newSectorCommandAI;

  SectorPresences[SectorPresences.Length] = other;

  newSectorCommandAI = getNewSectorCommandAI();
  newSectorCommandAI.Sector = other.Sector;
  newSectorCommandAI.SectorPresence = other;
  SectorCommandAIs[SectorCommandAIs.Length] = newSectorCommandAI;

  newSectorCommandAI.initializeWorker();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Lost_Sector_Presence(SectorPresence Other)
{
  local int i;

  for (i=0;i<SectorPresences.Length;i++)
    if (SectorPresences[i] == Other)
    {
      SectorPresences.Remove(i,1);
      return;
    }

  for (i=0;i<SectorCommandAIs.Length;i++)
    if (SectorCommandAIs[i].Sector == Other.Sector)
    {
      SectorCommandAIs.Remove(i,1);
      return;
    }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function CommandingWorkerDecorator getNewSectorCommandAI()
{
  local CompositeSpaceWorker result;
  local DefaultSchedulerSpaceWorker schedulerWorker;
  local IndependantSpreadSchedulerStrategy independantAlgorithm;

  // Leaf: Scheduler Worker.
  schedulerWorker = DefaultSchedulerSpaceWorker(allocateObject(class'IncrementalSchedulerSpaceWorker'));
  if (AISkillLevel <= 0.05) {
    schedulerWorker.SchedulerStrategyClass = class'RandomSchedulerStrategy';
  } else if (AISkillLevel <= 0.2) {
    independantAlgorithm = IndependantSpreadSchedulerStrategy(allocateObject(class'IndependantSpreadSchedulerStrategy'));
    independantAlgorithm.randomnessFactor = (0.3 - AISkillLevel) * 2.5;
    schedulerWorker.setSchedulerStrategy(independantAlgorithm);
  } else {
    // The independant algorithm seems to have better performance than the default. I am not sure why yet. I believe it is because
    // the default may be spreading it's forces too thinly.
    schedulerWorker.schedulerStrategyClass = class'IndependantSpreadSchedulerStrategy';
  }

  schedulerWorker.performanceFactor *= (1.5 - AISkillLevel);
  result = schedulerWorker;

  // Decorators.
  // Squad Forming must come AFTER AutoTask in the chain, if squads are to have tasks! (coming after in the chain means it has to be added earlier because we add to the front of the chain so things added later, will be earlier in the chain. In other words, the final order of decorators is the opposite of the sequence in which they were added)
  if (AISkillLevel >= 0.3)
    result = setupAndPrependWorkerDecorator(result, CommandingWorkerDecorator(allocateObject(class'SquadFormingCommandingWorkerDecorator')));

  result = setupAndPrependWorkerDecorator(result, CommandingWorkerDecorator(allocateObject(class'AutoTaskCommandingWorkerDecorator')));
  result = setupAndPrependWorkerDecorator(result, CommandingWorkerDecorator(allocateObject(class'FixedAttackPreferenceCommandingWorkerDecorator')));

  result.addTask(getIdleTask());

  return CommandingWorkerDecorator(result);
}

simulated function Task_Idle getIdleTask() {
  if (idleTask == none) {
    idleTask = Task_Idle(allocateObject(class'Task_Idle'));
    idleTask.priority = 0.1;
  }
  
  return idleTask;
}

simulated function CommandingWorkerDecorator setupAndPrependWorkerDecorator(CompositeSpaceWorker prependTo, CommandingWorkerDecorator decorator) {
  decorator.user = self;
  decorator.setDecorated(prependTo);

  return decorator;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************


// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function array<Contact> getContactsForDesignation(string designation);
simulated function array<Contact> filterContactsForDesignation(string designation, array<Contact> inputContacts);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function userGainedShip(Ship other)
{
  local Pilot newPilot;
  local CompositeSpaceWorker sectorCommandAI;

  // Clear any existing pilot and setup a new one.
  clearPilot(other);
  newPilot = Pilot(allocateObject(class'AIPilot'));
  newPilot.setPilotShip(other);

  // Add to ships list.
  ships[ships.length] = other;

  // create a worker for the new ship
  getOrCreateSectorPresenceForSector(SpaceGameSimulation(getGameSimulation()).getGlobalSector());
  sectorCommandAI = sectorCommandAIs[0];
  if (sectorCommandAI != None)
    addWorkerForShip(sectorCommandAI, other);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function userLostShip(Ship other)
{
  local int i;
  local CompositeSpaceWorker parentWorker;

  // Remove Workers.
  parentWorker = sectorCommandAIFor(other.sector);
  removeWorkerForShip(parentWorker, other);

  // Remove from ships list.
  for (i=0;i<ships.Length;i++)
    if (ships[i] == other)
    {
      ships.remove(i,1);
      break;
    }

  // Clear any existing pilot from the ship.
  clearPilot(Other);
}

simulated function clearPilot(Ship other) {
  if (other.pilot != none) {
    other.pilot.cleanup();
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated protected function SpaceWorker_Ship getNewShipWorker(Ship Other)
{
  local SpaceWorker_Ship NewWorker;

  NewWorker = SpaceWorker_Ship(allocateObject(class'SpaceWorker_Ship'));
  NewWorker.Ship = Other;
  other.setShipWorker(newWorker);
  NewWorker.initializeWorker();

  return NewWorker;
}

simulated protected function SpaceWorker_Weapon getNewWeaponWorker(ShipWeapon Other)
{
  local SpaceWorker_Weapon NewWorker;

  NewWorker = SpaceWorker_Weapon(allocateObject(class'SpaceWorker_Weapon'));
  NewWorker.Weapon = Other;
  Other.Worker = NewWorker;
  NewWorker.initializeWorker();

  return NewWorker;
}

simulated protected function addWorkerForShip(CompositeSpaceWorker parentWorker, Ship other)
{
  local int i;
  local SpaceWorker_Ship shipWorker;
  local SpaceWorker_Weapon weaponWorker;

  // Add Ship Worker.
  shipWorker = getNewShipWorker(other);
  if (shipWorker != none)
    parentWorker.addWorker(shipWorker);

  // Add Weapon Workers.
  for (i=0;i<other.weapons.length;i++) {
    weaponWorker = getNewWeaponWorker(other.weapons[i]);
    if (weaponWorker != none)
      parentWorker.addWorker(weaponWorker);
  }
}

simulated protected function removeWorkerForShip(CompositeSpaceWorker parentWorker, Ship other)
{
  local int i;
  local SpaceWorker worker;

  // Remove Ship Worker.
  worker = other.getShipWorker();
  if (worker != none) {
    if (parentWorker != none)
      parentWorker.removeWorker(worker);
    other.setShipWorker(none);
    worker.cleanup();
  }

  // Remove Weapon Workers.    
  for (i=0;i<other.weapons.length;i++) {
    worker = other.weapons[i].worker;
    if (worker != none) {
      if (parentWorker != none)
        parentWorker.removeWorker(worker);
      other.weapons[i].worker = none;
      worker.cleanup();
    }
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function gainedContact(Contact other)
{
  local int i;

  for (i=0;i<sensorObservers.length;i++)
    sensorObservers[i].gainedContact(other);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function lostContact(Contact Other)
{
  local int i;

  for (i=0;i<sensorObservers.Length;i++)
    sensorObservers[i].lostContact(Other);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function SpawnShipsRandomly(vector ApproximateLocation, float Deviation, int Count, ShipFactory factory)
{
  local int i;
  local Sector SpawnSector;

  SpawnSector = SpaceGameSimulation(getGameSimulation()).getGlobalSector();

  for (i=0;i<Count;i++)
    SpaceGameSimulation(getGameSimulation()).createShip_OpenSpace(self, SpawnSector, ApproximateLocation + (VRand() * FRand() * Deviation), factory);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Add/Remove Sensor Observers.

simulated function addSensorObserver(UserSensorObserver newObserver)
{
  sensorObservers[sensorObservers.length] = newObserver;
}

simulated function removeSensorObserver(UserSensorObserver oldObserver)
{
  local int i;

  for (i=0;i<sensorObservers.length;i++)
    if (sensorObservers[i] == oldObserver)
    {
      sensorObservers.remove(i,1);
      break;
    }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** AI Skill Levels.

simulated function setAISkillLevel(float newSkillLevel) {
  AISkillLevel = newSkillLevel;
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  PerformanceFactor=1
}