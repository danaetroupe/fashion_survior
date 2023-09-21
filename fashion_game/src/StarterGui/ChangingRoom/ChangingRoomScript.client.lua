local gui = script.Parent
local catalogFrame = gui.Catalog

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleScripts = ReplicatedStorage.ModuleScripts
local ClientEvents = ReplicatedStorage.ClientEvents

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local Catalog = require(ModuleScripts.Catalog)
local category = Catalog.Categories[1]

-- CLONE ---------------------------------------------------------------------------

local gClone = nil
local PlayerDisplay = gui.PlayerDisplay
local worldModel = PlayerDisplay.WorldModel
local stand = worldModel.Stand

local function duplicatePlayer()
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	character.Archivable = true
	gClone = character:Clone()
	character.Archivable = false
	gClone.Parent = worldModel
	gClone:MoveTo(stand.Position + Vector3.new(0,5,0))
	gClone:PivotTo(gClone:GetPivot() * CFrame.Angles(0, 0, 0))
end

local function updateClone()
	local pivot = gClone:GetPivot()
	gClone:Destroy()
	duplicatePlayer()
	gClone:PivotTo(pivot)
end

local function setCamera()
	local viewportCamera = Instance.new("Camera")
	PlayerDisplay.CurrentCamera = viewportCamera
	viewportCamera.Parent = PlayerDisplay

	local root = gClone.HumanoidRootPart.CFrame.Position
	viewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, -8) + root, root)
end

local function resetCamera()
	PlayerDisplay.CurrentCamera = workspace.Camera
end

-- ASSETS ---------------------------------------------------------------------------

local searchEvent = ClientEvents.Search
local getBundleEvent = ClientEvents.GetBundleId
local addAccessory = ClientEvents.AddAccessory
local getInfo = ClientEvents.GetInfo

local assetsFrame = catalogFrame.Assets
local footer = catalogFrame.Footer.Frame
local page = footer.Page
local back = footer.Left
local forward = footer.Right
local currentAssets = catalogFrame.Footer.CurrentAssets

local currentPage = 1
local pages = {}
local assets = nil
local gQuery = ""

local function clear()
	for _, child in assetsFrame:GetChildren() do
		if child.ClassName == "ImageButton" then
			child:Destroy()
		end
	end
end

local function showPage(assets, isWearing)
	clear()
	isWearing = isWearing or false
	assetsFrame.CanvasPosition = Vector2.new(0, 0)
	page.Text = "Page "..currentPage
	for _, asset in assets do
		local id = asset["Id"]
		local image = Instance.new("ImageButton")
		image.Parent = assetsFrame
		image.Image = "rbxthumb://type=Asset&id="..id.."&w=150&h=150"
		image.BackgroundColor3 = Color3.fromRGB(219, 184, 255)
		image.BackgroundTransparency = 0
		Instance.new("UICorner").Parent = image
		
		image.Activated:Connect(function ()
			local var = addAccessory:InvokeServer(id, asset["AssetType"])
			updateClone()
			--print(localPlayer.Character.Humanoid.HumanoidDescription:GetAccessories(true))
			if isWearing then
				image:Destroy()
			end
		end)
	end
end

local function sortResults(results, resultsPerPage)
	local sort = {}
	local i = 1
	local temp = {}
	for _, asset in results  do
		if i > resultsPerPage then
			i = 1
			table.insert(sort, temp)
			temp = {}
		end
		table.insert(temp, asset)
		i += 1
	end
	table.insert(sort, temp)
	return sort
end

local function search(query, page)
	currentPage = page
	local page = searchEvent:InvokeServer(category, query, currentPage)
	showPage(page) 
end

back.Activated:Connect(function ()
	if currentPage > 1 then
		currentPage -= 1
		search(gQuery, currentPage)
	end
end)

forward.Activated:Connect(function ()
	currentPage += 1
	search(gQuery, currentPage)
end)

-- Handles current assets
currentAssets.Activated:Connect(function()
	clear()
	local assets = {}
	local description = localPlayer.Character.Humanoid.HumanoidDescription
	local categories = {description.Face, description.Head, description.LeftArm, description.RightArm, 
		description.LeftLeg, description.RightLeg, description.Pants, description.Shirt, description.Torso}
	-- Get non-accessories
	for _, cat in categories do
		if cat ~= 0 then
			local success, result = pcall(function()
				return getInfo:InvokeServer(cat)
			end)
			if success then
				table.insert(assets, result)
			end
		end
	end
	-- Get accessories
	for _, acc in description:GetAccessories(true) do
		local success, result = pcall(function()
			return getInfo:InvokeServer(acc["AssetId"])
		end)
		if success then
			table.insert(assets, result)
		end
	end

	showPage(assets, true) -- true for isWearing
end)

-- HEADER ---------------------------------------------------------------------------

local GuiLib = ModuleScripts.GuiLib
local Dropdown = require(GuiLib.Classes.Dropdown)
local List = require(GuiLib.Constructors.List)

local header = catalogFrame.Header


local function createCategoryList()
	local list = {}
	for _, cat in Catalog.Categories do
		table.insert(list, cat.name)
	end
	return List.Create(list, Catalog.Settings.MAX_CAT_DISPLAY, Enum.FillDirection.Vertical, UDim.new(0,3))
end

local function showCategories()
	local list = createCategoryList()
	local button = header.Categories
	
	list.Size = UDim2.new(0.8, -12, Catalog.Settings.MAX_CAT_DISPLAY, 0)
	list.Visible = false
	list.Parent = button
	list.BackgroundColor3 = Color3.new(0.858824, 0.721569, 1)
	local ui = Instance.new("UICorner")
	ui.Parent = list
	
	local scroll = list:FindFirstChildOfClass("ScrollingFrame")
	scroll.ScrollBarImageTransparency = 1
	
	local option = button.Option
	for _, item in scroll:GetDescendants() do
		item.FontFace = option.FontFace
		item.TextSize = option.TextSize
		item.TextColor = option.TextColor
		if item.ClassName == "TextButton" then
			item.Activated:Connect(function()
				category = Catalog[header.Categories.Option.Text]
				search("", 1)
			end)
		end
	end
	Dropdown.new(button, list) 
end

local function passToSearch(enter)
	if enter then
		gQuery = header.Search.Search.Text
		search(gQuery, 1)
	end
end


header.Search.Search.FocusLost:Connect(passToSearch)

-- OVERLAY ---------------------------------------------------------------------------

local PlayerOverlay = gui.PlayerOverlay
local submit = PlayerOverlay.Submit

local changeSize = ClientEvents.ChangeSize
local SetColor = ClientEvents.SetColor


local function skinColors()
	local skinColorsFrame = PlayerOverlay.SkinColors
	for _, color in Catalog.SkinColors do
		local image = Instance.new("ImageButton")
		image.Image = ""
		image.BackgroundColor3 = Color3.fromRGB(color[1], color[2], color[3])
		image.Size = UDim2.new(1, 0, 1, 0)
		image.SizeConstraint = Enum.SizeConstraint.RelativeXX
		image.Parent = skinColorsFrame
		Instance.new("UICorner").Parent = image
		
		image.Activated:Connect(function()
			if (SetColor:InvokeServer(image.BackgroundColor3)) then
				updateClone()
			else
				print("Server error changing skin color")
			end
		end)
	end
end



local Buttons = PlayerOverlay.Buttons
local Scale = Buttons.Scale
local Rotate = Buttons.Rotate

Rotate.RotateLeft.Activated:Connect(function()
	gClone:PivotTo(gClone:GetPivot() * CFrame.Angles(0, math.rad(-45), 0))
end)
Rotate.RotateRight.Activated:Connect(function()
	gClone:PivotTo(gClone:GetPivot() * CFrame.Angles(0, math.rad(45), 0))
end)

Scale.SizeIncrease.Activated:Connect(function()
	local size = changeSize:InvokeServer(0.1)
	updateClone()
end)

Scale.SizeDecrease.Activated:Connect(function()
	local size = changeSize:InvokeServer(-0.1)
	updateClone()
end)

local function close()
	gui.Enabled = false
	resetCamera()
end

submit.Activated:Connect(close)

-- TIMER ---------------------------------------------------------------------------
local themeDisplay = gui.ThemeDisplay
local timeDisplay = themeDisplay.Timer

local function showTime()
	local total = Catalog.Settings.TOTAL_TIME
	for t = total, 0, -1 do
		timeDisplay.Text = t
		wait(1)
	end
	submit()
end

-- GENERAL ---------------------------------------------------------------------------

local function dressUp()
	-- Set Displays
	showCategories()
	search("", 1)
	duplicatePlayer()
	setCamera()
	skinColors()
	-- Start Timer
	showTime()
end

dressUp()

