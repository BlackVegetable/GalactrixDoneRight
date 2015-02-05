--  RemoveResource

use_safeglobals()




class "RemoveResource" (GameEvent)

RemoveResource.AttributeDescriptions = AttributeDescriptionList()
RemoveResource.AttributeDescriptions:AddAttribute('string','resource',{})
RemoveResource.AttributeDescriptions:AddAttribute('int',	'amount',{})
RemoveResource.AttributeDescriptions:AddAttribute('int', 'show', {} )




function RemoveResource:__init()
    super("RemoveResource")
end

return ExportClass("RemoveResource")