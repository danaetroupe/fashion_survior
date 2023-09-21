local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Challenge = require(ServerStorage.Challenges.Challenge)

local ColorMatchFolder = script.Parent
local ClothingRack = ColorMatchFolder.ClothingRack
local MatchingGui = ColorMatchFolder.MatchingGui


local NAME = ""
local MAX_PLAYERS = 2
local INSTRUCTIONS = {
	""
}
local TIME = 60
local POINTS = 120
local SINGLE_POINT = 1
local ROUNDS = 3
local COLOR_AMT = 9

local ColorMatch = Challenge.new(NAME, MAX_PLAYERS, INSTRUCTIONS, TIME, POINTS)

local COLORS = {
	Color3.new(1, 0, 0), -- RED
	Color3.new(0.258824, 0.356863, 1), -- BLUE
	Color3.new(0.447059, 1, 0.556863), -- GREEN
	Color3.new(1, 0.207843, 0.827451), -- PINK
	Color3.new(1, 0.901961, 0.352941), -- YELLOW
	Color3.new(0.615686, 0.360784, 1) -- PURPLE
}

-- PRIVATE FUNCTIONS
local function generateRandomColors(amt)
	local list = {}
	while #list < amt do
		local index = math.random(1, #COLORS)
		table.insert(list, COLORS[index])
	end
	return list
end

local function showColors(player, round)
	local gui = player.PlayerGui.MatchingGui
	local colors = ColorMatch.t_List[round]
	for i = 1, #gui.Frame:GetChildren(), 1 do
		local section = gui.Frame:FindFirstChild(tostring(i))
		local start = i + (2 * (i-1))
		section:FindFirstChild("1").BackgroundColor3 = colors[start]
		section:FindFirstChild("2").BackgroundColor3 = colors[start + 1]
		section:FindFirstChild("3").BackgroundColor3 = colors[start + 2]
	end
end

-- Play function to be triggerred by external script
ColorMatch:setInit(function ()
	ColorMatch:spawnGui(MatchingGui)
	local list = {}
	for i = 0, ROUNDS, 1 do
		table.insert(list, generateRandomColors(COLOR_AMT))
	end
	ColorMatch.t_List = list -- For reference use in setPlay
	for _, player in ColorMatch.Players do
		showColors(player, 1)
	end
end)

ColorMatch:setPlay(function ()
	while ColorMatch.Active do
		break
	end 
end)

ColorMatch:ExecutePlay()

return ColorMatch

