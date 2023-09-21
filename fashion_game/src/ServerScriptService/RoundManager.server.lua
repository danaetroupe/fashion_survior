local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local ModuleScripts = ServerStorage.ModuleScripts
local GameSettings = require(ModuleScripts.GameSettings)

local Timing = GameSettings.Timing

local Events = ServerStorage.Events
local StartDressUp = Events.DressUpChallenge
local StartImmunity = Events.ImmunityChallenge
local StartVote = Events.Vote

--[[
while (#Players:GetPlayers() > 3) do
	StartImmunity:Fire()
	wait(Timing)
	StartDressUp:Fire()
	wait(GameSettings.ChallengeTime)
	StartVote:Fire()
	wait(GameSettings.VoteTime)
end
]]