-- EndRumor
-- Sent to the hero when they finish a rumor game

use_safeglobals()

class "EndRumor" (GameEvent)

EndRumor.AttributeDescriptions = AttributeDescriptionList()
EndRumor.AttributeDescriptions:AddAttribute('string', "rumor", {})
EndRumor.AttributeDescriptions:AddAttribute('int','result',{default=0})        --1=win,0=loss
EndRumor.AttributeDescriptions:AddAttribute('int','reward',{default=0})        --1=win,0=loss
EndRumor.AttributeDescriptions:AddAttribute('string','questID',{})
EndRumor.AttributeDescriptions:AddAttribute('int','objectiveID',{})

function EndRumor:__init()
    super("EndRumor")
end

return ExportClass("EndRumor")
