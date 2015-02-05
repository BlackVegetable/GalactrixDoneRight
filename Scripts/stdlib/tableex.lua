-- functions for operating with tables


-- clear.
-- clears everything in a table.
-- but still keeps metatable and all references still point to table
function clear(t)
	assert(type(t) == "table");
	for k,v in pairs(t) do
		t[k]=nil;
	end
	-- if it was an array table it wont clear it till we cause a resize by writing to the hash part
	t._ = nil;
end


--[[
-- should be in functional.lua
function or_adaptor(f1,f2)
	return function(...)
		return f1(unpack(arg)) or f2(unpack(arg))
	end
end


function foreach_recursive(t, fn)
	for k,v in pairs(t) do
		if (type(v) == "table") then
			foreach_recursive(v, fn)
		else
			fn(k,v)
		end
	end
end
--]]


local clone
function clone(t, cache)
	local cache = cache or {}
	-- return if already in cache
	if (cache[t]) then return cache[t] end
	-- not in cache.
	-- make a new table and put in cache
	local copy = {}
	cache[t]=copy
	-- copy k,vs into new table
	for k,v in pairs(t) do
		if (type(v) == "table") then
			-- clone subtable
			v = clone(v, cache)
		end
		copy[k]=v;
	end
	return copy
end

table.clone=clone


local function random(t)
    return t[math.random(#t)]
end

table.random = random


local function join(t1, t2)
	local t = {}
	
	if type(t1) == 'table' and type(t2) == 'table' then
		if #t1 > #t2 then
			t = t1
			for i=1, #t2 do
				t[#t+1] = t2[i]
			end
		else
			t = t2
			for i=1, #t1 do
				t[#t+1] = t1[i]
			end
		end
	elseif type(t1) == 'table' then
		t = t1
		if t2 ~= nil then
			t[#t+1] = t2
		end
	elseif type(t2) == 'table' then
		t = t2
		if t1 ~= nil then
			t[#t+1] = t1
		end
	end
	
	return t
end

table.join = join

--[[
function test2()
	local t = {}
	t[1]=1;
	t[2]="test";
	t["self"] = t;
	
	local t2 = table.clone(t);
	assert(t2 ~= t, "same table")
	assert(t2[1] == 1, "couldnt clone primitive member" )
	assert(t2[2] == "test", "couldnt clone member" )
	assert(t2["self"] ~= t, "couldnt clone table member")
	assert(t2["self"] == t2, "couldnt clone table with cycles")
end
--]]

local function pretty_print(t, d)
	local depth = d or 0
	if type(t)=="table" then
		if depth == 0 then
			LOG(tostring(t) .. " = ")
		end
		LOG(string.rep("\t", depth) .. "{")
		local comma = ""
		for i,v in pairs(t) do
			local s = string.rep("\t", depth+1) .. string.format("%s[%s] = ", comma, tostring(i))
			if type(v)=="table" then
				LOG(s)
				pretty_print(v, depth+1)
			else
				LOG(s .. tostring(v))
			end
			comma = ","
		end
		LOG(string.rep("\t", depth) .. "}")
	end
end

table.pretty_print = pretty_print
