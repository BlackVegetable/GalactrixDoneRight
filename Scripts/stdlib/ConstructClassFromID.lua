
use_safeglobals()

local assert = assert
local string_len = string.len
local string_byte = string.byte

local reg_ctor_t = {}

-- This is called by the engine when there is no matching C++ class with the id
function _G.ConstructFromClassID(id)
	-- try full name first (eg "road") before falling back on class identifier letter
	local ctor = reg_ctor_t[ id ]

	if ctor == nil then
		ctor = reg_ctor_t[ string_byte(id,1) ]
	end

	assert(type(ctor) == 'function')
	return ctor and ctor(id) or nil
end

-- This is called by the engine to create custom event types
function _G.ConstructLuaEvent(eventName)
	local ctor = EVENTS[eventName];
	assert(ctor)
	return ctor()
end


-- lookup is a function that takes a 4CC code and returns an instance
function _G.RegisterClassFactory(classID, lookup)
	assert(type(classID) == "string")
	local classKey;
	if (string_len(classID) == 1) then
		classKey = string_byte(classID, 1)
	else
		-- we allow registering explicit names too.
		-- this is good for classes that arent part of hierarchy. like "road"
		assert(string_len(classID) == 4)
		classKey = classID;
	end
	reg_ctor_t[classKey] = lookup
end


-- utility function.
function _G.TableLookupConstructor(table)
	return function(key)
		local ctor = table[key]
		return ctor()
	end
end

function _G.ImportConstructor(base)
	return function(key)
		local path = (base or "") .. key
		local ctor = import(path)
		return ctor()
	end
end

function _G.AliasConstructor(base)
    assert(base)
	return function(key)
		local path = base
		local ctor = import(path)
		return ctor()
	end
end

-- say we have a table called WEAPONS which we store our classes is
-- We can make ConstructFromClassID("WXXX") automatically use it 
-- like so:
-- RegisterClassFactory( "W", TableLookupConstructor(WEAPONS) )

