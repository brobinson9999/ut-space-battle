class ONSVehicleGunAdapter extends ONSWeapon;

//var class<Projectile> TeamProjectileClasses[2];
var float MinAim;
/*

state InstantFireMode
{
    function Fire(Controller C)
    {
        FlashMuzzleFlash();

        if (AmbientEffectEmitter != None)
        {
            AmbientEffectEmitter.SetEmitterStatus(true);
        }

        // Play firing noise
        if (bAmbientFireSound)
            AmbientSound = FireSoundClass;
        else
            PlayOwnedSound(FireSoundClass, SLOT_None, FireSoundVolume/255.0,, FireSoundRadius, FireSoundPitch, False);

        TraceFire(WeaponFireLocation, WeaponFireRotation);
    }

    function AltFire(Controller C)
    {
    }

    simulated event ClientSpawnHitEffects()
    {
      local vector HitLocation, HitNormal, Offset;
      local actor HitActor;

      // if standalone, already have valid HitActor and HitNormal
      if ( Level.NetMode == NM_Standalone )
        return;
      Offset = 20 * Normal(WeaponFireLocation - LastHitLocation);
      HitActor = Trace(HitLocation, HitNormal, LastHitLocation - Offset, LastHitLocation + Offset, False);
      SpawnHitEffects(HitActor, LastHitLocation, HitNormal);
    }

    simulated function SpawnHitEffects(actor HitActor, vector HitLocation, vector HitNormal)
    {
    local PlayerController PC;

    PC = Level.GetLocalPlayerController();
    if (PC != None && ((Instigator != None && Instigator.Controller == PC) || VSize(PC.ViewTarget.Location - HitLocation) < 5000))
    {
      Spawn(class'HitEffect'.static.GetHitEffect(HitActor, HitLocation, HitNormal),,, HitLocation, Rotator(HitNormal));
      if ( !Level.bDropDetail && (Level.DetailMode != DM_Low) )
      {
        // check for splash
        if ( Base != None )
        {
          Base.bTraceWater = true;
          HitActor = Base.Trace(HitLocation,HitNormal,HitLocation,Location + 200 * Normal(HitLocation - Location),true);
          Base.bTraceWater = false;
        }
        else
        {
          bTraceWater = true;
          HitActor = Trace(HitLocation,HitNormal,HitLocation,Location + 200 * Normal(HitLocation - Location),true);
          bTraceWater = false;
        }

        if ( (FluidSurfaceInfo(HitActor) != None) || ((PhysicsVolume(HitActor) != None) && PhysicsVolume(HitActor).bWaterVolume) )
          Spawn(class'BulletSplash',,,HitLocation,rot(16384,0,0));
      }
    }
    }
}

state ProjectileFireMode
{
    function Fire(Controller C)
    {
      SpawnProjectile(ProjectileClass, False);
    }

    function AltFire(Controller C)
    {
        if (AltFireProjectileClass == None)
            Fire(C);
        else
            SpawnProjectile(AltFireProjectileClass, True);
    }
}
*/
static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaStarRed');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaStar');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaHeadRed');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaHeadBlue');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.SmokePanels1');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaStar2');
    L.AddPrecacheMaterial(Material'EpicParticles.Flares.FlashFlare1');
    L.AddPrecacheMaterial(Material'EmitterTextures.MultiFrame.rockchunks02');
    L.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaFlare');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaStarRed');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaStar');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaHeadRed');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaHeadBlue');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.SmokePanels1');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaStar2');
    Level.AddPrecacheMaterial(Material'EpicParticles.Flares.FlashFlare1');
    Level.AddPrecacheMaterial(Material'EmitterTextures.MultiFrame.rockchunks02');
    Level.AddPrecacheMaterial(Material'AW-2004Particles.Weapons.PlasmaFlare');

    Super.UpdatePrecacheMaterials();
}

function byte BestMode()
{
  local bot B;

  B = Bot(Instigator.Controller);
  if ( B == None )
    return 0;

  if ( (Vehicle(B.Enemy) != None)
       && (B.Enemy.bCanFly || B.Enemy.IsA('ONSHoverCraft')) && (FRand() < 0.3 + 0.1 * B.Skill) )
    return 1;
  else
    return 0;
}

state ProjectileFireMode
{
  function Fire(Controller C)
  {
    Super.Fire(C);
  }

  function AltFire(Controller C)
  {
    local ONSAttackCraftMissle M;
    local Vehicle V, Best;
    local float CurAim, BestAim;

    M = ONSAttackCraftMissle(SpawnProjectile(AltFireProjectileClass, True));
    if (M != None)
    {
      if (AIController(Instigator.Controller) != None)
      {
        V = Vehicle(Instigator.Controller.Enemy);
        if (V != None && (V.bCanFly || V.IsA('ONSHoverCraft')) && Instigator.FastTrace(V.Location, Instigator.Location))
          M.SetHomingTarget(V);
      }
      else
      {
        BestAim = MinAim;
        for (V = Level.Game.VehicleList; V != None; V = V.NextVehicle)
          if ((V.bCanFly || V.IsA('ONSHoverCraft')) && V != Instigator && Instigator.GetTeamNum() != V.GetTeamNum())
          {
            CurAim = Normal(V.Location - WeaponFireLocation) dot vector(WeaponFireRotation);
            if (CurAim > BestAim && Instigator.FastTrace(V.Location, Instigator.Location))
            {
              Best = V;
              BestAim = CurAim;
            }
          }
        if (Best != None)
          M.SetHomingTarget(Best);
      }
    }
  }
}

DefaultProperties
{
    Mesh=Mesh'ONSWeapons-A.PlasmaGun'
    YawBone=PlasmaGunBarrel
    YawStartConstraint=0
    YawEndConstraint=65535
    PitchBone=PlasmaGunBarrel
    PitchUpLimit=18000
    PitchDownLimit=49153
    FireSoundClass=sound'ONSVehicleSounds-S.LaserSounds.Laser01'
    AltFireSoundClass=sound'ONSVehicleSounds-S.AVRiL.AVRiLFire01'
    FireForce="Laser01"
    AltFireForce="Laser01"
    ProjectileClass=class'ONSVehicleGunProjectileAdapter'
    FireInterval=0.2
    AltFireProjectileClass=class'ONSAttackCraftMissle'
    AltFireInterval=3.0
    WeaponFireAttachmentBone=PlasmaGunBarrel
    WeaponFireOffset=0.0
    bAimable=True
    RotationsPerSecond=1.2
    DualFireOffset=50
    AIInfo(0)=(bLeadTarget=true,RefireRate=0.95)
    AIInfo(1)=(bLeadTarget=true,AimError=400,RefireRate=0.50)
    MinAim=0.900
}
