class LaserBoltProjectileDragee extends ScalableEmitter;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var bool bFading;
var vector fadingVelocity;
var float fadeRate;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setColor() {
  // Set color - default purple.
}

simulated function postBeginPlay() {
  setColor();
  
  super.postBeginPlay();
}

simulated function startFading(float newFadeRate, vector newFadingVelocity) {
  bFading = true;
  fadingVelocity = newFadingVelocity;
  fadeRate = newFadeRate;
}

simulated function tick(float delta) {
  local float newScale;
  
  super.tick(delta);
  
  if (fadeRate > 0) {
    newScale = currentScale - (delta * fadeRate);
    if (newScale > 0) {
      setLocation(location + (fadingVelocity * delta));
      setScale(newScale);
    } else {
      destroy();
    }
  }
 
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultProperties
{
  currentScale=2
  
  Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=128,R=64))
        ColorScale(1)=(RelativeTime=0.750000,Color=(B=255,G=128,R=64))
        ColorScale(2)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        MaxParticles=2
        StartLocationOffset=(X=150.000000)
        SpinParticles=True
        SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.070000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=0.150000,RelativeSize=1.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=0.750000)
        StartSizeRange=(X=(Min=150.000000,Max=150.000000))
        UniformSize=True
        InitialParticlesPerSecond=50.000000
        AutomaticInitialSpawning=False
        Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
    SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.000000,Max=2.000000)
        InitialDelayRange=(Min=0.050000,Max=0.050000)
        Name="SpriteEmitter1"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamEndPoints(0)=(offset=(X=(Min=600.000000,Max=600.000000)),Weight=1.000000)
        DetermineEndPointBy=PTEP_Offset
        RotatingSheets=3
    LowFrequencyPoints=2
        HighFrequencyPoints=2
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=128,R=64))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=128,R=64))
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        StartLocationOffset=(X=-150.000000)
        StartSizeRange=(X=(Min=30.000000,Max=30.000000))
        InitialParticlesPerSecond=2000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'AS_FX_TX.Beams.LaserTex'
        SecondsBeforeInactive=0.000000
    LifetimeRange=(Min=10.000000,Max=10.000000)
        Name="BeamEmitter1"
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter1'
}



