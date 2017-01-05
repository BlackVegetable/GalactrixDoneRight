


use_safeglobals()



class "MonsterNotKilled" (GameEvent)

MonsterNotKilled.AttributeDescriptions = AttributeDescriptionList()
MonsterNotKilled.AttributeDescriptions:AddAttribute('string', 'monster', {} )
MonsterNotKilled.AttributeDescriptions:AddAttribute('string', 'battleground', {} )
MonsterNotKilled.AttributeDescriptions:AddAttribute('string', 'questID', {} )
MonsterNotKilled.AttributeDescriptions:AddAttribute('int', 'objectiveID', {} )

function MonsterNotKilled:__init()
	super("MonsterNotKilled")
end

return ExportClass("MonsterNotKilled")