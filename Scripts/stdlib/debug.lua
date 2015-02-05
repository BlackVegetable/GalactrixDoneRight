

-- Tools for debugging lua

-- need a tool that can tell how much gc-able memory is in use
-- by a particular node (eg table).
-- note that multiple nodes can refer to the same memory so
-- total memory is not the sum of all nodes
-- but it does use a cache per call so Memory(_G) would be close.


-- track memory over time
-- must classify game state transitions (eg in game screen, on map etc)

-- tools to print information and graphs on screen


-- our own version of assert that breaks into our debugger

local assert = assert
local table_insert = table.insert

-- _ALERT function
function _ALERT(error)
	local trace = debug and debug.traceback 
	error = trace and error.."\n".. trace() or error
end



-- return the function name as best as we can
local function funcname(info)
	if info.name then
		return info.namewhat .. " function '" .. info.name .. "'" 
	end
	if info.what == "main" then
		return "main chunk"
	end
	-- c func or tail call
	if info.what == "C" or info.what == "t" then
		return "?"
	end
	return "<".. info.short_src ..":".. info.linedefined ..">"
end

-- convert v into a format suitable for logging.
-- 
local function prettyval(v)
	if (type(v)=="string") then
		-- TODO: better escaping. eg "a\\nb"
		local s = string.gsub(v, "\n", "\\n")
		return "\""..s.."\""
	end
	if (type(v)=="userdata") then
		mt = getmetatable(v)
		if mt.__luabind_class ~= nil then
			return class_info(v).name
		end
		
		return "userdata"
	end
	return tostring(v) 
end

-- $FILE($LINE): in function $FUNCTION
--	locals:
--		$name, $val
--	upvalues:
--		$name, $val
assert(debug)
assert(debug.getinfo)
local dumping=false
function debug.dump()
	if dumping then return "error: recursive call to dump" end
	dumping=true
	
	local function locals(level, t)
		local i=1
		level = level + 1
		local k,v = debug.getlocal(level, i)
		while k do
			if (i==1) then table_insert(t, "\t\tlocals:") end
			table_insert(t, "\t\t\t"..tostring(k).. ":\t".. prettyval(v) )
			i=i+1
			k,v = debug.getlocal(level, i)
		end
	end

	local function upvals(info, t)
		-- some things (eg tailcalls) cant get a ref to the function
		if not info.func then return end
		local i=1
		local k,v = debug.getupvalue(info.func, i)
		while k do
			if (i==1) then table_insert(t, "\t\tupvals:") end
			table_insert(t, "\t\t\t"..tostring(k).. ":\t".. prettyval(v) )
			i=i+1
			k,v = debug.getupvalue(info.func, i)
		end
	end
	
	local depth=1
	while (debug.getinfo(depth, "n")) do depth = depth+1 end
	
	local i		= 2
	local info	= debug.getinfo(i)
	local t		= {}
	while info do
		if (i==2) then table_insert(t, "stack traceback (depth ~ "..depth.."):") end

		-- $file($line): in function $func
		local line = "\t"..info.short_src .. 
			(info.currentline == -1 and "" or "(" .. info.currentline .. ")")	-- if we have a line print it
			.. ": in " .. funcname(info)
		table_insert(t, line)

		-- locals
		locals(i,t)
		
		-- upvals
		upvals(info,t)
		
		i = i+1
		info = debug.getinfo(i)
	end
	local s = table.concat(t, "\n")
	dumping=false
	return s
end

