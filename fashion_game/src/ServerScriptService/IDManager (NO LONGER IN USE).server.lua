local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ModuleScripts = ServerStorage.ModuleScripts
--local MainModule = require(ModuleScripts.MainModule)

local ClientEvents = ReplicatedStorage.ClientEvents

local function testID(player, id)
	local InsertService = game:GetService("InsertService")
	local model = InsertService:LoadAsset(id)
	model.Parent = workspace
	local mesh = model:FindFirstChild("Mesh", true) or model:FindFirstChild("SpecialMesh", true)
	local tex = mesh.TextureId
	return tex
end

--[[
local function search(player, query, category, sortType)
	query = query or ""
	category = category or 1
	sortType = sortType or 1
	
	local textures = {}
	local assets = MainModule.Search(query, category, sortType)
	for _, asset in assets do
		local id = asset.data.id
		table.insert(textures, testID(id))
	end
	return {textures, assets}
end
]]

--print(MainModule.Search("christmas"))

