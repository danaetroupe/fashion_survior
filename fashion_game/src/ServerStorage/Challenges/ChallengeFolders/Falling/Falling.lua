local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Challenge = require(ServerStorage.Challenges.Challenge)

local FallingFolder = script.Parent
local Assets = FallingFolder.Assets:GetChildren()

local NAME = "ONE MINUTE CHALLENGE"
local MAX_PLAYERS = 2
local INSTRUCTIONS = {
		"Catch the objects as they fall from the sky.",
	"The player that earns the most points in one minute wins.",
	"START!"
}
local TIME = 60
local POINTS = 120
local SINGLE_POINT = 1

local Falling = Challenge.new(NAME, MAX_PLAYERS, INSTRUCTIONS, TIME, POINTS)

local function addForce(asset)
	local attachment = Instance.new("Attachment")
	attachment.Parent = asset

	local velocity = Instance.new("LinearVelocity")
	velocity.MaxForce = math.huge
	velocity.VectorVelocity = Vector3.new(0, -10, 0)
	velocity.Attachment0 = attachment
	velocity.Parent = asset
end


-- Play function to be triggerred by external script
Falling:setPlay(function ()
	local x1, x2, y1, y2, z1, z2 = Falling:getPlatformInfo()
	while Falling.Active do
		wait(1)
		local x = math.random(x1, x2)
		local y = y2 + 40
		local z = math.random(z1, z2)
		local index = math.random(1, #Assets)
		local asset = Assets[index]
		asset = Falling:spawnAsset(Vector3.new(x, y, z), asset)
		local spot = FallingFolder.Spot
		spot = Falling:spawnAsset(Vector3.new(x, y1, z), spot, true)
		addForce(asset)
		asset.Touched:Connect(function(hit)
			spot:Destroy()
			asset:Destroy()
			if hit.Parent:FindFirstChild("Humanoid") then
				local player = Players:GetPlayerFromCharacter(hit.Parent)
				Falling:awardPoint(player, SINGLE_POINT)
			end
			
		end)
	end 
end)

Falling:ExecutePlay()

return Falling
