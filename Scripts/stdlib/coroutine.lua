

-- coroutine manager
--	allows:
--		creation of coroutines
--		removal of coroutines from manager 
--			(if you dont hold a strong ref this will cause it to be collected)
--		running of coroutines
--			including removal of dead coroutines from manager
--
--	see test() to see how easy it is to use coroutines
--
--	TODO: make into package so its suitable for require()
--	TODO: more tests
--	TODO: cache globals to make access faster
--	TODO: better detection of 5.0 vs 5.1. this will allow better error messages
--	TODO: more common coroutine funcs (eg frame_waiter() condition_waiter() )

-------------------------------------------
require "weakref"

local pairs = pairs
local assert = assert
local table_remove = table.remove

LOG = LOG or print


-- table for running coroutines
local threads = {}

-- create_coro(f)
-- 	this will schedule func for running in coroutine
-- returns a weakref.
-- NOTE: it doesnt run it immedietely though

function create_coro(func)
	local co = coroutine.create(func);
	table.insert(threads, co);
	return weakref(co);
end

-- remove coro from running threads
-- this forcibly kills the coro (unless you keep it somewhere else)
-- note: linear search. 
--         luckily there should only be few coroutines (probably less than 1000 but coros only take about 1 KB by default (alterable with some C tweaks))
--         also removing coroutines forcibly should be pretty rare
function remove_coro(coro)
	if (coro == nil) then return false end

	-- handle weak reference
	if (type(coro)=="function") then
		coro=coro();
	end
	
	-- find coroutine
	for k,v in pairs(threads) do
		if (v==coro) then
			print ("removing thread "..v);
			local n = #threads
			threads[k]=threads[n]	-- move last one into our spot
			table_remove (threads)  -- pop last slot
			return true;
		end
	end
	return false;
end


-- tick_coros()
--  run waiting threads
-- TODO: allow multiple returns?
--       actually handle the returns (ie map coroutine to "future"?)
--       optimize removal. we dont need to keep order. so we can swap last with the one we are removing
function tick_coros()
	local n = #threads
	if (n == 0) then
		-- no coroutines to tick.
		return
	end
	
	local last=n
	for i = n, 1, -1 do
		local co			= threads[i];
		local status, res	= coroutine.resume (co)
		if (status) then
			-- thread finished or re-resumed
			if (coroutine.status(co)=="dead") then
				-- thread finished. remove it
				threads[i] = threads[last]
				table_remove(threads)
				last = last-1
			end
		else
			-- thread failed
			LOG("Coroutine Error: ("..tostring(co)..")"..res);
--			LOG("\t" .. debug.traceback(co));	-- NOTE: i think this only works for 5.1
			assert(coroutine.status(co) == "dead")
			-- remove it
			threads[i] = threads[last]
			table_remove(threads)
			last = last-1
		end
	end
end


-- tick()
--   this is an example of a per frame tick function. youd call this from C. 
--   its more efficient if we only call one lua function and it calls others.
-- this would be in some other lua file (probably main.lua).
--	function tick()
--		tick_coros();
--		-- any other per frame lua stuff for this game
--	end
-----------------------------------------------




local GetTime = GetGameTime or function() return os.clock()*1000 end

-- simple helper func for sleeping
function sleep(ms)
	local now	= GetTime()
	local t		= now + ms
	while (now < t) do
		coroutine.yield();
		now	= GetTime()
	end
end


function test()
	-- now for the tests

	-- a simple illustration
	-- normal functions can be scheduled. they will execute once. as you would expect
	local function simple()
		print "test"
	end
	create_coro(simple);
	create_coro(simple);


	-- a complex example
	-- it shows 2 ways of storing state.
	-- we can store it in the coroutine (the i counter)
	-- or we can store it in the object (sys.max)
	local function run_particle_system(sys)
		local i = 0;
		while (i<sys.max) do
			print("particlesystem ".. tostring(sys) .." i="..i);
			i=i+1;
			coroutine.yield(); -- yield for next frame
		end
	end
	-- functional programming tool.
	-- like C++s bind
	function bind1st(f,arg1)
		return function(...) 
			return f(arg1, unpack(arg))
		end
	end
	function new_particle_system(max)
		local sys = {max=max or 10}
		local f = bind1st(run_particle_system, sys);
		create_coro(f);
	end
	new_particle_system(5)
	new_particle_system(7)



	-- a common example
	-- coroutine will count to max and tick every s seconds
	-- this just shows that you dont have to create the coroutine in the factory function
	-- (but its generally a good idea)
	function new_sleeper(max,s)
		max	= max or 5
		s	= s   or 5
		return function()
			local i=1;
			while (i<=max) do
				print("sleeper i="..i.. " t=".. os.clock() );
				sleep(s*1000);
				i=i+1;
			end
		end
	end
	create_coro( function () sleep(5) end )
	create_coro( new_sleeper(5,3) )
	create_coro( new_sleeper(6,2) )


	-- harness
	-- this simulates a game loop
	while (#threads ~= 0) do
		tick_coros();
		-- collect garbage every frame
		collectgarbage();
		collectgarbage();
	end
end

-- creates HEAPS of coroutines and ticks them as fast as possible
-- on my system 10000 coros can run at 30 fps (admitedly doing very little work)
-- this can be used as a guide to see how many coros you can run on your system
-- this helps determine memory overhead of coroutines
-- it also helps determine how fast we can switch between coroutines.
-- TODO: worst case frame rate can be a once off. better to use statistics
-- TODO: test on DS (i predict ~50-100 coros at 30 fps)
-- TODO: test with LuaJIT. (its coroutines are a little heavier)
function stresstest()
	for i=1,10000 do
		local id = i;
		create_coro( function ()
			sleep( (5 + id/500)*1000 ); 
			end)
	end
	local t=GetTime();
	local worstfps=10000000;
	while (#threads ~= 0) do
		tick_coros();
		-- collect garbage every frame
		collectgarbage();

		local now = GetTime()
		local fps = 1000/(now-t)
--		print( "\t\tFPS: "..  fps )
		if (fps<worstfps) then worstfps=fps end	
		t=now
		
		local mem = gcinfo()
		local memperthread = mem/#threads
--		print ("\t\t" ..
--			" n = " .. (table.getn(threads)) ..
--			" mem = " .. (gcinfo()) ..
--			" KB/coro: " .. memperthread
--			);
	end
	print("worst fps: "..worstfps);
end