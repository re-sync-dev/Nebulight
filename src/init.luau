--[==[

	[init.luau]:
		Nebulight is an open source lighting preset creation and application library for Roblox

	[Author(s)]:
		- Vyon (https://github.com/Vyon)

--]==]

-- Services:
local Lighting = game:GetService("Lighting")

-- Modules:
local Types = require(script.Types)
local SerDes = require(script.SerDes)
local PrettyPrint = require(script.PrettyPrint)

-- Types:
--[=[

	@within Nebulight
	@interface Preset
	TODO: Fill out

]=]
export type Preset = Types.Preset

-- Constants:
local SER_KEYS =
	{ "Lighting", "Sky", "Atmosphere", "Bloom", "DepthOfField", "SunRays", "Blur", "ColorCorrection", "ColorGrading" }

-- Main Module:
--[=[

	@class Nebulight
	Nebulight is an open source lighting preset creation and application library for Roblox

--]=]
local Nebulight = {}

--[=[

	@within Nebulight
	TODO: Add description
	
	@function CreatePreset
	@return Preset

]=]
function Nebulight.CreatePreset()
	local Preset: Preset = {}

	SerDes.Lighting.Des.Lighting(Lighting, Preset)

	for _, Child in Lighting:GetChildren() do
		local ClassName = Child.ClassName

		if ClassName:match("Effect$") then
			ClassName = ClassName:sub(1, -7) --> Imo having this in the code would be dumb
		end

		if not SerDes.Lighting.Des[ClassName] then
			warn(`[Nebulight.CreatePreset]: {ClassName} is not deserializable`)
			continue
		end

		SerDes.Lighting.Des[ClassName](Child, Preset)
	end

	return Preset
end

--[=[

	@within Nebulight
	TODO: Add description
	
	@function CreateFromConfig
	@param Config Folder

	@return Preset

]=]
function Nebulight.CreateFromConfig(Config: Folder): Preset
	local Preset = {}

	for _, Child in Config:GetChildren() do
		if not table.find(SER_KEYS, Child.Name) then --> Sanity check
			continue
		end

		local Func = SerDes.Instance.Des[Child.Name]

		if not Func then
			warn(`[Nebulight.CreateFromConfig]: Deserialize function does not exist for '{Child.Name}'`)
			continue
		end

		Func(Child, Preset)
	end

	return Preset
end

--[=[

	@within Nebulight
	TODO: Add description

	@function UsePreset
	@param Preset Preset
	@param SkyOnly boolean?

]=]
function Nebulight.UsePreset(Preset: Preset, SkyOnly: boolean?)
	SerDes.Lighting.Ser.Sky(Lighting, Preset)

	if SkyOnly then
		return
	end

	for _, Key in SER_KEYS do
		if Key == "Sky" then
			continue --> Already did it :)
		end

		local Func = SerDes.Lighting.Ser[Key]

		if not Func then
			warn(`[Nebulight.UsePreset]: Serialize function does not exist for '{Key}'`)
			continue
		end

		Func(Lighting, Preset)
	end
end

--[=[

	@within Nebulight
	TODO: Add description

	@function SaveAsModule
	@param Preset Preset
	@param Minify boolean?

	@return string

]=]
function Nebulight.SaveAsModule(Preset: Preset, Minify: boolean?)
	return PrettyPrint(Preset, {
		minify = Minify,
	})
end

--[=[

	@within Nebulight
	TODO: Add description

	@function SaveAsConfig
	@param Preset Preset

	@return Instance

]=]
function Nebulight.SaveAsConfig(Preset: Preset)
	local Config = Instance.new("Folder")
	Config.Name = "Config"

	for _, Key in SER_KEYS do
		local Func = SerDes.Instance.Ser[Key]

		if not Func then
			warn(`[Nebulight.SaveAsConfig]: Serialize function does not exist for '{Key}'`)
			continue
		end

		Func(Config, Preset)
	end

	return Config
end

return Nebulight
