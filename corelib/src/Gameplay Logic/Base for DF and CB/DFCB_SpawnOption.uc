class DFCB_SpawnOption extends BaseObject;

var ShipFactory factory;
var float       pointCost;          // How many points are deducted to purchase this ship.

simulated function cleanup()
{
  factory = none;

  super.cleanup();
}
  
defaultproperties
{
}