-- RemoveFriend

use_safeglobals()




class "RemoveFriend" (GameEvent)

RemoveFriend.AttributeDescriptions = AttributeDescriptionList()
RemoveFriend.AttributeDescriptions:AddAttribute('string',	'friend',{})
RemoveFriend.AttributeDescriptions:AddAttribute('int', 'show', {} )



function RemoveFriend:__init()
    super("RemoveFriend")
end

return ExportClass("RemoveFriend")