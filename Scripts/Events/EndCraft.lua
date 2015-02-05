-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndCraft" (GameEvent)

EndCraft.AttributeDescriptions = AttributeDescriptionList()
EndCraft.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndCraft.AttributeDescriptions:AddAttribute('string', 'itemID', {default="I000"})
EndCraft.AttributeDescriptions:AddAttribute('string','questID',{})
EndCraft.AttributeDescriptions:AddAttribute('int','objectiveID',{})


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function EndCraft:__init()
    super("EndCraft")
end

return ExportClass("EndCraft")
