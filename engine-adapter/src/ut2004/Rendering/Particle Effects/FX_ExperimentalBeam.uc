class FX_ExperimentalBeam extends ScalableBeamEmitter;

defaultproperties
{
	currentScale=1

	Begin Object Class=BeamEmitter Name=BeamEmitter0
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=False
		InitialParticlesPerSecond=10000.000000

		CoordinateSystem=PTCS_Relative

		BeamDistanceRange=(Min=512.000000,Max=512.000000)
		DetermineEndPointBy=PTEP_OffsetAsAbsolute
		UseRotationFrom=PTRS_Actor

		AlphaTest=False

		UseColorScale=True
		ColorScale(0)=(Color=(B=255,G=255,R=255))
		ColorScale(1)=(RelativeTime=0.800000,Color=(B=255,G=255,R=255))
		ColorScale(2)=(RelativeTime=1.000000)

		UseSizeScale=True
		UseRegularSizeScale=False
		SizeScale(0)=(RelativeSize=0.750000)
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.250000)
		StartSizeRange=(X=(Min=60.000000,Max=60.000000),Y=(Min=60.000000,Max=60.000000))

		LifetimeRange=(Min=0.150000,Max=0.150000)

		Texture=Texture'AW-2004Particles.Energy.Burnbeam'
	End Object
	Emitters(0)=BeamEmitter'BeamEmitter0'

	AutoDestroy=true
}