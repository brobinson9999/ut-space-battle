class FX_FireballExplosion extends ScalableEmitter;

simulated function PostBeginPlay()
{
	local PlayerController PC;

	PC = Level.GetLocalPlayerController();
	if ( PC == None )
	{
		Destroy();
		return;
	}
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 8000) )
	{
		Emitters[0].Disabled = true;
		Emitters[3].Disabled = true;
		Emitters[4].Disabled = true;
	}
}

DefaultProperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        ColorScale(1)=(RelativeTime=0.185714,Color=(B=56,G=56,R=56,A=255))
        ColorScale(2)=(RelativeTime=0.639286,Color=(B=77,G=77,R=77,A=255))
        ColorScale(3)=(RelativeTime=0.875000,Color=(B=53,G=53,R=53,A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(A=255))
        ColorScale(5)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(6)=(RelativeTime=1.000000)
        FadeOutStartTime=0.930000
        FadeInEndTime=0.200000
        MaxParticles=10
        Name="Smoke"
        StartLocationOffset=(Z=200.000000)
        StartLocationRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=3.000000,Max=200.000000))
        SphereRadiusRange=(Min=180.000000,Max=180.000000)
        SpinsPerSecondRange=(X=(Min=-0.020000,Max=0.020000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Max=300.000000),Y=(Max=300.000000),Z=(Max=300.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ONSBPTextures.fX.ExploTrans'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=1.000000)
        InitialDelayRange=(Max=0.064000)
		DetailMode=DM_High
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=300.000000,Max=500.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseDirectionAs=PTDU_Normal
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.480000
        FadeOutStartTime=1.513600
        MaxParticles=4
        Name="ground"
        StartLocationRange=(Z=(Min=0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.010000)
        SizeScale(1)=(RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=0.250000,RelativeSize=3.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=115.559998,Max=115.559998),Y=(Min=115.559998,Max=115.559998),Z=(Min=115.559998,Max=115.559998))
        InitialParticlesPerSecond=300.000000
        Texture=Texture'ONSBPTextures.fX.ExploTrans'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.700000,Max=0.700000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter55
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(Color=(B=155,G=180,R=205,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=155,G=180,R=205,A=255))
        FadeOutStartTime=1.000000
        FadeInEndTime=0.100000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        Name="SpriteEmitter55"
        StartLocationRange=(Z=(Min=-32.000000,Max=128.000000))
        AlphaRef=4
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=12.000000)
        StartSizeRange=(X=(Min=30.000000,Max=60.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BenTex01.textures.SmokePuff01'
        LifetimeRange=(Min=1.500000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=50.000000,Max=1400.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        RotateVelocityLossRange=True
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter55'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.907143,Color=(B=225,G=225,R=225,A=160))
        ColorScale(2)=(RelativeTime=1.000000)
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(4)=(RelativeTime=1.000000)
        FadeOutStartTime=0.686190
        MaxParticles=10
        Name="ExploNew"
        StartLocationOffset=(Z=200.000000)
        StartLocationRange=(X=(Min=-80.000000,Max=80.000000),Y=(Min=-80.000000,Max=80.000000),Z=(Min=-100.000000,Max=300.000000))
        SphereRadiusRange=(Min=180.000000,Max=180.000000)
        SpinsPerSecondRange=(X=(Min=-0.020000,Max=0.020000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(1)=(RelativeTime=0.070000,RelativeSize=0.650000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=180.000000,Max=190.000000),Y=(Min=180.000000,Max=190.000000),Z=(Min=180.000000,Max=190.000000))
        InitialParticlesPerSecond=80.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ONSBPTextures.fX.ExploTrans'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.600000,Max=0.900000)
 		DetailMode=DM_High
       StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=4.000000,Max=600.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'ArboreaLanscape.Cliffs.littlerock01'
        UseCollision=false
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-3800.000000)
        DampingFactorRange=(X=(Min=0.458000,Max=0.580000),Y=(Min=0.458000,Max=0.580000),Z=(Min=0.458000,Max=0.580000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=2.670000
        MaxParticles=10
        Name="MeshEmitter0"
        StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000))
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.024000,Max=0.087000),Y=(Min=0.024000,Max=0.087000),Z=(Min=0.024000,Max=0.087000))
        InitialParticlesPerSecond=200.000000
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-600.000000,Max=600.000000),Y=(Min=-600.000000,Max=600.000000),Z=(Min=1030.000000,Max=2900.000000))
		DetailMode=DM_High
    End Object
    Emitters(4)=MeshEmitter'MeshEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.700000
        FadeOutStartTime=0.119000
        MaxParticles=3
        Name="groundboom"
        StartLocationRange=(Z=(Min=0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.010000)
        SizeScale(1)=(RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=0.250000,RelativeSize=3.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=120.000000,Max=120.000000),Y=(Min=120.000000,Max=120.000000),Z=(Min=120.000000,Max=120.000000))
        InitialParticlesPerSecond=300.000000
        Texture=Texture'ONSBPTextures.fX.ExploTrans'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.500000,Max=0.500000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        Backup_Disabled=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-600.000000)
        ColorScale(0)=(Color=(B=155,G=180,R=205,A=164))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=155,G=180,R=205,A=170))
        FadeOutStartTime=0.740000
        FadeInEndTime=0.080000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        Name="endsmoke"
        StartLocationRange=(Z=(Min=-32.000000,Max=128.000000))
        AlphaRef=4
        SpinsPerSecondRange=(X=(Min=-0.070000,Max=0.070000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.340000,RelativeSize=8.520000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=14.400000)
        StartSizeRange=(X=(Min=30.000000,Max=60.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BenTex01.textures.SmokePuff01'
        LifetimeRange=(Min=1.600000,Max=2.000000)
        InitialDelayRange=(Min=0.059000,Max=0.059000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=500.000000,Max=800.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        RotateVelocityLossRange=True
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter3'

    bNoDelete=False
    AutoDestroy=True

    bDynamicLight=true
    LightEffect=LE_QuadraticNonIncidence
    LightType=LT_FadeOut
    LightBrightness=255
    LightHue=28
    LightSaturation=90
    LightRadius=90
    LightPeriod=32
    LightCone=128
}
