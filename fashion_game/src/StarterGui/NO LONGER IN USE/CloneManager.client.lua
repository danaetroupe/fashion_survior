local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gui = script.Parent
local frame = gui.ScreenFrame
local start = frame.Start
local left = frame.Left
local right = frame.Right
local active = false

local localPlayer = Players.LocalPlayer
--local camera = workspace.CurrentCamera
local clone = nil

local viewport = gui.ViewportFrame
local worldmodel = viewport.WorldModel
local stand = worldmodel.Stand

local DEGREES = 45


local ClientEvents = ReplicatedStorage.ClientEvents
local loadAsset = ClientEvents.LoadAsset

local function addToClone(asset) 
	local model = loadAsset:InvokeServer(asset)
	local item = model:GetChildren()
end


local function addToPlayer(asset)
	
end
-- Clones the player's current character (WORKS)
local function duplicatePlayer()
	local character = localPlayer.Character
	character.Archivable = true
	clone = character:Clone()
	character.Archivable = false
	clone.Parent = worldmodel
	clone:MoveTo(stand.Position + Vector3.new(0,5,0))
	clone:PivotTo(clone:GetPivot() * CFrame.Angles(0, 0, 0))
	--local humanoid = clone:WaitForChild("Humanoid")
	--local size = camera.ViewportSize
	--humanoid.CameraOffset = Vector3.new(size.X/3)
	return clone
end

-- Sets player's camera on clone (WORKING)
local function setCamera(clone)
	local viewportCamera = Instance.new("Camera")
	viewport.CurrentCamera = viewportCamera
	viewportCamera.Parent = viewport
	
	local root = clone.HumanoidRootPart.CFrame.Position
	viewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, -8) + root, root)
	
	--[[camera.CameraType = Enum.CameraType.Scriptable -- camera will need to be reset at the end
	local size = camera.ViewportSize
	
	camera.FieldOfView = 45
	camera.CFrame = CFrame.new(camPos.CFrame.Position, root + Vector3.new())
	camera.CameraSubject = clone.Humanoid]]
end

local function dressUp()
	active = true
	duplicatePlayer()
	setCamera(clone)
	addToClone(48474313)
end

local function turnLeft()
	clone:PivotTo(clone:GetPivot() * CFrame.Angles(0, math.rad(-45), 0))
end
local function turnRight()
	clone:PivotTo(clone:GetPivot() * CFrame.Angles(0, math.rad(45), 0))
end

start.Activated:Connect(dressUp)
left.Activated:Connect(turnLeft)	
right.Activated:Connect(turnRight)
