


use_safeglobals()



class "RemoveItem" (GameEvent)

RemoveItem.AttributeDescriptions = AttributeDescriptionList()
RemoveItem.AttributeDescriptions:AddAttribute('string', 'item', {} )
RemoveItem.AttributeDescriptions:AddAttribute('int', 'show', {} )


function RemoveItem:__init()
	super("RemoveItem")
end

return ExportClass("RemoveItem")