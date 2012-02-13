class UT3CicadaPartRenderable extends BasePartRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
    SkeletalMesh=SkeletalMesh'VH_Cicada.Mesh.SK_VH_Cicada'
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

	trailOffsets(0)=(X=-45,Y=-32.5,Z=60)
	trailOffsets(1)=(X=-45,Y=32.5,Z=60)

  Drawscale=0.05
}