class SpaceWeatherEffect extends PlayerFollowingWeatherEffect;

defaultproperties
{
  spawnRangeFactor=0.5
  maxParticleDistance=10000

  Begin Object Class=SpriteEmitter Name=SpriteEmitter0
    automaticInitialSpawning=true
    respawnDeadParticles=true
    particlesPerSecond=0
//    initialParticlesPerSecond=500
    maxParticles=500

    coordinateSystem=PTCS_Independent
    startLocationShape=PTLS_Sphere
    sphereRadiusRange=(min=5000,max=10000)

    RelativeWarmupTime=5
    UseColorScale=True
    SpinParticles=True
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    BlendBetweenSubdivisions=True
    UseRandomSubdivision=True
    ColorScale(0)=(Color=(B=96,G=128,R=164))
    ColorScale(1)=(RelativeTime=0.200000,Color=(B=96,G=128,R=164,A=255))
    ColorScale(2)=(RelativeTime=0.500000,Color=(B=64,G=100,R=128,A=255))
    ColorScale(3)=(RelativeTime=1.000000,Color=(B=68,G=104,R=125))
    FadeOutStartTime=0.500000
    FadeInEndTime=0.350000
    SizeScale(0)=(RelativeSize=0.3000)
    SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
    StartSizeRange=(X=(Min=50.000000,Max=90.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'AW-2004Particles.Weapons.SmokePanels2'
    TextureUSubdivisions=4
    TextureVSubdivisions=4
    LifetimeRange=(Min=5,Max=8)
    Name="SpriteEmitter0"
  End Object
  Emitters(0)=SpriteEmitter'SpriteEmitter0'
}
