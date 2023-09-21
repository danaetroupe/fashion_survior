local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerEvents = ReplicatedStorage.ServerEvents

local start = ServerEvents.ChallengeStart
local stop = ServerEvents.ChallengeEnd
local update = ServerEvents.UpdatePoints

local frame = script.Parent
local timer = frame.Timer
local points = frame.Points

start.OnClientEvent:Connect(function(totalTime)
	frame.Visible = true
	timer.Text = totalTime
	
	for t = totalTime, 0, -1 do
		timer.Text = t
		wait(1)
	end
	frame.Visible = false
end)

-- Update player display points
update.OnClientEvent:Connect(function(score)
	points.Text = tostring(score)
end)

stop.OnClientEvent:Connect(function()
	frame.Visible = false
end)