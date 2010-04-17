class LinkMixed extends LinkLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser other)
  {
    super.loadUser(other);

    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("CARR_M"),          10000); // Carrier

    // Create Spawn Options.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("MXF"),             3000);  // Frigate.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W2DEST"),          1000);  // Destroyer.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("W1G"),             500);   // Heavy Gunship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("MXG"),             300);   // Patrol Ship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("MXFSG"),           200);   // Fighter Support Gunship.
    DFCB_BaseUser(other).addSpawnOption(other.blueprintFromID("MXFI"),            75);    // Superiority Fighter.
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}