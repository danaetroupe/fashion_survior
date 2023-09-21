local Catalog = {}

Catalog.Hats = {
	name = "Hats",
	assetTypes = {Enum.AvatarAssetType.Hat},
}

Catalog.Shirts = {
	name = "Shirts",
	assetTypes = {Enum.AvatarAssetType.ShirtAccessory, Enum.AvatarAssetType.Shirt, Enum.AvatarAssetType.JacketAccessory,
		Enum.AvatarAssetType.SweaterAccessory
	}
}

Catalog.Pants = {
	name = "Pants",
	assetTypes = {Enum.AvatarAssetType.Pants, Enum.AvatarAssetType.PantsAccessory, 
		Enum.AvatarAssetType.ShortsAccessory},
}

Catalog.Shoes = {
	name = "Shoes",
	assetTypes = {Enum.AvatarAssetType.LeftShoeAccessory, Enum.AvatarAssetType.RightShoeAccessory}
}

Catalog.Dresses = {
	name = "Dresses",
	assetTypes = {Enum.AvatarAssetType.DressSkirtAccessory}
}

Catalog.Hair = {
	name = "Hair",
	assetTypes = {Enum.AvatarAssetType.HairAccessory}
}

Catalog.Accessories = {
	name = "Accessories",
	assetTypes = {Enum.AvatarAssetType.NeckAccessory, Enum.AvatarAssetType.ShoulderAccessory, 
		Enum.AvatarAssetType.FrontAccessory, Enum.AvatarAssetType.BackAccessory,
		Enum.AvatarAssetType.WaistAccessory, Enum.AvatarAssetType.FaceAccessory
	}
}

Catalog.Faces = {
	name = "Faces",
	assetTypes = {Enum.AvatarAssetType.Face}
}

Catalog.Body = {
	name = "Body",
	assetTypes = {Enum.AvatarAssetType.Torso, Enum.AvatarAssetType.Head, Enum.AvatarAssetType.RightArm,
		Enum.AvatarAssetType.RightLeg, Enum.AvatarAssetType.LeftArm, Enum.AvatarAssetType.LeftLeg
	}
}

Catalog.Categories = {
	Catalog.Hats, Catalog. Shirts, Catalog.Faces, Catalog.Hair, 
	Catalog.Pants, Catalog.Dresses, Catalog.Accessories, Catalog.Dresses
}

Catalog.Settings = {
	MAX_ACCESSORIES = 10,
	MAX_CAT_DISPLAY = 5,
	TOTAL_TIME = 180
}



Catalog.SkinColors = {
	{255, 245, 223}, {255, 221, 196}, {255, 217,174}, {255, 203, 147}, {246, 226, 172}, {255, 216, 185}, {238, 194, 168},
	{220, 183, 139}, {243, 183, 141}, {231, 173, 134}, {228, 171, 132}, {205, 154, 119}, {202, 149, 117}, {214, 139, 98},
	{204, 138, 111}, {196, 139, 105}, {198, 127, 90}, {180, 113, 81}, {164, 103, 74}, {147, 92, 65}, {134, 85, 60}, {165, 115, 88}, 
	{152, 105, 81}, {142, 100, 77}, {134, 85, 60}, {137, 58, 46}, {136, 65, 67}, {145, 52, 0}, {109, 68, 49}, {88, 53, 39},
	{76, 46, 33}, {65, 39, 28}, {255, 198, 237}, {150, 254, 255}, {180, 255, 201}, {214, 201, 255}, {255, 0, 0}, {21, 38, 137}, 
	{0, 255, 132}, {204, 97, 255}, {225, 225, 225}, {179, 179, 179}, {132, 132, 132}, {0, 0, 0}
}

return Catalog
