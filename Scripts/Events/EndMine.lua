-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndMine" (GameEvent)

EndMine.AttributeDescriptions = AttributeDescriptionList()
EndMine.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndMine.AttributeDescriptions:AddAttribute('string','asteroid',{default=""})
EndMine.AttributeDescriptions:AddAttribute('string','questID',{})
EndMine.AttributeDescriptions:AddAttribute('int','objectiveID',{})


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function EndMine:__init()
    super("EndMine")
end

return ExportClass("EndMine")
