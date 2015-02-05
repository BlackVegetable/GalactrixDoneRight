
use_safeglobals()



class "GiveGold" (GameEvent)

GiveGold.AttributeDescriptions = AttributeDescriptionList()
GiveGold.AttributeDescriptions:AddAttribute('int', 'amount', {} )
GiveGold.AttributeDescriptions:AddAttribute('int', 'show', {} )

function GiveGold:__init()
	super("GiveGold")
end

return ExportClass("GiveGold")