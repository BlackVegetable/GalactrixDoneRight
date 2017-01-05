-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "Damage" (GameEvent)

Damage.AttributeDescriptions = AttributeDescriptionList()
Damage.AttributeDescriptions:AddAttribute('int','amount',{default=3})
Damage.AttributeDescriptions:AddAttribute('string','type',{default="mine"})


function Damage:__init()
    super("Damage")
end

return ExportClass("Damage")
