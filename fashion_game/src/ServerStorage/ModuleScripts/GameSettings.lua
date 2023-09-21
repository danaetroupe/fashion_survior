local GameSettings = {}

-- Game Status
GameSettings.Status = {
	GameActive = false,
	Round = {
		"Immunity", "DressUp"
	}
}

-- Timing
GameSettings.Timing = {
	IntroTime = 30,
	ChallengeTime = 120,
	VoteTime = 30,
	IntermissionTime = 10,
}

GameSettings.PlayerProperties = {
	"InGame", "HasImmunity", "Votes"
}

return GameSettings

