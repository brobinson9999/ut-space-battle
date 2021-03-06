class DragProjectileRenderable extends DrunkenProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var class<Actor> dragClass;
  var array<Actor> dragees;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function createDragees();
  
  // Set drawtype and other rendering parameters.
  simulated function initializeProjectileRenderable()
  {
    local rotator newRotation;
    
    super.initializeProjectileRenderable();
    
    newRotation = rotator(projectile.endLocation - projectile.startLocation);
    newRotation.roll = rotation.roll;
    setRotation(newRotation);

    createDragees();
  }
  
  simulated function updateLocation() {
    local int i;
    
    super.updateLocation();
    
    for (i=dragees.length-1;i>=0;i--)
    {
      if (dragees[i] == none) {
        dragees.Remove(i, 1);
      } else {
        dragees[i].setLocation(location);
        dragees[i].setRotation(rotation);
      }
    }
  }
  
  simulated function destroyDragees()
  {
    local int i;

    for (i=dragees.length-1;i>=0;i--)
    {
      if (dragees[i] != none)
        dragees[i].destroy();

      dragees.remove(i, 1);
    }
  }
  
  simulated function destroyed()
  {
    destroyDragees();
    
    super.destroyed();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}
