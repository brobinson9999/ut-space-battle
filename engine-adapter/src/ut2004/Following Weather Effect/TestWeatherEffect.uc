class TestWeatherEffect extends PlayerFollowingWeatherEffect;

defaultproperties
{
  spawnRangeFactor=0.5
  maxParticleDistance=1000

  Begin Object Class=SpriteEmitter Name=SpriteEmitter12
    automaticInitialSpawning=true
    respawnDeadParticles=true
    particlesPerSecond=20
    initialParticlesPerSecond=25

    coordinateSystem=PTCS_Independent
    startLocationShape=PTLS_Sphere
    sphereRadiusRange=(min=5000,max=10000)
    

    startVelocityRange=(z=(min=-100,max=-50))

    SpinParticles=True
//    UniformSize=True
    ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
    Opacity=0.200000
    MaxParticles=50
    StartSpinRange=(X=(Max=1.000000))
    StartSizeRange=(X=(Min=50.000000,Max=50.000000))
    Texture=AW-2004Particles.Weapons.HardSpot
    LifetimeRange=(Min=5,Max=10)

    Name="SpriteEmitter12"
  End Object
  emitters(0)=SpriteEmitter'SpriteEmitter12'
}
