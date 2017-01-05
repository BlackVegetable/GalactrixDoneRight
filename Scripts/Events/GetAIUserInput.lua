-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "GetAIUserInput" (GameEvent)

GetAIUserInput.AttributeDescriptions = AttributeDescriptionList()
GetAIUserInput.AttributeDescriptions:AddAttribute('GameObject', "player", {})
GetAIUserInput.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
GetAIUserInput.AttributeDescriptions:AddAttribute('GameObject', "obj", {})

function GetAIUserInput:__init()
    super("GetAIUserInput")
end

return ExportClass("GetAIUserInput")
