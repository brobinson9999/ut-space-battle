class CompositeSpaceWorker extends DefaultSpaceWorker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	var array<SpaceWorker> workers;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function addWorker(SpaceWorker other)
	{
		workers[workers.length] = other;
	}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function removeWorker(SpaceWorker other)
	{
		local int i;

		for (i=0;i<workers.length;i++)
			if (workers[i] == other)
			{
				workers.remove(i,1);
				break;
			}
	}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function addTask(SpaceTask task)
	{
		super.addTask(task);
		
		addTaskToChildren(task);
	}
	
	simulated function addTaskToChildren(SpaceTask task)
	{
		local int i;
		
		for (i=0;i<workers.length;i++)
			workers[i].addTask(task);
	}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function removeTask(SpaceTask task)
	{
		super.removeTask(task);

		removeTaskFromChildren(task);
	}

	simulated function removeTaskFromChildren(SpaceTask task)
	{
		local int i;
		
		for (i=0;i<workers.length;i++)
			workers[i].removeTask(task);
	}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function removeExpiredTasks()
  {
    local int i;

		super.removeExpiredTasks();

    for (i=workers.length-1;i>=0;i--)
			workers[i].removeExpiredTasks();     
	}

	simulated function removeExpiredWorkers()
  {
    local int i;
    
    for (i=workers.length-1;i>=0;i--)
			workers[i].removeExpiredWorkers();     

    for (i=workers.length-1;i>=0;i--)
      if (!workers[i].is_Relevant())
      	removeWorker(workers[i]);
			
		super.removeExpiredWorkers();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function cleanup()
	{
		while (workers.length > 0)
			removeWorker(workers[0]);
			
		super.cleanup();
	}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}