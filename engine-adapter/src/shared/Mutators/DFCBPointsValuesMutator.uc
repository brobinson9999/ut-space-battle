class DFCBPointsValuesMutator extends AutoRunConsoleCommandsMutator abstract;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var int reinforcementCount;

var float pointsPerKill;

var float reinforcementStartingPoints;
var float minReinforcementPoints, maxReinforcementPoints;

var float flagshipStartingPoints;
var float minFlagshipPoints, maxFlagshipPoints;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function array<string> getConsoleCommands() {
  local array<string> result;
  
  result[result.length] = "reinforcementCount " $ reinforcementCount;
  result[result.length] = "reinforcementStartingPoints " $ reinforcementStartingPoints;
  result[result.length] = "minReinforcementPoints " $ minReinforcementPoints;
  result[result.length] = "maxReinforcementPoints " $ maxReinforcementPoints;
  result[result.length] = "flagshipStartingPoints " $ flagshipStartingPoints;
  result[result.length] = "minFlagshipPoints " $ minFlagshipPoints;
  result[result.length] = "maxFlagshipPoints " $ maxFlagshipPoints;
  
  return result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  groupName="UTSB_fleetLimits"
  groupNames[0]="UTSB_fleetLimits"
  friendlyName="UTSB: Modify Fleet Size"
  description="UT Space Battle: Specify the number of reinforcements, and size limits for flagships and reinforcements."
  
  reinforcementCount=0
  pointsPerKill=2
  
  flagshipStartingPoints=0
  minFlagshipPoints=10000
  maxFlagshipPoints=10000

  reinforcementStartingPoints=0
  minReinforcementPoints=0
  maxReinforcementPoints=3000
}
