-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()





class "DirectDamage" (GameEvent)

DirectDamage.AttributeDescriptions = AttributeDescriptionList()
DirectDamage.AttributeDescriptions:AddAttribute('int','amount',{default=3})
DirectDamage.AttributeDescriptions:AddAttribute('string','type',{default="mine"})
DirectDamage.AttributeDescriptions:AddAttribute('GameObject','source',{})
DirectDamage.AttributeDescriptions:AddAttribute('GameObject','BattleGround',{})


function DirectDamage:__init()
    super("DirectDamage")
end

return ExportClass("DirectDamage")
