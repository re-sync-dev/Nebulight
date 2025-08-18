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

-- Main Module:
return {
	Ser = {
		Lighting = function(Config: Folder, Preset: Preset)
			local Lighting = Instance.new("Folder")
			Lighting.Name = "Lighting"
			Lighting.Parent = Config

			if Preset.Brightness then
				Set(Lighting, "Brightness", Preset.Brightness)
			end

			if Preset.Ambient then
				Set(Lighting, "Ambient", Preset.Ambient)
			end

			if Preset.OutdoorAmbient then
				Set(Lighting, "OutdoorAmbient", Preset.OutdoorAmbient)
			end

			if Preset.DiffuseScale then
				Set(Lighting, "DiffuseScale", Preset.DiffuseScale)
			end

			if Preset.SpecularScale then
				Set(Lighting, "SpecularScale", Preset.SpecularScale)
			end

			if Preset.ShadowSoftness then
				Set(Lighting, "ShadowSoftness", Preset.ShadowSoftness)
			end

			if Preset.Exposure then
				Set(Lighting, "Exposure", Preset.Exposure)
			end

			if Preset.GlobalShadows then
				Set(Lighting, "GlobalShadows", Preset.GlobalShadows)
			end

			if Preset.ColorShift then
				local ColorShift = Instance.new("Folder")
				ColorShift.Name = "ColorShift"
				ColorShift.Parent = Lighting

				if Preset.ColorShift.Top then
					Set(ColorShift, "Top", Preset.ColorShift.Top)
				end

				if Preset.ColorShift.Bottom then
					Set(ColorShift, "Bottom", Preset.ColorShift.Bottom)
				end

				if ColorShift:GetAttribute("Modified") then
					Lighting:SetAttribute("Modified", true)
				else
					ColorShift:Destroy()
				end
			end

			if Preset.Time then
				local Time = Instance.new("Folder")
				Time.Name = "Time"
				Time.Parent = Lighting

				if Preset.Time.Clock then
					Set(Time, "Clock", Preset.Time.Clock)
				end

				if Preset.Time.Latitude then
					Set(Time, "Latitude", Preset.Time.Latitude)
				end

				if Time:GetAttribute("Modified") then
					Lighting:SetAttribute("Modified", true)
				else
					Time:Destroy()
				end
			end

			if Preset.Fog then
				local Fog = Instance.new("Folder")
				Fog.Name = "Fog"
				Fog.Parent = Lighting

				if Preset.Fog.Color then
					Set(Fog, "Color", Preset.Fog.Color)
				end

				if Preset.Fog.Start then
					Set(Fog, "Start", Preset.Fog.Start)
				end

				if Preset.Fog.End then
					Set(Fog, "End", Preset.Fog.End)
				end

				if Fog:GetAttribute("Modified") then
					Lighting:SetAttribute("Modified", true)
				else
					Fog:Destroy()
				end
			end

			if not Lighting:GetAttribute("Modified") then
				Lighting:Destroy()
			end
		end,
		Sky = function(Config: Folder, Preset: Preset)
			local Skybox = Preset.Sky

			if not Skybox then
				return
			end

			local SkyboxRef = Instance.new("Folder")
			SkyboxRef.Name = "Sky"
			SkyboxRef.Parent = Config

			-- Skybox texture:
			for Key, Prop in
				{
					Top = "SkyboxUp",
					Bottom = "SkyboxDn",
					Left = "SkyboxLf",
					Right = "SkyboxRt",
					Front = "SkyboxFt",
					Back = "SkyboxBk",
				} :: { [string]: string }
			do
				Set(SkyboxRef, Key, Skybox[Key])
			end

			if Skybox.CelestialBodies ~= nil then
				Set(SkyboxRef, "CelestialBodies", Skybox.CelestialBodies)
			end

			if Skybox.Orientation then
				Set(SkyboxRef, "Orientation", Skybox.Orientation)
			end

			if Skybox.Moon then
				local MoonRef = Instance.new("Folder")
				MoonRef.Name = "Moon"
				MoonRef.Parent = Config

				if Skybox.Moon.Size then
					Set(MoonRef, "Size", Skybox.Moon.Size)
				end

				if Skybox.Moon.Texture then
					Set(MoonRef, "Texture", Skybox.Moon.Texture)
				end

				if MoonRef:GetAttribute("Modified") then
					SkyboxRef:SetAttribute("Modified", true)
				else
					MoonRef:Destroy()
				end
			end

			if Skybox.Sun then
				local SunRef = Instance.new("Folder")
				SunRef.Name = "Sun"
				SunRef.Parent = Config

				if Skybox.Sun.Size then
					Set(SunRef, "Size", Skybox.Sun.Size)
				end

				if Skybox.Sun.Texture then
					Set(SunRef, "Texture", Skybox.Sun.Texture)
				end

				if SunRef:GetAttribute("Modified") then
					SkyboxRef:SetAttribute("Modified", true)
				else
					SunRef:Destroy()
				end
			end

			if Skybox.StarCount then
				Set(SkyboxRef, "StarCount", Skybox.StarCount)
			end

			if not SkyboxRef:GetAttribute("Modified") then
				SkyboxRef:Destroy()
			end
		end,
		Atmosphere = function(Config: Folder, Preset: Preset)
			local Atmosphere = Preset.Atmosphere

			if not Atmosphere then
				return
			end

			local AtmosphereRef = Instance.new("Folder")
			AtmosphereRef.Name = "Atmosphere"
			AtmosphereRef.Parent = Config

			if Atmosphere.Density then
				Set(AtmosphereRef, "Density", Atmosphere.Density)
			end

			if Atmosphere.Offset then
				Set(AtmosphereRef, "Offset", Atmosphere.Offset)
			end

			if Atmosphere.Color then
				Set(AtmosphereRef, "Color", Atmosphere.Color)
			end

			if Atmosphere.Decay then
				Set(AtmosphereRef, "Decay", Atmosphere.Decay)
			end

			if Atmosphere.Glare then
				Set(AtmosphereRef, "Glare", Atmosphere.Glare)
			end

			if Atmosphere.Haze then
				Set(AtmosphereRef, "Haze", Atmosphere.Haze)
			end

			if not AtmosphereRef:GetAttribute("Modified") then
				AtmosphereRef:Destroy()
			end
		end,
		Bloom = function(Config: Folder, Preset: Preset)
			local Bloom = Preset.Bloom

			if not Bloom then
				return
			end

			local BloomRef = Instance.new("Folder")
			BloomRef.Name = "Bloom"
			BloomRef.Parent = Config

			if Bloom.Enabled ~= nil then
				Set(BloomRef, "Enabled", Bloom.Enabled)
			end

			if Bloom.Intensity then
				Set(BloomRef, "Intensity", Bloom.Intensity)
			end

			if Bloom.Size then
				Set(BloomRef, "Size", Bloom.Size)
			end

			if Bloom.Threshold then
				Set(BloomRef, "Threshold", Bloom.Threshold)
			end

			if not BloomRef:GetAttribute("Modified") then
				BloomRef:Destroy()
			end
		end,
		DepthOfField = function(Config: Folder, Preset: Preset)
			local DepthOfField = Preset.DepthOfField

			if not DepthOfField then
				return
			end

			local DepthOfFieldRef = Instance.new("Folder")
			DepthOfFieldRef.Name = "DepthOfField"
			DepthOfFieldRef.Parent = Config

			if DepthOfField.Enabled ~= nil then
				Set(DepthOfFieldRef, "Enabled", DepthOfField.Enabled)
			end

			if DepthOfField.FarIntensity then
				Set(DepthOfFieldRef, "FarIntensity", DepthOfField.FarIntensity)
			end

			if DepthOfField.FocusDistance then
				Set(DepthOfFieldRef, "FocusDistance", DepthOfField.FocusDistance)
			end

			if DepthOfField.InFocusRadius then
				Set(DepthOfFieldRef, "InFocusRadius", DepthOfField.InFocusRadius)
			end

			if DepthOfField.NearIntensity then
				Set(DepthOfFieldRef, "NearIntensity", DepthOfField.NearIntensity)
			end

			if not DepthOfFieldRef:GetAttribute("Modified") then
				DepthOfFieldRef:Destroy()
			end
		end,
		SunRays = function(Config: Folder, Preset: Preset)
			local SunRays = Preset.SunRays

			if not SunRays then
				return
			end

			local SunRaysRef = Instance.new("Folder")
			SunRaysRef.Name = "SunRays"
			SunRaysRef.Parent = Config

			if SunRays.Enabled ~= nil then
				Set(SunRaysRef, "Enabled", SunRays.Enabled)
			end

			if SunRays.Intensity then
				Set(SunRaysRef, "Intensity", SunRays.Intensity)
			end

			if SunRays.Spread then
				Set(SunRaysRef, "Spread", SunRays.Spread)
			end

			if not SunRaysRef:GetAttribute("Modified") then
				SunRaysRef:Destroy()
			end
		end,
		Blur = function(Config: Folder, Preset: Preset)
			local Blur = Preset.Blur

			if not Blur then
				return
			end

			local BlurRef = Instance.new("Folder")
			BlurRef.Name = "Blur"
			BlurRef.Parent = Config

			if Blur.Enabled ~= nil then
				Set(BlurRef, "Enabled", Blur.Enabled)
			end

			if Blur.Size then
				Set(BlurRef, "Size", Blur.Size)
			end

			if not BlurRef:GetAttribute("Modified") then
				BlurRef:Destroy()
			end
		end,
		ColorCorrection = function(Config: Folder, Preset: Preset)
			local ColorCorrection = Preset.ColorCorrection

			if not ColorCorrection then
				return
			end

			local ColorCorrectionRef = Instance.new("Folder")
			ColorCorrectionRef.Name = "ColorCorrection"
			ColorCorrectionRef.Parent = Config

			if ColorCorrection.Enabled ~= nil then
				Set(ColorCorrectionRef, "Enabled", ColorCorrection.Enabled)
			end

			if ColorCorrection.Brightness then
				Set(ColorCorrectionRef, "Brightness", ColorCorrection.Brightness)
			end

			if ColorCorrection.Contrast then
				Set(ColorCorrectionRef, "Contrast", ColorCorrection.Contrast)
			end

			if ColorCorrection.Saturation then
				Set(ColorCorrectionRef, "Saturation", ColorCorrection.Saturation)
			end

			if ColorCorrection.TintColor then
				Set(ColorCorrectionRef, "TintColor", ColorCorrection.TintColor)
			end

			if not ColorCorrectionRef:GetAttribute("Modified") then
				ColorCorrectionRef:Destroy()
			end
		end,
		ColorGrading = function(Config: Folder, Preset: Preset)
			local ColorGrading = Preset.ColorGrading

			if not ColorGrading then
				return
			end

			local ColorGradingRef = Instance.new("Folder")
			ColorGradingRef.Name = "ColorGrading"
			ColorGradingRef.Parent = Config

			if ColorGrading.Enabled ~= nil then
				Set(ColorGradingRef, "Enabled", ColorGrading.Enabled)
			end

			if ColorGrading.Preset then
				Set(ColorGradingRef, "Preset", ColorGrading.Preset)
			end

			if not ColorGradingRef:GetAttribute("Modified") then
				ColorGradingRef:Destroy()
			end
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

				Moon = (Ref:FindFirstChild("Moon") and Get(Ref, "CelestialBodiesShown")) and {
					Texture = Get(Ref.Moon, "Texture"),
					Size = Get(Ref.Moon, "Size"),
				} or nil,

				Sun = (Ref:FindFirstChild("Sun") and Get(Ref, "CelestialBodiesShown")) and {
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
