class ChasmSnakePartRenderable extends BasePartRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  Begin Object Class=StaticMeshComponent Name=MainMeshComponent
		StaticMesh=StaticMesh'LT_Support.SM.Mesh.S_LT_Supports_SM_ChasmSnake1'

    CollideActors=FALSE
    BlockActors=FALSE
    BlockZeroExtent=FALSE
    BlockNonZeroExtent=FALSE
    BlockRigidBody=FALSE
  End Object
  Components.Add(MainMeshComponent)

  Drawscale=0.05
	LocationOffset=(Z=-150,Y=100)
}

