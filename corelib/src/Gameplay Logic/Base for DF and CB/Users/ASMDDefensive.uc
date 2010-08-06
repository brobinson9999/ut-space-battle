class ASMDDefensive extends ASMDLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser other)
  {
    super.loadUser(other);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SCARR_S"),               10000);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("DoubleBroadside"),       9000);

    // Create Spawn Options.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("CFRIG"),                 3000);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("OffensiveMonitor"),      850);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("HSKYG"),                 500);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("LSHKG"),                 300);
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SHKFSG"),                200);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SkymineBomber"),         105);
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SkymineFighter"),        75);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}