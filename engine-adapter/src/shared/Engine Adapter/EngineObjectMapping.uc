class EngineObjectMapping extends AssociationListActor;

// This class is used to map users to controllers. It provides a thin layer over AssociationListActor.
// I use the Actor version of AssociationList because the engine object will be an actor, and I want
// it to be properly set to none if that actor gets destroyed.
// The engine objects are the "keys" and the game objects are the "values".

simulated function object getEngineObjectForGameObject(object other) {
  return getKey(other);
}

simulated function object getGameObjectForEngineObject(object other) {
  return getValue(other);
}

simulated function setGameObjectForEngineObject(object gameObject, object engineObject) {
  removeKey(engineObject);
  addValue(engineObject, gameObject);
}

defaultproperties
{
}