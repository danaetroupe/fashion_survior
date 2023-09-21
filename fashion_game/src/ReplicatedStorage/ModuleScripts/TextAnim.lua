local TextAnim = {}

local Players = game:GetService("Players")
local tweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer

local DEFAULT_WAIT_TIME = 0.08
local DEFAULT_SPEED = 1


-- PUBLIC
-- Typing effect
function TextAnim.typing(text, textDisplay, waitTime) 
	local waitTime = waitTime or DEFAULT_WAIT_TIME
	textDisplay.Text = ""
		for _, t in ipairs(text:split("")) do
			textDisplay.Text = textDisplay.Text .. t
			wait(waitTime)
		end
	return true
end

--Fade in effect
function TextAnim.fadeIn(text, textDisplay, speed)
	local tweenInfo = TweenInfo.new(speed or DEFAULT_SPEED)
	textDisplay.TextTransparency = 1
	textDisplay.Text = text
	
	local tween = tweenService:Create(textDisplay, tweenInfo, {TextTransparency = 0})
	tween:Play()
	tween.Completed:Wait()
	return true
end

-- Fade out effect
function TextAnim.fadeOut(textDisplay, speed)
	local tweenInfo = TweenInfo.new(speed or DEFAULT_SPEED)
	local tweenInfo2 = TweenInfo.new(speed or DEFAULT_SPEED)

	local tween = tweenService:Create(textDisplay, tweenInfo, {TextTransparency = 1, Transparency = 1})
	local tween2 = tweenService:Create(textDisplay.Parent, tweenInfo2, {Transparency = 1})
	tween2:Play()
	wait(1)
	tween:Play()
	tween.Completed:Wait()
	return true
end
return TextAnim

