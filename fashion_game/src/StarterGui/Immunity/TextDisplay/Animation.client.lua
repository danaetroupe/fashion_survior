local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local ServerEvents = ReplicatedStorage.ServerEvents
local ModuleScripts = ReplicatedStorage.ModuleScripts
local ClientEvents = ReplicatedStorage.ClientEvents

local SendText = ServerEvents.SendText
local animComplete = ClientEvents.AnimationComplete

local WAIT_TIME = 0.08
local PAUSE = 2
local SPEED = 3

local frame = script.Parent
local title = frame.Title
local caption = frame.Caption

SendText.OnClientEvent:Connect(function(titleText, captionLines)
	-- Fade in dark background
	local tweenInfo = TweenInfo.new(SPEED)
	local frameTween = TweenService:Create(frame, tweenInfo, {Transparency = 0})
	frameTween:Play()
	wait(1)
	
	-- Fade in title text
	local tweenInfo = TweenInfo.new(SPEED)
	title.TextTransparency = 1
	title.Text = titleText

	local tween = TweenService:Create(title, tweenInfo, {TextTransparency = 0})
	tween:Play()
	tween.Completed:Wait()
	animComplete:FireServer()
	wait(2)
	
	-- Fade out background and title
	local tweenInfo = TweenInfo.new(SPEED)
	local tweenInfo2 = TweenInfo.new(SPEED)

	local tween = TweenService:Create(title, tweenInfo, {TextTransparency = 1, Transparency = 1})
	local tween2 = TweenService:Create(frame, tweenInfo2, {Transparency = 1})
	tween2:Play()
	wait(1)
	tween:Play()
	tween.Completed:Wait()
	
	-- Read instructions
	for i, line in captionLines do
		caption.Text = ""
		for _, t in ipairs(line:split("")) do
			caption.Text = caption.Text .. t
			wait(WAIT_TIME)
		end
		if i == #captionLines then
			animComplete:FireServer()
		end
		wait(PAUSE)
	end
	caption.Text = ""
end)
