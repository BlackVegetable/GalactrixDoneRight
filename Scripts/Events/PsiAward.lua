-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "PsiAward" (GameEvent)

PsiAward.AttributeDescriptions = AttributeDescriptionList()
PsiAward.AttributeDescriptions:AddAttribute('GameObject', "player", {})
PsiAward.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
PsiAward.AttributeDescriptions:AddAttribute('int', "index", {})
PsiAward.AttributeDescriptions:AddAttribute('int', "direction", {})
PsiAward.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=0})

function PsiAward:__init()
    super("PsiAward")
end

return ExportClass("PsiAward")
