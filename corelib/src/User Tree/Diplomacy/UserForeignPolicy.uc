class UserForeignPolicy extends BaseObject abstract;

// isFriendly: User User -> boolean
// Returns true if objectUser is friendly toward subjectUser, false otherwise.
simulated function bool isFriendly(User objectUser, User subjectUser);

// isHostile: User User -> boolean
// Returns true if objectUser is hostile toward subjectUser, false otherwise.
simulated function bool isHostile(User objectUser, User subjectUser);

defaultproperties
{
}