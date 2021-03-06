class DummyBalanced extends BaseUserLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser other)
  {
    super.loadUser(other);

    // Create Spawn Options.
    if (FRand() > 0.5)
      DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("SMALL"),   5);      // Immobile Target (Small).
    else if (FRand() > 0.5)
      DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("MEDIUM"),  5);      // Immobile Target (Medium).
    else
      DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("LARGE"),   5);      // Immobile Target (Large).
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}