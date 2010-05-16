class PartShipObserver extends ShipObserver;

simulated function notifyPartDamaged(Part part);
simulated function notifyPartRepaired(Part part);
simulated function notifyPartFiredWeapon(Part part, WeaponProjectile projectile);

defaultproperties
{
}