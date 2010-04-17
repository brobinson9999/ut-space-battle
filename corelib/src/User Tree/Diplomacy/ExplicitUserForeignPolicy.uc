class ExplicitUserForeignPolicy extends UserForeignPolicy;

var array<UserDiplomaticStatus> diplomaticStatii;

simulated protected function UserDiplomaticStatus newDiplomaticStatus(User objectUser, User subjectUser) {
  local UserDiplomaticStatus newStatus;

  newStatus = UserDiplomaticStatus(allocateObject(class'UserDiplomaticStatus'));
  newStatus.objectUser = objectUser;
  newStatus.subjectUser = subjectUser;
  diplomaticStatii[diplomaticStatii.length] = newStatus;

  return newStatus;
}
  
simulated function UserDiplomaticStatus getExistingDiplomaticStatus(User objectUser, User subjectUser) {
  local int i;

  for (i=0;i<diplomaticStatii.length;i++)
    if (objectUser == diplomaticStatii[i].objectUser && subjectUser == diplomaticStatii[i].subjectUser)
      return diplomaticStatii[i];

  return none;
}
  
simulated function UserDiplomaticStatus getOrCreateDiplomaticStatus(User objectUser, User subjectUser) {
  local UserDiplomaticStatus status;
  
  status = getExistingDiplomaticStatus(objectUser, subjectUser);
  if (status == none)
    status = newDiplomaticStatus(objectUser, subjectUser);

  return status;
}

simulated function bool isFriendly(User objectUser, User subjectUser) {
  local UserDiplomaticStatus status;
  
  status = getExistingDiplomaticStatus(objectUser, subjectUser);
  if (status != none)
    return status.isFriendly();
  else
    return false;
}

simulated function bool isHostile(User objectUser, User subjectUser) {
  local UserDiplomaticStatus status;
  
  status = getExistingDiplomaticStatus(objectUser, subjectUser);
  if (status != none)
    return status.isHostile();
  else
    return false;
}

simulated function setFriendly(User objectUser, User subjectUser) {
  getOrCreateDiplomaticStatus(objectUser, subjectUser).setFriendly();
}

simulated function setHostile(User objectUser, User subjectUser) {
  getOrCreateDiplomaticStatus(objectUser, subjectUser).setHostile();
}

simulated function cleanup() {
  while (diplomaticStatii.length > 0) {
    diplomaticStatii[0].cleanup();
    diplomaticStatii.remove(0,1);
  }
  
  super.cleanup();
}

defaultproperties
{
}