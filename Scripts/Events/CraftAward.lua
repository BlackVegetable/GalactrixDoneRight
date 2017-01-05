-- CraftAward
-- Sent when gems are matched in the crafting game

use_safeglobals()






class "CraftAward" (GameEvent)

CraftAward.AttributeDescriptions = AttributeDescriptionList()
CraftAward.AttributeDescriptions:AddAttribute('GameObject', "player", {})
CraftAward.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
CraftAward.AttributeDescriptions:AddAttribute('int', "index", {})
CraftAward.AttributeDescriptions:AddAttribute('int', "direction", {})
CraftAward.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=1})

function CraftAward:__init()
    super("CraftAward")
end

return ExportClass("CraftAward")
