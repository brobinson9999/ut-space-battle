class ShockBeamExplosion extends ScalableEmitter;

defaultproperties
{
	currentScale=1

	// Flash
	Begin Object Class=SpriteEmitter Name=SpriteEmitter1
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000

		SpinParticles=True
		UniformSize=True

		FadeIn=True
		FadeInEndTime=0.025
		FadeOut=True
		FadeOutStartTime=0.025
		LifetimeRange=(Min=0.5,Max=0.5)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=650,Max=650))
    SizeScale(0)=(RelativeTime=0,RelativeSize=1)
    SizeScale(1)=(RelativeTime=1,RelativeSize=0)

		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.ShockComboFlash'
	End Object
	Emitters(0)=SpriteEmitter'SpriteEmitter1'

	// Sparkles
	Begin Object Class=SpriteEmitter Name=SpriteEmitter5
		MaxParticles=3
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000

		SpinParticles=True
		UniformSize=True

		FadeOut=True
		FadeOutStartTime=0
		LifetimeRange=(Min=1.5,Max=2.5)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=25,Max=25))
    SizeScale(0)=(RelativeTime=0,RelativeSize=1)
    SizeScale(1)=(RelativeTime=1,RelativeSize=0)

		StartLocationShape=PTLS_Sphere
		SphereRadiusRange=(Min=1.000000,Max=1.000000)

	  GetVelocityDirectionFrom=PTVD_AddRadial
    StartVelocityRadialRange=(Min=100.000000,Max=200.000000)


		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.shock_sparkle'
	End Object
	Emitters(1)=SpriteEmitter'SpriteEmitter5'
	
	AutoDestroy=true
}
