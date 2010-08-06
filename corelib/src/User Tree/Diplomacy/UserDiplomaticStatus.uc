class UserDiplomaticStatus extends BaseObject;

var User objectUser;
var User subjectUser;

var bool bFriendly;
var bool bHostile;
  
simulated function bool isFriendly() {
  return bFriendly;
}

simulated function bool isHostile() {
  return bHostile;
}

simulated function setFriendly() {
  bFriendly = true;
  bHostile  = false;
}

simulated function setHostile() {
  bFriendly = false;
  bHostile  = true;
}

simulated function cleanup() {
  objectUser = none;
  subjectUser = none;

  super.cleanup();
}
  
defaultproperties
{
}