-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "GameStart" (GameEvent)

GameStart.AttributeDescriptions = AttributeDescriptionList()

GameStart.AttributeDescriptions:AddAttributeCollection('GameObject', 'Players',{})
GameStart.AttributeDescriptions:AddAttributeCollection('GameObject', 'GamePatterns', {})
GameStart.AttributeDescriptions:AddAttributeCollection('string', 'mp_id',{})
GameStart.AttributeDescriptions:AddAttribute('int', 'time_limit',{default = 0})
GameStart.AttributeDescriptions:AddAttribute('int', 'max_keys',{default = 0})
GameStart.AttributeDescriptions:AddAttribute('int', 'gravity',{default = 0})--0,..,6
GameStart.AttributeDescriptions:AddAttribute('string', 'hack_pattern',{default = ""})
--GameStart.AttributeDescriptions:AddAttribute('GameObject', 'hack_patternObj',{})




-- attribute collection for members of side 1
-- attribute collection for members of side 2

function GameStart:__init()
    super("GameStart")
    LOG("GameStart Event Created")
end


return ExportClass("GameStart")