class UserDiplomaticStatusObserver extends UserObserver;

var User observingFor;
var User observedUser;

simulated function UserDiplomaticStatusObserver createUserDiplomaticStatusObserver(User newObservedUser, User newObservingFor) {
  local UserDiplomaticStatusObserver result;
  
  result = UserDiplomaticStatusObserver(newObservingFor.allocateObject(class'UserDiplomaticStatusObserver'));
  result.observingFor = newObservingFor;
  result.observedUser = newObservedUser;

  result.observedUser.addUserObserver(result);
  
  return result;
}
  
simulated function userCleaningUp() {
  observingFor.otherUserCleanedUp(observedUser);
  
  cleanup();
}

simulated function cleanup()
{
  if (observedUser != none)
    observedUser.removeUserObserver(self);

  observedUser = none;
  observingFor = none;

  super.cleanup();
}

defaultproperties
{
}