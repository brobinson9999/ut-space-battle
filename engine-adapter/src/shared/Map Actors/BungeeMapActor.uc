class BungeeMapActor extends BaseMapActor;

// Prevent ships from flying too far from this actor by applying a "bungee" cord effect.

simulated function tick(float delta) {
  local int i;
  local array<ship> ships;
  
  ships = SpaceGameSimulation(getGameSimulation()).getGlobalSector().ships;

  for (i=0;i<ships.length;i++)
    bungeeShip(ships[i], delta);

  super.tick(delta);
}

simulated function bungeeShip(Ship other, float delta)
{
  local vector bungeeVelocity;
  local vector locationDifference;

  // multiplied by getGlobalPositionScaleFactor to convert internal units to game engine specific units
  locationDifference = (other.getShipLocation() - location) * class'UnrealEngineCanvasObject'.static.getGlobalPositionScaleFactor();

  bungeeVelocity = -normal(locationDifference) * fmax(0, (VSize(locationDifference) - 200000) * 0.1);

  // Apply Damping effect.
  if (vSize(bungeeVelocity) > 0)
    other.velocity *= (1-delta);

  other.velocity += bungeeVelocity * delta;
}

defaultproperties
{
}
