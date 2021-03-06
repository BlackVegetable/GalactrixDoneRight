--------------------------------------------------------------------------------
--   __                             _                     _             
--  / _|                           | |                   | |            
-- | |_ _ __   ___ __   __ ___ _ __| | __ _ _   _ ___    | |_   _  __ _ 
-- |  _| '_ \ / _ \\ \ / // _ \ '__| |/ _` | | | / __|   | | | | |/ _` |
-- | | | | | | (_) |\ V /|  __/ |  | | (_| | |_| \__ \ _ | | |_| | (_| |
-- |_| |_| |_|\___/  \_/  \___|_|  |_|\__,_|\__, |___/(_)|_|\__,_|\__,_|
--                                           __/ |                      
--                                          |___/                       
--
--------------------------------------------------------------------------------
-- Originally created on 09/08/2008 by Steve Fawkner
--
-- Copyright 2008, Infinite Interactive Pty. Ltd., all rights reserved.
--------------------------------------------------------------------------------

use_safeglobals()



------------------------------------------------------
--
--   myFunction()
--
--      myDescription
--
function _G.LoadAndExecute(module, fn, purge, ...)
	local md = import(module)
	local ret = md[fn](...)
	md = nil
	if purge then
		purge_garbage()
	end
	return ret
end


--------------------------------------------------------------------------------
-- fnoverlays.lua - End of file
--------------------------------------------------------------------------------
