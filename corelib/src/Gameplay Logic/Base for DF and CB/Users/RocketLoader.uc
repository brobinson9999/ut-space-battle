class RocketLoader extends BaseUserLoader;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function LoadUser(BaseUser Other)
  {
    local PartShip Ship;
    
    // Weapons.
    newWeaponTechnology(Other, "BUR", 1.5,  35000, 0.015, 6.0, 0.5,   3, 35,  "Burst Rocket");        // Overall DPS: 0.6
    newWeaponTechnology(Other, "POW", 10,   20000, 0.025, 7.5, 0,     1, 150, "Powderkeg Missile");   // Overall DPS: 4/3
    newWeaponTechnology(Other, "BOM", 20,   25000, 0.015, 7.5, 0,     1, 250, "Bombardment Missile"); // Overall DPS: 8/3

    // Sensor Technologies.
    newSensorTechnology(Other, "SENSTECH", 2000000);

    // Ships.    
    Ship = ScourgeBlueprint(Other, "SCOURGE", "Scourge Bomber");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("POW"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("BUR"));

    Ship = RaiderBlueprint(Other, "RAIDER", "Raider Gunship");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("POW"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("POW"));

    Ship = BroadsideBlueprint(Other, "BROADSIDE", "Broadside Weapons Platform");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("BUR"));

    Ship = DoubleDeckBroadsideBlueprint(Other, "DoubleBroadside", "Doubledeck Broadside Weapons Platform");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("BOM"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[10].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[11].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[12].setTechnology(Other.TechnologyFromID("BUR"));

    Ship = CarrierBattle_CarrierBlueprint(Other, "CARR", "Assault Carrier");
    Ship.Parts[0].setTechnology(Other.TechnologyFromID("SENSTECH"));
    Ship.Parts[1].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[2].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[3].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[4].setTechnology(Other.TechnologyFromID("BUR"));
    Ship.Parts[5].setTechnology(Other.TechnologyFromID("POW"));
    Ship.Parts[6].setTechnology(Other.TechnologyFromID("POW"));
    Ship.Parts[7].setTechnology(Other.TechnologyFromID("POW"));
    Ship.Parts[8].setTechnology(Other.TechnologyFromID("POW"));
    Ship.Parts[9].setTechnology(Other.TechnologyFromID("SENSTECH"));
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}