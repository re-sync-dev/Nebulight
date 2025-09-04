--!optimize 1
--[==[

	[Instance.luau]:
		Functions to serialize and deserialize PresetConfig instances

	[Author(s)]:
		- Vyon (https://github.com/Vyon)

--]==]

-- Modules:
local Types = require(script.Parent.Parent.Types)

-- Types:
type Preset = Types.Preset

-- Functions:
local function Get(Parent: Instance, Name: string): any?
	local Child = Parent:FindFirstChild(Name)

	if not Child then
		return nil
	end

	return (Child :: { Value: any }).Value
end

local function Set(Parent: Instance, Name: string, Value: any)
	local Class
	local Type = typeof(Value)

	if Type == "string" then
		Class = "StringValue"
	elseif Type == "number" then
		Class = "NumberValue"
	elseif Type == "boolean" then
		Class = "BoolValue"
	elseif Type == "Color3" then
		Class = "Color3Value"
	elseif Type == "Vector3" then
		Class = "Vector3Value"
	elseif Type == "EnumItem" then
		Class = "StringValue"
		Value = Value.Name --> Enums will be manually converted back in des process
	else
		error(`Unknown value type: {Type}`)
	end

	local Ref = Instance.new(Class)
	Ref.Name = Name
	Ref.Value = Value
	Ref.Parent = Parent

	Parent:SetAttribute("Modified", true)
end

local function CreateProps(Name: string, Parent: Instance, Props: { [string]: any })
	local Folder = Instance.new("Folder")
	Folder.Name = Name
	Folder.Parent = Parent

	for Key, Value in Props do
		if type(Value) == "table" then
			local SubFolder = CreateProps(Key, Folder, Value)

			if SubFolder then
				Folder:SetAttribute("Modified", true)
			end
		else
			Set(Folder, Key, Value)
			Folder:SetAttribute("Modified", true)
		end
	end

	if Folder:GetAttribute("Modified") then
		Folder:SetAttribute("Modified", nil)
	else
		Folder:Destroy()
		Folder = nil
	end

	return Folder
end

-- Main Module:
return {
	Ser = {
		Lighting = function(Config: Folder, Preset: Preset)
			CreateProps("Lighting", Config, {
				["Ambient"] = Preset.Ambient,
				["Brightness"] = Preset.Brightness,
				["ColorShift"] = Preset.ColorShift,
				["DiffuseScale"] = Preset.DiffuseScale,
				["SpecularScale"] = Preset.SpecularScale,
				["GlobalShadows"] = Preset.GlobalShadows,
				["OutdoorAmbient"] = Preset.OutdoorAmbient,
				["ShadowSoftness"] = Preset.ShadowSoftness,
				["Time"] = Preset.Time,
				["Exposure"] = Preset.Exposure,
				["Fog"] = Preset.Fog,
			})
		end,
		Sky = function(Config: Folder, Preset: Preset)
			local Sky = Preset.Sky

			if not Sky then
				return
			end

			CreateProps("Sky", Config, {
				["Sun"] = Sky.Sun,
				["Top"] = Sky.Top,
				["Moon"] = Sky.Moon,
				["Left"] = Sky.Left,
				["Back"] = Sky.Back,
				["Right"] = Sky.Right,
				["Front"] = Sky.Front,
				["Bottom"] = Sky.Bottom,
				["StarCount"] = Sky.StarCount,
				["Orientation"] = Sky.Orientation,
				["CelestialBodies"] = Sky.CelestialBodies,
			})
		end,
		Atmosphere = function(Config: Folder, Preset: Preset)
			local Atmosphere = Preset.Atmosphere

			if not Atmosphere then
				return
			end

			CreateProps("Atmosphere", Config, {
				["Density"] = Atmosphere.Density,
				["Offset"] = Atmosphere.Offset,
				["Color"] = Atmosphere.Color,
				["Decay"] = Atmosphere.Decay,
				["Glare"] = Atmosphere.Glare,
				["Haze"] = Atmosphere.Haze,
			})
		end,
		Bloom = function(Config: Folder, Preset: Preset)
			local Bloom = Preset.Bloom

			if not Bloom then
				return
			end

			CreateProps("Bloom", Config, {
				["Enabled"] = Bloom.Enabled,
				["Intensity"] = Bloom.Intensity,
				["Size"] = Bloom.Size,
				["Threshold"] = Bloom.Threshold,
			})
		end,
		DepthOfField = function(Config: Folder, Preset: Preset)
			local DepthOfField = Preset.DepthOfField

			if not DepthOfField then
				return
			end

			CreateProps("DepthOfField", Config, {
				["Enabled"] = DepthOfField.Enabled,
				["FarIntensity"] = DepthOfField.FarIntensity,
				["FocusDistance"] = DepthOfField.FocusDistance,
				["InFocusRadius"] = DepthOfField.InFocusRadius,
				["NearIntensity"] = DepthOfField.NearIntensity,
			})
		end,
		SunRays = function(Config: Folder, Preset: Preset)
			local SunRays = Preset.SunRays

			if not SunRays then
				return
			end

			CreateProps("SunRays", Config, {
				["Enabled"] = SunRays.Enabled,
				["Intensity"] = SunRays.Intensity,
				["Spread"] = SunRays.Spread,
			})
		end,
		Blur = function(Config: Folder, Preset: Preset)
			local Blur = Preset.Blur

			if not Blur then
				return
			end

			CreateProps("Blur", Config, {
				["Enabled"] = Blur.Enabled,
				["Size"] = Blur.Size,
			})
		end,
		ColorCorrection = function(Config: Folder, Preset: Preset)
			local ColorCorrection = Preset.ColorCorrection

			if not ColorCorrection then
				return
			end

			CreateProps("ColorCorrection", Config, {
				["Enabled"] = ColorCorrection.Enabled,
				["Brightness"] = ColorCorrection.Brightness,
				["Contrast"] = ColorCorrection.Contrast,
				["Saturation"] = ColorCorrection.Saturation,
				["TintColor"] = ColorCorrection.TintColor,
			})
		end,
		ColorGrading = function(Config: Folder, Preset: Preset)
			local ColorGrading = Preset.ColorGrading

			if not ColorGrading then
				return
			end

			CreateProps("ColorGrading", Config, {
				["Enabled"] = ColorGrading.Enabled,
				["Preset"] = ColorGrading.Preset,
			})
		end,
	} :: { [string]: (Config: Folder, Preset: Preset) -> () },
	Des = {
		Lighting = function(
			Ref: Folder & {
				ColorShift: Folder,
				Time: Folder,
				Fog: Folder,
			},
			Preset: Preset
		)
			Preset.Brightness = Get(Ref, "Brightness")
			Preset.Ambient = Get(Ref, "Ambient")
			Preset.OutdoorAmbient = Get(Ref, "OutdoorAmbient")
			Preset.ColorShift = Ref:FindFirstChild("ColorShift")
					and {
						Top = Get(Ref.ColorShift, "Top"),
						Bottom = Get(Ref.ColorShift, "Bottom"),
					}
				or nil
			Preset.DiffuseScale = Get(Ref, "DiffuseScale")
			Preset.SpecularScale = Get(Ref, "SpecularScale")
			Preset.ShadowSoftness = Get(Ref, "ShadowSoftness")
			Preset.Exposure = Get(Ref, "Exposure")
			Preset.GlobalShadows = Get(Ref, "GlobalShadows")
			Preset.Time = Ref:FindFirstChild("Time")
					and {
						Clock = Get(Ref.Time, "Clock"),
						Latitude = Get(Ref.Time, "Latitude"),
					}
				or nil
			Preset.Fog = Ref:FindFirstChild("Fog")
					and {
						Color = Get(Ref.Fog, "Color"),
						Start = Get(Ref.Fog, "Start"),
						End = Get(Ref.Fog, "End"),
					}
				or nil
		end,
		Sky = function(
			Ref: Folder & {
				Sun: Folder,
				Moon: Folder,
			},
			Preset: Preset
		)
			Preset.Sky = {
				Top = Get(Ref, "Top"),
				Bottom = Get(Ref, "Bottom"),
				Left = Get(Ref, "Left"),
				Right = Get(Ref, "Right"),
				Front = Get(Ref, "Front"),
				Back = Get(Ref, "Back"),
				CelestialBodies = Get(Ref, "CelestialBodies"),
				StarCount = Get(Ref, "StarCount"),

				Orientation = Get(Ref, "Orientation"),

				Moon = (Ref:FindFirstChild("Moon") and Get(Ref, "CelestialBodies")) and {
					Texture = Get(Ref.Moon, "Texture"),
					Size = Get(Ref.Moon, "Size"),
				} or nil,

				Sun = (Ref:FindFirstChild("Sun") and Get(Ref, "CelestialBodies")) and {
					Texture = Get(Ref.Sun, "Texture"),
					Size = Get(Ref.Sun, "Size"),
				} or nil,
			}
		end,
		Atmosphere = function(Ref: Folder, Preset: Preset)
			Preset.Atmosphere = {
				Density = Get(Ref, "Density"),
				Offset = Get(Ref, "Offset"),
				Color = Get(Ref, "Color"),
				Decay = Get(Ref, "Decay"),
				Glare = Get(Ref, "Glare"),
				Haze = Get(Ref, "Haze"),
			}

			Preset.Fog = nil --> Atmosphere 'cancels out' fog to my knowledge
		end,
		Bloom = function(Ref: Folder, Preset: Preset)
			Preset.Bloom = {
				Enabled = Get(Ref, "Enabled"),
				Intensity = Get(Ref, "Intensity"),
				Size = Get(Ref, "Size"),
				Threshold = Get(Ref, "Threshold"),
			}
		end,
		DepthOfField = function(Ref: Folder, Preset: Preset)
			Preset.DepthOfField = {
				Enabled = Get(Ref, "Enabled"),
				FarIntensity = Get(Ref, "FarIntensity"),
				FocusDistance = Get(Ref, "FocusDistance"),
				InFocusRadius = Get(Ref, "InFocusRadius"),
				NearIntensity = Get(Ref, "NearIntensity"),
			}
		end,
		SunRays = function(Ref: Folder, Preset: Preset)
			Preset.SunRays = {
				Enabled = Get(Ref, "Enabled"),
				Intensity = Get(Ref, "Intensity"),
				Spread = Get(Ref, "Spread"),
			}
		end,
		Blur = function(Ref: Folder, Preset: Preset)
			Preset.Blur = {
				Enabled = Get(Ref, "Enabled"),
				Size = Get(Ref, "Size"),
			}
		end,
		ColorCorrection = function(Ref: Folder, Preset: Preset)
			Preset.ColorCorrection = {
				Enabled = Get(Ref, "Enabled"),
				Brightness = Get(Ref, "Brightness"),
				Contrast = Get(Ref, "Contrast"),
				Saturation = Get(Ref, "Saturation"),
				TintColor = Get(Ref, "TintColor"),
			}
		end,
		ColorGrading = function(Ref: Folder, Preset: Preset)
			Preset.ColorGrading = {
				Enabled = Get(Ref, "Enabled"),
				Preset = Enum.TonemapperPreset[Get(Ref, "Preset") or "Default"],
			}
		end,
	},
}
