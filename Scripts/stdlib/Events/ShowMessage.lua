-- ShowMessage


use_safeglobals()




class "ShowMessage" (GameEvent)

ShowMessage.AttributeDescriptions = AttributeDescriptionList()
ShowMessage.AttributeDescriptions:AddAttribute('string',	'message',{})
ShowMessage.AttributeDescriptions:AddAttribute('int', 'show', {default=1} )




function ShowMessage:__init()
    super("ShowMessage")
end

return ExportClass("ShowMessage")