-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "Nova" (GameEvent)

Nova.AttributeDescriptions = AttributeDescriptionList()




function Nova:__init()
    super("Nova")
end

return ExportClass("Nova")