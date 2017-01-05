--  ShowLocation

use_safeglobals()




class "ShowLocation" (GameEvent)

ShowLocation.AttributeDescriptions = AttributeDescriptionList()
ShowLocation.AttributeDescriptions:AddAttribute("string","location",{default=""})
ShowLocation.AttributeDescriptions:AddAttribute('int', 'show', {} )



function ShowLocation:__init()
    super("ShowLocation")
end

return ExportClass("ShowLocation")