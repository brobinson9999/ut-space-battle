class UTSpaceBattleGameSimulation extends SpaceGameSimulation;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

struct FleetOption {
  var string fleetName;
  var class<BaseUserLoader> fleetLoaderClass;
};

var int userFleetIndex;
var UserForeignPolicy newUserForeignPolicy;

var array<UTSpaceBattleGameSimulationObserver> observers;

simulated function addObserver(UTSpaceBattleGameSimulationObserver newObserver) {
  observers[observers.length] = newObserver;
}

simulated function removeObserver(UTSpaceBattleGameSimulationObserver oldObserver) {
  local int i;
  
  for (i=0;i<observers.length;i++)
    if (observers[i] == oldObserver) {
      observers.remove(i,1);
      return;
    }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ***** Events and Notifications.

simulated function playerKilled(object killedGameObject, object killerGameObject) {
  local int i;

  for (i=observers.length-1;i>=0;i--)
    observers[i].gamePlayerKilled(killedGameObject, killerGameObject);
}

simulated function restartPlayer(object gamePlayerObject) {
  if (UTSB_BaseUser(gamePlayerObject) != none)
    UTSB_BaseUser(gamePlayerObject).attemptRespawn();
}

simulated function object createGamePlayerObject(string playerName, float skillLevel, bool bPlayerUser)
{
  local User newUser;

  newUser = createNewUser(bPlayerUser);
  newUser.setForeignPolicy(newUserForeignPolicy);

  newUser.setAISkillLevel(skillLevel);
  newUser.displayName = playerName;

  return newUser;
}

  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setFleetDelta(int delta, BaseUser user) {
//  local object engineObject;
  local array<FleetOption> fleets;
  
  fleets = getFleets();

  if (fleets.length > 0) {
    userFleetIndex += delta;
    while (userFleetIndex < 0)
      userFleetIndex += fleets.length;
    while (userFleetIndex >= fleets.length)
      userFleetIndex -= fleets.length;
      
    
    // If already playing, kill off and clear user.
    // TODOLD Deal with this somehow.
    if (user != none) {
      playerKilled(user, user);

      user.cleanupShips();
      user.cleanupTechnologiesBlueprints();
      loadLoader(user, getPlayerFleet().fleetLoaderClass);
    }
  } 
}

simulated function array<FleetOption> getFleets();

simulated function FleetOption getPlayerFleet() {
  local array<FleetOption> fleets;
  
  fleets = getFleets();

  if (userFleetIndex < 0 || userFleetIndex >= fleets.length)
    return getRandomFleet();
  else
    return fleets[userFleetIndex];
}

simulated function FleetOption getRandomFleet() {
  local array<FleetOption> fleets;
  
  fleets = getFleets();
  myAssert(fleets.length > 0, "UTSpaceBattleGameSimulation.getRandomFleet fleets.length == 0");
    
  return fleets[rand(fleets.length)];
}

simulated function class<User> getNewUserClass() {
  return class'BaseUser';
}

simulated function User createNewUser(bool bPlayerUser) {
  local FleetOption userType;
  local User newUser;

  if (bPlayerUser)
    userType = getPlayerFleet();
  else
    userType = getRandomFleet();

  newUser = User(allocateObject(getNewUserClass()));
  newUser.displayName = "New Player";

  addUser(newUser);

  newUser.initializeUser();

  if (BaseUser(newUser) != none)
    loadLoader(BaseUser(newUser), userType.fleetLoaderClass);

  createdNewUser(newUser);

  return newUser;
}

simulated function loadLoader(BaseUser user, class<BaseUserLoader> thisLoaderClass)
{
  local BaseUserLoader newLoader;

  newLoader = BaseUserLoader(allocateObject(thisLoaderClass));
  newLoader.loadUser(user);
  newLoader.cleanup();
}

simulated function createdNewUser(User newUser);

simulated function cleanup() {
  while (observers.length > 0) {
    removeObserver(observers[0]);
  }

  newUserForeignPolicy = none;  
  
  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  userFleetIndex=-1
}