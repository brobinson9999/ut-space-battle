class ASMDLoader extends BaseUserLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function LoadUser(BaseUser Other)
  {
    local PartShip Ship;

    newWeaponTechnology(Other, "SM1", 0.5,    12500,  0.015,    1,  0,    1, 250, "Skymine Launcher");        // Overall DPS: 0.5
    newWeaponTechnology(Other, "SB1", 0.75, 0,      0.0085,   1.5,  0,    1, 0,   "Shock Cannon");            // Overall DPS: 0.75/1.5 = 0.5

    newWeaponTechnology(Other, "SM2", 1,    12500,  0.015,    2,    0,    1, 500, "Heavy Skymine Launcher");  // Overall DPS: 1/2 = 0.5
    newWeaponTechnology(Other, "SM3", 15,   20000,  0.0065,   7.5,  0,    1, 15,  "ASMD Paladin Cannon");     // Overall DPS: 15/7.5 = 2

    newWeaponTechnology(Other, "SB3", 0.75, 0,      0.009,    1.1,  0.1,  4, 0,   "Shock Cannon Battery");    // Overall DPS: 3/1.5 = 2
    newWeaponTechnology(Other, "SB2", 4.5,  0,      0.0065,   4.5,  0,    1, 0,   "Heavy Shock Cannon");      // Overall DPS: 4.5/4.5 = 1

    // Sensor Technologies.
    newSensorTechnology(Other, "SENSTECH", 2000000);

    // Ships.
    Ship = SingleLightFighterBlueprint(Other, "SkymineFighter", "Skymine Fighter", 1);
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SM1"));

    Ship = SingleHeavyFighterBlueprint(Other, "SkymineBomber", "Skymine Bomber", 1);
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM2"));

    Ship = FighterSupportGunshipBlueprint(Other, "SHKFSG", "Shock Fighter Support Gunship");
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB1"));

    Ship = FighterSupportGunshipBlueprint(Other, "SM1FSG", "Skymine Fighter Support Gunship");
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM1"));

    Ship = PatrolShipBlueprint(Other, "LSKYG", "Tactical Skymine Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SM1"));

    Ship = PatrolShipBlueprint(Other, "LSHKG", "Shock Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB1"));

    Ship = HeavyGunshipBlueprint(Other, "HSKYG", "Heavy Skymine Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SM2"));
    
    Ship = HeavyGunshipBlueprint(Other, "HPALG", "Heavy Paladin Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SM3"));

    Ship = TorpedoShipBlueprint(Other, "TorpedoShip", "ASMD Torpedo Ship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SM3"));

    Ship = V2ShipBlueprint(Other, "HeavyShockLancer", "Heavy Shock Lancer");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB3"));

    Ship = VT1H2ShipBlueprint(Other, "OffensiveMonitor", "Heavy Shock Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB1"));
    
    Ship = FrigateBlueprint(Other, "FRIGB2", "Heavy Shock Frigate");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB2"));

    Ship = FrigateBlueprint(Other, "FRIGB2B3", "Mixed Shock Frigate"); 
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB2"));

    Ship = FrigateBlueprint(Other, "FRIGB2M2", "Shock/Core Frigate"); // not used right now..
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB2"));

    Ship = FrigateBlueprint(Other, "CFRIG", "Core Frigate");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB2"));

    Ship = CarrierBattle_CarrierBlueprint(Other, "SCARR", "Support Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));

    Ship = CarrierBattle_CarrierBlueprint(Other, "SCARR_H", "Heavy Support Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB1"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("SM3"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));
    
    Ship = CarrierBattle_CarrierBlueprint(Other, "SCARR_S", "Skymine Support Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("SM2"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));

    Ship = DoubleDeckBroadsideBlueprint(Other, "DoubleBroadside", "Doubledeck Broadside Weapons Platform");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("SB2"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("SB3"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[10].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[11].setTechnology(Other.TechnologyFromID("SM1"));
    Ship.Parts[12].setTechnology(Other.TechnologyFromID("SM1"));
  
  }


  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}