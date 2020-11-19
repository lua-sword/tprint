local M = {
	inline=true,

	indent = "\t",
	assign = " = ",
	list_sep=",",
	list_sep_last="",
	empty_table="{}",

	identifier = "^[a-zA-Z_][a-zA-Z0-9_]*$", -- does not support UTF8 identifier
	reserved = {
		["and"]=true, ["break"]=true, ["do"]=true, ["else"]=true, ["elseif"]=true, ["end"]=true,
		["and"]=true, ["break"]=true, ["do"]=true, ["elseif"]=true, ["else"]=true, ["end"]=true,
		["false"]=true, ["for"]=true, ["function"]=true, ["goto"]=true, ["if"]=true, ["in"]=true,
		["local"]=true, ["nil"]=true, ["not"]=true, ["or"]=true, ["repeat"]=true, ["return"]=true,
		["then"]=true, ["true"]=true, ["until"]=true, ["while"]=true, 
	},
	ishort=true,
	kshort=true,
	updater = nil, --[[function(t, lvl, cfg) return cfg end]]
	nonprintable = "[%z\1-\31\127-\255]",
	nonprintable_names = {["\0"]="0", ["\a"]="a", ["\b"]="b", ["\t"]="t", ["\n"]="n", ["\v"]="v", ["\f"]="f", ["\r"]="r",},
	recursivefound = function(t, lvl, cfg)
		cfg.seen[t]=(cfg.seen[t] or 0) +1
		return "{--[["..tostring(t).." is a trap! ("..tostring(cfg.seen[t])..")!]]} "
	end,

	inline_setup = {
		[false] = {
			indent = "\t",
			assign = " = ",
			list_sep=",",
			list_sep_last="",
			empty_table="{}",
		},
		[true] = {
			indent = "",
			assign = " = ",
			list_sep=",",
			list_sep_last="",
			empty_table="{}",
		},
		["compact"] = {
			indent = "",
			assign = "=",
			list_sep=",",
			list_sep_last="",
			empty_table="{}",
		},
	},
}

local function doublequote_dump_string(s, nonprintable_pat, nonprintable_names)
	nonprintable_pat = nonprintable_pat or "[%z\1-\31\127-\255]"
	nonprintable_names = nonprintable_names or {["\0"]="0", ["\a"]="a", ["\b"]="b", ["\t"]="t", ["\n"]="n", ["\v"]="v", ["\f"]="f", ["\r"]="r",}
	local byte = string.byte
	return '"'..(s
		:gsub("[\"\\]", function(cap)
			return "\\"..cap
		end)
		:gsub(nonprintable_pat, function(cap)
			return "\\"..(nonprintable_names[cap] or tostring(byte(cap)))
		end)
	)..'"'
end

local function internal_tprint(t, lvl, cfg)
	lvl = lvl or 0
	cfg = cfg or {}

	if cfg.updater then
		cfg = cfg.updater(t, lvl, cfg)
	end
	--local inline	= cfg.inline
	local indent	= cfg.indent
	local assign	= cfg.assign
	local identifier = cfg.identifier
	local reserved	= cfg.reserved
	local separator	= cfg.list_sep
	local list_sep_last = cfg.list_sep_last
	local skipassign = cfg.skipassign

	if type(t) == "table" then
		if cfg.seen[t] then
			return cfg.recursivefound(t, lvl, cfg)
		end
		cfg.seen[t]=0
		local r={}
		lvl=lvl+1 -- ident
		local i=1 -- implicit numeric index
		for k,v in pairs(t) do
			if not skipassign or not skipassign(t,k,v) then
				local line = ""
				-- if k is a numerical index
				-- check if it is reallly the current index : it could also be a number <= 0 or a float, ...
				-- only if not deny by config
				if type(k) == "number" and i == k and (cfg.ishort ~= false) then
					i=i+1 -- increment the implicit index
					--	"two",
					--	AST: `Id{ "two" }
					-- it's a key/hash index and k is a valid identifier and not a reserved word
				elseif type(k) == "string" and cfg.kshort~=false and (type(identifier)~="string" or k:find(identifier)) and (not reserved or not reserved[k]) then
					line = k .. assign
					--	foo="FOO",
					--	AST: `Pair{ `String{ "foo" }, `String{ "FOO" } }
				else
					line = "["..internal_tprint(k,lvl,cfg).."]"..assign
					--	["foo"]="FOO",
					--	AST: `Pair{ `String{ "foo" }, `String{ "FOO" } }
					-- or
					--	[1]="one",
					--	AST: `Pair{ `Number{ 1 }, `Id{ "one" } }
				end
				-- the content value
				r[#r+1]= (cfg.inline and "" or (indent):rep(lvl)) .. line .. internal_tprint(v,lvl,cfg)
			end
		end
		lvl=lvl-1 -- dedent
		local r2 = { "{" }
		r =  table.concat(r, (separator)..(cfg.inline and "" or "\n"))
		if r=="" then -- a empty list
			if cfg.empty_table then
				return cfg.empty_table
			end
		else
			table.insert(r2, (r..(list_sep_last)))
		end
		table.insert(r2, (cfg.inline and "" or (indent):rep(lvl)).."}" )
		return table.concat(r2, (cfg.inline and "" or "\n"))
	end
	if type(t) == "string" then
		--return ("%q"):format(t)
		return doublequote_dump_string(t, cfg.nonprintable, cfg.nonprintable_names)
	end
	return tostring(t)
end
local function pub_tprint(t, cfg)
	cfg = cfg or {}
	for k,v in pairs(M.inline_setup[cfg.inline or true] or {}) do
		if cfg[k]==nil and v~=nil then
			cfg[k]=v
		end
	end
	cfg = setmetatable(cfg, {__index=M})
	cfg.seen = cfg.seen or {}
	return internal_tprint(t, nil, cfg)
end
return setmetatable(M, {__call=function(_, ...) return pub_tprint(...) end})
