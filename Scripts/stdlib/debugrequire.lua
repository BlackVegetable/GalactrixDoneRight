local require = require
local requirestack = {}
local function myrequire(filename)
	-- this level starts with 0 kb of child requires
	table.insert(requirestack, 0);
	local n				= #requirestack
	-- we want an accurate reading so we collect garbage before reading mem levels
	collectgarbage("collect");collectgarbage("collect");
	local m1			= collectgarbage("count")
	local r				= {require(filename)}
	collectgarbage("collect");collectgarbage("collect");
	local m2			= collectgarbage("count")
	local ourChildren	= requirestack[n]
	
	-- tell our parent level our allocations
	-- this includes our children too.
	if (n > 1) then
		requirestack[n-1]	= requirestack[n-1] + (m2-m1)
	end
	-- pop our level
	table.remove(requirestack)
	-- this files own contrib to memory
	local mydelta = (m2-m1)-ourChildren
	LOG(string.format(" =====> require %s took %0.2f KB",filename, mydelta))
	
	return unpack(r)
end
_G.require=myrequire
