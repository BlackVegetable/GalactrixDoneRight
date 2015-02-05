--[[

   leakdetect.lua: A few helpers for tracking the lifetimes of GameObjects.  To use:
   
   Enable the leak detect before creating any game objects (Startup.lua is a good place).
   
       local leakdetect = require("leakdetect")
	   leakdetect.Enable()
	
	At application termination, BUT NOT IN OnEnd(), call DumpAnyObjects:
	
	   local leakdetect = require("leakdetect")
	   leakdetect.DumpAnyObjects()
	   
	IMPORTANT: for any GameObjects that implement a PreDestroy method, you need to call
	the PreDestroyHook callback, otherwise the detection system will think the object
	has leaked.
	
		function Puz3:PreDestroy()
			leakdetect.PreDestroyHook(self)
			-- other existing cleanup code
		end
		
	HOW IT WORKS:
	
	When you call enable the existing GameObjectManager.Construct method is replaced
	with a version that records the stack trace of the construct call in a table.  It 
	also replaces the default GameObject.PreDestroy method to remove the object from
	the table when the object is destroyed.  
	
	When an object is Destroyed it is added to a weak table, so that there is a list
	of objects that have been destroyed but still have strong references that prevents
	them from being collected by the GC.
	
	ABOUT THE OUTPUT:
	
	"GameObjects that were Constructed but not Destroyed"
	
	A list of all objects constructed but not destroy (no really!).  The stack trace
	from when the object was constructed is written to the log.
	
	"GameObjects that were Constructed and Destroyed, but not collected"
	
	These are the objects that were not collected by the GC even though they were 
	properly destroyed.  The stack trace from when the object was constructed is 
	written to the log, as well a list of all the strong references that are 
	preventing the GC from collecting the object.
	
	WHAT IT CANT DO
	
	It cant track game objects allocated by the engine.  This makes it useless for
	tracking leaks in a multiplayer environment and means it wont track objects 
	allocated as part of deserialisation (ie, loading save games).

--]]

local leakdetect = {}
local gchelpers = require "gchelpers"

local oldConstruct = GameObjectManager.Construct
local oldConstructLocal = GameObjectManager.ConstructLocal

local allNotDestroyed = {}
local allNotCollected = {}

setmetatable(allNotCollected, {__mode="k"})

function leakdetect.PreDestroyHook(obj)
	allNotCollected[obj] = allNotDestroyed[obj]
	allNotDestroyed[obj] = nil
end

function leakdetect.Enable()
	function GameObjectManager.Construct(self, typeid)
		local obj = oldConstruct(self, typeid)
		local msg = debug.traceback(string.format("GameObject of type [%s]", typeid))
		allNotDestroyed[obj] = msg
		return obj
	end
	
	function GameObjectManager.ConstructLocal(self, typeid)
		local obj = oldConstructLocal(self, typeid)
		local msg = debug.traceback(string.format("GameObject of type [%s]", typeid))
		allNotDestroyed[obj] = msg
		return obj
	end	

	function GameObject.PreDestroy(obj)
		leakdetect.PreDestroyHook(obj)
	end
end

function leakdetect.DumpAnyObjects()
	purge_garbage()
	purge_garbage()
	purge_garbage()
	
	LOG("GameObjects that were Constructed but not Destroyed")
	
	for k,v in pairs(allNotDestroyed) do
		LOG(string.format("%s allocated from %s", tostring(k), v))
	end
	
	LOG("GameObjects that were Constructed and Destroyed, but not collected")
	
	for k,v in pairs(allNotCollected) do
		LOG(string.format("%s allocated from %s", tostring(k), v))
		LOG(string.format("References to this object:"))
		for _,ref in ipairs(gchelpers.findrefs(k)) do
			LOG(ref)
		end
	end
end

return leakdetect
