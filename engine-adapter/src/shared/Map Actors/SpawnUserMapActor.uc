class SpawnUserMapActor extends BaseMapActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var() string userID;
  var() string userUniqueID;
  var() bool bPlayerUser;
  var User user;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function trigger(Actor other, Pawn eventInstigator) {
  getUser();
}

simulated function User getUser() {
  if (user == none) {
    if (bPlayerUser)
      executeConsoleCommand("spawn_user " $ userID);
    else
      executeConsoleCommand("spawn_neutral " $ userID);

    // not the most elegant way - uses the fact that the most recently added will be last in the user list.
    // also doesn't work properly if the spawning failed.
    user = SpaceGameSimulation(getGameSimulation()).users[SpaceGameSimulation(getGameSimulation()).users.length-1];
  
    user.setAISkillLevel(0.5);
    user.displayName = userUniqueID;
  }
  
  return user;
}

simulated function cleanup() {
  user = none;
  
  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}
