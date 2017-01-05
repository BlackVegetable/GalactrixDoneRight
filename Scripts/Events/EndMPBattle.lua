-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "EndMPBattle" (GameEvent)

EndMPBattle.AttributeDescriptions = AttributeDescriptionList()
EndMPBattle.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndMPBattle.AttributeDescriptions:AddAttribute('string','enemy',{default="HE01"})--1=win,0=loss
EndMPBattle.AttributeDescriptions:AddAttribute('string','questID',{})
EndMPBattle.AttributeDescriptions:AddAttribute('int','objectiveID',{})
EndMPBattle.AttributeDescriptions:AddAttribute('int','mode',{default=0})--0=Online-unranked,1=Online-Ranked,2=Local MP


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function EndMPBattle:__init()
    super("EndMPBattle")
end

return ExportClass("EndMPBattle")
