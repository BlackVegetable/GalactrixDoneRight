
use_safeglobals()



class "StartBattle" (GameEvent)

StartBattle.AttributeDescriptions = AttributeDescriptionList()
StartBattle.AttributeDescriptions:AddAttribute('string', 'monster', {} )
StartBattle.AttributeDescriptions:AddAttribute('string', 'battleground', {} )
StartBattle.AttributeDescriptions:AddAttribute('string', 'questID', {} )
StartBattle.AttributeDescriptions:AddAttribute('int', 'objectiveID', {} )
StartBattle.AttributeDescriptions:AddAttributeCollection('string', 'params', {} )

function StartBattle:__init()
	super("StartBattle")
end

return ExportClass("StartBattle")