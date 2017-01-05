-- HideLocation

use_safeglobals()




class "HideLocation" (GameEvent)

HideLocation.AttributeDescriptions = AttributeDescriptionList()
HideLocation.AttributeDescriptions:AddAttribute("string","location",{default=""})
HideLocation.AttributeDescriptions:AddAttribute('int', 'show', {})

function HideLocation:__init()
    super("HideLocation")
end

return ExportClass("HideLocation")