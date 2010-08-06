class FX_CyanBeam extends ScalableEmitter;

simulated function SetupBeam(vector hitLocation)
{
  local BeamEmitter.ParticleBeamEndPoint End;
  local int x;
  local float Dist;
	local vector offsetVector;

  SpawnEffects(HitLocation, Normal(HitLocation - Location));

  dist = VSize(HitLocation - Location);
	offsetVector.x = dist;
	
  end.offset.x.min = offsetVector.x;
  end.offset.x.max = offsetVector.x;
  end.offset.y.min = offsetVector.y;
  end.offset.y.max = offsetVector.y;
  end.offset.z.min = offsetVector.z;
  end.offset.z.max = offsetVector.z;

  for (x = 0; x < Emitters.Length; x++)
  {
    BeamEmitter(Emitters[x]).BeamDistanceRange.Min = Dist;
    BeamEmitter(Emitters[x]).BeamDistanceRange.Max = Dist;
    BeamEmitter(Emitters[x]).BeamEndPoints[0] = End;
  }
}

simulated function SpawnEffects(vector HitLocation, vector HitNormal)
{
  local rotator HitRotation;

  HitRotation = rotator(HitNormal);

  Spawn(class'ShockImpactFlareB',,, HitLocation, HitRotation);
  Spawn(class'ShockImpactRingB',,, HitLocation, HitRotation);
  Spawn(class'ShockImpactScorch',,, HitLocation, rotator(-HitNormal));
  Spawn(class'ShockExplosionCoreB',,, HitLocation+HitNormal*8, HitRotation);
}

defaultproperties
{
	currentScale=1

	Begin Object Class=BeamEmitter Name=BeamEmitter0
		CoordinateSystem=PTCS_Relative

		BeamDistanceRange=(Min=512.000000,Max=512.000000)
		DetermineEndPointBy=PTEP_OffsetAsAbsolute
		RotatingSheets=3
		LowFrequencyPoints=2
		HighFrequencyPoints=2
		BranchProbability=(Max=1.000000)
		BranchSpawnAmountRange=(Max=2.000000)
		UseColorScale=True
		RespawnDeadParticles=False
		AlphaTest=False
		UseSizeScale=True
		UseRegularSizeScale=False
		AutomaticInitialSpawning=False
		ColorScale(0)=(Color=(B=192,G=192,R=192))
		ColorScale(1)=(RelativeTime=0.800000,Color=(B=128,G=255,R=128))
		ColorScale(2)=(RelativeTime=1.000000)
		MaxParticles=1
		UseRotationFrom=PTRS_Actor
		SizeScale(0)=(RelativeSize=0.750000)
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.250000)
		StartSizeRange=(X=(Min=60.000000,Max=60.000000),Y=(Min=60.000000,Max=60.000000))
		InitialParticlesPerSecond=5000.000000
		Texture=AW-2004Particles.Energy.BeamBolt1a
		LifetimeRange=(Min=0.150000,Max=0.150000)
		Name="BeamEmitter0"
	End Object
	Emitters(0)=BeamEmitter'BeamEmitter0'

	Begin Object Class=BeamEmitter Name=BeamEmitter1
		CoordinateSystem=PTCS_Relative

		BeamDistanceRange=(Min=512.000000,Max=512.000000)
		DetermineEndPointBy=PTEP_OffsetAsAbsolute
		RotatingSheets=3
		LowFrequencyPoints=2
		HighFrequencyPoints=2
		BranchProbability=(Max=1.000000)
		BranchSpawnAmountRange=(Max=2.000000)
		UseColorScale=True
		RespawnDeadParticles=False
		AlphaTest=False
		UseSizeScale=True
		UseRegularSizeScale=False
		AutomaticInitialSpawning=False
		ColorScale(0)=(Color=(B=64,G=64,R=64))
		ColorScale(1)=(RelativeTime=0.800000,Color=(B=192,G=192,R=128))
		ColorScale(2)=(RelativeTime=1.000000)
		Opacity=0.400000
		MaxParticles=1
		UseRotationFrom=PTRS_Actor
		SizeScale(0)=(RelativeSize=1.000000)
		SizeScale(1)=(RelativeTime=1.000000)
		StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=60.000000,Max=60.000000))
		InitialParticlesPerSecond=5000.000000
		Texture=EpicParticles.Flares.SoftFlare
		LifetimeRange=(Min=0.200000,Max=0.200000)
		Name="BeamEmitter1"
	End Object
	Emitters(1)=BeamEmitter'BeamEmitter1'

	AutoDestroy=true
	bNoDelete=false
	RemoteRole=ROLE_SimulatedProxy
	bNetInitialRotation=true
	bNetTemporary=true
}