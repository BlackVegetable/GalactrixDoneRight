-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "MineAward" (GameEvent)

MineAward.AttributeDescriptions = AttributeDescriptionList()
MineAward.AttributeDescriptions:AddAttribute('GameObject', "player", {})
MineAward.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
MineAward.AttributeDescriptions:AddAttribute('int', "index", {})
MineAward.AttributeDescriptions:AddAttribute('int', "direction", {})
MineAward.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=1})

function MineAward:__init()
    super("MineAward")
end

return ExportClass("MineAward")
