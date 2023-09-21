local ReplicatedStorage = game:GetService("ReplicatedStorage")
local update = ReplicatedStorage.ServerEvents.UpdatePoints
local stop = ReplicatedStorage.ServerEvents.ChallengeEnd

update.OnClientEvent:Connect(function(points)
	script.Parent.Text = tostring(points)
end)

stop.OnClientEvent:Connect(function()
	script.Parent.Text = ""
end)