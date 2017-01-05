


use_safeglobals()



class "GiveItem" (GameEvent)

GiveItem.AttributeDescriptions = AttributeDescriptionList()
GiveItem.AttributeDescriptions:AddAttribute('string', 'item', {} )
GiveItem.AttributeDescriptions:AddAttribute('int', 'show', {} )


function GiveItem:__init()
	super("GiveItem")
end

return ExportClass("GiveItem")