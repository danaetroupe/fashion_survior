local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local function onPlayerJoin(player)
	player:SetAttribute("InGame", true)
	local character = player.Character or player.CharacterAdded:Wait()
	local gui = ServerStorage.HeadTop
	gui:Clone().Parent = character:FindFirstChild("Head")
end

-- Apply humanoid description from clone onto player
local function dressPlayer(player, description)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	if not character:IsDescendantOf(workspace) then
		character.AncestryChanged:Wait()
	end
	humanoid:ApplyDescriptionReset(description)
end

local function lockAllPlayers()
	-- KEEP all active players from moving
end

-- Dress player in their default outfit
local function resetPlayer(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	if not character:IsDescendantOf(workspace) then
		character.AncestryChanged:Wait()
	end
	local description = Players:GetHumanoidDescriptionFromUserId(player.UserId)
	humanoid:ApplyDescriptionReset(description)
end

Players.PlayerAdded:Connect(onPlayerJoin)