-- SpawnParticles
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()






class "SpawnParticles" (GameEvent)

SpawnParticles.AttributeDescriptions = AttributeDescriptionList()


function SpawnParticles:__init()
	super("SpawnParticles")
end

return ExportClass("SpawnParticles")