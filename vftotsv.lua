kpse.set_program_name("luatex")
local parsepl = require "parsepl"
local pl_loader = require "pl_loader"


local name = arg[1] or "ntxmia"
local s, fonttype = pl_loader.load(name)

local t = parsepl.parse(s)

local function print_r(v,indent)
	local v = v or {}
	local indent = indent or ""
	for x,y in pairs(v) do
		if type(y) == "table" then
			print(indent .. x)
			print_r(y,indent .. "  ")
		else
			print(indent .. x ..": "..y)
		end
	end
end

local fonts = {}
local first_font 

local function load_font(name)
	local filename = lfs.currentdir()..  "/" .. name .. ".tsv"
	local f = io.open(filename,"r")
	if f == nil then
		return nil
	end
	f:close()
	local t = {}
	for line in io.lines(filename) do
		local r = line:explode("\t")
		if r then
			local i = tonumber(r[1])
			t[i] = {r[2],r[3]}
		end
	end
  return t
end

local function get_char(font_id, value)
	local t = fonts[font_id] or {}
	return t[value]
end

local function make_line(number, map) 
	local chars, glyphs = {},{} 
	for _,v in ipairs(map) do
		chars[#chars+1] = v[1]
		glyphs[#glyphs+1] = v[2]
	end
	print(number, table.concat(chars,"; "), table.concat(glyphs,"; "))
end

for k,v in pairs(t) do
	if v.type == "character" then -- and v.setcharcnt ~= 1  then
		local font_id = first_font
		local map = v.map or {}
		local t = {}
		for _, x in ipairs(map) do
			if x.typ == "selectfont" then
				font_id = x.value
			elseif x.typ == "setchar" then
				t[#t+1] = get_char(font_id, x.value)
			end
		end
		if #t == 0 then
			t[1] = get_char(first_font, v.value)
		end
		make_line(v.value, t)
	  --print(k,v.type)
		-- print("---------")
	  -- print_r(v)
	elseif v.type=="mapfont" then
		local t = load_font(v.name) 
		if not t then
			print("Cannot load tsv file for font "..v.name)
		--	os.exit(1)
		end
		local id = v.identifier
	  first_font = first_font or id
		fonts[id] = t
		-- fonts[id].name = v.name
		-- print_r(v)
	end
end
