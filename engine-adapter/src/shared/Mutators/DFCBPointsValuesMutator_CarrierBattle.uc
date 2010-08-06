class DFCBPointsValuesMutator_CarrierBattle extends DFCBPointsValuesMutator;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	friendlyName="UTSB: Carrier Battle"
	description="UT Space Battle: Sets fleet size parameters for fleet combat with 10000 point flagships and 8 reinforcements of up to 3000 points."
	
	flagshipStartingPoints=0
	minFlagshipPoints=10000
	maxFlagshipPoints=10000

  pointsPerKill=5
	reinforcementCount=8

  reinforcementStartingPoints=0
	minReinforcementPoints=0
	maxReinforcementPoints=3000
}
