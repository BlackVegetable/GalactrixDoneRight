


use_safeglobals()



class "ItemNotReceived" (GameEvent)

ItemNotReceived.AttributeDescriptions = AttributeDescriptionList()
ItemNotReceived.AttributeDescriptions:AddAttribute('string', 'item', {} )


function ItemNotReceived:__init()
	super("ItemNotReceived")
end

return ExportClass("ItemNotReceived")