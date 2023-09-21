local ServerStorage = game:GetService("ServerStorage")
local Challenges = ServerStorage.Challenges
local Challlenge = Challenges.Challenge

local List = Challenges.ChallengeFolders

local ChallengeList = {
	List.Falling.Falling
	--List.ColorMatch.ColorMatch
}

local function selectRandomChallengeList ()
	local index = math.random(1, #ChallengeList)
	local challenge = require(ChallengeList[index])
end

selectRandomChallengeList()