


use_safeglobals()



class "MonsterKilled" (GameEvent)

MonsterKilled.AttributeDescriptions = AttributeDescriptionList()
MonsterKilled.AttributeDescriptions:AddAttribute('string', 'monster', {} )
MonsterKilled.AttributeDescriptions:AddAttribute('string', 'battleground', {} )
MonsterKilled.AttributeDescriptions:AddAttribute('string', 'questID', {} )
MonsterKilled.AttributeDescriptions:AddAttribute('int', 'objectiveID', {} )

function MonsterKilled:__init()
	super("MonsterKilled")
end

return ExportClass("MonsterKilled")