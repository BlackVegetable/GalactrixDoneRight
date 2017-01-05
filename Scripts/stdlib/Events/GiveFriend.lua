-- GiveFriend

use_safeglobals()




class "GiveFriend" (GameEvent)

GiveFriend.AttributeDescriptions = AttributeDescriptionList()
GiveFriend.AttributeDescriptions:AddAttribute('string',	'friend',{})
GiveFriend.AttributeDescriptions:AddAttribute('int', 'show', {} )



function GiveFriend:__init()
    super("GiveFriend")
end

return ExportClass("GiveFriend")