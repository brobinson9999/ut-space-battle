class SpaceWorker_Ship extends DefaultSpaceWorker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var Ship    Ship;
  
  var float   Attack_Preference;
  
  var SpaceTask    Current_Task;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setTaskPreference(class<SpaceTask> Task_Class, object New_Target, float BiasWeight)
{
  local int i;

  super.setTaskPreference(Task_Class, New_Target, BiasWeight);

  // Ship may be none if we are setting the task preference to none while cleaning up.
  if (ship == none)
    return;

  if (Task_Class == class'Task_Attack')
    AIPilot(Ship.Pilot).Weapons_Target = Contact(New_Target);

  for (i=0;i<Ship.Weapons.Length;i++)
    Ship.Weapons[i].Worker.setTaskPreference(Task_Class, New_Target, BiasWeight);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Needs to be expanded.
simulated function bool isAssignedToTask(SpaceTask task) {
  if (Assigned_Task_Type != task.class)
    return false;

  if (Task_Attack(task).target == Assigned_Task_Target)
    return true;

  return false;
}

simulated function float Evaluate_Effectiveness_Against(SpaceTask task)
{
  local int i;
  local float PersistenceFactor;
  local float AssignmentFactor;
  local float baseEffectiveness;
  local float DPS;
  local float otherVulnerability;
  local float targetCondition;

  if (Task == Current_Task)
    PersistenceFactor = persistenceModifierBase;
  else
    PersistenceFactor = 1;

  AssignmentFactor = 1;

  if (Ship == None)
    errorMessage(self$": Worker without ship.");

  if (Task_Attack(Task) != None && Attack_Preference > 0)
  {
    targetCondition = getContactCondition(Task_Attack(task).target);
    if (targetCondition == 0)
      return 0;

    otherVulnerability = Task_Attack(task).target.estimateTargetVulnerability() * targetCondition;

    // Check for manual assignment.
    if (isAssignedToTask(task))
      AssignmentFactor = Assigned_Task_Bias_Weight;

    for (i=0;i<Ship.Weapons.Length;i++)
      DPS = DPS + Ship.Weapons[i].DamagePerSecond();

    baseEffectiveness = Rate_Effectiveness_Against_Attack(Task_Attack(Task).Target) * Attack_Preference * DPS;

    baseEffectiveness = baseEffectiveness / otherVulnerability;
  }

  if (Task_Defense(Task) != None && Attack_Preference > 0)
  {
    // Check for manual assignment.
    if (Assigned_Task_Type == Task.Class && Task_Defense(Task).Target == Assigned_Task_Target)
      AssignmentFactor = Assigned_Task_Bias_Weight;

    for (i=0;i<Ship.Weapons.Length;i++)
      DPS = DPS + Ship.Weapons[i].DamagePerSecond();

    if (Task_Defense(Task).Target.estimateContactRadius() > Ship.Radius)
    {
      baseEffectiveness = Rate_Effectiveness_Against_Defense(Task_Defense(Task).Target) * Attack_Preference * DPS;
    }
  }

  if (Task_Patrol(Task) != None && Attack_Preference > 0)
  {
    // Check for manual assignment.
    if (Assigned_Task_Type == Task.Class && Task_Patrol(Task).Target == Assigned_Task_Target)
      AssignmentFactor = Assigned_Task_Bias_Weight;

    baseEffectiveness = Rate_Effectiveness_Against_Patrol(Task_Patrol(Task).Target) * Attack_Preference;
  }

  if (Task_Idle(task) != none) {
    baseEffectiveness = 1;
  }

  baseEffectiveness = baseEffectiveness * PersistenceFactor;
  baseEffectiveness = baseEffectiveness * AssignmentFactor;

  return baseEffectiveness;
}

simulated function float getContactCondition(Contact other) {
  local int targetConditionCurrent;
  local int targetConditionMax;

  if (other == none)
    return 0;

  other.estimateTargetCondition(targetConditionCurrent, targetConditionMax);

  // smarter AIs should use the current condition of the ship to identify weakened targets. dumber AIs just go off the targets total health.
  if (ship.getShipOwner().AISkillLevel > 0.4)
    return float(targetConditionCurrent);
  else
    return float(targetConditionMax);
}

simulated function float Rate_Effectiveness_Against_Attack(Contact X)
{
  local vector Dp, Dv, RotDv;
  local float TimeToMatchSpeed;
  local float XScore;
  local float DistanceFactor;

  if (!X.isHostile() || X.Sector != Ship.Sector)
    return 0;

  Dp = X.getContactLocation() - Ship.getShipLocation();

  // 20080311: I'm seeing an issue here. As the ship approaches the target, it takes longer to
  // match speed - it looks like it's getting away.. Maybe I should only be measuring approach speed.
//      Dv = X.getContactVelocity() - Ship.Velocity;
//      TimeToMatchSpeed = (VSize(Dv) / Ship.Acceleration);
//      Dp += ((Dv * 0.5) * TimeToMatchSpeed * (1+(Vector(Ship.DesiredRotation) Dot Normal(Dv))));

  Dv = X.getContactVelocity() - Ship.Velocity;
  RotDv = Dv UnCoordRot Rotator(Dp);
  if (ship.acceleration > 0) {
    TimeToMatchSpeed = (FMin(RotDv.X,0) / Ship.Acceleration);
    Dp += ((Dv * 0.5) * TimeToMatchSpeed * (1+(Vector(Ship.DesiredRotation) Dot Normal(Dv))));
  }

  XScore = 1;
//    DistanceFactor = FMax(25, sqrt(VSize(Dp)));

//    DistanceFactor = FMax(25, VSize(Dp) / Ship.Acceleration);
  if (ship.acceleration > 0) {
    DistanceFactor = FClamp(VSize(Dp) / (Ship.Acceleration), 5, 25);
  } else {
    DistanceFactor = 1;
  }

//    DistanceFactor = FMin(350, DistanceFactor);
//    DistanceFactor = sqrt(VSize(Dp)) + sqrt(VSize(X.getContactLocation()));
//    XScore /= sqrt(VSize(Dp)) + sqrt(VSize(X.getContactLocation()));
  XScore /= DistanceFactor;
  XScore *= 0.7 + (Vector(Ship.DesiredRotation) Dot Normal(Dp)) * 0.3;

//    XScore *= 1/(VSize(X.getContactLocation()));

  XScore *= 10000000;

  // Defending ships are more likely to attack ships close to the thing they are defending.
  if (Task_Defense(Current_Task) != None)
  {
    Dp = (Task_Defense(Current_Task).Target.getContactLocation() - X.getContactLocation());
    if (ship.acceleration > 0) {
      DistanceFactor = FClamp(VSize(Dp) / (Ship.Acceleration), 0.5, 2);
    } else {
      DistanceFactor = 1;
    }
    XScore += XScore * (((2/DistanceFactor)-1) * 100);
  }

  return XScore;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float Rate_Effectiveness_Against_Defense(Contact X)
{
  local vector Dp, Dv, RotDv;
  local float TimeToMatchSpeed;
  local float XScore;
  local float DistanceFactor;

  // Temporary - return 0 for self.
  if (X.getContactSourceLocation() == ship.getShipLocation())
    return 0;

  Dp = X.getContactLocation() - Ship.getShipLocation();

  if (Ship.Acceleration > 0)
  {
    // 20080311: I'm seeing an issue here. As the ship approaches the target, it takes longer to
    // match speed - it looks like it's getting away.. Maybe I should only be measuring approach speed.
//      Dv = X.getContactVelocity() - Ship.Velocity;
//      TimeToMatchSpeed = (VSize(Dv) / Ship.Acceleration);
//      Dp += ((Dv * 0.5) * TimeToMatchSpeed * (1+(Vector(Ship.DesiredRotation) Dot Normal(Dv))));

    Dv = X.getContactVelocity() - Ship.Velocity;
    RotDv = Dv UnCoordRot Rotator(Dp);
    TimeToMatchSpeed = (FMin(RotDv.X,0) / Ship.Acceleration);
    Dp += ((Dv * 0.5) * TimeToMatchSpeed * (1+(Vector(Ship.DesiredRotation) Dot Normal(Dv))));
  }

  XScore = 1;
  DistanceFactor = FMax(25, VSize(Dp) / Ship.Acceleration);
//    DistanceFactor = FMin(500, DistanceFactor);

//    DistanceFactor = sqrt(VSize(Dp)) + sqrt(VSize(X.getContactLocation()));
//    XScore /= sqrt(VSize(Dp)) + sqrt(VSize(X.getContactLocation()));
  XScore /= DistanceFactor;
  XScore *= 0.7 + (Vector(Ship.DesiredRotation) Dot Normal(Dp)) * 0.3;

//    XScore *= 1/(VSize(X.getContactLocation()));

  XScore *= 10000000;

  return XScore;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float Rate_Effectiveness_Against_Patrol(Contact X)
{
  local vector Dp, Dv, RotDv;
  local float TimeToMatchSpeed;
  local float XScore;
  local float DistanceFactor;

  if (Ship.Acceleration == 0)
    return 0;

  Dp = X.getContactLocation() - Ship.getShipLocation();


  // 20080311: I'm seeing an issue here. As the ship approaches the target, it takes longer to
  // match speed - it looks like it's getting away.. Maybe I should only be measuring approach speed.
//      Dv = X.getContactVelocity() - Ship.Velocity;
//      TimeToMatchSpeed = (VSize(Dv) / Ship.Acceleration);
//      Dp += ((Dv * 0.5) * TimeToMatchSpeed * (1+(Vector(Ship.DesiredRotation) Dot Normal(Dv))));

  Dv = X.getContactVelocity() - Ship.Velocity;
  RotDv = Dv UnCoordRot Rotator(Dp);
  TimeToMatchSpeed = (FMin(RotDv.X,0) / Ship.Acceleration);
  Dp += ((Dv * 0.5) * TimeToMatchSpeed * (1+(Vector(Ship.DesiredRotation) Dot Normal(Dv))));

  XScore = 1;
  DistanceFactor = FMax(25, VSize(Dp) / Ship.Acceleration);
//    DistanceFactor = sqrt(VSize(Dp)) + sqrt(VSize(X.getContactLocation()));
//    XScore /= sqrt(VSize(Dp)) + sqrt(VSize(X.getContactLocation()));
  XScore /= DistanceFactor;
  XScore *= 0.7 + (Vector(Ship.DesiredRotation) Dot Normal(Dp)) * 0.3;

//    XScore *= 1/(VSize(X.getContactLocation()));

  XScore *= 10000000;

  return XScore;
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function modifyPriorityForAssignment(PotentialTaskWorkerAssignment assigned, PotentialTaskWorkerAssignment other)
  {
    if (SpaceWorker_Weapon(assigned.worker) != None && SpaceWorker_Weapon(assigned.worker).Weapon.Ship == Ship)
    {
      if (other.task == assigned.task)
        other.assignmentPriority *= 1.1;
      else
        other.assignmentPriority *= 0.9;
        
      return;
    }
    
    super.modifyPriorityForAssignment(assigned, other);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float Evaluate_Cost_Against(SpaceTask Task)
  {
    // eg risk for attack tasks, missile expenditures, etc.
    return 0;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool Is_Relevant()
  {
    return (Ship != None && Ship.Pilot != None && !Ship.bCleanedUp);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Recieve_Assignment_To(SpaceTask task)
  {
    // Assign current task.
    Current_Task = Task;

    // Assign Manuever.
    Assign_Next_Manuever();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Assign_Next_Manuever()
  {
    local AIPilot Pilot;
    
    // Get Pilot.
    Pilot = AIPilot(Ship.Pilot);
    if (Pilot == None)
    {
      errorMessage("Assign_Next_Manuever: Ship does not have an AIPilot.");
      return;
    }
    
    Pilot.Weapons_Target = None;
    Pilot.InterceptTarget_Contact = None;
    Pilot.InterceptTarget_Ship = None;
    
    if (Task_Attack(Current_Task) != None)
    {
      Pilot.InterceptTarget_Contact = Task_Attack(Current_Task).Target;
      Pilot.Weapons_Target = Pilot.InterceptTarget_Contact;
      Pilot.AutoSelectAttackMode();
      return;
    }
    
    if (Task_Defense(Current_Task) != None)
    {
      Pilot.InterceptTarget_Contact = Task_Defense(Current_Task).Target;
      Pilot.AutoDefense();
      return;
    }

    if (Task_Patrol(Current_Task) != None)
    {
      Pilot.InterceptTarget_Contact = Task_Patrol(Current_Task).Target;
      Pilot.AutoPatrol();
      return;
    }

    if (Task_Idle(current_Task) != none) {
      pilot.autoWait();
      
      return;
    }
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Event called from ship or lower AI.
  simulated function Manuever_Completed()
  {
    Assign_Next_Manuever();
  }
  
  // Event called from ship or lower AI.
  simulated function Manuever_Cannot_Be_Completed()
  {
    Assign_Next_Manuever();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Cleanup()
  {
    Ship = None;
    Current_Task = None;
    
    Super.Cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}