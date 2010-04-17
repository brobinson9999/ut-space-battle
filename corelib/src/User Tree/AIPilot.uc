class AIPilot extends Pilot;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  const                   MM_DoNothing              = 0;

  const                   MM_StandGround            = 20;
  const                   MM_MaintainDistance       = 1;
  const                   MM_MaintainDistanceFacing = 2;
  
  const                   MM_Intercept              = 3;
  
  const                   MM_Dock                   = 10;
  
  const                   MM_Defense                = 13;
  const                   MM_Patrol                 = 14;

  const                   MM_Strafe                 = 15;

  const                   MM_CameraShip              = 16;
  
  const                   MM_Intercept_ChaseTail    = 17;

  const                   rm_stationary                 = 0;
  const                   rm_faceAcceleration           = 1;
  const                   rm_faceVelocity               = 2;
  const                   rm_faceDesiredVelocity        = 3;
  const                   rm_faceDesiredLocation        = 4;
  const                   rm_faceInterceptTarget        = 5;
  const                   rm_faceInterceptTargetLeadIn  = 6;
  const                   rm_faceWeaponsTargetLeadIn    = 8;
  const                   rm_freeFlight                 = 7;
  
  const                   lm_stationary                 = 0;
  const                   lm_maintainVelocity           = 1;
  const                   lm_desiredLocation            = 2;
  const                   lm_interceptTargetDirect      = 3;
  const                   lm_interceptTargetLeadIn      = 4;
  const                   lm_orbitTarget                = 5;
  const                   lm_freeFlight                 = 6;
  
  var int                 ManueverMode;

  var SpaceWorker_Ship    worker;
  
  var float               desiredStrafeAccuracy;
  var float               desiredDefenseAccuracy;
  var float               desiredInterceptionSpeedFactor;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var bool                bFreeFlight;
  var vector              freeFlightAcceleration;
  var rotator             freeFlightRotation;

  var rotator             chasedContactRotation;
  var vector              chasedContactLocation;
  var float               chasedContactRadius;
  var vector              chasedContactVelocity;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var Contact             InterceptTarget_Contact;
  var Ship                InterceptTarget_Ship;
  var Contact             Weapons_Target;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
  
  simulated function updateLinear() {
    autoManuever();
  }
  
  simulated function updateAngular() {
    autoManuever();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AutoWait()
  {
    SetManueverMode(MM_DoNothing);
  }
  
  simulated function AutoDefense()
  {
    SetManueverMode(MM_Defense);
  }
  
  simulated function AutoPatrol()
  {
    SetManueverMode(MM_Patrol);
  }
  
  simulated function cameraShip() {
    setManueverMode(MM_CameraShip);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SetManueverMode(int NewManueverMode)
  {
    LeaveManueverMode();
    ManueverMode = NewManueverMode;
    EnterManueverMode();
  }
  
  simulated function LeaveManueverMode()
  {
  }
  
  simulated function EnterManueverMode()
  {
  }

  simulated function AutoManuever()
  {
    if (bFreeFlight)
    {
      AMFreeFlight();
      return;
    }
    
    switch (ManueverMode)
    {
      case MM_DoNothing:
        break;
        
      case MM_StandGround:
        AMStandGround();
        break;

      case MM_CameraShip:
        AMCameraShip();
        break;
      
      case MM_MaintainDistance:
      case MM_MaintainDistanceFacing:
        AMMaintainDistance();
        break;

      case MM_Intercept:
        AMIntercept();
        break;

      case MM_Intercept_ChaseTail:        
        AMIntercept_ChaseTail();
        break;

      case MM_Defense:
        AMDefense();
        break;

      case MM_Patrol:
        AMPatrol();
        break;
        
      case MM_Strafe:
        AMStrafe();
        break;
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  /*
      Attack Mode Selection
        Direct Attack Modes
          Stand Ground
          Maintain Distance, Facing
          Intercept (Approach from different Directions, Interception close to engagement range possible)
          Chase Down (Greater Speed will allow a chase and rear attack. Calculate time to reach engagement range) (Attacking from the rear is the preferred course for non-"hard" targets but should not be used against hard targets.)
            - This is very similar in implementation to Intercept.. should they be the same or are there differences in the breakoff that justify them being separate?

        Turret Attack Modes
          Stand Ground
          Maintain Distance
          Orbit
          Strafe/Broadside (Attack Run but orbit halfway before continuing.)
  */

  simulated function AutoSelectAttackMode()
  {
    local bool bDirectAttackMode;
    
    bDirectAttackMode = hasFixedWeapons(Ship);
    
    if (bDirectAttackMode)
      AutoSelectDirectAttackMode();
    else
      AutoSelectTurretAttackMode();
  }

  simulated function bool hasFixedWeapons(Ship Target)
  {
    local int i;
    
    for (i=0;i<Target.Weapons.Length;i++)
      if (isFixedWeapon(Target.Weapons[i]))
        return true;

    return false;
  }
  
  simulated function bool isFixedWeapon(Part Candidate)
  {
    if (ShipWeapon(Candidate) == None)
      return false;
     
    return ShipWeapon(Candidate).maxFireArc < 32768;
  }
   
  simulated function Contact getFixedWeaponsTarget() {
    local int i;
    
    for (i=0;i<ship.weapons.length;i++)
      if (isFixedWeapon(ship.weapons[i]) && ship.weapons[i].worker != none && ship.weapons[i].worker.currentTask != none && ship.weapons[i].worker.currentTask.target != none)
        return ship.weapons[i].worker.currentTask.target;
    
    return none;
  }

  simulated function AutoSelectDirectAttackMode()
  {
    // Seems to be more aggressive - but also presents more risk especially against targets with turrets?
//    SetManueverMode(MM_Intercept_ChaseTail);
    
    // Makes a quick pass - only gets a limited number of shots in as it passes. Not exposed to enemy fire for as long though - pros? cons? 
    // Possibly superior for cases where this ship is not agile enough to get on the tail of the target, or the target is passing by quickly and we don't want to match speed with it, rather we wish to take one pass and break off.
    SetManueverMode(MM_Intercept);
//    SetManueverMode(MM_Strafe);
  }
  
  simulated function AutoSelectTurretAttackMode()
  {
    SetManueverMode(MM_Strafe);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// launchIfNecessary: ->
// This function launches the ship if it is currently docked, otherwise it does nothing.
simulated function launchIfNecessary() {
  if (ship.getDockedTo() != none)
    ship.attemptUndock();
}

  simulated function AMFreeFlight()
  {
    launchIfNecessary();

//    Ship.bUseDesiredVelocity = true;
//    Ship.bUseDesiredLocation = false;

    setDesiredVelocity(ship.velocity + (ship.acceleration * freeFlightAcceleration));
    
    Ship.desiredVelocity_RelativeTo = None;

    rotationManuever(rm_freeFlight);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMStandGround()
  {
    launchIfNecessary();

    // Don't move. Rotate to face target if we have one.
    setDesiredVelocity(Vect(0,0,0));
    Ship.DesiredVelocity_RelativeTo = None;

    rotationManuever(rm_faceInterceptTargetLeadIn);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMMaintainDistance()
  {
    local vector Dp;
    
    launchIfNecessary();

    // Maintain Distance.
    Ship.DesiredVelocity_RelativeTo = interceptTarget_Contact;
    
    Dp = InterceptTarget_Contact.getContactLocation() - Ship.getShipLocation();
    setDesiredVelocity(Normal(Dp) * (VSize(Dp) - 400));

    // Set facing.
    if (ManueverMode == MM_MaintainDistanceFacing)
      rotationManuever(rm_faceInterceptTargetLeadIn);
    else
      rotationManuever(rm_faceVelocity);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMCameraShip()
  {
    local vector Dp;
    local float desiredSpeed;
    local vector interceptLocation;
    
    local vector relativeLocation;
    local vector cameraShipOffset;
    
    launchIfNecessary();

//    ship.bUseDesiredVelocity = true;
//    ship.bUseDesiredLocation = false;
    
    if (interceptTarget_Contact == none) {
      // cheat - change ship acceleration when farther away and/or going faster.
      ship.acceleration = (vSize(ship.velocity) * 4) + 5000;
      setDesiredVelocity(vect(0,0,0));
      ship.desiredVelocity_RelativeTo = none;
      return;
    }
      
    relativeLocation = (chasedContactLocation - ship.getShipLocation()) UnCoordRot chasedContactRotation;
    
    chasedContactRadius *= 3;

    relativeLocation.x = 0;
    cameraShipOffset = -normal(relativeLocation) * chasedContactRadius * 1.5;
    cameraShipOffset.x = chasedContactRadius * -3;
    
    interceptLocation = chasedContactLocation + (cameraShipOffset CoordRot chasedContactRotation);
    Dp = interceptLocation - ship.getShipLocation();

    // cheat - change ship acceleration when farther away and/or going faster.
    ship.acceleration = vSize(Dp) + vSize(chasedContactVelocity - ship.velocity) + 5000;

    desiredSpeed = sqrt(2 * vSize(Dp) * ship.acceleration * 0.5);


    setDesiredVelocity((normal(Dp) * desiredSpeed) + (chasedContactVelocity * 0.8));
    ship.desiredVelocity_RelativeTo = none;

    // Face some point ahead of the contact.    
    rotateToFacePosition(chasedContactLocation + (Vector(chasedContactRotation) * 50000) + (Normal(chasedContactVelocity) * 0));
  }  
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMIntercept_ChaseTail()
  {
    launchIfNecessary();

    moveToFormation(interceptTarget_Contact, vect(-1,0,0) * strafeDistanceForWeapons(interceptTarget_Contact, desiredStrafeAccuracy));
    
    rotationManuever(rm_faceInterceptTargetLeadIn);
  }  
  
  simulated function AMIntercept()
  {
    // Abort if no target.
    if (InterceptTarget_Contact == None)
    {
      errorMessage("AMIntercept: No target.");
      return;
    }
    
    
    moveToFormation(interceptTarget_Contact, (normal(ship.getShipLocation() - interceptTarget_Contact.getContactLocation()) uncoordRot interceptTarget_Contact.getContactSourceRotation()) * strafeDistanceForWeapons(interceptTarget_Contact, desiredStrafeAccuracy));

    // Use generic intercept.
    AMIntercept_Generic(interceptTarget_Contact.getContactLocation(), interceptTarget_Contact.getContactVelocity(), ship.acceleration * desiredInterceptionSpeedFactor, ship.acceleration);
    rotationManuever(rm_faceInterceptTargetLeadIn);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function moveToFormation(Contact formationLeader, vector relativePosition) {
    local vector Dp;
    local float desiredSpeed;
    local vector interceptLocation;

//    Ship.bUseDesiredVelocity = true;
//    Ship.bUseDesiredLocation = false;

    interceptLocation = formationLeader.getContactLocation() + (relativePosition CoordRot formationLeader.getContactSourceRotation());
    Dp = interceptLocation - ship.getShipLocation();

    desiredSpeed = sqrt(2 * vSize(Dp) * ship.acceleration * 0.5);

    setDesiredVelocity(normal(Dp) * desiredSpeed);
    ship.desiredVelocity_RelativeTo = formationLeader;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************



// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMIntercept_Generic(vector Target_Position, vector Target_Velocity, float InterceptSpeed, float wobbleMagnitude)
  {
    local vector Dp;
    local vector InterceptPoint;
    local float LDp;
    //local float ETA;
    local float DesiredSpeed;
//    local vector RelativeVelocity;
    local vector RotatedTargetVelocity;
    
    local float ExpectDecelThrottle;
    
    launchIfNecessary();
    
    InterceptPoint = Target_Position;

    // 20090101: Make the fighters scatter a little bit. This is a cheap way to do it and doesn't look that good. Real formations would be greatly preferable.
    // Scattering is beneficial because fighters targetting the group have to rotate to target the members of the group. This introduces a delay for enemy fighters
    // when they retarget. If the fighters are clumped up there is no delay and many fighters can be destroyed in quick succession with only minor adjustments to 
    // aim.
//    if (ship.owner.AISkillLevel > 0.4)
      interceptPoint = interceptPoint + (VRand() * wobbleMagnitude);

    // Head Toward
    Dp = InterceptPoint - Ship.getShipLocation();
    LDp = VSize(Dp);

    // Don't assume that ALL throttle can be applied to deceleration.
    ExpectDecelThrottle = 0.5;
    
    // 20081109: Worked out in black notebook.
    // Desired Approach Speed.
    DesiredSpeed = sqrt((2 * LDp * Ship.Acceleration * ExpectDecelThrottle) + (InterceptSpeed ** 2));

    // I have the desired approach speed, (that is under my control) but I have to factor in the target's approach speed as well.
    // If RotatedTargetVelocity.X is negative, the target is approaching me.
    RotatedTargetVelocity = Target_Velocity UnCoordRot Rotator(Dp);
    DesiredSpeed -= -RotatedTargetVelocity.X;
    
//    Ship.bUseDesiredVelocity = true;
//    Ship.bUseDesiredLocation = false;

    setDesiredVelocity(Normal(Dp) * DesiredSpeed);
    Ship.DesiredVelocity_RelativeTo = None;
    
    // Indicate manuever completion.
    if (LDp < 100)
      Manuever_Completed();
  }

  simulated function float ProjectileSpeed()
  {
    local int i;
    
    for (i=0;i<Ship.Weapons.Length;i++)
      return Ship.Weapons[i].localTechnology.MuzzleVelocity;
      
    return 0;
  }

simulated function vector AM_Intercept_Calculate_Lead_In(vector Target_Position, vector Target_Velocity, float ProjSpeed) {
  return calculateLeadIn(ship.getShipLocation(), ship.velocity, target_position, target_velocity, projSpeed);
}

simulated static function vector calculateLeadIn(vector ownLocation, vector ownVelocity, vector Target_Position, vector Target_Velocity, float ProjSpeed) {
  local int i;
  local vector Dp;
  local vector InterceptPoint;
  local float LDp;
  local float ETA;
  local vector RelativeVelocity;

  local float OldETA;
  local float IterateDelta;

  local float ShipApproachSpeed;
  local float ProjApproachSpeed;

  // Get Relative Velocity.
  RelativeVelocity = ownVelocity - Target_Velocity;

  InterceptPoint = Target_Position;

  // Head Toward
  Dp = InterceptPoint - ownLocation;
  LDp = VSize(Dp);
  IterateDelta = LDp;

  ETA = 0;

  if (ProjSpeed > 0)
  {
    // Iterative approach - closed form would be better.
    for (i=0;i<15;i++)
    {
      ShipApproachSpeed = (RelativeVelocity UnCoordRot Rotator(Dp)).X;
      ProjApproachSpeed = (ProjSpeed + ShipApproachSpeed);

      OldETA = ETA;
      ETA = LDp / ProjApproachSpeed;
      IterateDelta = Abs(ETA - OldETA);

      // Limit to 2 seconds lead in? For interception anyway.
      ETA = FMin(ETA, 2);

      InterceptPoint = Target_Position + (Target_Velocity * FMin(ETA, 2));

      // Calculate new distance.
      Dp = InterceptPoint - ownLocation;
      LDp = VSize(Dp);

      if (IterateDelta < 0.01) break;
    }
  }

  return InterceptPoint;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMDock()
  {
    // Abort if no target.
    if (InterceptTarget_Ship == None)
    {
      errorMessage("AMDock: No target.");
      return;
    }

    // Use generic intercept.
    AMIntercept_Generic(InterceptTarget_Ship.getShipLocation(), InterceptTarget_Ship.Velocity, Ship.Acceleration * 1, 0);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMDefense()
  {
    local bool bFixedWeapons;
    
    // Abort if no target.
    if (interceptTarget_Contact == None)
    {
      errorMessage("AMDefense: No target.");
      return;
    }
    
    bFixedWeapons = hasFixedWeapons(ship);
    if (bFixedWeapons)
      weapons_Target = getFixedWeaponsTarget();
    
    // Use generic orbit.
    Generic_Orbit(InterceptTarget_Contact.getContactLocation(), strafeDistanceForShip(interceptTarget_Contact, ship.acceleration * 2, desiredDefenseAccuracy), Ship.Acceleration * 5);
    if (bFixedWeapons && weapons_Target != none)
      rotationManuever(rm_faceWeaponsTargetLeadIn);
    else
      rotationManuever(rm_faceDesiredVelocity);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMStrafe()
  {
    // Abort if no target.
    if (interceptTarget_Contact == none)
    {
      errorMessage("AMStrafe: No target.");
      return;
    }

    // Use generic orbit.
    generic_Orbit(interceptTarget_Contact.getContactLocation(), strafeDistanceForWeapons(interceptTarget_Contact, desiredStrafeAccuracy), ship.acceleration * 5);

    if (hasFixedWeapons(ship))
      rotationManuever(rm_faceInterceptTargetLeadIn);
    else
      rotationManuever(rm_faceVelocity);
  }
  
  simulated function float strafeDistanceForShip(Contact other, float strafeSpeed, float desiredAccuracy)
  {
    return FMax(strafeDistanceForAgility(strafeSpeed), strafeDistanceForWeapons(other, desiredAccuracy));
  }
  
  // Returns an appropriate strafing distance based on this ship's agility.
  simulated function float strafeDistanceForAgility(float strafeSpeed)
  {
    local float result;

    result = ((2 * strafeSpeed)**2) / (pi * ship.acceleration);

    return result;
  }

  // Returns an appropriate strafing distance based on weapon range.
  simulated function float strafeDistanceForWeapons(Contact other, float desiredAccuracy)
  {
    local int i;
    local float StrafeDistance;
    
    if (other == none || ship.weapons.length == 0)
      return 1000;
      
    for (i=0;i<ship.weapons.length;i++) {
      strafeDistance = strafeDistance + strafeDistanceForWeapon(ship.weapons[i], desiredAccuracy);
    }

    strafeDistance = strafeDistance / ship.weapons.length;

    return strafeDistance;
  }

  simulated function float strafeDistanceForWeapon(ShipWeapon Weapon, float desiredAccuracy)
  {
    local float targetRadius;
    local float useAccuracy;
    local float Result;
    
    if (Weapon == None) return 0;
    
    targetRadius = InterceptTarget_Contact.estimateContactRadius();
    
    // If a weapon has zero precision, division by zero can occur!
    useAccuracy = FMax(weapon.localTechnology.precision, 0.00001);
    
    // accuracy * range = targetRadius / desiredAccuracy
    // range = (targetradius / desiredAccuracy) / accuracy
    result = FMin(100000, (targetRadius / desiredAccuracy) / useAccuracy);

    return Result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Generic_Orbit(vector TargetLocation, float OrbitDist, float OrbitSpeed)
  {
    local vector LocDiff;
    local vector InterceptPosition;
    
    local vector TweakedLocDiff;
    local vector RotModdedLocDiff;

    LocDiff = TargetLocation - Ship.getShipLocation();

    RotModdedLocDiff = Ship.Velocity UnCoordRot Rotator(LocDiff);
    RotModdedLocDiff.X = 0;
    TweakedLocDiff = RotModdedLocDiff CoordRot Rotator(LocDiff);

    InterceptPosition = TargetLocation + (OrbitDist * Normal(TweakedLocDiff));
    AMIntercept_Generic(InterceptPosition, InterceptTarget_Contact.getContactVelocity(), OrbitSpeed, 0);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function AMPatrol()
  {
    // Abort if no target.
    if (InterceptTarget_Contact == None)
      return;

    AMDefense();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float RangeForDamagePct(Contact Target, ShipWeapon Weapon, float DesiredDPSFactor)
  {
    return Weapon.RangeForEffectiveDPSFactor(Target, DesiredDPSFactor);
  }

  simulated function float EngagementRangeFor(Contact T, ShipWeapon W)
  {
    return RangeForDamagePct(T, W, 0.5);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Set_Worker(SpaceWorker_Ship NewWorker)
  {
    Worker = NewWorker;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Manuever_Completed() {
    if (Worker != None) Worker.Manuever_Completed();
  }
  
  simulated function Manuever_Cannot_Be_Completed() {
    if (Worker != None) Worker.Manuever_Cannot_Be_Completed();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup()
  {
    if (worker != none) {
      worker.cleanup();
      worker = none;
    }
    
    interceptTarget_Contact = none;
    interceptTarget_Ship = none;
    weapons_Target = none;
    
    super.cleanup();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setDesiredVelocity(vector newDesiredVelocity) {
    if (ship != none) {
      ship.bUseDesiredVelocity = true;
      ship.desiredVelocity = newDesiredVelocity;
      ship.desiredAcceleration = ship.acceleration * normal(ship.desiredvelocity - ship.velocity);
    }
  }
  
  simulated function setDesiredAcceleration(vector newDesiredAcceleration) {
    if (ship != none) {
      ship.bUseDesiredVelocity = false;
      ship.desiredAcceleration = newDesiredAcceleration;
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function linearManuever(int manueverType) {
    switch (manueverType) {
      case lm_stationary:
        break;
      case lm_maintainVelocity:
        break;
      case lm_desiredLocation:
        break;
      case lm_interceptTargetDirect:
        break;
      case lm_interceptTargetLeadIn:
        break;
      case lm_orbitTarget:
        break;
      case lm_freeFlight:
        break;
    }
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function rotationManuever(int manueverType) {
    switch (manueverType) {
      case rm_stationary:
        setDesiredRotation(ship.rotation);
        break;
      case rm_faceAcceleration:
        rotateToFaceAcceleration();
        break;
      case rm_faceVelocity:
        rotateToFaceVelocity();
        break;
      case rm_faceDesiredVelocity:
        rotateToFaceDesiredVelocity();
        break;
      case rm_faceDesiredLocation:
        rotateToFaceDesiredLocation();
        break;
      case rm_faceInterceptTarget:
        rotateToFaceInterceptTarget();
        break;
      case rm_faceInterceptTargetLeadIn:
        rotateToFaceLeadIn(interceptTarget_Contact.getContactLocation(), interceptTarget_Contact.getContactVelocity(), projectileSpeed());
        break;
      case rm_faceWeaponsTargetLeadIn:
        rotateToFaceLeadIn(weapons_Target.getContactLocation(), weapons_Target.getContactVelocity(), projectileSpeed());
        break;
      case rm_freeFlight:
        setDesiredRotation(freeFlightRotation);
        break;
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function rotateToFaceLeadIn(vector targetPosition, vector targetVelocity, float travelSpeed) {
    local vector leadInPoint;
    
    leadInPoint = AM_Intercept_Calculate_Lead_In(targetPosition, targetVelocity, travelSpeed);

    rotateToFacePosition(leadInPoint);
  }

  simulated function rotateToFaceInterceptTarget() {
    rotateToFaceContact(interceptTarget_Contact);
  }
  
  simulated function rotateToFaceContact(Contact contact) {
    if (contact != none)
      rotateToFacePosition(contact.getContactLocation());
  }

  simulated function rotateToFaceAcceleration() {
    rotateToFacingVector(ship.desiredAcceleration);
  }
  
  simulated function rotateToFaceDesiredVelocity() {
    rotateToFacingVector(ship.desiredVelocity);
  }

  simulated function rotateToFaceVelocity() {
    rotateToFacingVector(ship.velocity);
  }
  
  simulated function rotateToFaceDesiredLocation() {
    rotateToFacePosition(ship.desiredLocation);
  }

  simulated function rotateToFacePosition(vector facingPosition) {
    rotateToFacingVector(facingPosition - ship.getShipLocation());
  }
  
  simulated function rotateToFacingVector(vector facingVector) {
    local rotator newDesiredRotation;
    local vector relativeVector;
    local rotator relativeRotator;
    
    // Abort if length is zero - it has no direction.
    if (facingVector == vect(0,0,0))
      return;
      
    relativeVector = facingVector UncoordRot ship.rotation;
    relativeRotator = rotator(relativeVector);
    newDesiredRotation = relativeRotator CoordRot ship.rotation;
    
    setDesiredRotation(newDesiredRotation);
  }
  
  simulated function setDesiredRotation(rotator newDesiredRotation) {
    ship.desiredRotation = newDesiredRotation;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  desiredStrafeAccuracy=0.75
  desiredDefenseAccuracy=4
  desiredInterceptionSpeedFactor=4
}