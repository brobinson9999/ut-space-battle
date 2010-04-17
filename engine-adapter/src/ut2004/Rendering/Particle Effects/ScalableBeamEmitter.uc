class ScalableBeamEmitter extends BeamGraphic;

simulated function setBeamEndPoint(vector endPoint)
{
  local BeamEmitter.ParticleBeamEndPoint End;
  local int i;
  local float Dist;
	local vector offsetVector;

  dist = VSize(endPoint - location);
	offsetVector.x = dist;
	
  end.offset.x.min = offsetVector.x;
  end.offset.x.max = offsetVector.x;
  end.offset.y.min = offsetVector.y;
  end.offset.y.max = offsetVector.y;
  end.offset.z.min = offsetVector.z;
  end.offset.z.max = offsetVector.z;

  for (i=0;i<emitters.length;i++)
  	if (BeamEmitter(emitters[i]) != none) {
			BeamEmitter(emitters[i]).beamDistanceRange.min = dist;
			BeamEmitter(emitters[i]).beamDistanceRange.max = dist;
			BeamEmitter(emitters[i]).beamEndPoints[0] = end;
		}
}

simulated function setBeamColor(Color beamColor) {
  local int i,j;

  for (i=0;i<emitters.length;i++)
  	if (BeamEmitter(emitters[i]) != none) {
			for (j=0;j<emitters[i].colorScale.length;j++) {
				BeamEmitter(emitters[i]).colorScale[j].color = multiplyColors(BeamEmitter(emitters[i]).colorScale[j].color, beamColor);
			}
		}
}

simulated function Color multiplyColors(Color inputA, Color inputB) {
	local Color result;
	
	result.r = multiplyColorElement(inputA.r, inputB.r);
	result.g = multiplyColorElement(inputA.g, inputB.g);
	result.b = multiplyColorElement(inputA.b, inputB.b);
	result.a = multiplyColorElement(inputA.a, inputB.a);

	return result;
}

simulated function float multiplyColorElement(float inputA, float inputB) {
	return (inputA / 255) * (inputB / 255) * 255;
}

defaultproperties
{
}