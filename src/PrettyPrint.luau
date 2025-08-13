-- Taken from: https://github.com/luau-lang/lute/blob/a58e4e11a4ef4f2f5c2d2611ddfc8053a6ba3577/batteries/pp.luau
-- LICENSE: https://github.com/luau-lang/lute/blob/primary/LICENSE

type ExistingOptions = {
	rawStrings: boolean?,
	minify: boolean?,
}

local isPrimitiveType = { string = true, number = true, boolean = true }

local typeSortOrder: { [string]: number } = {
	["boolean"] = 1,
	["number"] = 2,
	["string"] = 3,
	["function"] = 4,
	["vector"] = 5,
	["buffer"] = 6,
	["thread"] = 7,
	["table"] = 8,
	["userdata"] = 9,
	["nil"] = 10,
	["Color3"] = 11,
	["Vector3"] = 12,
}

local function isPrimitiveArray(array: { [unknown]: unknown }): boolean
	local max, len = 0, #array

	for key, value in array do
		if type(key) ~= "number" then
			return false
		elseif key <= 0 then
			return false
		-- userdatas arent primitives
		elseif not isPrimitiveType[type(value)] then
			return false
		end

		max = math.max(key, max)
	end

	return len == max
end

local function getFormattedAdress(t: {}): string
	return `table<({t})>`
end

local function formatValue(value: unknown, options: ExistingOptions): string
	local s = not options.minify and " " or "" --> spacing

	if type(value) == "table" then
		return getFormattedAdress(value :: any) -- simple representation for table values
	elseif typeof(value) == "Color3" then
		if value.R % 1 == 0 and value.G % 1 == 0 and value.B % 1 == 0 then
			return `Color3.new({value.R},{s}{value.G},{s}{value.B})`
		end

		return `Color3.fromRGB({math.floor(value.R * 255)},{s}{math.floor(value.G * 255)},{s}{math.floor(value.B * 255)})`
	elseif typeof(value) == "Vector3" then
		if value.Magnitude == 0 then
			return "Vector3.zero"
		elseif value.Magnitude == 1 then
			return "Vector3.one"
		end

		return `Vector3.new({value.X},{s}{value.Y},{s}{value.Z})`
	elseif type(value) ~= "string" then
		if type(value) == "number" then --> In the specific case of nebulight we don't need high precision
			value *= 1000
			value = math.floor(value) / 1000
		end

		return tostring(value)
	end

	if options and options.rawStrings then
		return `"{value}"`
	end
	return string.format("%q", value)
end

local function formatKey(key: unknown, seq: boolean, options: ExistingOptions): string
	if seq then
		return ""
	end

	local s = not options.minify and " " or "" --> spacing

	if type(key) == "table" then
		return `[{getFormattedAdress(key :: any)}]{s}={s}` -- TODO: handling for table keys
	end
	if type(key) ~= "string" then
		return `[{tostring(key)}]{s}=`
	end

	-- key is a simple identifier
	if string.match(key, "^[%a_][%w_]-$") == key then
		return `{key}{s}={s}`
	end

	return `[{string.format("%q", key)}]{s}={s}`
end

local function isEmpty(t: { [unknown]: unknown }): boolean
	for _ in t do
		return false
	end
	return true
end

-- FIXME(luau): mark `dataTable` indexer as read-only
local function traverseTable(
	dataTable: { [unknown]: unknown },
	seen: { [unknown]: boolean },
	indent: number,
	options: ExistingOptions
): string
	local output = ""
	local indentStr = string.rep("\t", not options.minify and indent or 0)

	local keys = {}

	-- Collect all keys, not just primitives
	for key in dataTable do
		table.insert(keys, key)
	end

	table.sort(keys, function(a: string, b: string): boolean
		local typeofTableA, typeofTableB = typeof(dataTable[a]), typeof(dataTable[b])

		if typeofTableA ~= typeofTableB then
			return typeSortOrder[typeofTableA] < typeSortOrder[typeofTableB]
		end

		if type(a) == "number" and type(b) == "number" then
			return a < b
		end

		return tostring(a) < tostring(b)
	end)

	local inSequence = false
	local previousKey = 0

	for idx, key in keys do
		if type(key) == "number" and key > 0 and key - 1 == previousKey then
			previousKey = key
			inSequence = true
		else
			inSequence = false
		end

		local value = dataTable[key]

		if typeof(value) ~= "table" then
			output =
				`{output}{indentStr}{formatKey(key, inSequence, options)}{formatValue(value, options)},{not options.minify and "\n" or ""}`
			continue
		end

		-- prevents self-referential tables from looping infinitely
		if seen[value] then
			output =
				`{output}{indentStr}{formatKey(key, inSequence, options)}[Circular Reference <({value})>],{not options.minify and "\n" or ""}`
			continue
		else
			seen[value] = true
		end

		if isEmpty(value :: { [unknown]: unknown }) then
			output = string.format(
				`%s%s%s\{\},{not options.minify and "\n" or ""}`,
				output,
				indentStr,
				formatKey(key, inSequence, options)
			)
			continue
		end

		if isPrimitiveArray(value :: { [unknown]: unknown }) then -- collapse primitive arrays
			local outputConcatTbl = table.create(#value) :: { string }

			for valueIndex, valueInArray in value :: { unknown } do
				outputConcatTbl[valueIndex] = formatValue(valueInArray, options)
			end

			output = string.format(
				`%s%s%s\{%*\},{not options.minify and "\n" or ""}`,
				output,
				indentStr,
				formatKey(key, inSequence, options),
				table.concat(outputConcatTbl, `,{not options.minify and " " or ""}`)
			)
			continue
		end

		output = string.format(
			`%s%s%s\{{not options.minify and "\n" or ""}%s%s\},{not options.minify and "\n" or ""}`,
			output,
			indentStr,
			formatKey(key, inSequence, options),
			traverseTable(value :: any, seen, indent + 1, options),
			indentStr
		)

		seen[value] = nil
	end

	return output
end

return function(data: unknown, options: ExistingOptions?): string
	options = options or {} :: ExistingOptions

	-- if it's not a primitive, we'll pretty print it as a value
	if type(data) ~= "table" then
		return formatValue(data, options :: ExistingOptions)
	end

	return `\{{not (options :: any).minify and "\n" or ""}{traverseTable(
		data :: { [unknown]: unknown },
		{ [data] = true },
		1,
		options :: ExistingOptions
	)}\}`
end
