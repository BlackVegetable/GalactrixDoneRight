-- ShowCutscene


use_safeglobals()




class "ShowCutscene" (GameEvent)

ShowCutscene.AttributeDescriptions = AttributeDescriptionList()
ShowCutscene.AttributeDescriptions:AddAttribute('string',	'cutscene',{})
ShowCutscene.AttributeDescriptions:AddAttribute('int', 'show', {default=1} )




function ShowCutscene:__init()
    super("ShowCutscene")
end

return ExportClass("ShowCutscene")