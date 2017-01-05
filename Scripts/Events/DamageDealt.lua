-- DamageDealt
-- this event is sent from a player receiving damage to the
-- source of that damage, so the player can track damage dealt

use_safeglobals()




class "DamageDealt" (GameEvent)

DamageDealt.AttributeDescriptions = AttributeDescriptionList()
DamageDealt.AttributeDescriptions:AddAttribute("int", "amount", {default=0})

function DamageDealt:__init()
    super("DamageDealt")
end

return ExportClass("DamageDealt")