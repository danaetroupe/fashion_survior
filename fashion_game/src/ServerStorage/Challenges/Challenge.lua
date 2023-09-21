local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleScripts = ServerStorage.ModuleScripts
local GameSettings = require(ModuleScripts.GameSettings)
local ServerEvents = ReplicatedStorage.ServerEvents
local ClientEvents = ReplicatedStorage.ClientEvents

local sendText = ServerEvents.SendText
local animationComplete = ClientEvents.AnimationComplete
local update = ServerEvents.UpdatePoints
local start = ServerEvents.ChallengeStart
local stop = ServerEvents.ChallengeEnd

local Challenge = {}
Challenge.__index = Challenge


local Platform = script.Parent.Platform

function Challenge.new(name, minPlayers, instructions, gameTime, pointsToWin)
	local self = setmetatable({}, Challenge)
	
	self.Name = name
	self.MinPlayers = minPlayers or 1
	self.Instructions = instructions
	self.Time = gameTime
	self.PointsToWin = pointsToWin
	
	self.Players = {}
	self.Scores = {}
	
	self.Active = false
	
	return self
end

-- Generate folder to store challenge related items
function Challenge:generateWorkspaceFolder(name)
	local folder = Instance.new("Folder")
	folder.Name = name or "ChallengeFolder"
	folder.Parent = workspace
	
	self.WorkspaceFolder = folder
end

function Challenge:createPlayerList()
	for _, player in ipairs(Players:GetPlayers())  do
		player:SetAttribute("HasImmunity", false)
		if player:GetAttribute("InGame") == true then
			table.insert(self.Players, player)
		end
	end
end

function Challenge:spawnGui(baseGui)
	if self.Players == {} then
		self.createPlayerList()
	end
	
	for _, player in self.Players do
		local gui = baseGui:clone()
		gui.Parent = player.PlayerGui
		print('done')
	end
end

-- Generate platform for players 
function Challenge:generatePlatform(platform, position)
	local platform = platform or script.Parent.Platform
	position = position or Vector3.new(0, 0, 0)
	local platform = Platform:Clone()
	local x, y, z = platform:GetBoundingBox()
	position = Vector3.new(position.X, y, position.Z)
	platform:MoveTo(position)
	platform.Name = "Platform"
	
	if self.WorkspaceFolder then
		platform.Parent = self.WorkspaceFolder
	else
		Challenge:generateWorkspaceFolder()
		platform.Parent = self.WorkspaceFolder
	end
	
	self.Platform = platform
end

-- Teleport active players into challenge
function Challenge:spawn()
	local size, position = nil
	if not self.Platform then
		Challenge:generatePlatform()
	end
	local spwn = self.Platform.Spawn
	local size = spwn.Size
	local position = spwn.Position
	
	for _, player in ipairs(Players:GetPlayers()) do
		-- Reset Immunity All
		player:SetAttribute("HasImmunity", false)
		-- Spawn active players only
		if player:GetAttribute("InGame") == true then
			local x = math.random(position.X-(size.X/2),position.X+(size.X/2))
			local y = position.Y
			local z = math.random(position.Z-(size.Z/2),position.Z+(size.Z/2))
			local character = player.Character or player.CharacterAdded:Wait()
			character:MoveTo(Vector3.new(x, y, z))
			-- Keeps track of all active player points
			self.Scores[player.Name] = 0
			update:FireClient(player, 0)
			table.insert(self.Players, player)
		end
	end
	
end


function Challenge:setPlay(funct)
	self.Play = funct
end

function Challenge:setInit(funct)
	self.Init = funct
end

function Challenge:animate()
	local name = self.Name
	local instructions = self.Instructions
	sendText:FireAllClients(name, instructions)
end

function Challenge:endChallenge(player)
	-- Reset values 
	self.Active = false
	local topScore = 0
	local topPlayer = nil
	-- If there has already been a top player chosen
	if player then
		topPlayer = player
	-- Otherwise, loop through scores to determine who has highest scores. Ties will go to first person in list. 
	else
		for _, player in self.Scores do
			if player > topScore then
				topScore = player
				topPlayer = player.Name
			end
		end
	end
	topPlayer:SetAttribute("HasImmunity", true)
	stop:FireAllClients(player)
end

function Challenge:ExecutePlay()
	-- initalize
	self.Scores = {}
	self.Players = {}
	
	wait(1)
	self:animate()
	animationComplete.OnServerEvent:Wait()
	self:spawn()
	animationComplete.OnServerEvent:Wait()
	if self.Init then
		self.Init()
	end
	for _, player in self.Players do
		start:FireClient(player, self.Time)
	end
	self.Active = true
	self.Play()
	wait(self.Time)
	self:endChallenge()
end

function Challenge:Destroy()
	self.WorkspaceFolder:Destroy()
end

function Challenge:getPlatformInfo()
	local platform = self.Platform.Spawn
	local size, position =  platform.Size, platform.Position
	local x1, x2 = position.X-(size.X/2), position.X+(size.X/2)
	local y1, y2 = position.Y-(size.Y/2), position.Y+(size.Y/2)
	local z1, z2 = position.Z-(size.Z/2), position.Z+(size.Z/2)
	return x1, x2, y1, y2, z1, z2
end

function Challenge:spawnAsset(position, asset, anchored)
	local clone = asset:Clone()
	if self.WorkspaceFolder then
		clone.Parent = self.WorkspaceFolder
	else
		Challenge:generateWorkspaceFolder()
		clone.Parent = self.WorkspaceFolder
	end
	clone.Position = position
	if anchored then
		clone.Anchored = true
	else
		clone.Anchored = false
	end
	return clone
end



function Challenge:awardPoint(player, pointAmount)
	-- Update score
	self.Scores[player.Name] += pointAmount
	local score = self.Scores[player.Name]
	update:FireClient(player, score)
	-- Check if game over
	if score > self.PointsToWin then
		self:endChallenge()
	end
end

return Challenge
