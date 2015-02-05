-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "GetUserInput" (GameEvent)

GetUserInput.AttributeDescriptions = AttributeDescriptionList()
GetUserInput.AttributeDescriptions:AddAttribute('GameObject', "player", {})
GetUserInput.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
GetUserInput.AttributeDescriptions:AddAttribute('GameObject', "obj", {})

function GetUserInput:__init()
    super("GetUserInput")
end

return ExportClass("GetUserInput")
