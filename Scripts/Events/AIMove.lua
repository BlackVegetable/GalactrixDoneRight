-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "AIMove" (GameEvent)

AIMove.AttributeDescriptions = AttributeDescriptionList()
AIMove.AttributeDescriptions:AddAttribute("int","swap1",{default=1})
AIMove.AttributeDescriptions:AddAttribute("int","swap2",{default=2})




function AIMove:__init()
    super("AIMove")
end

return ExportClass("AIMove")
