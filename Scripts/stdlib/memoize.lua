-- memoize
--	allows us to cache results of an expression
--	if we stop holding the result then our cache is subject to GC
--
-- FIXME:	support more func types than 1 arg
--				a tuple type would be convenient for this
-- FIXME:	use a better map. 
--				ie fix case where table1==table2 but they hash differently
-- FIXME:	if you pass a complex type into a memoized function and it returns a 
--				string thats already in lua then this will cause the complex type
--				to be held until the string is GC'd.
--				not much we can do about this. 
--				we COULD store a weak reference to the string in the function
--					and then call collectgarbage and check the weak reference.
--					but it means we will need to call collectgarbage everytime
--					a memoized function returns a string. not good.
--				or we COULD create a proxy whose gc metamethod sets a dirty flag 
--					and the next memoize can walk the table cleaning out 
--					strings if they are the primary ref
--			in general we should just avoid memoizing functions that return common strings
-- FIXME:	hook to memory system.
--				as a last resort to free extra memory we should collect all memos
--
-- eg: we can memoize a compile() function so that if it produces same bytecode
--		it will use the already compiled function

local assert = assert

-- metatable for all memos
--	weak valued. NOT weak keyed because strings could cause premature release.
local memometa = {__mode="v"};

-- result types we can memoize
local memoable = {["function"] = true, ["userdata"] = true, ["thread"] = true, ["table"] = true};

-- returns a memoized function
-- this is a function that does the same as func but memoizes the result
-- this means that given the same input as a previous result it will return the previous result
local function memoize_f(func)
	local memo = setmetatable({}, memometa);
	return	function(arg1)
				local r = memo[arg1];
				if (r==nil) then
					r = func(arg1);
					-- cache if its cachable
					if (memoable[type(arg1)] or memoable[type(r)]) then
						memo[arg1]=r
					end
				end
				return r;
			end
end
memoize = memoize_f
memoize = memoize_f(memoize_f)

local function test()
	local function testfunc(name)
		return {name}
	end
	local testfunc_m = memoize(testfunc)
	local testfunc_m2 = memoize(testfunc)
	assert(testfunc_m == testfunc_m2)

	local r1 = testfunc("test")
	local r2 = testfunc("test")
	assert(r1 ~= r2)
	
	local r1 = testfunc_m("test")
	local r2 = testfunc_m("test")
	assert(r1==r2)

	local r1 = testfunc_m("test")
	local r2 = testfunc_m2("test")
	assert(r1==r2)

	-- a semi useful example that should be similar to compile() example
	-- a more useful example would do more than just loadstring
	local r1 = loadstring("local function f() print(_VERSION) end")
	local r2 = loadstring("local function f() print(_VERSION) end")
	assert(r1~=r2)
	-- now memoize
	local loadstring_m = memoize(loadstring)
	local r1 = loadstring_m("local function f() print(_VERSION) end")
	local r2 = loadstring_m("local function f() print(_VERSION) end")
	assert(r1==r2)
end

test()
test = nil
collectgarbage();collectgarbage()


return memoize;