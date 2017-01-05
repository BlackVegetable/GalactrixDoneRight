--------------------------------------------------------------------------------
--   _____                        _   _            _    _      _                         _             
--  / ____|                      | | (_)          | |  | |    | |                       | |            
-- | |      ___  _ __  ___  _   _| |_ _ _ __   ___| |__| | ___| |_ __   ___ _ __ ___    | |_   _  __ _ 
-- | |     / _ \| '__|/ _ \| | | | __| | '_ \ / _ \  __  |/ _ \ | '_ \ / _ \ '__/ __|   | | | | |/ _` |
-- | |____| (_) | |  | (_) | |_| | |_| | | | |  __/ |  | |  __/ | |_) |  __/ |  \__ \ _ | | |_| | (_| |
--  \_____|\___/|_|   \___/ \__,_|\__|_|_| |_|\___|_|  |_|\___|_| .__/ \___|_|  |___/(_)|_|\__,_|\__,_|
--                                                              | |                                    
--                                                              |_|                                    
--
--------------------------------------------------------------------------------
-- Originally created on 08/19/2008 by Steve Fawkner
--
-- Copyright 2008, Infinite Interactive Pty. Ltd., all rights reserved.
--------------------------------------------------------------------------------
use_safeglobals()

--------------------------------------------------------------------------------
--   local CRH = import("CoroutineHelpers")
--
--	 CRH.Run(coro_fn,interval,timeslice,callback_fn)
--		Call me to start a coroutine running
--
--	 CRH.Update(time)
--		Call me from OnDraw in the main thread
--
--	 CRH.CheckYield(id)
--		Call me from the coroutine to see if I should yield back to the main thread
--
--	 CRH.KillAll()
--		Call me from the main trhead to clean any junk up
--
--   function coro_fn(id, ...)
--		This is the actual coroutine function... it should pass that "id" into CheckYield calls
--		
--   function callback_fn()
--		Call this when the coroutine ends
--		
--------------------------------------------------------------------------------


local coro_list = {}
local yield_list = {}
local coro_id = 1
local MAX_CORO_ID = 50000
local MIN_CORO_ID = 100

local function GetMyTime()
	return GetSystemTime()
	--return GetGameTime()
end

------------------------------------------------------
--
--  Run(coro_fn,interval,timeslice,callback_fn)
--
--      Manage a coroutine - this starts it running if start_me is true
--
local function Run(coro_fn,interval,timeslice,callback_fn)
	
	--coro_fn(0)
	
	--LOG("COROUTINEHELPERS:Run() Request to run Coroutine id="..coro_id)
	
	-- Create the coroutine
	local myCoro = {}
	myCoro.coro_fn = coro_fn
	myCoro.interval = interval
	myCoro.timeslice = timeslice
	myCoro.callback_fn = callback_fn
	myCoro.coro = coroutine.create(myCoro.coro_fn)
	myCoro.last_time = GetMyTime()
	myCoro.id = coro_id
	myCoro.first = true
	
	-- Manage the id's
	coro_id = coro_id + 1
	if coro_id > MAX_CORO_ID then
		coro_id = MIN_CORO_ID
	end
	
	-- Set its initial state
	yield_list[myCoro.id] = {}
	yield_list[myCoro.id].last_time = myCoro.last_time
	yield_list[myCoro.id].timeslice = myCoro.timeslice
	local add_me = true
	--LOG("COROUTINEHELPERS:Run() starting id="..myCoro.id)
	--local alive = coroutine.resume(myCoro.coro, myCoro.id, ...)
	--LOG("COROUTINEHELPERS:Run() started id="..myCoro.id)
	--if not alive then
		--LOG("COROUTINEHELPERS:Run() it all finished at once! id="..myCoro.id)
	--	add_me = false
	--end
	
	-- add it to the coroutine management list
	if add_me then
		table.insert(coro_list,myCoro)
	end
	
end


------------------------------------------------------
--
--  Update(time)
--
--      Update the coroutines... should be called from OnDraw
--			by the main thread
--
local function Update(time)
	
	
	local cleanupKey = nil
	time = GetMyTime(); -- override it with system time
	
	
	-- Check for running each coroutine
	for k,v in pairs(coro_list) do
		--LOG("COROUTINEHELPERS:Update() Checking! id="..v.id.."  time:"..tostring(time-v.last_time).." of "..v.interval.."  ("..time.."/"..v.last_time..")")
		if time >= v.last_time + v.interval then
			v.last_time = time
			--LOG("COROUTINEHELPERS:Update() About to resume! id="..v.id)
			if (v.coro) then
				
				local okay
				local errmsg
				
				if v.first then
					okay, errmsg = coroutine.resume(v.coro, v.id)
					v.first = false
				else
					okay, errmsg = coroutine.resume(v.coro)
				end
				
				--LOG("COROUTINEHELPERS:Update() Resume Done! id="..v.id.." okay="..tostring(okay).." errmsg="..tostring(errmsg))
				if not okay then
					error(debug.traceback(v.coro, errmsg))
				end
				
				local status = coroutine.status(v.coro)
				--LOG("COROUTINEHELPERS:Update() status! id="..v.id.." status="..status)
				local alive = true
				if status == "dead" then
					alive = false
					--LOG("COROUTINEHELPERS:Update() Dead coro found! id="..v.id)
				end
				
				if not alive then
					--LOG(debug.traceback(v.coro,"COROUTINEHELPERS:Update() Dead coroutine - remove me! id="..v.id.." "..tostring(errmsg)))
					v.coro = nil
					cleanupKey = k
					yield_list[v.id] = nil
					if v.callback_fn then
						v.callback_fn()
					end
					break
				end
			else
				cleanupKey = k
			end
		end
	end
	
	-- Clean only one per update
	if cleanupKey then
		--LOG("COROUTINEHELPERS:Update() Removing coroutine!")
		table.remove(coro_list,cleanupKey)
	end
	
end



------------------------------------------------------
--
--  CheckYield(id, timeslice)
--
--      Should I yield yet?
--			Call this periodically from the coroutine
--
local function CheckYield(id)
	
	if not id or id <= 0 then
		return
	end
	
	local myTime = GetMyTime()
	--LOG("COROUTINEHELPERS:CheckYield() Checking! id="..id.."  time:"..tostring(myTime-yield_list[id].last_time).." of "..yield_list[id].timeslice.."  ("..myTime.."/"..yield_list[id].last_time..")")
	
	if myTime >= yield_list[id].last_time + yield_list[id].timeslice then
		--LOG("COROUTINEHELPERS:CheckYield() Yielding! id="..id)
		coroutine.yield()
		--LOG("COROUTINEHELPERS:CheckYield() Yielded! id="..id)
		yield_list[id].last_time = GetMyTime()
		--LOG("COROUTINEHELPERS:CheckYield() Set last time="..myTime)
	end
 	--LOG("COROUTINEHELPERS:CheckYield() Exiting! id="..id)
	
end


------------------------------------------------------
--
--  KillAll()
--
--      Kill all coroutines
--
local function KillAll()
	coro_list = {}
	yield_list = {}
	coro_id = 1
end


------------------------------------------------------
--
--		Table of functions
--
------------------------------------------------------

local CoroutineHelpers = 
{
	Run = Run,
	Update = Update,
	CheckYield = CheckYield,
	KillAll = KillAll,
}

return CoroutineHelpers

--------------------------------------------------------------------------------
-- CoroutineHelpers.lua - End of file
--------------------------------------------------------------------------------
