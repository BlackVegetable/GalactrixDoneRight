-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "SupaNova" (GameEvent)

SupaNova.AttributeDescriptions = AttributeDescriptionList()




function SupaNova:__init()
    super("SupaNova")
end

return ExportClass("SupaNova")