-- GiveResource


use_safeglobals()




class "GiveResource" (GameEvent)

GiveResource.AttributeDescriptions = AttributeDescriptionList()
GiveResource.AttributeDescriptions:AddAttribute('string',	'resource',{})
GiveResource.AttributeDescriptions:AddAttribute('int',	'amount',{})
GiveResource.AttributeDescriptions:AddAttribute('int', 'show', {} )




function GiveResource:__init()
    super("GiveResource")
end

return ExportClass("GiveResource")