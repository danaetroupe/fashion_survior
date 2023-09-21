local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleScripts = ReplicatedStorage.ModuleScripts
local Catalog = require(ModuleScripts.Catalog)

local ClientEvents = ReplicatedStorage.ClientEvents
local searchEvent = ClientEvents.Search

local catalogFrame = script.Parent
local assetsFrame = catalogFrame.Assets
local buttonsFrame = catalogFrame.Buttons

local previous = buttonsFrame.Previous
local nextB = buttonsFrame.Next
local backPageButton = catalogFrame.Back
local nextPageButton = catalogFrame.Next

local queryInput = catalogFrame.Query
local searchButton = catalogFrame.Search

local currentPage = 1
local previousPage = #Catalog.Categories 
local nextPage = 2

local layout = assetsFrame:FindFirstChild("UIGridLayout")
local layoutX = layout.AbsoluteCellSize.X + layout.CellPadding.X.Offset
local layoutY = layout.AbsoluteCellSize.y + layout.CellPadding.Y.Offset
local CELLS = math.floor(assetsFrame.AbsoluteSize.X/layoutX) * math.floor(assetsFrame.AbsoluteSize.y/layoutY)

local function clear()
	for _, child in assetsFrame:GetChildren() do
		if child.ClassName == "ImageButton" then
			child:Destroy()
		end
	end
end

--[[
local function showAllFromCategory()
	clear()
	
	previous.Text = Catalog.Categories[previousPage]["name"]
	nextB.Text = Catalog.Categories[nextPage]["name"]
	
	for _, id in Catalog.Categories[currentPage]["assets"] do
		local image = Instance.new("ImageLabel")
		image.Parent = assetsFrame
		image.Image = "rbxthumb://type=Asset&id="..id.."&w=150&h=150"
		image.BackgroundTransparency = 1
		image:SetAttribute("assetId", id)
	end
end]]


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

local function putOnClone(id)
	
end

--print(sortResults({1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }, 3))

local function searchCatalog(query)
	local category = Catalog.Categories[currentPage]
	return searchEvent:InvokeServer(category, query)
end

local function showPage(assets)
	for _, asset in assets do

		local id = asset["Id"]
		local image = Instance.new("ImageButton")
		image.Parent = assetsFrame
		image.Image = "rbxthumb://type=Asset&id="..id.."&w=150&h=150"
		image.BackgroundColor3 = Color3.fromRGB(219, 184, 255)
		image.BackgroundTransparency = 0
		image:SetAttribute("assetId", id)
		Instance.new("UICorner").Parent = image
		image.Activated:Connect(function ()
			putOnClone(id)
		end)
	end
end

local function search(query)
	clear()
	local results = searchCatalog(query)
	local sort = sortResults(results, CELLS)
	showPage(sort[1])
	return sort
end

local function passToSearch()
	search(queryInput.Text)
end

--local sort = search("")
searchButton.Activated:Connect(passToSearch)

local function goLeft()
	currentPage -= 1
	nextPage -= 1
	previousPage -= 1

	if currentPage <= 0  then
		currentPage = #Catalog.Categories
	end
	if previousPage <= 0 then 
		previousPage = #Catalog.Categories
	end
	if nextPage <= 0  then
		nextPage = #Catalog.Categories
	end

	search("")
end

local function goRight()
	currentPage += 1
	nextPage += 1 
	previousPage += 1

	if currentPage > #Catalog.Categories then
		currentPage = 1
	end
	if nextPage > #Catalog.Categories then
		nextPage = 1
	end
	if previousPage > #Catalog.Categories then
		previousPage = 1
	end

	search("")
end


--showAllFromCategory()
previous.Activated:Connect(goLeft)
nextB.Activated:Connect(goRight)

--[[
local function getSearch(id)
	local texture = GetId:InvokeServer(id)
	local image = Instance.new("ImageLabel")
	image.Parent = frame
	image.Image = texture
end

--getSearch(10370321127)

local function test(id)
	local image = Instance.new("ImageLabel")
	image.Parent = frame
	image.Image = "rbxthumb://type=Asset&id="..id.."&w=150&h=150"
	image.BackgroundTransparency = 1
end

local function show
test(10370321127)]]
