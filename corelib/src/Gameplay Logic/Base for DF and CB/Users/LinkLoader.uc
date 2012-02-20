class LinkLoader extends BaseUserLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function loadUser(BaseUser Other)
  {
    local PartShip Ship;
    
    // Weapons.
    // Light Cannons.
    newWeaponTechnology(Other, "W0",  0.4, 50000, 0.01,   0.5,  0,      1, 0, "Plasma Autocannon");         // Overall DPS: 1
    newWeaponTechnology(Other, "W3",  0.4, 75000, 0.015,  1.4,  0.033,  3, 0, "Pulse Cannon");              // Overall DPS: 1.5/1.5 = 1

    // Heavy Weapons.
    newWeaponTechnology(Other, "W1",  0.5, 100000, 0.01,  1.4,  0.033,  3, 0, "Precision Pulse Cannon");    // Overall DPS: 1.5/1.5 = 1
    newWeaponTechnology(Other, "W2",  5,   25000, 0.0075, 2.5,  0,      1, 0, "Heavy Plasma Cannon");       // Overall DPS: 2

    // Very Heavy Weapons.
    newWeaponTechnology(Other, "W4",  2.5, 60000, 0.005, 1.25, 0, 1, 0,       "Long Range Autocannon");     // Overall DPS: 2
    newWeaponTechnology(Other, "W5",  0.5, 50000, 0.01, 0.3, 0.05, 4, 0,      "Autocannon Battery");        // Overall DPS: 4

    // Sensor Technologies.
    newSensorTechnology(Other, "SENSTECH", 2000000);

        
    Ship = InterceptorBlueprint(Other, "W0F", "Interceptor");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    
    Ship = InterceptorBlueprint(Other, "MXFI", "Mixed Fighter");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));

    Ship = SuperiorityFighterBlueprint(Other, "W3F", "Superiority Fighter");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W3"));

    Ship = FighterSupportGunshipBlueprint(Other, "W0FSG", "W0 Fighter Support Gunship");
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));

    Ship = FighterSupportGunshipBlueprint(Other, "MXFSG", "Mixed Fighter Support Gunship");
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));

    Ship = FighterSupportGunshipBlueprint(Other, "W3FSG", "W3 Fighter Support Gunship");
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W3"));

    Ship = PatrolShipBlueprint(Other, "W0G", "Plasma Light Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W0"));

    Ship = PatrolShipBlueprint(Other, "MXG", "Mixed Light Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W0"));

    Ship = PatrolShipBlueprint(Other, "W3G", "Pulse Light Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W3"));

    Ship = HeavyGunshipBlueprint(Other, "W1G", "Defense Heavy Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W1"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W1"));

    Ship = HeavyGunshipBlueprint(Other, "W2G", "Attack Heavy Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W2"));

    Ship = DestroyerBlueprint(Other, "W2DEST", "Destroyer");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("W1"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("W1"));

    Ship = FrigateBlueprint(Other, "W5F", "Assault Frigate");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W5"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W5"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W5"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W5"));

    Ship = FrigateBlueprint(Other, "MXF", "Assault Frigate");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W5"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W5"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W4"));

    Ship = FrigateBlueprint(Other, "W4F", "Siege Frigate");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W4"));

    Ship = CarrierBattle_CarrierBlueprint(Other, "CARR_B", "Pulse/Balanced Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("W1"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("W1"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));

    Ship = CarrierBattle_CarrierBlueprint(Other, "CARR_M", "Mixed Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W3"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("W1"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("W1"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));

    Ship = CarrierBattle_CarrierBlueprint(Other, "CARR_S", "Plasma Siege Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("W2"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));

    Ship = DoubleDeckBroadsideBlueprint(Other, "DoubleBroadside", "Doubledeck Broadside Weapons Platform");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("W4"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[10].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[11].setTechnology(Other.TechnologyFromID("W0"));
    Ship.Parts[12].setTechnology(Other.TechnologyFromID("W0"));
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}