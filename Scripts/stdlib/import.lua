
-- Import
-- operates similar to require
-- except returns the strong value
-- but stores it in a weak valued table
-- this allows the value to be garbage collected when no longer in use
-- NOTES:	only supports one return
--			what if the chunk throws an error?


local import_table		= {}
local import_table_mt	= {__mode="v"}
setmetatable(import_table, import_table_mt)


-- this is for preloading the import table.
-- this can be useful. eg for making some C values "importable"
-- even though you cant actually load them from a file
function preimport(name, value)
	import_table[name] = value
end


function import(name)
	
	-- first check if we still have a value loaded
	local v = import_table[name]
	if (v) then 
		return v
	end
	
	
	--[[
	local LUA_PATH = LUA_PATH or os.getenv("LUA_PATH") or "?.lua;?"
	-- iterate over paths
	for k in string.gfind(LUA_PATH, "[^;]+;?") do 
		k = string.gsub(k, ";", "")
		k = string.gsub(k, "?", name)

		local file = io.open(k, "rb")
		if (file) then 
			-- found the file
			io.close(file);
			local chunk,err = loadfile(k)
			if (chunk) then
				local res = chunk()
				import_table[name] = res
				return res
			else
				error(err);
			end
		end
	end
	
	error("could not load package \"".. name .."\" from " .. LUA_PATH)
	]]--

	local res = require(name)
	import_table[name] = res
	-- support 5.0 and 5.1
	local _LOADED = _LOADED or package.loaded
	_LOADED[name]=nil
	return res
end




