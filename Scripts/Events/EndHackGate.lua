-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndHackGate" (GameEvent)

EndHackGate.AttributeDescriptions = AttributeDescriptionList()
EndHackGate.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndHackGate.AttributeDescriptions:AddAttribute('string','gate',{default=""})
EndHackGate.AttributeDescriptions:AddAttribute('string','questID',{})
EndHackGate.AttributeDescriptions:AddAttribute('int','objectiveID',{})


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function EndHackGate:__init()
    super("EndHackGate")
end

return ExportClass("EndHackGate")
