class BaseUserLoader extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function loadUser(BaseUser other);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// **** Technology Constructors.
  
simulated function addTechnologyToUser(BaseUser other, SpaceTechnology technology) {
  other.technologies[other.technologies.Length] = technology;
}
  
simulated function WeaponTechnology newWeaponTechnology(BaseUser Other, string identifier, float intensity, float muzzleVelocity, float precision, float refireTime, float burstRefireTime, float burstSize, float weaponBlastRadius, string friendlyName)
{
  local WeaponTechnology technology;

  technology = WeaponTechnology(allocateObject(class'WeaponTechnology'));

  technology.identifier = identifier;
  technology.intensity = intensity;
  technology.muzzleVelocity = muzzleVelocity;
  technology.precision = precision;
  technology.refireTime = refireTime;
  technology.burstRefireTime = burstRefireTime;
  technology.burstSize = burstSize;
  technology.weaponBlastRadius = weaponBlastRadius;
  technology.friendlyname = friendlyName;

  addTechnologyToUser(other, technology);

  return technology;
}

simulated function SpaceTechnology newSensorTechnology(BaseUser other, string identifier, float intensity)
{
  local SensorTechnology technology;
  
  technology = SensorTechnology(allocateObject(class'SensorTechnology'));

  technology.identifier = identifier;
  technology.intensity = intensity;

  addTechnologyToUser(other, technology);

  return technology;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// **** Blueprint Constructors.

simulated function PartShip newPartShip(BaseUser other, string identifier, string friendlyName, float mass, float thrust, float rotationRate, float armor, float selfRepairRate)
{
  local ShipBlueprint shipBlueprint;
  local PartShipFactory shipFactory;
  local DefaultShip prototype;

  shipBlueprint = ShipBlueprint(allocateObject(class'ShipBlueprint'));
  shipBlueprint.identifier = identifier;
  shipBlueprint.setFriendlyName(friendlyName);

  shipFactory = PartShipFactory(allocateObject(class'PartShipFactory'));
  shipBlueprint.shipFactory = shipFactory;

  // this is less than ideal
  prototype = DefaultShip(shipFactory.getPrototype());

  prototype.setShipMaximumAcceleration(thrust / mass);
  prototype.setShipMaximumRotationalAcceleration(rotationRate);
  prototype.armor = armor;
  
  if (selfRepairRate > 0)
    addSelfRepairSystem(PartShip(prototype), selfRepairRate);

  shipFactory.recalcPrototypePhysics();

  other.blueprints[other.blueprints.length] = shipBlueprint;

  return PartShip(shipFactory.getPrototype());
}

simulated function addSelfRepairSystem(Ship other, float repairRate) {
  local SelfRepairPartShipSystem newSystem;
  
  if (PartShip(other) != none) {
    newSystem = SelfRepairPartShipSystem(allocateObject(class'SelfRepairPartShipSystem'));
    newSystem.repairRate = repairRate;
    other.addSystem(newSystem);
  }
}

simulated function newShipPart(BaseUser other, string shipIdentifier, string partIdentifier, class<Part> partClass, vector relativeLocation, rotator relativeRotation, float scale, float maxFireArc)
{
  local PartShipFactory shipFactory;
  local DefaultShip prototype;
  local Part shipPart;
  
  // this is less than ideal
  shipFactory = PartShipFactory(other.blueprintFromID(shipIdentifier).shipFactory);
  prototype = DefaultShip(shipFactory.getPrototype());

  shipPart = Part(allocateObject(partClass));
  shipPart.partID = partIdentifier;
  PartShip(prototype).addPart(shipPart);
  shipPart.initializePart();

  shipPart.relativeLocation = relativeLocation;
  shipPart.relativeRotation = relativeRotation;
  shipPart.physicalScale = scale;
  if (ShipWeapon(shipPart) != none)
    ShipWeapon(shipPart).maxFireArc = maxFireArc;

  shipFactory.recalcPrototypePartPhysics(shipPart);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip ScourgeBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 3;

  // weapons: 2 + 4 = 6

  // sum of part scales: 2

  // 1.5x2=3
  Result = newPartShip(Other, Identifier, FriendlyName, 30, 7500, 4096, 0.55 * Scale, 0.1);

  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,0,0)       * Scale, Rot(0,0,16384),    1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip RaiderBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 3.5;

  // weapons: 4 + 8 = 12
  // additional armor: 5.5
  // total: 17.5

  // sum of part scales: 5

  // 2.5x5=12.5
  Result = newPartShip(Other, Identifier, FriendlyName, 100, 20000, 1024, 1.5 * Scale, 0.1);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,20,20)     * Scale, Rot(0,0,57344),    1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,-20,20)    * Scale, Rot(0,0,8192),     1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(0,-20,-20)   * Scale, Rot(0,0,24576),    1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(0,20,-20)    * Scale, Rot(0,0,40960),    1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip BroadsideBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 8;

  // frigate has 4x5 = 20
  // this has 5 x 9 = 45

  Result = newPartShip(Other, Identifier, FriendlyName, 1000, 20000, 256, 6.5 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,20,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,-20,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(0,40,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(0,-40,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W5",       class'ShipWeapon', Vect(0,60,0)      * Scale, Rot(0,0,0),        0.5 * scale, 32768);
  newShipPart(Other, Identifier, "W6",       class'ShipWeapon', Vect(0,-60,0)     * Scale, Rot(0,0,0),        0.5 * scale, 32768);
  newShipPart(Other, Identifier, "W7",       class'ShipWeapon', Vect(0,80,0)      * Scale, Rot(0,0,0),        0.5 * scale, 32768);
  newShipPart(Other, Identifier, "W8",       class'ShipWeapon', Vect(0,-80,0)     * Scale, Rot(0,0,0),        0.5 * scale, 32768);

  return Result;
}

simulated function PartShip DoubleDeckBroadsideBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 8;

  // 5x13=65 
  Result = newPartShip(Other, Identifier, FriendlyName, 1500, 25000, 192, 6.5 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,20,10)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,-20,10)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(0,40,10)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(0,-40,10)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W12",      class'ShipWeapon', Vect(0,20,-10)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W22",      class'ShipWeapon', Vect(0,-20,-10)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W32",      class'ShipWeapon', Vect(0,40,-10)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W42",      class'ShipWeapon', Vect(0,-40,-10)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W5",       class'ShipWeapon', Vect(0,60,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W6",       class'ShipWeapon', Vect(0,-60,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W7",       class'ShipWeapon', Vect(0,80,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W8",       class'ShipWeapon', Vect(0,-80,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip SimpleShipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 3.5;

  // weapons: 4 + 8 = 12
  // additional armor: 5.5
  // total: 17.5

  // sum of part scales: 5

  // 2.5x5=12.5
  Result = newPartShip(Other, Identifier, FriendlyName, 100, 20000, 1024, 1.5 * Scale, 0.1);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,20,20)     * Scale, Rot(0,0,57344),    1 * scale, 32768);

  return Result;
}

simulated function PartShip SingleLightFighterBlueprint(BaseUser Other, string Identifier, string FriendlyName, float scaleMultiplier)
{
  local PartShip result;
  local float scale;

  scale = 1 * scaleMultiplier;

  result = newPartShip(other, identifier, friendlyName, 10, 7500, 24000, 0.35 * scale, 0.1 * scale);

  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,0,0)       * Scale, Rot(0,0,0),          1 * scale, 0);

  return result;
}

simulated function PartShip SingleHeavyFighterBlueprint(BaseUser Other, string Identifier, string FriendlyName, float scaleMultiplier)
{
  local PartShip result;
  local float scale;

  scale = 2 * scaleMultiplier;

  result = newPartShip(other, identifier, friendlyName, 20, 10000, 10000, 0.5 * scale, 0.1 * scale);

  newShipPart(Other, Identifier, "W1",       class'Part',       Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 0);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,0,-20)     * Scale, Rot(0,0,0),        1 * scale, 0);

  return result;
}

simulated function PartShip FighterBlueprint(BaseUser Other, string Identifier, string FriendlyName, float scaleMultiplier)
{
  local PartShip Result;
  local float Scale;

  Scale = 1 * scaleMultiplier;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 7500, 24000, 0.35 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 0);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 0);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip SuperiorityFighterBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;

  Result = FighterBlueprint(Other, Identifier, FriendlyName, 0.9);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip InterceptorBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;

  Result = FighterBlueprint(Other, Identifier, FriendlyName, 1);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip SingleLightFighterSupportGunshipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 1;

  Result = newPartShip(Other, Identifier, FriendlyName, 25, 15000, 12000, 1 * Scale, 0.15 * Scale);

  newShipPart(Other, Identifier, "DUMMY1",   class'Part', Vect(5,10,0)            * Scale, Rot(8192,0,0),           1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(5,-10,0)       * Scale, Rot(-8192,0,0),        1 * scale, 32768);

  return Result;
}

simulated function PartShip SingleHeavyFighterSupportGunshipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 25, 15000, 12000, 1 * Scale, 0.15 * Scale);

  newShipPart(Other, Identifier, "DUMMY1",   class'Part', Vect(5,10,0)            * Scale, Rot(8192,0,0),           1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(5,-10,0)       * Scale, Rot(-8192,0,0),        1 * scale, 32768);

  return Result;
}

// Is this balanced? Seems to be similar in size to the "2 light" fighters.
simulated function PartShip FighterSupportGunshipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 25, 15000, 12000, 1 * Scale, 0.15 * Scale);

  newShipPart(Other, Identifier, "DUMMY1",   class'Part', Vect(10,0,0)            * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,10,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,-10,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip PatrolShipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 2000, 8384, 1.5 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(10,10,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(10,-10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(-10,-10,0)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(-10,10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip HeavyGunshipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 1850, 8384, 1.5 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(10,10,-10)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(10,-10,-10)  * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(0,5,5)       * Scale, Rot(0,0,0),        2 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(0,-5,5)      * Scale, Rot(0,0,0),        2 * scale, 32768);

  return Result;
}

simulated function PartShip TorpedoShipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 1850, 4096, 1.5 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(10,0,-25)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(10,0,-10)      * Scale, Rot(0,0,0),        1 * scale, 32768);

  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(-30,0,30)      * Scale, Rot(0,0,0),        1 * scale, 0);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(0,0,0)         * Scale, Rot(0,0,0),        1 * scale, 0);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(30,0,-30)      * Scale, Rot(0,0,0),        1 * scale, 0);

  return Result;
}

simulated function PartShip V2ShipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 1900, 10000, 3 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,20,0)      * Scale, Rot(0,0,0),        2 * scale, 0);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,-20,0)      * Scale, Rot(0,0,0),        2 * scale, 0);

  return Result;
}

simulated function PartShip VT1H2ShipBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 2;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 1850, 4096, 1.5 * Scale, 0.1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(-10,0,20)      * Scale, Rot(0,0,0),        1 * scale, 32768);

  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(0,0,0)      * Scale, Rot(0,0,0),        2 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(20,-60,0)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(20,60,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip DestroyerBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 4;

  Result = newPartShip(Other, Identifier, FriendlyName, 30, 3000, 1024, 2.5 * Scale, 0.15 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(-20,0,10)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(-10,10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(-10,-10,0)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(0,10,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(0,-10,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W5",       class'ShipWeapon', Vect(10,10,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W6",       class'ShipWeapon', Vect(10,-10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W7",       class'ShipWeapon', Vect(20,10,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W8",       class'ShipWeapon', Vect(20,-10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip SingleVeryHeavyFrigateBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 8;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 2000, 512, 2.5 * Scale, 0.5 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(10,0,0)      * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(-10,0,0)     * Scale, Rot(32768,0,0),    1 * scale, 32768);

  return Result;
}

simulated function PartShip FrigateBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 8;

  Result = newPartShip(Other, Identifier, FriendlyName, 10, 2000, 512, 2.5 * Scale, 0.5 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(10,10,0)     * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(10,-10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(-10,-10,0)   * Scale, Rot(0,0,0),        1 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(-10,10,0)    * Scale, Rot(0,0,0),        1 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartShip CarrierBattle_CarrierBlueprint(BaseUser Other, string Identifier, string FriendlyName)
{
  local PartShip Result;
  local float Scale;

  Scale = 5.6;

  // weapons: 8 + 16 = 24
  // hangars: 48?
  // armor/engineering: 24ish

  // sum of part scales: 17

  Result = newPartShip(Other, Identifier, FriendlyName, 1000, 25000, 256, 5 * Scale, 1 * Scale);

  newShipPart(Other, Identifier, "SENS",     class'ShipSensor', Vect(20,0,0)      * Scale, Rot(0,0,0),                1.5 * scale, 32768);
  newShipPart(Other, Identifier, "W1",       class'ShipWeapon', Vect(0,0,0)       * Scale, Rot(0,0,0),                3   * scale, 32768);
  newShipPart(Other, Identifier, "W2",       class'ShipWeapon', Vect(-20,0,0)     * Scale, Rot(0,0,0),                1   * scale, 32768);
  newShipPart(Other, Identifier, "W3",       class'ShipWeapon', Vect(-5,-15,0)    * Scale, Rot(32768,-14336,16384),   1.5 * scale, 32768);
  newShipPart(Other, Identifier, "W4",       class'ShipWeapon', Vect(-5,15,0)     * Scale, Rot(32768,-14336,16384),   1.5 * scale, 32768);
  newShipPart(Other, Identifier, "W5",       class'ShipWeapon', Vect(0,10,0)      * Scale, Rot(0,0,0),                1   * scale, 32768);
  newShipPart(Other, Identifier, "W6",       class'ShipWeapon', Vect(0,-10,0)     * Scale, Rot(0,0,0),                1   * scale, 32768);
  newShipPart(Other, Identifier, "W7",       class'ShipWeapon', Vect(0,20,0)      * Scale, Rot(0,0,0),                1   * scale, 32768);
  newShipPart(Other, Identifier, "W8",       class'ShipWeapon', Vect(0,-20,0)     * Scale, Rot(0,0,0),                1   * scale, 32768);
  newShipPart(Other, Identifier, "SENS2",    class'ShipSensor', Vect(0,0,0)       * Scale, Rot(0,0,0),                1.5 * scale, 32768);
  newShipPart(Other, Identifier, "H1",       class'ShipHangar', Vect(-5,-5,-7.5)  * Scale, Rot(-16384,0,32768),       1.5 * scale, 32768);
  newShipPart(Other, Identifier, "H2",       class'ShipHangar', Vect(-5,5,-7.5)   * Scale, Rot(-16384,0,32768),       1.5 * scale, 32768);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}