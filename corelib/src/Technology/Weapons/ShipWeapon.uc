class ShipWeapon extends Part;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var     WeaponTechnology        localTechnology;
  
  var     float                   lastFiredTime;
  var     int                     burstCounter;

  // Maximum fire arc for this weapon. The fire arc indicates the max angle of deviation from directly forward.
  // 0 indicates directly forward, 32768 indicates all around.
  var     float                   maxFireArc;

  var     SpaceWorker_Weapon      worker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setTechnology(SpaceTechnology newTechnology) {
    super.setTechnology(newTechnology);
    
    localTechnology = WeaponTechnology(newTechnology);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float nextFireTime()
  {
    if (localTechnology.burstSize > 1 && burstCounter < localTechnology.burstSize)
      return lastFiredTime + localTechnology.burstRefireTime;
    else
      return lastFiredTime + localTechnology.refireTime;
  }
  
  simulated function bool readyToFire()
  {
    if (!bOnline)
      return false;

    return (getCurrentTime() >= nextFireTime());      
  }
  
  simulated function updateBurstCounter() {
    if (getCurrentTime() - lastFiredTime >= localTechnology.refireTime)
      burstCounter = 0;
  }
  
  simulated function bool tryFire(Contact target)
  {
    if (!readyToFire())
      return false;
      
    // 20090125:
    // Reset the burst counter if it has been the full reload time, or if the burst counter is full. It seems like checking if the burst counter is full isn't necessary, if it is
    // we would have to have waited the full reload time in order for readyToFire to return true. However sometimes if the timing is close enough, it returns true from readyToFire
    // but false to this check. This causes burstCounter to exceed burstSize.
    // 20100215: Why does it have that problem? It seems like it should work regardless of how close the timing is.
    updateBurstCounter();
    if (burstCounter >= localTechnology.burstSize)
      burstCounter = 0;
    
    fire(target);
      
    return true;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  private simulated function fire(Contact target)
  {
    local float Range;
    local float oldRangeGuess, newRangeGuess;
    local int iterations;
    local WeaponProjectile newProjectile;
    local float ShotVelocity;
    local Vector guessedLocation, guessedVelocity;
    local vector desiredFireDirection;
    local vector actualFireDirection;

    myAssert(ship != none, "ShipWeapon.fire but ship == none");
    myAssert(ship.getShipSector() != none, "ShipWeapon.fire but ship.getShipSector() == none");
      
    newProjectile = WeaponProjectile(allocateObject(class'WeaponProjectile'));
    newProjectile.Damage = localTechnology.Intensity;
    newProjectile.StartTime = getCurrentTime(); // Used to be the ships last update time - that causes problems and is not correct. If we use the ships last update time impact events can be scheduled prior to the current game time.
    newProjectile.StartLocation = Ship.getShipLocation() + (RelativeLocation CoordRot Ship.getShipRotation());
    
    // Should go through the contact for this...
    newProjectile.Target = Target.contactShip;
    
    
    newProjectile.projectileBlastRadius = localTechnology.weaponBlastRadius;
    
    newProjectile.Owner = Ship.getShipOwner();
    newProjectile.Instigator = newProjectile.Owner;
    
    // Determine Impact Location.
    // We want to distribute fire through the area that the contact might be.
    // To do this we pick a random point in a sphere around the center of the contact,
    // with radius equal to the amount of uncertainty in the contact's recorded position.
    guessedLocation = target.getContactLocation() + (vRand() * fRand() * target.contactRadius);
    newProjectile.EndLocation = guessedLocation;
    range = VSize(newProjectile.EndLocation - newProjectile.StartLocation);

    guessedVelocity = target.getContactVelocity();

    if (localTechnology.muzzleVelocity > 0)
    {
      // Adjust Range for lead in.
      // I think this can be improved.

      // Determine actual projectile speed.
      ShotVelocity = localTechnology.MuzzleVelocity + VSize(Ship.getShipVelocity());

      // Estimate lead in.
      oldRangeGuess = range;
      while (iterations < 10) {
        newProjectile.EndLocation = guessedLocation + (guessedVelocity * (oldRangeGuess / shotVelocity));
        newRangeGuess = VSize(newProjectile.endLocation - newProjectile.startLocation);

        iterations++;

        if (abs(newRangeGuess - oldRangeGuess) < 0.1)
          break;
          
        oldRangeGuess = newRangeGuess;
      }

      range = newRangeGuess;
    }

    // If we don't know the target's exact location, we want to fire within the envelope of space that we think the target is in.
    if (target.contactRadius > 0)
      newProjectile.endLocation += VRand() * FRand() * target.contactRadius;

    desiredFireDirection = normal(newProjectile.endLocation - newProjectile.startLocation);
    actualFireDirection = getBestFireDirection(desiredFireDirection, vector(ship.getShipRotation()), maxFireArc);
    newProjectile.endLocation = newProjectile.startLocation + (actualFireDirection * vsize(newProjectile.endLocation - newProjectile.startLocation));
    
    newProjectile.endLocation += VRand() * FRand() * localTechnology.precision * range;

    if (localTechnology.muzzleVelocity > 0) {
      // Setup End Time and Impact Event.
      newProjectile.endTime = newProjectile.startTime + (range / (localTechnology.muzzleVelocity + VSize(ship.getShipVelocity())));
      ship.getShipSector().projectileEnteredSector(newProjectile);
    } else {
      // Impact immediately.
      newProjectile.EndTime = newProjectile.StartTime;
      ship.getShipSector().projectileEnteredSector(newProjectile);
    }
    
    if (ship != none)
      ship.notifyPartFiredWeapon(self, newProjectile);

    if (localTechnology.muzzleVelocity == 0)
      newProjectile.impact();
    else
      getClock().addAlarm(newProjectile.EndTime, newProjectile).callback = newProjectile.impact;


    // Set Last Fire Time and Burst Counter.
    lastFiredTime = getCurrentTime();
    BurstCounter++;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float Estimated_Accuracy_Against(Contact Target, float minFixedCos)
  {
    local vector desiredFireDirection;
    
    // Expected "max" deviation.
    local float ExpectedDeviation;
    
    local float TargetRadius;
    local float Range;

    local float DamageFraction;
    local float AccuracyFraction;

    local float Fixed_Cos;
    local float Fixed_Hypotenuse;
    local float Fixed_Deviation;
    
    local vector TargetLocation;
    
    if (ship == none)
      return 0;
    
    // Get Target Location.
    TargetLocation = class'Ballistics'.static.calculateLeadIn(ship.getShipLocation(), ship.getShipVelocity(), target.getContactLocation(), target.getContactVelocity(), localTechnology.MuzzleVelocity);
    
    // Determine range.
    Range = VSize(TargetLocation - Ship.getShipLocation());
    
    // Account for turret precision.
    
    // Account for weapon precision.
    ExpectedDeviation += localTechnology.Precision * Range * 0.5;
    
    // Account for projectile travel time. (assuming maximum possible evade)
    if (localTechnology.MuzzleVelocity != 0)
      ExpectedDeviation += VSize(Target.getContactAcceleration()) * (Range / localTechnology.MuzzleVelocity) * 0.5;
    
    // Account for sensor inaccuracy.
    ExpectedDeviation += Target.contactRadius;

    // Adjust for fixed weapons.
    if (maxFireArc < 32768)
    {
      desiredFireDirection = normal(targetLocation - ship.getShipLocation());
      Fixed_Cos = getBestFireDirection(desiredFireDirection, vector(ship.getShipRotation()), maxFireArc) dot desiredFireDirection;
//      Fixed_Cos = Normal(Vector(Ship.getShipRotation())) Dot Normal(TargetLocation - Ship.getShipLocation());
      
      Fixed_Cos = FMax(minFixedCos, fixed_Cos);
      
      // Presumably, Fixed_Cos cannot be greater than 1 - sometimes the result comes up slightly greater - ie 1.000000156 and this causes sqrt of a negative number below.
      // If Fixed_Cos <= 0, the target is behind this ship - we'll just use an arbitrary large deviation value.
      if (Fixed_Cos >= 1) {
        Fixed_Deviation = 0;
      } else if (Fixed_Cos <= 0) {
        Fixed_Deviation = 1000000;
      } else {
        // SOHCAHTOA  
        Fixed_Hypotenuse = Range / Fixed_Cos;

        // Pythagorean Theorem
        Fixed_Deviation = sqrt((Fixed_Hypotenuse*Fixed_Hypotenuse) - (Range*Range));
      }
    }
    
    Fixed_Deviation -= localTechnology.weaponBlastRadius;
    
    // Offset for radius.
    ExpectedDeviation = FMax(ExpectedDeviation, 0);
    
    TargetRadius = Target.estimateContactRadius();

    // Still doesn't handle fixed deviation properly...
    if ((Fixed_Deviation - ExpectedDeviation) > TargetRadius)
      return 0;

    ExpectedDeviation = ExpectedDeviation + Fixed_Deviation;
    
    // Calculate expected accuracy.
    // This is what fraction of full normal DPS will be inflicted from this distance.
    // If Expected Deviation is equal to radius, the average shot hits but any below average shots will miss - so you would be hitting
    // with 50% of your shots but not all of those shots would do full damage. The average damage would be half. So when
    // TargetRadius == ExpectedDeviation the accuracy is 0.25.
    // If ExpectedDeviation is zero, the accuracy is 1.
    // If ExpectedDeviation is ?
    // It seems the overall formula is the chance to hit times the fraction of damage that the hits you make do.
    // The fraction of damage you do will be one half when all hits are evenly distributed across the hull.
    // If ExpectedDeviation is greater than the target radius, hits will be evently distributed across the hull.
    // If ExpectedDeviation is less than the target radius, hits will do more damage.
    if (ExpectedDeviation <= 0) {
      DamageFraction = 1;
      AccuracyFraction = 1;
    } else if (ExpectedDeviation < TargetRadius) {
      // ExpectedDeviation is less than the target's radius.
      // Expect every shot to hit with damage ranging evenly from 1 to ExpectedDeviation / TargetRadius.
      // The average damage is 1 - ((1 + (ExpectedDeviation / TargetRadius)) / 2)?
      
      // I need to determine how much DPS the average shot does. If ExpectedDeviation == TargetRadius then average DPS is 0.5.
      
      DamageFraction = 0.5 + (0.5 * ((TargetRadius - ExpectedDeviation)/TargetRadius));
      AccuracyFraction = 1;
    } else {
      DamageFraction = 0.5;
      AccuracyFraction = TargetRadius / ExpectedDeviation;
    }
      
    return DamageFraction * AccuracyFraction;    
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float RangeForEffectiveDPSFactor(Contact Target, float DesiredDPSFactor)
  {
    // Best Case (still needs to add weapons radius into it.)
    // Precision * Range == Expected Miss By Amount from Imprecision. At this range average damage factor is 0.5.
    // Where does Target Evasion come in?
    // The Estimated_Accuracy_Against simulated function already encodes this - ideally I should find a way to have them both share the same algorithm so I won't have to maintain two.
    
    
    return (localTechnology.Precision * DesiredDPSFactor) / (Target.estimateContactRadius());
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Not including accuracy.
  simulated function float DamagePerSecond()
  {
    if (localTechnology == None)
      return 0;
    
    return (localTechnology.Intensity * FMin(1, localTechnology.BurstSize)) / (localTechnology.RefireTime + (localTechnology.BurstSize * localTechnology.BurstRefireTime));
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function InitializeClonedPart(Part Clone)
  {
    Super.InitializeClonedPart(Clone);
    
    ShipWeapon(Clone).maxFireArc = maxFireArc;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// getBestFireDirection: vector vector float -> vector
// Consumes a desired direction to fire in, the facing of the weapon, and the maximum fire arc of the weapon. Returns the
// direction closest to the desired direction that is also within the arc. If the desired direction is within the fire arc
// of the weapon it is returned unchanged. The fire arc is measured in Unreal Rotation Units and is independant on each of
// yaw and pitch.
simulated static function vector getBestFireDirection(vector desiredFireDirection, vector centerOfFireArc, float fireArcSize) {
  local rotator relativeFireRotation;
  
  if (fireArcSize == 0)
    return centerOfFireArc;
  if (fireArcSize == 32768)
    return normal(desiredFireDirection);
  
  relativeFireRotation = normalize(rotator(desiredFireDirection unCoordRot rotator(centerOfFireArc)));
  
  // Give the desired fire direction exactly if it is within the arc.
  if (abs(relativeFireRotation.yaw) - fireArcSize <= 0 && abs(relativeFireRotation.pitch) - fireArcSize <= 0)
    return desiredFireDirection;

  // This introduces an imperfect result due to the conversion to rotator and then back to vector, but it is extremely close.
  relativeFireRotation.yaw = FClamp(relativeFireRotation.yaw, -fireArcSize, fireArcSize);
  relativeFireRotation.pitch = FClamp(relativeFireRotation.pitch, -fireArcSize, fireArcSize);
  return vector(relativeFireRotation) coordRot rotator(centerOfFireArc);
}

  simulated function Cleanup()
  {
//    if (Worker != None) Worker.Cleanup();
    
    localTechnology = none;
    worker = none;
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}