local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AvatarEditorService = game:GetService("AvatarEditorService")
local AssetService = game:GetService("AssetService")

local ClientEvents = ReplicatedStorage.ClientEvents
local loadAssetEvent = ClientEvents.LoadAsset
local searchCatalog = ClientEvents.Search
local getBundleEvent = ClientEvents.GetBundleId
local setSkinColor = ClientEvents.SetColor
local addAccessory = ClientEvents.AddAccessory
local getInfo = ClientEvents.GetInfo
local changeSize = ClientEvents.ChangeSize

local ModuleScripts = ReplicatedStorage.ModuleScripts
local Catalog = require(ModuleScripts.Catalog)

local function getVariables(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character.Humanoid
	local description = humanoid:GetAppliedDescription()

	return humanoid, description
end

local function createModel(player, id)
	local model = InsertService:LoadAsset(id)
	model.Parent = workspace
	return model
end

setSkinColor.OnServerInvoke = function(player, color)
	local humanoid, description = getVariables(player)

	description.HeadColor = color
	description.LeftArmColor = color
	description.RightArmColor = color
	description.LeftLegColor = color
	description.RightLegColor = color
	description.TorsoColor = color
	humanoid:ApplyDescriptionReset(description) 
	return true
end

changeSize.OnServerInvoke = function(player, size)
	local humanoid, description = getVariables(player)
	
	if (description.BodyTypeScale > 0  and size < 0) or (description.BodyTypeScale < 1 and size > 0) then
		description.BodyTypeScale += size
		humanoid:ApplyDescriptionReset(description)
		return true
	else return false
	end
end

local function getTypeName(assetTypeId)
	for i, v in Enum.AssetType:GetEnumItems() do
		if v.Value == assetTypeId then
			return v.Name
		end
	end
end
getInfo.OnServerInvoke = function(player, id)
	local MarketPlaceService = game:GetService("MarketplaceService")
	local info = MarketPlaceService:GetProductInfo(id)
	local index = info["AssetTypeId"]
	return {Id = info["AssetId"], AssetType = getTypeName(index)}

end

addAccessory.OnServerInvoke = function(player, id, assetType)
	local humanoid, description = getVariables(player)
	-- Fix ROBLOX Formatting Errors
	if assetType == "Hat" then
		assetType = "HatAccessory"
	elseif assetType == "ShoulderAccessory" then
		assetType = "ShouldersAccessory"
	end
	-- Accessory Handling
	if string.find(assetType, "Accessory") then
		local checkType = pcall(function()
			if not description[assetType] then
				assetType = "NeckAccessory"
			end
		end)
		-- Change assetType for non-built-in accessories
		if not checkType then
			assetType = "NeckAccessory"
		end

		local accessories = string.split(description[assetType], ",")
		local index = table.find(accessories, tostring(id))
		-- Clear accessory
		if index then
			table.remove(accessories, index)
		elseif #humanoid:GetAccessories() < Catalog.Settings.MAX_ACCESSORIES then
			-- Check if accessory is non-rigid and remove if it already exists
			local getAcc = description:GetAccessories(true)
			local found = false
			for i, acc in getAcc do
				if acc["AssetId"] == id then
					table.remove(getAcc, i)
					description:SetAccessories(getAcc, true)
					found = true
					break
				end
			end
			-- Add accessory to humanoid description if it doesn't exist
			if not found then
				table.insert(accessories, tostring(id))
			end
		else
			print(player, "tried to wear too many accessories")
		end
		-- Save to humanoid description
		description[assetType] = table.concat(accessories, ",")
	-- Handle non-accessory assets
	else
		if description[assetType] == id then
			description[assetType] = 0 -- Remove and set to default
		else
			description[assetType] = id -- Set to id
		end
	end
	-- Apply description to humanoid
	humanoid:ApplyDescriptionReset(description) 
	return true
end


local catalogSearchParams = CatalogSearchParams.new()

-- Category is passed in from catalog
searchCatalog.OnServerInvoke = function(player, category, query, page)
	local catalogSearchParams = CatalogSearchParams.new()
	--[[if category["bundleType"] then
		catalogSearchParams.BundleTypes = category["bundleType"]]
	if category["assetTypes"] then
		catalogSearchParams.AssetTypes = category["assetTypes"]
	else
		error("Category does not have an assettype or bundletype: ")
	end
	if query then
		catalogSearchParams.SearchKeyword = query
	end
	catalogSearchParams.IncludeOffSale = true
	local search = AvatarEditorService:SearchCatalog(catalogSearchParams)
	for n = 1, page do
		search:AdvanceToNextPageAsync()
	end
	print(search:GetCurrentPage())
	return search:GetCurrentPage()
end

-- Returns Outfit from Bundle
local function getBundleInfo(player, id)
	local details = AssetService:GetBundleDetailsAsync(id)
	for _, asset in details.Items  do
		if asset.Type == "UserOutfit" then
			return asset.Id
		end
	end
end

loadAssetEvent.OnServerInvoke = createModel
getBundleEvent.OnServerInvoke = getBundleInfo

