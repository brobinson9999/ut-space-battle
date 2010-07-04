//-----------------------------------------------------------
//
//-----------------------------------------------------------
class mONSMASCannonBeamEffect extends Emitter;

var bool bCancel;

replication
{
  reliable if (bNetDirty && Role == ROLE_Authority)
    bCancel;
}

simulated function Cancel()
{
  bCancel = True;
  bTearOff = True;
  SpriteEmitter(Emitters[2]).FadeOut = True;
  SpriteEmitter(Emitters[2]).LifeTimeRange.Min = 0.5;
  SpriteEmitter(Emitters[2]).LifeTimeRange.Max = 0.5;
  SpriteEmitter(Emitters[2]).SizeScale[0].RelativeTime = 3.0;
  SpriteEmitter(Emitters[2]).SizeScale[0].RelativeSize = 0.0;
  Kill();
}

function PostNetRecieve()
{
    if (bCancel)
        Cancel();
}

DefaultProperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        CoordinateSystem=PTCS_Relative

        RespawnDeadParticles=True
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        FadeOutStartTime=0.070000
        FadeInEndTime=0.025000
        MaxParticles=80
        StartSpinRange=(X=(Min=0.750000,Max=5.000000))
        StartSizeRange=(X=(Min=65.000000,Max=65.000000))
        InitialParticlesPerSecond=80.000000
        Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
        LifetimeRange=(Min=0.020000,Max=0.020000)
//        InitialDelayRange=(Min=1.300000,Max=1.300000)
        Name="SpriteEmitter3"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter3'
    Begin Object Class=BeamEmitter Name=BeamEmitter2
        CoordinateSystem=PTCS_Relative

        AutomaticInitialSpawning=False
        InitialParticlesPerSecond=50.000000
        ParticlesPerSecond=50.000000
        RespawnDeadParticles=True
        MaxParticles=2

        BeamDistanceRange=(Min=10000.000000,Max=10000.000000)
        DetermineEndPointBy=PTEP_Distance

        FadeOut=True
        FadeOutStartTime=0.500000

        AlphaTest=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=15.000000,Max=15.000000))
        Texture=Texture'VMParticleTextures.LeviathanParticleEffects.LEVmainPartBeam'
        LifetimeRange=(Min=10.000000,Max=10.000000)
//        StartLocationOffset=(X=100.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=-100.000000))
        Name="BeamEmitter2"
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter2'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        CoordinateSystem=PTCS_Relative

        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        FadeOutStartTime=0.5
        MaxParticles=1
        SizeScale(0)=(RelativeTime=3.000000,RelativeSize=4.000000)
        InitialParticlesPerSecond=200.000000
        Texture=Texture'VMParticleTextures.LeviathanParticleEffects.LeviathanMGUNFlare'
        LifetimeRange=(Min=1.00000,Max=1.00000)
        Name="SpriteEmitter4"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter4'
    AutoDestroy=False
    bNoDelete=False
    LightHue=180
    LightSaturation=255
    LightBrightness=255
    bNetNotify=True
}
