-- SetNewDest - this is sent to hero object to reset pos at end of movement 

use_safeglobals()




class "SetNewDest" (GameEvent)

SetNewDest.AttributeDescriptions = AttributeDescriptionList()
SetNewDest.AttributeDescriptions:AddAttribute('GameObject',"heroObj",{})
SetNewDest.AttributeDescriptions:AddAttribute('GameObject',"world",{})



function SetNewDest:__init()
    super("SetNewDest")
end

return ExportClass("SetNewDest")