-- RemoveFactionStatus 

use_safeglobals()




class "RemoveFactionStatus" (GameEvent)

RemoveFactionStatus.AttributeDescriptions = AttributeDescriptionList()
RemoveFactionStatus.AttributeDescriptions:AddAttribute('string',	'faction',{})
RemoveFactionStatus.AttributeDescriptions:AddAttribute('int',	'amount',{})
RemoveFactionStatus.AttributeDescriptions:AddAttribute('int', 'show', {} )




function RemoveFactionStatus:__init()
    super("RemoveFactionStatus")
end

return ExportClass("RemoveFactionStatus")