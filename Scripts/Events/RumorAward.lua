-- RumorAward
-- Sent when gems are matched in the rumour game

use_safeglobals()

class "RumorAward" (GameEvent)

RumorAward.AttributeDescriptions = AttributeDescriptionList()
RumorAward.AttributeDescriptions:AddAttribute('GameObject', "player", {})
RumorAward.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
RumorAward.AttributeDescriptions:AddAttribute('int', "index", {})
RumorAward.AttributeDescriptions:AddAttribute('int', "direction", {})
RumorAward.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=0})

function RumorAward:__init()
    super("RumorAward")
end

return ExportClass("RumorAward")
