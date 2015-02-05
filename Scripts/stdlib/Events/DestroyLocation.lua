--  DestroyLocation

use_safeglobals()




class "DestroyLocation" (GameEvent)

DestroyLocation.AttributeDescriptions = AttributeDescriptionList()
DestroyLocation.AttributeDescriptions:AddAttribute("string","location",{default=""})
DestroyLocation.AttributeDescriptions:AddAttribute('int', 'show', {} )



function DestroyLocation:__init()
    super("DestroyLocation")
end

return ExportClass("DestroyLocation")