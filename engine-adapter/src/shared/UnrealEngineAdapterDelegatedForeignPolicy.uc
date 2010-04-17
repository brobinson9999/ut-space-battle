class UnrealEngineAdapterDelegatedForeignPolicy extends UserForeignPolicy;

var UnrealEngineAdapter adapter;

simulated function setAdapter(UnrealEngineAdapter newAdapter) {
  adapter = newAdapter;
}

simulated function bool isFriendly(User objectUser, User subjectUser) {
  return adapter.isGameObjectFriendly(objectUser, subjectUser);
}

simulated function bool isHostile(User objectUser, User subjectUser) {
  return adapter.isGameObjectHostile(objectUser, subjectUser);
}

simulated function cleanup() {
  setAdapter(none);

  super.cleanup();
}

defaultproperties
{
}