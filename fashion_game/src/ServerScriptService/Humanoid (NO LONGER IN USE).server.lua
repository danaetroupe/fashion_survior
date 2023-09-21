local Players = game:GetService("Players")

local function onPlayerJoin(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	if not character:IsDescendantOf(workspace) then
		character.AncestryChanged:Wait()
	end
	local humanoidDescription = humanoid:GetAppliedDescription()
	humanoidDescription.HatAccessory = 10370321127
	humanoid:ApplyDescriptionReset(humanoidDescription)
end

--Players.PlayerAdded:Connect(onPlayerJoin)