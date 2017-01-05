--------------------------------------------------------------------------------
--   _____                           _    _                 _ _               _             
--  / ____|                         | |  | |               | | |             | |            
-- | (___   ___ _ __  ___  ___ _ __ | |__| | __ _ _ __   __| | | ___ _ __    | |_   _  __ _ 
--  \___ \ / __| '__|/ _ \/ _ \ '_ \|  __  |/ _` | '_ \ / _` | |/ _ \ '__|   | | | | |/ _` |
--  ____) | (__| |  |  __/  __/ | | | |  | | (_| | | | | (_| | |  __/ |    _ | | |_| | (_| |
-- |_____/ \___|_|   \___|\___|_| |_|_|  |_|\__,_|_| |_|\__,_|_|\___|_|   (_)|_|\__,_|\__,_|
--                                                                                          
--                                                                                          
--
--------------------------------------------------------------------------------
-- Originally created on 04/28/2008 by Steve Fawkner
--
-- Copyright 2008, Infinite Interactive Pty. Ltd., all rights reserved.
--------------------------------------------------------------------------------

use_safeglobals()

local type = type
local Graphics = Graphics

	
--------------------------------------------------------------------------------
--
--					INSTRUCTIONS
--
--------------------------------------------------------------------------------
--
--	1. Add a CallScreenHandler() call from the game's Application.lua/OnDraw(time)
--     function. NOTE: now its done in tick_stdlib
--
--  2. When you are going to close one screen & open another, use
--		CallScreenSequencer( scr1, scr2)
--     This should be done wherever you'd normally use an open/close sequence of calls
--
--  3. Use the following function to enable/disable sequencing
--		SetScreenSequencing(on)
--
--------------------------------------------------------------------------------

local ready_count = 0
local ready_t ={}

local waiting_count = 0
local waiting_t ={}

local sequencing_b = true
local fadeToBlack = false
local fadeInDelay = 0

local SCREEN_PLACEHOLDER = "IAAPH"

local NotifyScreenSequencer

function _G.IsScreenLoaded(scr)
	return rawget(SCREENS, scr)
end

function _G.PrintScreens(scr)
	for k,v in pairs(SCREENS) do 
		LOG("SCREEN IN MEMORY: "..k)
	end
end

------------------------------------------------------
--
--   SetScreenSequencing(on)
--
--      Turns sequencing on/off
--
function _G.SetScreenSequencing(on)
	sequencing_b = on
end

------------------------------------------------------
--
--   SetFadeToBlack(on)
--
--      Turns fadetoblack on/off
--
function _G.SetFadeToBlack(on, delay)
	fadeToBlack = on
	if delay then
		fadeInDelay = delay
	else
		fadeInDelay = 0
	end
end

function _G.GetFadeToBlack()
	return fadeToBlack 
end

------------------------------------------------------
--
--   CallScreenHandler()
--      This will update the state of screens; 
--      Opening 
--
function _G.CallScreenHandler()

	local lastOpened
	
	if (not sequencing_b) then
		return
	end

	-- Check if screens are ready to be moved to the "ready" list
	for i=1,waiting_count do
		local scr1 = waiting_t[i] and waiting_t[i].scr1
		local actualScr = scr1 and SCREENS[scr1]
		if (scr1 and actualScr and not actualScr:IsOpen()) then
			NotifyScreenSequencer(scr1)
		end
	end

	-- Process any "ready" screens
	if (ready_count > 0 and not (fadeToBlack == true and Graphics.IsFading() == true)) then
		for i=1,ready_count do
			SCREENS[ready_t[i].scr1] = nil
		end
		
		for k,v in pairs(_G.SCREENS) do
			if not _G.SCREENS[k]:IsOpen() then
				_G.SCREENS[k] = nil
			end
		end				
		
		--[[
		-- should this be done here? autoload tables arent really screen related.
		-- they could do it at the call site
		local ClearAutoLoadTables = ClearAutoLoadTables
		if ClearAutoLoadTables then
			ClearAutoLoadTables()
		end
		--]]
		
		local purge_garbage = purge_garbage
		if purge_garbage then
			purge_garbage()
		else
			collectgarbage();collectgarbage();
		end
		
		local flush_image_cache = flush_image_cache
		if flush_image_cache then
			flush_image_cache()
		end		

		-- Check if we open a screen or call a function
		for i=1,ready_count do
			local scr2 = ready_t[i].scr2
			if type(scr2) == "function" then
				scr2()
				lastOpened = SCREEN_PLACEHOLDER
			else
				local ManageAssetGroups = ManageAssetGroups
				assert(ManageAssetGroups, "no ManageAssetGroups")
				if ManageAssetGroups then
					ManageAssetGroups(scr2)
				end				
				
				SCREENS[scr2]:Open(unpack(ready_t[i].params));
				if(_G.is_open("CustomLoadingMenu") and not _G.is_open("BlockingMesageMenu"))then
					SCREENS.CustomLoadingMenu:MoveToFront()
				end
				lastOpened = scr2
				
			end
		end
		
		ready_t ={}
		ready_count = 0
	end
	
	if lastOpened ~= nil and (lastOpened == SCREEN_PLACEHOLDER or SCREENS[lastOpened]:IsOpen() == true) then
		if fadeToBlack then
			--Graphics.FadeFromBlack()		
			if _G.Hero and fadeInDelay > 0 then
				local event = GameEventManager:Construct("FadeFromBlack")
				local nextTime = GetGameTime() + fadeInDelay
				GameEventManager:SendDelayed( event, _G.Hero, nextTime )				
			else
				Graphics.FadeFromBlack()
			end
			SetFadeToBlack(false)			
		end		
	end
end



------------------------------------------------------
--
--   CallScreenSequencer(actualScr, scr1, scr2)
--
--      Call this when you want to change from one screen to another
--		The change will not start until you call NotifyScreenSequencer(scr1)
--
function _G.CallScreenSequencer(scr1, scr2, ...)
LOG("CallScreenSequencer " .. scr1)
	local actualScr
	if type(scr1) == "string" then
		actualScr = SCREENS[scr1]
	else
		actualScr = scr1
	end
	assert(actualScr)
	
	local TwoOpen = false
	
	if (type(scr2) == "string") then
		if rawget(SCREENS, scr2) then
			if (SCREENS[scr2]:IsOpen()) then
				TwoOpen = true
				--LOG("Second screen is already open")
			end
		end
	end
	
	if fadeToBlack and (TwoOpen == false) then--and type(scr2) ~= "function") then
		Graphics.FadeToBlack()
		--LOG("Fading")
	end
	
	if actualScr:IsOpen() then
		actualScr:Close()
	end
	
	if (sequencing_b) then
		waiting_count = waiting_count + 1
		waiting_t[waiting_count] = {}
		waiting_t[waiting_count].scr1 = scr1
	 	waiting_t[waiting_count].scr2 = scr2
		waiting_t[waiting_count].params = arg
	else
		-- we only use sequencing to keep memory down on small devices
		-- if its off then we dont need to worry about mem so much so we wont release our screen ref
		-- _G.SCREENS[scr1] = nil
		if type(scr2) == "function" then
		 	scr2()
		else
			if fadeToBlack and TwoOpen == false then
				Graphics.FadeFromBlack()
				SetFadeToBlack(false)		
				--LOG("UnFading")
			end
			SCREENS[scr2]:Open(unpack(arg));
		end		
	end
end


------------------------------------------------------
--
--   NotifyScreenSequencer(scr1)
--
--      Automatically transitions from one screen to another
--
function NotifyScreenSequencer(scr1)
	
	if (not sequencing_b) then
		return
	end

	-- Move screen to "ready" list
	for i=1,waiting_count do
		if (waiting_t[i].scr1 == scr1) then
			-- Copy it!	
			ready_count = ready_count + 1
			ready_t[ready_count] = {}
			ready_t[ready_count].scr1 = waiting_t[i].scr1
			ready_t[ready_count].scr2 = waiting_t[i].scr2
			ready_t[ready_count].params = waiting_t[i].params
			
			waiting_t[i].scr1 = nil
		end
	end
	
	-- Check if we have any screens waiting
	local someLeft = false
	for i=1,waiting_count do
		if (waiting_t[i].scr1 ~= nil) then
			someLeft = true
			break
		end
	end
	if (not someLeft) then
		waiting_t ={}
		waiting_count = 0
	end
end


--------------------------------------------------------------------------------
-- ScreenHandler.lua - End of file
--------------------------------------------------------------------------------
