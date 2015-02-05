
require "import"
import "safeglobals"
use_safeglobals()

-- Debug

-- require "debugex.lua"
require "debug"
-- for verbose stack trace on error. this will log all locals and upvalues
_G._TRACEBACK = debug.dump
--[[ this disables debug.dump. place it in your Startup.lua below require "stdlib"
_TRACEBACK = function() return "" end 
]]

local cg = collectgarbage
function _G.collectgarbage(a,b)
	if type(a) == "number" and b == nil then
		if gcinfo() > a then
			collectgarbage()
		end
	else
		return cg(a,b)
	end
end

-- Libraries

require "weakref"
require "autoload"
require "gen_continuous"
require "memory"
require "utility"
require "tableex"
require "coroutine"
require "stringex"

-- Helpers

require "ConstructClassFromID" -- our construction system for Lua classes. used by engine code to map 4 character codes to Lua classes
require "GameObjectHelpers"
require "ParticleHelpers"
require "OptionsHelpers"
require "GraphHelpers"
require "TextHelpers"
require "ScreenHandler"

-- Functions

function _G.tick_stdlib(time)

	-- run continuous functions
	-- this will do stuff like sizing elements over time.
	-- (should this be called every frame instead of on tick events?)
	tick_continuous(time)
	_G.CallScreenHandler()
end

--[[ extras for testing
require "quests/Quest"
require "coroutine"
require "memoize"
require "gchelpers"
require "traverse"
--]]


--]]