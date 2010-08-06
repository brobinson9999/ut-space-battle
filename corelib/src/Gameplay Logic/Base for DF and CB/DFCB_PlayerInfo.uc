class DFCB_PlayerInfo extends BaseObject;

var float Points;

var DFCB_TeamInfo Team;
var Ship Ship;

var bool bFlagship;

var bool  bAlive;
var float NextSpawnTime;

simulated function cleanup() {
  team = none;
  ship = none;

  super.cleanup();
}
  
defaultproperties
{
}