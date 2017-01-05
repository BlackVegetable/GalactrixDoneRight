


use_safeglobals()



class "ItemReceived" (GameEvent)

ItemReceived.AttributeDescriptions = AttributeDescriptionList()
ItemReceived.AttributeDescriptions:AddAttribute('string', 'item', {} )


function ItemReceived:__init()
	super("ItemReceived")
end

return ExportClass("ItemReceived")