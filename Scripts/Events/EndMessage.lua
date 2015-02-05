-- EndMessage
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndMessage" (GameEvent)

EndMessage.AttributeDescriptions = AttributeDescriptionList()



function EndMessage:__init()
    super("EndMessage")
end

return ExportClass("EndMessage")
