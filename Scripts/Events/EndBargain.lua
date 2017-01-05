-- EndBargain
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()

class "EndBargain" (GameEvent)

EndBargain.AttributeDescriptions = AttributeDescriptionList()
EndBargain.AttributeDescriptions:AddAttribute('int','result',{default=0})--1=win,0=loss
EndBargain.AttributeDescriptions:AddAttribute('string', 'location', {default=""})
EndBargain.AttributeDescriptions:AddAttribute('int', 'nil_gems', {default=0})
EndBargain.AttributeDescriptions:AddAttribute('string','questID',{})
EndBargain.AttributeDescriptions:AddAttribute('int','objectiveID',{})


function EndBargain:__init()
    super("EndBargain")
end

return ExportClass("EndBargain")
