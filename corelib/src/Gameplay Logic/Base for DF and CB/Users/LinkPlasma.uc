class LinkPlasma extends LinkLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser other)
  {
    super.loadUser(other);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("CARR_S"),              10000);     // Carrier

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("DoubleBroadside"),     9000);

    // Create Spawn Options.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W4F"),                 3000);      // Frigate.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W2G"),                 500);       // Heavy Gunship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W0G"),                 300);       // Patrol Ship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W0FSG"),               200);       // Fighter Support Gunship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W0F"),                 75);        // Interceptor.
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}