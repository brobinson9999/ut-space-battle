class HeavyShockProjectileDragee extends UTProj_PaladinEnergyBolt;

simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal ) {}
simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp) {}
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal) {}
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated, optional float CullDistance) { return true; }
simulated function Explode(vector HitLocation, vector HitNormal) {}
simulated function RenderableExplode(vector HitLocation, vector HitNormal) { Super.Explode(HitLocation, HitNormal); }

DefaultProperties
{
  bCollideActors = false
  bCollideWorld = false
  bProjTarget = false
}
