-- GiveFactionStatus

use_safeglobals()




class "GiveFactionStatus" (GameEvent)

GiveFactionStatus.AttributeDescriptions = AttributeDescriptionList()
GiveFactionStatus.AttributeDescriptions:AddAttribute('string',	'faction',{})
GiveFactionStatus.AttributeDescriptions:AddAttribute('int',	'amount',{})
GiveFactionStatus.AttributeDescriptions:AddAttribute('int', 'show', {} )




function GiveFactionStatus:__init()
    super("GiveFactionStatus")
end

return ExportClass("GiveFactionStatus")