class DefaultShip extends Ship;

var float armor;

simulated function initializeClonedShip(Ship clone)
{
  super.initializeClonedShip(clone);
  
  DefaultShip(clone).armor = armor;
}
  
defaultproperties
{
}