class SetDiplomaticStatusMapActor extends BaseMapActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var() string userUniqueID;
  var() string otherUserUniqueID;

  var() bool bHostile;
  var() bool bFriendly;
  
  var() bool bMutual;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function trigger(Actor other, Pawn eventInstigator) {
  local BaseUser user;
  local BaseUser otherUser;

  user = BaseUser(getUser(userUniqueID));
  otherUser = BaseUser(getUser(otherUserUniqueID));

  if (user == none) {
    errorMessage(self$" triggered but user with ID "$userUniqueID$" could not be found.");
    return;
  }

  if (otherUser == none) {
    errorMessage(self$" triggered but user with ID "$otherUserUniqueID$" could not be found.");
    return;
  }

  if (bHostile)
    user.setHostile(otherUser);
  if (bFriendly)
    user.setFriendly(otherUser);

  if (bMutual) {
    if (bHostile)
      otherUser.setHostile(user);
    if (bFriendly)
      otherUser.setFriendly(user);
  }
}

simulated function User getUser(string uniqueID) {
  local SpawnUserMapActor suma;
  
  foreach dynamicActors(class'SpawnUserMapActor', suma) {
    if (suma.userUniqueID == uniqueID) {
      return suma.getUser();
    }
  }
  
  return none;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}
