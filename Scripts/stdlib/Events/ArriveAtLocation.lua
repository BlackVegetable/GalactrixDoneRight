 

use_safeglobals()




class "ArriveAtLocation" (GameEvent)

ArriveAtLocation.AttributeDescriptions = AttributeDescriptionList()
ArriveAtLocation.AttributeDescriptions:AddAttribute("string","location",{})




function ArriveAtLocation:__init()
    super("ArriveAtLocation")
end

return ExportClass("ArriveAtLocation")
