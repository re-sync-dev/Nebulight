--[==[

	[Types.luau]:
		Static typing

	[Author(s)]:
		- Vyon (https://github.com/Vyon)

--]==]

export type Preset = {
	-- Lighting --
	Brightness: number?,
	Ambient: Color3?,
	OutdoorAmbient: Color3?,
	ColorShift: {
		Top: Color3?,
		Bottom: Color3?,
	}?,
	DiffuseScale: number?,
	SpecularScale: number?,
	ShadowSoftness: number?,
	Exposure: number?,
	GlobalShadows: boolean?,
	Time: {
		Clock: number?, -- ClockTime
		Latitude: number?, -- GeographicalLatitude
	}?,
	Fog: {
		Color: Color3?,
		Start: number?,
		End: number?,
	}?,

	-- Sky --
	Sky: {
		Top: string,
		Bottom: string,
		Left: string,
		Right: string,
		Front: string,
		Back: string,
		CelestialBodies: boolean?,
		StarCount: number?,

		Orientation: Vector3,

		Moon: {
			Texture: string?,
			Size: number?,
		}?,
		Sun: {
			Texture: string?,
			Size: number?,
		}?,
	}?,

	-- Atmosphere --
	Atmosphere: {
		Density: number?,
		Offset: number?,
		Color: Color3?,
		Decay: Color3?,
		Glare: number?,
		Haze: number?,
	}?,

	-- Bloom --
	Bloom: {
		Enabled: boolean?,
		Intensity: number?,
		Size: number?,
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
		Enabled: boolean?,
		Intensity: number?,
		Spread: number?,
	}?,

	-- Blur --
	Blur: {
		Enabled: boolean?,
		Size: number?,
	}?,

	-- Color Correction --
	ColorCorrection: {
		Enabled: boolean?,
		Brightness: number?,
		Contrast: number?,
		Saturation: number?,
		TintColor: Color3?,
	}?,

	ColorGrading: {
		Enabled: boolean?,
		Preset: Enum.TonemapperPreset?,
	}?,
}

return 0
