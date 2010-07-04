class AttachingFlyingDog extends FlyingDog placeable;

var array<actor> attachedActors;
var array<vector> attachedOffsets;

simulated function addTurret(string turretName, vector offset) {
  local Actor turret;
  local class<Actor> turretClass;

  turretClass = class<Actor>(dynamicLoadObject(turretName, class'Class'));
  turret = spawn(turretClass,self,,location + (offset >> rotation), rotation);
  
  ASTurret(turret).turretBase.destroy();
  ASTurret(turret).turretSwivel.destroy();
  
  turret.setCollision(true, false, false);
  attachActor(turret, offset);
}

simulated function attachActor(actor newActor, vector newOffset) {
  attachedActors[attachedActors.length] = newActor;
  attachedOffsets[attachedOffsets.length] = newOffset;
}

simulated function tick(float delta) {
  local int i;
  local vector newLocation;
  
  super.tick(delta);
  
  for (i=attachedActors.length-1;i>=0;i--) {
    if (attachedActors[i] == none) {
      attachedActors.remove(i,1);
      attachedOffsets.remove(i,1);
    } else {
      newLocation = location + (attachedOffsets[i] >> rotation);
      if (attachedActors[i].location != newLocation)
        attachedActors[i].setLocation(newLocation);
    }
  }
}

function KDriverEnter(Pawn p) {
  local int i;

  super.KDriverEnter(p);
  
  for (i=attachedActors.length-1;i>=0;i--) {
    if (Pawn(attachedActors[i]) != none && p != none)
      Pawn(attachedActors[i]).instigator = p;
//      Pawn(attachedActors[i]).team = p.getTeamNum();
  }  
}

// temporary hack to prevent turrets from damaging me.
function takeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType) {
  local int i;
  
  for (i=0;i<attachedActors.length;i++)
    if (attachedActors[i] == instigatedBy)
      return;
      
  super.takeDamage(damage, instigatedBy, hitLocation, momentum, damageType);
}

defaultproperties
{
}
