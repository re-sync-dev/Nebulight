--!optimize 1
--[==[

	[Lighting.luau]:
		SerDes functions specifically for actual lighting instances

	[Author(s)]:
		- Vyon (https://github.com/Vyon)

--]==]

-- Modules:
local Types = require(script.Parent.Parent.Types)
local SetProperties = require(script.Parent.Parent.SetProperties)

-- Types:
type Preset = Types.Preset

-- Main Module:
return {
	Ser = {
		Lighting = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			SetProperties(Lighting, {
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
			}, Info)
		end,
		Sky = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local Sky = Preset.Sky
			local SkyRef = (Lighting:FindFirstChild("Sky") :: any) :: Sky?

			if Sky then
				if not SkyRef then
					SkyRef = Instance.new("Sky")
					SkyRef.Parent = Lighting
				end

				SetProperties(SkyRef, {
					["Sun"] = Sky.Sun,
					["Moon"] = Sky.Moon,
					["Top"] = Sky.Top,
					["Left"] = Sky.Left,
					["Back"] = Sky.Back,
					["Right"] = Sky.Right,
					["Front"] = Sky.Front,
					["Bottom"] = Sky.Bottom,
					["StarCount"] = Sky.StarCount,
					["Orientation"] = Sky.Orientation,
					["CelestialBodies"] = Sky.CelestialBodies,
				}, Info)
			else
				if SkyRef then
					SkyRef:Destroy()
				end
			end
		end,
		Atmosphere = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local Atmosphere = Preset.Atmosphere
			local AtmosphereRef = (Lighting:FindFirstChild("Atmosphere") :: any) :: Atmosphere?

			if Atmosphere then
				if not AtmosphereRef then
					AtmosphereRef = Instance.new("Atmosphere")
					AtmosphereRef.Parent = Lighting
				end

				SetProperties(AtmosphereRef, {
					["Density"] = Atmosphere.Density,
					["Offset"] = Atmosphere.Offset,
					["Color"] = Atmosphere.Color,
					["Decay"] = Atmosphere.Decay,
					["Glare"] = Atmosphere.Glare,
					["Haze"] = Atmosphere.Haze,
				}, Info)
			else
				if AtmosphereRef then
					AtmosphereRef:Destroy()
				end
			end
		end,
		Bloom = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local Bloom = Preset.Bloom
			local BloomRef = (Lighting:FindFirstChild("Bloom") :: any) :: BloomEffect?

			if Bloom then
				if not BloomRef then
					BloomRef = Instance.new("BloomEffect")
					BloomRef.Parent = Lighting
				end

				SetProperties(BloomRef, {
					["Enabled"] = Bloom.Enabled,
					["Intensity"] = Bloom.Intensity,
					["Size"] = Bloom.Size,
					["Threshold"] = Bloom.Threshold,
				}, Info)
			else
				if BloomRef then
					BloomRef:Destroy()
				end
			end
		end,
		DepthOfField = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local DepthOfField = Preset.DepthOfField
			local DepthOfFieldRef = (Lighting:FindFirstChild("DepthOfField") :: any) :: DepthOfFieldEffect?

			if DepthOfField then
				if not DepthOfFieldRef then
					DepthOfFieldRef = Instance.new("DepthOfFieldEffect")
					DepthOfFieldRef.Parent = Lighting
				end

				SetProperties(DepthOfFieldRef, {
					["Enabled"] = DepthOfField.Enabled,
					["FarIntensity"] = DepthOfField.FarIntensity,
					["FocusDistance"] = DepthOfField.FocusDistance,
					["InFocusRadius"] = DepthOfField.InFocusRadius,
					["NearIntensity"] = DepthOfField.NearIntensity,
				}, Info)
			else
				if DepthOfFieldRef then
					DepthOfFieldRef:Destroy()
				end
			end
		end,
		SunRays = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local SunRays = Preset.SunRays
			local SunRaysRef = (Lighting:FindFirstChild("SunRays") :: any) :: SunRaysEffect?

			if SunRays then
				if not SunRaysRef then
					SunRaysRef = Instance.new("SunRaysEffect")
					SunRaysRef.Parent = Lighting
				end

				SetProperties(SunRaysRef, {
					["Enabled"] = SunRays.Enabled,
					["Intensity"] = SunRays.Intensity,
					["Spread"] = SunRays.Spread,
				}, Info)
			else
				if SunRaysRef then
					SunRaysRef:Destroy()
				end
			end
		end,
		Blur = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local Blur = Preset.Blur
			local BlurRef = (Lighting:FindFirstChild("Blur") :: any) :: BlurEffect?

			if Blur then
				if not BlurRef then
					BlurRef = Instance.new("BlurEffect")
					BlurRef.Parent = Lighting
				end

				SetProperties(BlurRef, {
					["Enabled"] = Blur.Enabled,
					["Size"] = Blur.Size,
				}, Info)
			else
				if BlurRef then
					BlurRef:Destroy()
				end
			end
		end,
		ColorCorrection = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local ColorCorrection = Preset.ColorCorrection
			local ColorCorrectionRef = (Lighting:FindFirstChild("ColorCorrection") :: any) :: ColorCorrectionEffect?

			if ColorCorrection then
				if not ColorCorrectionRef then
					ColorCorrectionRef = Instance.new("ColorCorrectionEffect")
					ColorCorrectionRef.Parent = Lighting
				end

				SetProperties(ColorCorrectionRef, {
					["Enabled"] = ColorCorrection.Enabled,
					["Brightness"] = ColorCorrection.Brightness,
					["Contrast"] = ColorCorrection.Contrast,
					["Saturation"] = ColorCorrection.Saturation,
					["TintColor"] = ColorCorrection.TintColor,
				}, Info)
			else
				if ColorCorrectionRef then
					ColorCorrectionRef:Destroy()
				end
			end
		end,
		ColorGrading = function(Lighting: Lighting, Preset: Preset, Info: TweenInfo?)
			local ColorGrading = Preset.ColorGrading
			local ColorGradingRef = (Lighting:FindFirstChild("ColorGrading") :: any) :: ColorGradingEffect?

			if ColorGrading then
				if not ColorGradingRef then
					ColorGradingRef = Instance.new("BlurEffect")
					ColorGradingRef.Parent = Lighting
				end

				SetProperties(ColorGradingRef, {
					["Enabled"] = ColorGrading.Enabled,
					["Preset"] = ColorGrading.Preset,
				}, Info)
			else
				if ColorGradingRef then
					ColorGradingRef:Destroy()
				end
			end
		end,
	} :: { [string]: (Lighting: Lighting, Preset: Preset, Info: TweenInfo?) -> () },
	Des = {
		Lighting = function(Ref: Lighting, Preset: Preset)
			Preset.Brightness = Ref.Brightness
			Preset.Ambient = Ref.Ambient
			Preset.OutdoorAmbient = Ref.OutdoorAmbient
			Preset.ColorShift = {
				Top = Ref.ColorShift_Top,
				Bottom = Ref.ColorShift_Bottom,
			}
			Preset.DiffuseScale = Ref.EnvironmentDiffuseScale
			Preset.SpecularScale = Ref.EnvironmentSpecularScale
			Preset.ShadowSoftness = Ref.ShadowSoftness
			Preset.Exposure = Ref.ExposureCompensation
			Preset.GlobalShadows = Ref.GlobalShadows
			Preset.Time = {
				Clock = Ref.ClockTime,
				Latitude = Ref.GeographicLatitude,
			}
			Preset.Fog = {
				Color = Ref.FogColor,
				Start = Ref.FogStart,
				End = Ref.FogEnd,
			}
		end,
		Sky = function(Ref: Sky, Preset: Preset)
			Preset.Sky = {
				Top = Ref.SkyboxUp,
				Bottom = Ref.SkyboxDn,
				Left = Ref.SkyboxLf,
				Right = Ref.SkyboxRt,
				Front = Ref.SkyboxFt,
				Back = Ref.SkyboxBk,
				CelestialBodies = Ref.CelestialBodiesShown,
				StarCount = Ref.StarCount,

				Orientation = Ref.SkyboxOrientation,

				Moon = Ref.CelestialBodiesShown and {
					Texture = Ref.MoonTextureId,
					Size = Ref.MoonAngularSize,
				} or nil,

				Sun = Ref.CelestialBodiesShown and {
					Texture = Ref.SunTextureId,
					Size = Ref.SunAngularSize,
				} or nil,
			}
		end,
		Atmosphere = function(Ref: Atmosphere, Preset: Preset)
			Preset.Atmosphere = {
				Density = Ref.Density,
				Offset = Ref.Offset,
				Color = Ref.Color,
				Decay = Ref.Decay,
				Glare = Ref.Glare,
				Haze = Ref.Haze,
			}

			Preset.Fog = nil --> Atmosphere 'cancels out' fog to my knowledge
		end,
		Bloom = function(Ref: BloomEffect, Preset: Preset)
			Preset.Bloom = {
				Enabled = Ref.Enabled,
				Intensity = Ref.Intensity,
				Size = Ref.Size,
				Threshold = Ref.Threshold,
			}
		end,
		DepthOfField = function(Ref: DepthOfFieldEffect, Preset: Preset)
			Preset.DepthOfField = {
				Enabled = Ref.Enabled,
				FarIntensity = Ref.FarIntensity,
				FocusDistance = Ref.FocusDistance,
				InFocusRadius = Ref.InFocusRadius,
				NearIntensity = Ref.NearIntensity,
			}
		end,
		SunRays = function(Ref: SunRaysEffect, Preset: Preset)
			Preset.SunRays = {
				Enabled = Ref.Enabled,
				Intensity = Ref.Intensity,
				Spread = Ref.Spread,
			}
		end,
		Blur = function(Ref: BlurEffect, Preset: Preset)
			Preset.Blur = {
				Enabled = Ref.Enabled,
				Size = Ref.Size,
			}
		end,
		ColorCorrection = function(Ref: ColorCorrectionEffect, Preset: Preset)
			Preset.ColorCorrection = {
				Enabled = Ref.Enabled,
				Brightness = Ref.Brightness,
				Contrast = Ref.Contrast,
				Saturation = Ref.Saturation,
				TintColor = Ref.TintColor,
			}
		end,
		ColorGrading = function(Ref: ColorGradingEffect, Preset: Preset)
			Preset.ColorGrading = {
				Enabled = Ref.Enabled,
				Preset = Ref.TonemapperPreset,
			}
		end,
	},
}
