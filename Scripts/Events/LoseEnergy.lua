-- LoseEnergy
--  this event is sent from items to players. It causes them to lose energy.

use_safeglobals()

class "LoseEnergy" (GameEvent)

LoseEnergy.AttributeDescriptions = AttributeDescriptionList()
LoseEnergy.AttributeDescriptions:AddAttribute('string','effect',{default="intel"})
LoseEnergy.AttributeDescriptions:AddAttribute('int','amount',{default=3})
LoseEnergy.AttributeDescriptions:AddAttribute('int','show',{default=1})
LoseEnergy.AttributeDescriptions:AddAttribute('int','mutate',{default=1})

LoseEnergy.name = "LoseEnergy"

function LoseEnergy:__init()
    super("LoseEnergy")
end

return ExportClass("LoseEnergy")
