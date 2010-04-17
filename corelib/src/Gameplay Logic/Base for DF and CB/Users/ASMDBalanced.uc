class ASMDBalanced extends ASMDLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser other)
  {
    super.loadUser(other);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SCARR"),                  10000);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("DoubleBroadside"),        9000);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("FRIGB2"),                 3000);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("OffensiveMonitor"),       850);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("HSKYG"),                  500);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("LSKYG"),                  300);
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SM1FSG"),                 200);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SkymineBomber"),          105);
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SkymineFighter"),         75);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}