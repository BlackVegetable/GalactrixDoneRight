-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "Award" (GameEvent)

Award.AttributeDescriptions = AttributeDescriptionList()
Award.AttributeDescriptions:AddAttribute('GameObject', "player", {})
Award.AttributeDescriptions:AddAttribute('GameObject', "BattleGround", {})
Award.AttributeDescriptions:AddAttribute('int', "index", {})
Award.AttributeDescriptions:AddAttribute('int', "direction", {default=1})
Award.AttributeDescriptions:AddAttribute('int', "displayMessages", {default=1})
Award.AttributeDescriptions:AddAttribute('int', "play_sound", {default=1})

function Award:__init()
    super("Award")
end

return ExportClass("Award")
