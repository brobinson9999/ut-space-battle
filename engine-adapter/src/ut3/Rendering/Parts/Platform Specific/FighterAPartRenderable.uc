class FighterAPartRenderable extends BasePartRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
    SkeletalMesh=SkeletalMesh'VH_Cicada.Mesh.SK_VH_Cicada'
    Translation=(X=-40.0,Y=0.0,Z=-70.0) // -60 seems about perfect for exact alignment, -70 for some 'lee way'
//    AnimTreeTemplate=AnimTree'VH_Cicada.Anims.AT_VH_Cicada'
//    AnimSets.Add(AnimSet'VH_Cicada.Anims.VH_Cicada_Anims')

    CollideActors=FALSE
    BlockActors=FALSE
    BlockZeroExtent=FALSE
    BlockNonZeroExtent=FALSE
    BlockRigidBody=FALSE
    bForceMeshObjectUpdates=TRUE
  End Object
  Components.Add(SkeletalMeshComponent0)

	trailOffsets(0)=(X=-85,Y=-32.5,Z=-10)
	trailOffsets(1)=(X=-85,Y=32.5,Z=-10)

  Drawscale=0.1
}