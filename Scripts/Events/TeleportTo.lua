-- TeleportTo

use_safeglobals()




class "TeleportTo" (GameEvent)

TeleportTo.AttributeDescriptions = AttributeDescriptionList()
TeleportTo.AttributeDescriptions:AddAttribute("string","location",{default=""})
TeleportTo.AttributeDescriptions:AddAttribute('int', 'show', {} )



function TeleportTo:__init()
    super("TeleportTo")
end

return ExportClass("TeleportTo")