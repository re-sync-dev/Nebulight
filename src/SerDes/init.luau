-- Modules:
local Types = require(script.Parent.Types)

-- Types:
type Preset = Types.Preset

-- Main Module:
return (
	setmetatable({}, {
		__index = function(self, Key: string)
			local Child = script:FindFirstChild(Key)

			if not Child or not Child:IsA("ModuleScript") then
				return
			end

			local Success, Result = pcall(require, Child)

			if not Success then
				warn(`[Nebulight/SerDes] Failed to require {Key} due to error: {Result}`)
				return
			end

			return Result
		end,
		__newindex = function()
			error("attempt to modify a readonly table")
		end,

		__metatable = "The metatable is locked",
	}) :: any
) :: {
	Lighting: {
		Ser: { [string]: (Lighting: Lighting, Preset: Preset, Info: TweenInfo?) -> () },
		Des: { [string]: (Ref: Instance, Preset: Preset) -> () },
	},
	Instance: {
		Ser: { [string]: (ConfigRef: Folder, Preset: Preset) -> () },
		Des: { [string]: (Ref: Folder, Preset: Preset) -> () },
	},
}
