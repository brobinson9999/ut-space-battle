class SquadFormingCommandingWorkerDecorator extends CommandingWorkerDecorator;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Periodically considers existing squad workers and forms other workers into new squads.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var int minSquadSize;
  var int maxSquadSize;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function updateSelf()
  {
    updateSquads();

    super.updateSelf();
  }
  
  simulated function updateSquads()
  {
    cleanupSquads();
    formSquads();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanupSquads()
  {
    local int i;
    local SpaceWorker_Squad squad;

    for (i=0;i<workers.length;i++)
    {
      squad = SpaceWorker_Squad(workers[i]);
      if (squad != None)
        cleanupSquad(squad);
    }
  }
  
  simulated function cleanupSquad(SpaceWorker_Squad squad)
  {
    squad.cleanupWorkers();
    if (squad.getMemberCount() < minSquadSize)
      disbandSquad(squad);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function formSquads()
  {
    local int i;
    local array<SpaceWorker> squadWorkers;
    
    // Attempt to form workers into squads if there are enough of them.
    for (i=workers.length-1;i>=0;i--)
    {
      // Accumulate suitable workers.
      if (isWorkerSuitableForSquad(workers[i]))
        squadWorkers[squadWorkers.Length] = SpaceWorker_Ship(workers[i]);
        
      // If we have accumulated the maximum squad size, form a new squad from the accumulated workers and clear the accumulation array.
      if (squadWorkers.length >= maxSquadSize)
      {
        createNewSquadFromWorkers(squadWorkers);
        squadWorkers.remove(0, squadWorkers.length);
      }
    }
    
    // If we have more than the minimum number of workers, form a squad with the remainder.
    if (squadWorkers.length >= minSquadSize)
      createNewSquadFromWorkers(squadWorkers);
  }

  simulated function bool isWorkerSuitableForSquad(SpaceWorker candidate)
  {
    return (SpaceWorker_Ship(candidate) != None && SpaceWorker_Ship(candidate).attack_Preference > 0);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function createNewSquadFromWorkers(array<SpaceWorker> squadWorkers)
  {
    local int i;
    local SpaceWorker_Squad newSquad;

    // Create and initialize the new squad.
    newSquad = createNewSquad();

    // Add the workers in the accumulation array into the new squad, and remove them from my own list.
    for (i=0;i<squadWorkers.Length;i++)
      transferWorkerToSquad(squadWorkers[i], newSquad);

    // Add the new squad as a worker.
    addWorker(newSquad);
  }

  simulated function SpaceWorker_Squad createNewSquad()
  {
    local SpaceWorker_Squad newSquad;

    // Create and initialize the new squad.
    newSquad = SpaceWorker_Squad(allocateObject(class'SpaceWorker_Squad'));
    newSquad.initialize();

    // Seed it with the current tasks.
    copyTasks(newSquad);
    
    return newSquad;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function disbandSquad(SpaceWorker_Squad squad)
  {
    local int i;
    local array<SpaceWorker> squadWorkers;
    
    squadWorkers = squad.getMemberList();
    for (i=0;i<squadWorkers.length;i++)
      transferWorkerFromSquad(squadWorkers[i], squad);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function transferWorkerToSquad(SpaceWorker worker, SpaceWorker_Squad squad)
  {
    removeWorker(worker);
    squad.addWorker(worker);
  }
  
  simulated function transferWorkerFromSquad(SpaceWorker worker, SpaceWorker_Squad squad)
  {
    squad.removeWorker(worker);
    addWorker(worker);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  minSquadSize=2
  maxSquadSize=4

  performanceFactor=2.5
  performanceFactorMinUpdateTime=2
}