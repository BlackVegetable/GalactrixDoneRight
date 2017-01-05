--  ClearBoard
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "ClearBoard" (GameEvent)

ClearBoard.AttributeDescriptions = AttributeDescriptionList()
ClearBoard.AttributeDescriptions:AddAttribute("int","void",{default=0})
ClearBoard.AttributeDescriptions:AddAttribute("int","refresh_board",{default=1})




function ClearBoard:__init()
    super("ClearBoard")
end

return ExportClass("ClearBoard")
