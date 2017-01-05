-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "UnhackGate" (GameEvent)

UnhackGate.AttributeDescriptions = AttributeDescriptionList()
UnhackGate.AttributeDescriptions:AddAttribute("string","gateID",{})
UnhackGate.AttributeDescriptions:AddAttribute("int","showAnim",{default=1})
UnhackGate.AttributeDescriptions:AddAttribute("int","instant",{default=0})




function UnhackGate:__init()
    super("UnhackGate")
end

return ExportClass("UnhackGate")
