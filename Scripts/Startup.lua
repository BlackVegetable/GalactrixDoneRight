-- startup.lua
-- this gets executed at program startup

-- get import and require ready for usess
LUA_PATH =
			"Assets/Scripts/?.lua;" ..
			"Assets/Scripts/stdlib/?.lua;" ..
            "Assets/?.lua;" ..			
            -- locations where we store the map and map info
			"Assets/Scripts/Maps/?.lua;" ..
			"Assets/Scripts/BattleGrounds/?.lua;" ..
			
			"Assets/Scripts/Heroes/?.lua;" ..
			"Assets/Scripts/StarSystems/?.lua;" ..
              -- fallback. we dont put lua files in the root but some modders might (maybe for config files?)
            "?.lua"

if package then
   package.path = LUA_PATH
end

LOG("Executing Startup script.")
LOG("Lua path is "..LUA_PATH)

-- SCF: Turn these on only for profiling purposes
--require "debugrequire"
--require "profiler"

--[[ DISABLE LOGGING
local function do_nothing()	
end
LOG = do_nothing
--]]

-- make print messages go to Log if its available (ie in game)
print = LOG or print

require "stdlib"

-- Load our Application functions
require "Application"

--Tutorials setup
_G.MAX_TUTORIALS = 30	
require "Tutorials/Tutorial"
--require "BattleGrounds/BattleManager"
require "Effects/EffectManager"
--require "Heroes/FactionManager"
--require "Ships/CargoManager"
--require "Ships/ShipManager"
require "Satellites/SatelliteManager"
--require "Items/ItemManager"
require "BattleGrounds/MessageManager"
require "MapObjectManager"
require "quests/Quest"
--require "Heroes/HeroManager"
require "Gems/GemManager"


-- The event system looks in the EVENTS table for constructors if we request an event that isnt provided
-- by the engine.
EVENTS = autoload("Events/")


-- Autoload screens
-- we require that Screens are always importable via 
--      import "Screens/ScreenName"
-- this is because the C++ Code registers some C++ based screens with the system
-- and in order for them to appear the same as the lua screens they must be importable
SCREENS = autoload("Screens/")


DATA = autoload("Data/")
GLOBAL_FUNCTIONS = autoload("GlobalFunctions/")

-- Autoload our games objects

-- maps
MAPS = autoload("Maps/")
RegisterClassFactory( "M", TableLookupConstructor(MAPS) )


-- NOTE:    stars and links are no longer class hierarchies
--              because they do not override behaviour. only data.
-- Stars
-- STARS = autoload("Stars/")
-- RegisterClassFactory( "R", TableLookupConstructor(STARS) )
-- Links
--  links link nodes together
-- LINKS = autoload("Links/")
-- RegisterClassFactory( "L", TableLookupConstructor(LINKS) )


-- Roads and Stars are leaf classes, not part of a heirarchy.
-- So we register them differently
-- this will still autoload road.lua when GameObjectManager:Construct("road") is called
--RegisterClassFactory( "Road", ImportConstructor() )
RegisterClassFactory( "Star", ImportConstructor("Stars/") )

RegisterClassFactory( "Gate", ImportConstructor("JumpGates/") )

GATES = autoload("JumpGates/")
RegisterClassFactory( "J", TableLookupConstructor(GATES) )


-- BATTLEGROUNDs
BATTLEGROUNDS = autoload("BattleGrounds/")
RegisterClassFactory( "B", TableLookupConstructor(BATTLEGROUNDS) )
RegisterClassFactory( "GMSG", ImportConstructor() )

-- REQUIRED FOR FXCONTAINER
RegisterClassFactory( "FFXT", ImportConstructor() )
RegisterClassFactory( "FFXS", ImportConstructor() )
RegisterClassFactory( "FFXG", ImportConstructor() )



-- Patterns

RegisterClassFactory( "Pttn", ImportConstructor("Patterns/") )--Pattern
RegisterClassFactory( "Mach", ImportConstructor("Patterns/") )--Match
PATTERNS = autoload("Patterns/")
RegisterClassFactory( "P", TableLookupConstructor(PATTERNS) )

-- Effects
RegisterClassFactory( "EFCT",ImportConstructor("Effects/") )  
EFFECTS = autoload("Effects/")
RegisterClassFactory( "F", TableLookupConstructor(EFFECTS) )

-- Ships
SHIPS = autoload("Ships/")
--RegisterClassFactory( "S", TableLookupConstructor(SHIPS) )
RegisterClassFactory( "Ship", ImportConstructor("Ships/") )




-- Autoload quests/missions
--QUESTS = autoload("Quests/")
--RegisterClassFactory( "Q", TableLookupConstructor(QUESTS) ) -- "QXXX" maps to Quest types


-- Autoload items
ITEMS = autoload("Items/")
--RegisterClassFactory( "I", TableLookupConstructor(ITEMS) )
RegisterClassFactory( "Item",ImportConstructor("Items/") )  
RegisterClassFactory( "IL00",ImportConstructor("Items/") ) 


-- Autoload items
PSI = autoload("Psi/")
RegisterClassFactory( "P", TableLookupConstructor(PSI) )  -- "PXXX" maps to Item types

-- Autoload crew
CREW = autoload("Crew/")
RegisterClassFactory( "C", TableLookupConstructor(CREW) )   -- "CXXX" maps to Crew types

-- Autoload Encounters
ENCOUNTERS = autoload("Encounters/")
RegisterClassFactory( "E", TableLookupConstructor(ENCOUNTERS) ) -- "EXXX" maps to Encounter types

HEROES = autoload("Heroes/")
RegisterClassFactory( "H", TableLookupConstructor(HEROES) ) -- "HXXX" maps to Hero types

-- Autoload Satellites
SATELLITES = autoload("Satellites/")
RegisterClassFactory( "T", TableLookupConstructor(SATELLITES) )

BEAMS = autoload("Beams/")

RegisterClassFactory( "PLNT", ImportConstructor("Satellites/") )
RegisterClassFactory( "SPST", ImportConstructor("Satellites/") )
RegisterClassFactory( "ASTD", ImportConstructor("Satellites/") )
RegisterClassFactory( "MOON", ImportConstructor("Satellites/") )
RegisterClassFactory( "SHYD", ImportConstructor("Satellites/") )
RegisterClassFactory( "FORG", ImportConstructor("Satellites/") )

_G.JumpGateList = {}

_G.StarList = {}



-- Autoload StarSystems
RegisterClassFactory( "SSTM", ImportConstructor("StarSystems/") )
--STARSYSTEMS = autoload("StarSystems/")
--RegisterClassFactory( "Y", TableLookupConstructor(STARSYSTEMS) )

-- Autoload Stars
STARS = autoload("Stars/")
RegisterClassFactory( "S", TableLookupConstructor(STARS) )

--Hero related 
RegisterClassFactory( "Hero", ImportConstructor("Heroes/") )

require "Tutorial" -- used for options screen
require "HintArrowOption" -- used for options screen

-- Gems

GEMS = autoload("Gems/")
RegisterClassFactory( "Gems", ImportConstructor("Gems/") )

RegisterClassFactory( "GSEL", ImportConstructor("Gems/") )


_G.ScreenManager = import("ScreenManager")


require "GalactrixGlobals"

_G.GAME_VERSION=""--"B.28","XB.9"


dofile("Assets/Scripts/StartupPlatform.lua")

LOG("Finished Startup script")

function GameObject.PreDestroy(self)
	LOG("PreDestroy called for type " .. ClassIDToString(self:GetClassID()))
end

function GameObject.__finalize()
	LOG("__finalize called for a game object!")
end


