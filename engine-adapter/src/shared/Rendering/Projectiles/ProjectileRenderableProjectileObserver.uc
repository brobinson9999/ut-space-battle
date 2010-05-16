class ProjectileRenderableProjectileObserver extends ProjectileObserver;

var WeaponProjectile observed;
var ProjectileRenderable observingFor;

simulated function initialize(WeaponProjectile newObserved, ProjectileRenderable observeFor)
{
  observed = newObserved;
  observingFor = observeFor;

  observed.addProjectileObserver(self);
}

simulated function cleanup()
{
  if (observed != none) {
    observed.removeProjectileObserver(self);
    observed = none;
  }
  
  if (observingFor != none) {
    observingFor = none;
    // observingFor has a private reference to this object which it must remove itself.
  }

  super.cleanup();
}

simulated function notifyCameraLeftSector()     { observingFor.notifyCameraLeftSector();    }
simulated function notifyProjectileMissed()     { observingFor.missed();                    }
simulated function notifyProjectileImpacted()   { observingFor.impact();                    }

defaultproperties
{
}