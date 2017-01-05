
use_safeglobals()



class "GiveExperience" (GameEvent)

GiveExperience.AttributeDescriptions = AttributeDescriptionList()
GiveExperience.AttributeDescriptions:AddAttribute('int', 'amount', {} )
GiveExperience.AttributeDescriptions:AddAttribute('int', 'show', {} )

function GiveExperience:__init()
	super("GiveExperience")
end

return ExportClass("GiveExperience")