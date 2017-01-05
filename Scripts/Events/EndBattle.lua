-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndBattle" (GameEvent)

EndBattle.AttributeDescriptions = AttributeDescriptionList()
EndBattle.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndBattle.AttributeDescriptions:AddAttribute('string','enemy',{default="HE01"})--1=win,0=loss
EndBattle.AttributeDescriptions:AddAttribute('string','questID',{})
EndBattle.AttributeDescriptions:AddAttribute('int','objectiveID',{})


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function EndBattle:__init()
    super("EndBattle")
end

return ExportClass("EndBattle")
