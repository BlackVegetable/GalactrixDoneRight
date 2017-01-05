-- LossMenu
-- this event is sent from the battleground to itself
-- it causes the losing menu for the battleground to be opened

use_safeglobals()

class "LossMenu" (GameEvent)

LossMenu.AttributeDescriptions = AttributeDescriptionList()
LossMenu.AttributeDescriptions:AddAttribute('int',        'winner_id',  {default=0})
LossMenu.AttributeDescriptions:AddAttribute('GameObject', 'stat_hero', {})

function LossMenu:__init()
	super("LossMenu")
end

return ExportClass("LossMenu")
