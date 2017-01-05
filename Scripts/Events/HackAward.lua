-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "HackAward" (GameEvent)

HackAward.AttributeDescriptions = AttributeDescriptionList()
HackAward.AttributeDescriptions:AddAttribute('GameObject', "player", {})
HackAward.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
HackAward.AttributeDescriptions:AddAttribute('int', "index", {})
HackAward.AttributeDescriptions:AddAttribute('int', "direction", {})
HackAward.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=0})

function HackAward:__init()
    super("HackAward")
end

return ExportClass("HackAward")
