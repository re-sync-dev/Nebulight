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
export type Preset = Types.Preset

-- Constants:
local SER_KEYS =
	{ "Lighting", "Sky", "Atmosphere", "Bloom", "DepthOfField", "SunRays", "Blur", "ColorCorrection", "ColorGrading" }

-- Main Module:
--[=[

	@class Nebulight
	Nebulight is an open source lighting preset creation and application library for Roblox

]=]
local Nebulight = {}

--[=[

	@within Nebulight
	@interface Preset
	.Brightness number?,
	.Ambient Color3?,
	.OutdoorAmbient Color3?,
	.ColorShift { Top: Color3?, Bottom: Color3? }?,
	.DiffuseScale number?,
	.SpecularScale number?,
	.ShadowSoftness number?,
	.Exposure number?,
	.GlobalShadows boolean?,
	.Time { Clock: number?, Latitude: number? }?,
	.Fog { Color: Color3?, Start: number?, End: number? }?,
	.Sky { Top: string, Bottom: string, Left: string, Right: string, Front: string, Back: string, CelestialBodies: boolean?, StarCount: number?, Orientation: Vector3?, Moon: { Texture: string?, Size: number? }?, Sun: { Texture: string?, Size: number? }? }?,
	.Atmosphere { Density: number?, Offset: number?, Color: Color3?, Decay: Color3?, Glare: number?, Haze: number? }?,
	.Bloom { Enabled: boolean?, Intensity: number?, Size: number?, Threshold: number? }?,
	.DepthOfField { Enabled: boolean?, FarIntensity: number?, FocusDistance: number?, InFocusRadius: number?, NearIntensity: number? }?,
	.SunRays { Enabled: boolean?, Intensity: number?, Spread: number? }?,
	.Blur { Enabled: boolean?, Size: number? }?,
	.ColorCorrection: { Enabled: boolean?, Brightness: number?, Contrast: number?, Saturation: number?, TintColor: Color3? }?,
	.ColorGrading { Enabled: boolean?, Preset: Enum.TonemapperPreset? }?,
]=]

--[=[

	@within Nebulight
	Creates a preset from the game's current lighting
	
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
	Converts a Folder into a Preset object
	
	@function CreateFromConfig
	@param Config Folder

	@return (Preset, boolean)

]=]
function Nebulight.CreateFromConfig(Config: Folder): (Preset, boolean)
	local Preset = {}
	local DidCreate = false

	for _, Child in Config:GetChildren() do
		if not table.find(SER_KEYS, Child.Name) then --> Sanity check
			continue
		end

		local Func = SerDes.Instance.Des[Child.Name]

		if not Func then
			warn(`[Nebulight.CreateFromConfig]: Deserialize function does not exist for '{Child.Name}'`)
			continue
		end

		DidCreate = true --> Even though it may not create anything in the des function, we'll still mark it because at least something was found
		Func(Child, Preset)
	end

	return Preset, DidCreate
end

--[=[

	@within Nebulight
	Applies the properties and classes to the Lighting

	@function UsePreset
	@param Preset Preset
	@param SkyOnly boolean?
	@param Info TweenInfo?

]=]
function Nebulight.UsePreset(Preset: Preset, SkyOnly: boolean?, Info: TweenInfo?)
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

		Func(Lighting, Preset, Info)
	end
end

--[=[

	@within Nebulight
	Converts the preset into a stringified version by pretty printing it.
	Optionally the preset can be minified.

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
	Converts the Preset into an instance based format

	@function SaveAsConfig
	@param Preset Preset

	@return Folder

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
