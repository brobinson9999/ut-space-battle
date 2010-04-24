class SpaceWorker_Weapon extends DefaultSpaceWorker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var ShipWeapon    weapon;

var Task_Attack   currentTask;

var float         performanceFactor;
var ThrottledPeriodicAlarm      selfUpdateAlarm;

var float         triggerHappy_Accuracy;

// Don't fire the next time this weapon considers firing.
// This is set when a human player is trying to fire so that the AI doesn't pre-empt what the player is trying to do.
var bool          bSkipNextAutoFire;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initialize()
{
//  setupNextUpdateEvent();
  getSelfUpdateAlarm().setPeriod(0.25);
  super.initialize();
}

//simulated function setupNextUpdateEvent()
//{
//  local float timeToReload;
//
//  if (!weapon.readyToFire()) {
//    timeToReload = weapon.nextFireTime() - getCurrentTime();
//
//    if (timeToReload > 0) {
//      setTimer(timeToReload);
//      return;
//    }
//  }
//
//  setTimer(getPerformanceThrottleFactor() * performanceFactor);
//}

simulated function ThrottledPeriodicAlarm getSelfUpdateAlarm() {
  if (selfUpdateAlarm == none) {
    selfUpdateAlarm = ThrottledPeriodicAlarm(allocateObject(class'ThrottledPeriodicAlarm'));
    selfUpdateAlarm.throttleMultiplier = performanceFactor;
//    selfUpdateAlarm.minimumPeriod = performanceFactorMinUpdateTime;
    selfUpdateAlarm.callBack = updateWorker;
  }
  
  return selfUpdateAlarm;
}

simulated function updateTimerElapsed()
{
  local float timeToReload;

//  timerEvent = None;

  updateWorker();

  if (weapon == none || weapon.ship == none || weapon.ship.bCleanedUp)
    getSelfUpdateAlarm().setPeriod(0);
  else if (!weapon.readyToFire()) {
    // If not ready to fire, set next update for the instant that we are ready to fire again.
    timeToReload = weapon.nextFireTime() - getCurrentTime();
    if (timeToReload > 0)
      getSelfUpdateAlarm().setTimer(timeToReload);
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Only accept tasks that this worker can perform.
  simulated function addTask(SpaceTask task)
  {
    if (Task_Attack(task) == none && Task_Idle(task) == none)
      return;
      
    super.addTask(task);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function updateWorker()
  {
    // This is set when a human player is trying to fire so that the AI doesn't pre-empt what the player is trying to do.
    if (bSkipNextAutoFire) {
      bSkipNextAutoFire = false;
      return;
    }
    
    if (currentTask == None || currentTask.Target == None) return;

    if (currentTask.target.getSensorSignature() == 0) {
      autoSelectBestTask();
      updateWorker();
      return;
    }

    if (weapon == None) return;
    if (!weapon.readyToFire()) return;

    considerFiring(currentTask.target);
  }

  // This is set when a human player is trying to fire so that the AI doesn't pre-empt what the player is trying to do.
  simulated function skipNextAutoFire() {
    bSkipNextAutoFire = true;
  }
  
  simulated function considerFiring(Contact Target)
  {
    local float TriggerHappy_Local;
    local WeaponTechnology WeaponTech;
    
    WeaponTech = Weapon.localTechnology;
    if (WeaponTech.BurstSize <= 1)
      TriggerHappy_Local = WeaponTech.RefireTime;
    else
    {
      TriggerHappy_Local = (WeaponTech.RefireTime + (WeaponTech.BurstRefireTime * WeaponTech.BurstSize)) / WeaponTech.BurstSize;
    }

    TriggerHappy_Local = (1-(0.15 / TriggerHappy_Local));

    TriggerHappy_Local *= TriggerHappy_Accuracy;
    
    TriggerHappy_Local = FMax(TriggerHappy_Local, 0.05);
    
    if (Weapon.Estimated_Accuracy_Against(Target, -1) > TriggerHappy_Local)
      Weapon.TryFire(Target);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float Evaluate_Effectiveness_Against(SpaceTask task)
  {
    local float targetCondition;
    local float dps;
    local float result;
    
    if (Task_Idle(task) != none) {
      return 1;
    }

    if (Task_Attack(task) == none || weapon == none || !weapon.bOnline)
      return 0; 
    
    targetCondition = getContactCondition(Task_Attack(task).target);
    if (targetCondition == 0)
      return 0;
      
    // When defending, the ship can rotate to fire more flexibly..
    // Could be improved.
    if (isShipDefending() && weapon.maxFireArc < 32768)
      dps = estimateDamagePerSecondForTask(task, 1);
    else
      dps = estimateDamagePerSecondForTask(task, -1);

    if (dps == 0)
      return 0;
      
    // reciprocal of time to destroy
    result = dps / targetCondition;

    result *= getPersistenceFactorForTask(task);
    result *= getAssignmentFactorForTask(task);
    
    result *= 10000;
    
    return result;
  }
  
  simulated function float getContactCondition(Contact other) {
    local int targetConditionCurrent;
    local int targetConditionMax;
    
    if (other == none)
      return 0;
      
    other.estimateTargetCondition(targetConditionCurrent, targetConditionMax);

    // smarter AIs should use the current condition of the ship to identify weakened targets. dumber AIs just go off the targets total health.
    if (weapon.ship.getShipOwner().AISkillLevel > 0.4)
      return float(targetConditionCurrent);
    else
      return float(targetConditionMax);
  }
  
  simulated function float estimateDamagePerSecondForTask(SpaceTask task, float minFixedCos) {
    local float result;

    result = 1;
    result *= weapon.estimated_Accuracy_Against(Task_Attack(task).target, minFixedCos);
    result *= weapon.damagePerSecond();
    result /= Task_Attack(task).target.estimateTargetVulnerability();
    
    return result;
  }
  
  simulated function float getPersistenceFactorForTask(SpaceTask task) {
    if (task == currentTask)
      return persistenceModifierBase;
    else
      return 1;
  }

  simulated function bool isShipDefending() {
    return (Task_Defense(weapon.ship.getShipWorker().current_task) != none);
  }
  
  simulated function float getAssignmentFactorForTask(SpaceTask task) {
    local float result;
    
    // Give a slight increase to likelyhood that they will attack the ship's weapon target.
    if (Task_Attack(task).Target == weapon.ship.getShipWorker().mainWeaponsTarget)
      result = 1.05;
    else
      result = 1;
      
    // Check for manual assignment.
    if (Assigned_Task_Type == task.class && Task_Attack(task).Target == Assigned_Task_Target)
      result *= Assigned_Task_Bias_Weight;

    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // eg risk for attack tasks, missile expenditures, etc.
  // for weapons I guess this is the cost of disarming itself temporarily by firing. eg, the opportunity cost of firing.
  simulated function float Evaluate_Cost_Against(SpaceTask Task) {
    return 0;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool Is_Relevant() {
    return (weapon != none && weapon.ship != none && !weapon.ship.bCleanedUp);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Recieve_Assignment_To(SpaceTask task) {
    currentTask = Task_Attack(task);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function modifyPriorityForAssignment(PotentialTaskWorkerAssignment assigned, PotentialTaskWorkerAssignment other)
  {
    if (SpaceWorker_Ship(assigned.worker) != none && SpaceWorker_Ship(assigned.worker).Ship == Weapon.Ship)
    {
      if (other.task == assigned.task)
        other.assignmentPriority *= 1.1;
      else
        other.assignmentPriority *= 0.9;

      return;
    }
    
    if (SpaceWorker_Weapon(assigned.worker) != none && SpaceWorker_Weapon(assigned.worker).weapon.ship == weapon.ship)
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

  simulated function autoSelectBestTask() {
    local SpaceTask bestTask;
    
    bestTask = getBestTask();
    
    Recieve_Assignment_To(bestTask);
  }
  
  simulated function SpaceTask getBestTask() {
    local int i;
    local float bestPriority;
    local PotentialTaskWorkerAssignment bestAssignment;
    local PotentialTaskWorkerAssignment thisAssignment;

    for (i=0;i<assignments.length;i++)
      evaluatePotentialAssignment(assignments[i]);
      
    for (i=0;i<assignments.length;i++) {
      thisAssignment = assignments[i];
      if (thisAssignment.task.is_Relevant() && thisAssignment.unmodifiedAssignmentPriority > 0 && (thisAssignment.unmodifiedAssignmentPriority > bestPriority || bestAssignment == None)) {
        bestAssignment = thisAssignment;
        bestPriority = bestAssignment.unmodifiedAssignmentPriority;
      }
    }
    
    if (bestAssignment == none)
      return none;
    else
      return bestAssignment.task;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Cleanup()
  {
    Weapon = None;
    currentTask = None;

    if (selfUpdateAlarm != none) {
      selfUpdateAlarm.cleanup();
      selfUpdateAlarm = none;
    }
    
    Super.Cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  PerformanceFactor=1
  TriggerHappy_Accuracy=0.15
}