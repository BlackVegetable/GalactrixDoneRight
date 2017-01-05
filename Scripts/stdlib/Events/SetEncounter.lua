
use_safeglobals()



class "SetEncounter" (GameEvent)

SetEncounter.AttributeDescriptions = AttributeDescriptionList()
SetEncounter.AttributeDescriptions:AddAttribute('string', 'monster', {} )
SetEncounter.AttributeDescriptions:AddAttribute('string', 'battleground', {} )
SetEncounter.AttributeDescriptions:AddAttributeCollection('string', 'params', {} )

function SetEncounter:__init()
	super("SetEncounter")
end

return ExportClass("SetEncounter")