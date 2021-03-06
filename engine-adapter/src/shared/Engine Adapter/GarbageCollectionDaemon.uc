// Periodically forces a garbage collection.
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

class GarbageCollectionDaemon extends BaseActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	var float timeAccumulator;
	var float garbageCollectionPeriod;
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function tick(float delta)
  {
  	super.tick(delta);
  	
  	timeAccumulator += delta;
  	if (timeAccumulator >= garbageCollectionPeriod) {
	  	consoleCommand("obj garbage");
  		timeAccumulator = 0;
  	}
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	garbageCollectionPeriod=1
}