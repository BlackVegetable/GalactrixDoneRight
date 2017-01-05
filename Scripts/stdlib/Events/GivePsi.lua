
use_safeglobals()



class "GivePsi" (GameEvent)

GivePsi.AttributeDescriptions = AttributeDescriptionList()
GivePsi.AttributeDescriptions:AddAttribute('int', 'amount', {} )
GivePsi.AttributeDescriptions:AddAttribute('int', 'show', {} )

function GivePsi:__init()
	super("GivePsi")
end

return ExportClass("GivePsi")
