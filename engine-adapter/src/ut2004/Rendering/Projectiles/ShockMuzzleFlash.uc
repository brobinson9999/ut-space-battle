class ShockMuzzleFlash extends ScalableEmitter;

defaultproperties
{
	currentScale=1

	Begin Object Class=SpriteEmitter Name=SpriteEmitter1
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000
		CoordinateSystem=PTCS_Relative

		UniformSize=True

		FadeOut=True
		FadeOutStartTime=0
		LifetimeRange=(Min=0.25,Max=0.25)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=65,Max=65))
    SizeScale(0)=(RelativeTime=0,RelativeSize=0)
    SizeScale(1)=(RelativeTime=0.25,RelativeSize=1)
    SizeScale(2)=(RelativeTime=1,RelativeSize=0)

		DrawStyle=PTDS_Brighten
		Texture=Texture'XEffectMat.shock_sparkle'
	End Object
	Emitters(0)=SpriteEmitter'SpriteEmitter1'
	
	AutoDestroy=true
}
