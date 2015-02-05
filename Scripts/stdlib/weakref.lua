

-- weak reference system for lua
--	Copyright 2006 Nikolas Bowe
-- 
-- when you have a weak reference you can get a strong reference by calling it
--	ie obj={}; objref = weakref(obj); assert(obj == objref());
-- If the object has been collected the reference will return nil
-- You will get the same reference back if you call weakref(obj) multiple times
--
-- see the tests
--
-- TODO: make it use the memoize.lua system
-- TODO: make things that arent contractual obligations of this system
--			but rather implementation details print warnings in test rather than error
-- TODO: maybe make the reference a stronger type? 
--			ie set a metatable on it so you can tell if something is a weakref or a normal func
-- TODO: move tests to test directory

local weakrefs = {}
local weakmeta = {__mode="kv"}
setmetatable(weakrefs, weakmeta)

function weakref(obj)
	local f = weakrefs[obj];
	if (f) then
		return f
	else
		-- create upvalue for weakref function
		local ref = setmetatable({obj}, weakmeta)
		-- create weakref closure
		f = function() return ref[1] end
		-- cache weakref closure in weakref table
		-- when obj is collected this will be removed
		weakrefs[obj] = f
		return f
	end
end

return weakref;
