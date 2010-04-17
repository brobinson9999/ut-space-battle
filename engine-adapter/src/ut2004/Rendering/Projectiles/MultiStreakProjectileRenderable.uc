class MultiStreakProjectileRenderable extends DrunkenProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	var vector nextBeamStart;
  var class<BeamGraphic> beamClass;
  var array<BeamGraphic> beams;
	var Color beamColor;
	var float beamSpawnDistance;						// Minimum distance the projectile must travel to spawn a new beam.
  var float beamScale;
  
  var bool bDestructionTimeElapsed;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function initialize() {
    super.initialize();
    
		setNextBeamStart(projectile.startLocation);
		beamScale = sqrt(projectile.damage);
  }
  
  simulated function setNextBeamStart(vector newNextBeamStart) {
  	nextBeamStart = newNextBeamStart;
  }

	simulated function considerSpawningBeamSegment() {
		if (bDestructionTimeElapsed)
			return;
		
		if (vsize(nextBeamStart - location) > beamSpawnDistance) {
			spawnBeamSegment(nextBeamStart, location);
			setNextBeamStart(location);
		}
	}
	
	simulated function setWorldLocation(vector newWorldLocation) {
		super.setWorldLocation(newWorldLocation);
		
		considerSpawningBeamSegment();
	}

	simulated function BeamGraphic spawnBeamSegment(vector beamStart, vector beamEnd) {
		local BeamGraphic result;
		
		result = spawn(beamClass,,, beamStart, rotator(beamEnd - beamStart));
    result.setScale(beamScale);
		result.setBeamColor(beamColor);
		result.setBeamEndPoint(beamEnd);
		
		beams[beams.length] = result;
		
		return result;
	}
	
  simulated function impact() {
  	local ScalableEmitter hitEffect;

    hitEffect = spawn(class'ShockBeamExplosion',,,projectile.endLocation, rotator(projectile.endLocation - projectile.startLocation));
    if (hitEffect != none && projectile != none)
    	hitEffect.setScale(sqrt(projectile.damage));
    
    super.impact();
    
    destructionTimeElapsed();
  }

	simulated function destructionTimeElapsed() {
		bDestructionTimeElapsed = true;
	}
	
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function cleanupNullSegments() {
		local int i;
		
		for (i=beams.length-1;i>=0;i--)
			if (beams[i] == none)
				beams.remove(i,1);
	}
	
	simulated function tick(float delta) {
		super.tick(delta);
		
		cleanupNullSegments();
		if (bDestructionTimeElapsed && beams.length == 0)
			destroy();
	}
	
  simulated function destroyBeams() {
    local int i;

    for (i=beams.length-1;i>=0;i--)
    {
      if (beams[i] != none)
        beams[i].destroy();

      beams.remove(i, 1);
    }
  }
  
  simulated function destroyed() {
    destroyBeams();
    
    super.destroyed();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
	beamClass=class'FX_TrailBeam'
	beamColor=(R=128,G=128,B=255)
	beamSpawnDistance=10
}