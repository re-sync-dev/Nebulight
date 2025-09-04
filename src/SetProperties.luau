-- Services:
local TweenService = game:GetService("TweenService")

-- Constants:
local REWRITES = {
	Lighting = {
		["DiffuseScale"] = "EnvironmentDiffuseScale",
		["SpecularScale"] = "EnvironmentSpecularScale",
		["Exposure"] = "ExposureCompensation",
		["ColorShift.Top"] = "ColorShift_Top",
		["ColorShift.Bottom"] = "ColorShift_Bottom",
		["Time.Clock"] = "ClockTime",
		["Time.Latitude"] = "GeographicLatitude",
		["Fog.Color"] = "FogColor",
		["Fog.Start"] = "FogStart",
		["Fog.End"] = "FogEnd",
	},
	Sky = {
		["Top"] = "SkyboxUp",
		["Bottom"] = "SkyboxDn",
		["Left"] = "SkyboxLf",
		["Right"] = "SkyboxRt",
		["Front"] = "SkyboxFt",
		["Back"] = "SkyboxBk",
		["CelestialBodies"] = "CelestialBodiesShown",
		["Moon.Size"] = "MoonAngularSize",
		["Moon.Texture"] = "MoonTextureId",
		["Sun.Size"] = "SunAngularSize",
		["Sun.Texture"] = "SunTextureId",
		["Orientation"] = "SkyboxOrientation",
	},
	["ColorGrading"] = {
		["Preset"] = "TonemapperPreset",
	},
}

-- Main Module:
return function(Ref: Instance, RawProps: { [string]: any }, Info: TweenInfo?)
	local PropRewrites = REWRITES[Ref.ClassName] or {}

	local List, Tweenable = {}, {}

	local function Add(T: { [string]: any }, From: string)
		for Key, Value in T do
			if type(Value) == "table" then
				Add(Value, Key .. ".")
				continue
			end

			if PropRewrites[From .. Key] then
				Key = PropRewrites[From .. Key]
			end

			if Info then
				local Type = typeof(Value)

				if Type == "number" or Type == "Vector3" or Type == "Color3" then
					Tweenable[Key] = Value
				else
					List[Key] = Value
				end
			else
				List[Key] = Value
			end
		end
	end

	Add(RawProps, "")

	-- Apply the non-tweenable props:
	for Key, Value in List do
		Ref[Key] = Value
	end

	if Info then
		TweenService:Create(Ref, Info, Tweenable):Play()
	end
end
