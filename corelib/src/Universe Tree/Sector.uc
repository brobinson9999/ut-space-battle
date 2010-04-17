class Sector extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var array<Ship>             ships;
var array<Projectile>       projectiles;
var array<SectorPresence>   sectorPresences;

var int                     hackCounter; // just used as a counter to provide unique ints

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function shipEnteredSector(Ship newShip)
{
  local int i;

  ships[ships.length] = newShip;
  newShip.setSector(self);

  for (i=0;i<sectorPresences.length;i++)
    sectorPresences[i].notifyShipEnteredSector(newShip);
}

simulated function shipLeftSector(Ship X)
{
  local int i;

  // Notify Sector Commands.
  for (i=0;i<SectorPresences.Length;i++)
    SectorPresences[i].NotifyShipLeftSector(X);

  X.Sector = None;

  // Remove from sector.
  for (i=0;i<Ships.Length;i++)
    if (Ships[i] == X)
    {
      Ships.Remove(i,1);
      break;
    }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function ProjectileEnteredSector(Projectile X)
{
  Projectiles[Projectiles.Length] = X;
  X.Sector = Self;
}

simulated function ProjectileLeftSector(Projectile Proj)
{
  local int i;

  Proj.Sector = None;

  for (i=0;i<Projectiles.Length;i++)
    if (Projectiles[i] == Proj)
    {
      Projectiles.Remove(i,1);
      break;
    }

  // Cleanup.
  Proj.Cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function removeSectorPresence(SectorPresence sectorPresenceToRemove)
{
  local int i;

  // Remove from sector.
  for (i=0;i<sectorPresences.length;i++)
    if (sectorPresences[i] == sectorPresenceToRemove) {
      sectorPresences.remove(i,1);
      break;
    }

  // Remove from user.
  sectorPresenceToRemove.user.lost_Sector_Presence(sectorPresenceToRemove);

  // Cleanup.
  sectorPresenceToRemove.cleanup();
}


// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Cleanup()
{
  while (Projectiles.Length > 0)
    ProjectileLeftSector(Projectiles[0]);

  while (Ships.Length > 0)
    ShipLeftSector(Ships[0]);

  while (SectorPresences.Length > 0)
    RemoveSectorPresence(SectorPresences[0]);

  Super.Cleanup();
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}