class FighterBPartRenderable extends BasePartRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
    SkeletalMesh=SkeletalMesh'VH_NecrisManta.Mesh.SK_VH_NecrisManta'
    Translation=(X=0.0,Y=0.0,Z=-64.0)
		Materials[0]=MaterialInstanceConstant'VH_NecrisManta.Materials.MI_VH_Viper_Red'
//		AnimTreeTemplate=AnimTree'VH_NecrisManta.Anims.AT_VH_NecrisManta'
//		AnimSets.Add(AnimSet'VH_NecrisManta.Anims.K_VH_NecrisManta')

    CollideActors=FALSE
    BlockActors=FALSE
    BlockZeroExtent=FALSE
    BlockNonZeroExtent=FALSE
    BlockRigidBody=FALSE
    bForceMeshObjectUpdates=TRUE
  End Object
  Components.Add(SkeletalMeshComponent0)

	trailOffsets(0)=(X=-80)
	
  Drawscale=0.1
}