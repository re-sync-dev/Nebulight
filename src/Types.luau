--[==[

	[Types.luau]:
		Static typing

	[Author(s)]:
		- Vyon (https://github.com/Vyon)

--]==]

export type Preset = {
	-- Lighting --
	Ambient: Color3?,
	Exposure: number?,
	Brightness: number?,
	DiffuseScale: number?,
	SpecularScale: number?,
	OutdoorAmbient: Color3?,
	ShadowSoftness: number?,
	GlobalShadows: boolean?,

	ColorShift: {
		Top: Color3?,
		Bottom: Color3?,
	}?,
	Time: {
		Clock: number?, -- ClockTime
		Latitude: number?, -- GeographicalLatitude
	}?,
	Fog: {
		End: number?,
		Color: Color3?,
		Start: number?,
	}?,

	-- Sky --
	Sky: {
		Top: string?,
		Bottom: string?,
		Left: string?,
		Right: string?,
		Front: string?,
		Back: string?,
		StarCount: number?,
		Orientation: Vector3?,
		CelestialBodies: boolean?,

		Moon: {
			Size: number?,
			Texture: string?,
		}?,
		Sun: {
			Size: number?,
			Texture: string?,
		}?,
	}?,

	-- Atmosphere --
	Atmosphere: {
		Haze: number?,
		Color: Color3?,
		Decay: Color3?,
		Glare: number?,
		Offset: number?,
		Density: number?,
	}?,

	-- Bloom --
	Bloom: {
		Size: number?,
		Enabled: boolean?,
		Intensity: number?,
		Threshold: number?,
	}?,

	-- Depth of Field --
	DepthOfField: {
		Enabled: boolean?,
		FarIntensity: number?,
		FocusDistance: number?,
		InFocusRadius: number?,
		NearIntensity: number?,
	}?,

	-- SunRays --
	SunRays: {
		Spread: number?,
		Enabled: boolean?,
		Intensity: number?,
	}?,

	-- Blur --
	Blur: {
		Size: number?,
		Enabled: boolean?,
	}?,

	-- Color Correction --
	ColorCorrection: {
		Enabled: boolean?,
		Contrast: number?,
		TintColor: Color3?,
		Brightness: number?,
		Saturation: number?,
	}?,

	ColorGrading: {
		Enabled: boolean?,
		Preset: Enum.TonemapperPreset?,
	}?,
}

return 0
