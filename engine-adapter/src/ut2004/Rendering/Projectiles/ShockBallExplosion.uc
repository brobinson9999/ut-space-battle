class ShockBallExplosion extends ScalableEmitter;

defaultproperties
{
	currentScale=250

	// Flash
	Begin Object Class=SpriteEmitter Name=SpriteEmitter1
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000

		SpinParticles=True
		UniformSize=True

		FadeOut=True
		FadeOutStartTime=0
		LifetimeRange=(Min=0.5,Max=0.5)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=650,Max=650))
    SizeScale(0)=(RelativeTime=0,RelativeSize=0)
    SizeScale(1)=(RelativeTime=1,RelativeSize=1)

		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.ShockComboFlash'
	End Object
	Emitters(0)=SpriteEmitter'SpriteEmitter1'

	// Ring
	Begin Object Class=SpriteEmitter Name=SpriteEmitter2
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000

		SpinParticles=True
		UniformSize=True

		FadeOut=True
		FadeOutStartTime=0
		LifetimeRange=(Min=0.1,Max=0.1)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=650,Max=650))
    SizeScale(0)=(RelativeTime=0,RelativeSize=0)
    SizeScale(1)=(RelativeTime=1,RelativeSize=1)

		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.shock_ring_a'
	End Object
	Emitters(1)=SpriteEmitter'SpriteEmitter2'

	// Core
	Begin Object Class=SpriteEmitter Name=SpriteEmitter3
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000

		SpinParticles=True
		UniformSize=True

		FadeOut=True
		FadeOutStartTime=0
		LifetimeRange=(Min=0.5,Max=0.5)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=150,Max=150))
    SizeScale(0)=(RelativeTime=0,RelativeSize=0)
    SizeScale(1)=(RelativeTime=1,RelativeSize=1)

		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.shock_core'
	End Object
	Emitters(2)=SpriteEmitter'SpriteEmitter3'

	// Flare
	Begin Object Class=SpriteEmitter Name=SpriteEmitter4
		MaxParticles=1
		RespawnDeadParticles=False
		AutomaticInitialSpawning=false
		InitialParticlesPerSecond=100000.000000

		SpinParticles=True
		UniformSize=True

		FadeOut=True
		FadeOutStartTime=0
		LifetimeRange=(Min=0.1,Max=0.1)

    UseSizeScale=True
    UseRegularSizeScale=False
		StartSizeRange=(X=(Min=650,Max=650))
    SizeScale(0)=(RelativeTime=0,RelativeSize=0)
    SizeScale(1)=(RelativeTime=1,RelativeSize=1)

		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.shock_flare_a'
	End Object
	Emitters(3)=SpriteEmitter'SpriteEmitter4'
	

	// Sparkles (Disabled for now)
	Begin Object Class=SpriteEmitter Name=SpriteEmitter5
		MaxParticles=25
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
		StartSizeRange=(X=(Min=65,Max=65))
    SizeScale(0)=(RelativeTime=0,RelativeSize=1)
    SizeScale(1)=(RelativeTime=1,RelativeSize=0)

		StartLocationShape=PTLS_Sphere
		SphereRadiusRange=(Min=1.000000,Max=1.000000)

	  GetVelocityDirectionFrom=PTVD_AddRadial
    StartVelocityRadialRange=(Min=100.000000,Max=400.000000)


		DrawStyle=PTDS_Translucent
		Texture=Texture'XEffectMat.shock_sparkle'
	End Object
//	Emitters(4)=SpriteEmitter'SpriteEmitter5'
	
	AutoDestroy=true
}
