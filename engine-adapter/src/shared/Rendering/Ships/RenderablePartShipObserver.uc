class RenderablePartShipObserver extends PartShipObserver;

var Ship observed;
var PartShipRenderable observingFor;

simulated function initializeShipObserver(Ship newObserved, PartShipRenderable observeFor)
{
  observed = newObserved;
  observingFor = observeFor;

  observed.addShipObserver(self);
}

simulated function cleanup()
{
  if (observed != none)
    observed.removeShipObserver(self);

  observed = none;
  observingFor = none;

  super.cleanup();
}

simulated function notifyShipCritical()                                           { observingFor.notifyShipCritical();                    }
simulated function notifyShipDestroyed()                                          { observingFor.notifyShipDestroyed();                   }
simulated function notifyPartDamaged(Part part)                                   { observingFor.notifyPartDamaged(part);                 }
simulated function notifyPartRepaired(Part part)                                  { observingFor.notifyPartRepaired(part);                }
simulated function notifyPartFiredWeapon(Part part, WeaponProjectile projectile)  { observingFor.notifyPartFiredWeapon(part, projectile); }

defaultproperties
{
}