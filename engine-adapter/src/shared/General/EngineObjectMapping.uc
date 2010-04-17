class EngineObjectMapping extends BaseActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// ** Used to map Users to Controllers.
// ** This should be in a subclass of actor since the engine object will be an actor, and we can end up with references that don't get cleaned
// ** up if the engine object gets destroyed.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	var array<object> mappedGameObjects;
	var array<object> mappedEngineObjects;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function int getGameObjectIndex(object other) {
		local int i;

		for (i=0;i<mappedGameObjects.length;i++)
			if (mappedGameObjects[i] == other)
				return i;

		return -1;
	}
	
	simulated function int getEngineObjectIndex(object other) {
		local int i;

		for (i=0;i<mappedEngineObjects.length;i++)
			if (mappedEngineObjects[i] == other)
				return i;

		return -1;
	}

	simulated function object getEngineObjectForGameObject(object other) {
		local int i;
		
		i = getGameObjectIndex(other);
		if (i >= 0)
			return mappedEngineObjects[i];

		return none;
	}
	
	simulated function object getGameObjectForEngineObject(object other) {
		local int i;
		
		i = getEngineObjectIndex(other);
		if (i >= 0)
			return mappedGameObjects[i];

		return none;
	}
	
	simulated function setGameObjectForEngineObject(object gameObject, object engineObject) {
		local int i;
		
		i = getEngineObjectIndex(engineObject);
		if (i >= 0) {
			mappedGameObjects[i] = gameObject;
		} else {
			mappedGameObjects[mappedGameObjects.length] = gameObject;
			mappedEngineObjects[mappedEngineObjects.length] = engineObject;
		}
	}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function cleanup() {
		if (mappedGameObjects.length > 0) mappedGameObjects.remove(0,	mappedGameObjects.length);
		if (mappedEngineObjects.length > 0) mappedEngineObjects.remove(0,	mappedEngineObjects.length);

		super.cleanup();
	}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	// Avoid destruction at the hands of mutators in PreBeginPlay.
  bGameRelevant=true
}