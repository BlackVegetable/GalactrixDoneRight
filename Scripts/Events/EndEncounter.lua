-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndEncounter" (GameEvent)

EndEncounter.AttributeDescriptions = AttributeDescriptionList()
EndEncounter.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndEncounter.AttributeDescriptions:AddAttribute('string','encounter',{default=""})
EndEncounter.AttributeDescriptions:AddAttribute('string','enemy',{default=""})
EndEncounter.AttributeDescriptions:AddAttribute('string','questID',{})
EndEncounter.AttributeDescriptions:AddAttribute('int','objectiveID',{})


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function EndEncounter:__init()
    super("EndEncounter")
end

return ExportClass("EndEncounter")
