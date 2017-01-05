local gchelpers = {}

local MAX_UP_VALUES = 10000		-- some largish integer, the number of upvalues to probe for

-- Engine has LOG but I want this script to run as standalone too 
-- (for testing) so emulate LOG with print if not present
local LOG = LOG or print
local assert = assert
local pairs = pairs
local string_format = string.format

-- Stores all objects to dump, table is weak, so objects in the 
-- table are cleared automatically when no further references
-- remain
gchelpers.watch_t = {}

setmetatable(gchelpers.watch_t, {__mode = "k"})

function gchelpers.watchnewgameobject(typeid)
	local obj = GameObjectManager:Construct(typeid)
	gchelpers.watch_t[obj] = debug.traceback(string.format("Game object of type %s, allocated at"))
	return obj
end

-- Add an object to the watch list.  All objects in the watch list
-- have all references to them dumped with gchelpers.dumpwatches()
function gchelpers.watchobject(obj)
	gchelpers.watch_t[obj] = obj
	return obj
end

-- Add an object to the watch list giving it a name.  The name is
-- printed when the object is dumped.  This is not that useful as
-- the name of the object can be derived from the references
function gchelpers.watchnamedobject(name, obj)
	gchelpers.watch_t[obj] = name
	return obj
end

-- For any watched objects that are still not collected, find and
-- print all references to the object
function gchelpers.dumpwatches()
	collectgarbage("collect")

	--LOG("-- OBJECTS --")
	for obj, k in pairs(gchelpers.watch_t) do
		LOG(string_format("Object: %s:%s is reachable by the following paths: ", tostring(k), tostring(obj)))
		for i, path in ipairs(gchelpers.findrefs(obj)) do
			LOG("\t" .. path)
		end
	end
	--LOG("-------------")
end

-- Internal
local function check_object(obj, path, state)
	assert(path)
	assert(state)
	
	if not obj then
		return
	end
	
	local function check_table(t, path)
		assert(t)
		assert(path)
		
		-- dont expand a table more than once
		if state.closed[t] then
			return
		else
			state.closed[t] = t
		end
		
		local metatable = getmetatable(t)
		local mode
		
		if metatable then
			mode = metatable.__mode
		end
		
		local weakkeys = false
		local weakvalues = false
		
		if mode and string.find(mode, "k", 0, true) then
			weakkeys = true
		end
		
		if mode and string.find(mode, "v", 0, true) then
			weakvalues = true
		end
		
		for k,v in pairs(t) do
			if not weakkeys then
				check_object(k, string_format("%s\n\t\t[%s] = %s", path, tostring(k), tostring(v)), state)
			end
			
			if not weakvalues then
				check_object(v, string_format("%s\n\t\t[%s] = %s", path, tostring(k), tostring(v)), state)
			end
		end
		
		if metatable then
			check_object(metatable, string_format("%s\n\t\tgetmetatable(%s) = %s", path, tostring(t), tostring(metatable)), state)
		end
	end
	
	local function check_upvalues(obj, path)
		assert(obj)
		assert(path)
		
		-- check upvalues
		for i=1,MAX_UP_VALUES do
			local name, value = debug.getupvalue(obj, i)
			
			if not name then
				break
			end
			
			check_object(name, string_format("%s\n\t\tupvalue[%s] = %s", path, tostring(name), tostring(value)), state)		-- names are probably always strings, so this is not strictly necessary?
			check_object(value, string_format("%s\n\t\tupvalue[%s] = %s", path, tostring(name), tostring(value)), state)
		end
	end

	local function check_userdata(ud, path)
		assert(ud)
		assert(path)
		
		check_object(debug.getfenv(ud), string_format("%s\n\t\tuserdata environment for %s", path, tostring(ud)), state)
		check_object(debug.getmetatable(ud), string_format("%s\n\t\tuserdata metatable for %s", path, tostring(ud)), state)
	end

	local function check_function(fn, path)
		assert(fn)
		assert(path)
		
		-- dont expand a function more than once
		if state.closed[fn] then
			return
		else
			state.closed[fn] = fn
		end
		
		check_object(getfenv(fn), string_format("%s\n\t\tfunction environment for %s", path, tostring(th)), state)
		check_upvalues(fn, path)
	end

	local function check_thread(th, path)
		assert(th)
		assert(path)
		
		check_object(debug.getfenv(th), string_format("%s\n\t\tfunction environment for %s", path, tostring(th)), state)
		gchelpers.check_stack(th, string_format("%s\n\t\tstack for %s", path, tostring(th)), state)
	end

	local objtype = type(obj)
	
	if state.ignore[obj] then
		return -- objects to ignore
	end
	
	if rawequal(obj, state.target) then
		table.insert(state.refs, path)
	end
	
	if objtype == "table" then
		check_table(obj, path)
	elseif objtype == "userdata" then
		check_userdata(obj, path)
	elseif objtype == "function" then
		check_function(obj, path)
	elseif objtype == "thread" then
		check_thread(obj, path)
	end
end

local function pretty_what(what)
	if what == "Lua" then
		return "L"
	else
		return "C"
	end
end

local function pretty_name(str)
	return str or "[anonymous]"
end

local function pretty_info(info)
	return string_format("%s:%s: %s(%d)", pretty_what(info.what), pretty_name(info.name), tostring(info.source), tostring(info.linedefined))
end

function gchelpers.check_stack(th, path, state) -- can be nil for main thread
	assert(path)
	assert(state)
	
	for i=1,10000 do
		local info
		if th then
			info = debug.getinfo(th, i)
		else
			info = debug.getinfo(i)
		end
		
		if not info or state.ignore[info.func] then
			break
		end
		
		-- this checks the upvalues and fenv
		check_object(info.func, string_format("%s\n\t\tfunction on stack level %d (%s)", path, i, pretty_info(info)), state)
		
		-- now check locals
		for l=1,10000 do
			local name, value
			
			if th then
				name, value = debug.getlocal(th, i, l)
			else
				name, value = debug.getlocal(i, l)
			end
			
			if not name then
				break
			end
			
			check_object(value, string_format("%s\n\t\tlocal %s on stack level %d (%s)", path, name, l, pretty_info(info)), state)
		end
	end
end

-- Internal
--  (this function consumes MUCH memory and will take a LONG time, it
--   would probable exhaust memory on the DS - closed list eventually
--   contains all reachable objects in the lua object space)
function gchelpers.findrefs(objtolocate)
	assert(objtolocate)
	
	local state = {
		refs = {},
		closed = {},
		ignore = { 
			closed = true, 
			check_object = true, 
			[gchelpers.check_stack] = true,
			[gchelpers.dumpwatches] = true,
		},
		target = objtolocate
	}
	
	-- check _G
	check_object(_G, string_format("_G table %s", tostring(_G)), state)
	check_object(debug.getregistry(), string_format("_R (lua registry) table %s", tostring(_R)), state)
	gchelpers.check_stack(nil, "main thread stack", state)
	
	if coroutine.running() then
		check_object(coroutine.running(), "running thread", state)
	end
	
	local refs = state.refs
	
	-- state.closed might hold a lot of memory at this stage
	state = nil
	collectgarbage("collect")
	
	return refs
end

--[[ TESTING CODE ]]

test = false

if test then
	_G.test1 = {}

	local leaky1 = {}
	local leaky2 = {}
	local leaky3 = {}
	local notleaky = {}

	gchelpers.watchnamedobject("leaky1", leaky1)
	gchelpers.watchnamedobject("leaky2", leaky2)
	gchelpers.watchnamedobject("leaky3", leaky3)
	gchelpers.watchnamedobject("notleaky", notleaky)

	_G.test1.accidentalref = leaky1
	_G.test1.accidentalref2 = leaky1
	_G.test1.accidentalref3 = leaky1
	_G.test2 = {}
	setmetatable(_G.test2, {__mode="kv"})
	_G.test2.weak = notleaky
	setmetatable(_G.test1, {whoops = leaky2})
	_G.testcoro = coroutine.create(function ()
		local leaky4 = {}
		gchelpers.watchnamedobject("leaky4", leaky4)
		coroutine.yield()
	end)
	
	_G.foo = function (a) 
		return function () 
			return a 
		end 
	end
	
	_G.food = _G.foo(gchelpers.watchobject({}))
	
	coroutine.resume(_G.testcoro)

	leaky1 = nil
	leaky2 = nil
	leaky3 = nil
	notleaky = nil

	gchelpers.dumpwatches()
end

-- deprecated
gchelper_watchobject = gchelpers.watchobject
gchelper_dumpwatches = gchelpers.dumpwatches

return gchelpers
