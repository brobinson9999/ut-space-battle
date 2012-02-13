class LinkPulse extends LinkLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser other)
  {
    super.loadUser(other);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("CARR_B"),             10000); // Carrier

    // Create Spawn Options.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W5F"),                3000);  // Frigate.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W2DEST"),             2000);  // Destroyer.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W2G"),                500);   // Heavy Gunship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W3G"),                300);   // Patrol Ship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W3FSG"),              200);   // Fighter Support Gunship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W3F"),                75);    // Superiority Fighter.
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}