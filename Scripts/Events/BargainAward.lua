-- Bargain Award
-- Sent when gems are matched in the bargaining game

use_safeglobals()






class "BargainAward" (GameEvent)

BargainAward.AttributeDescriptions = AttributeDescriptionList()
BargainAward.AttributeDescriptions:AddAttribute('GameObject', "player", {})
BargainAward.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
BargainAward.AttributeDescriptions:AddAttribute('int', "index", {})
BargainAward.AttributeDescriptions:AddAttribute('int', "direction", {})
BargainAward.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=0})

function BargainAward:__init()
    super("BargainAward")
end

return ExportClass("BargainAward")
