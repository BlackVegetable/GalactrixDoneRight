-- VictoryMenu
-- this event is sent from the battleground to itself
-- it causes the victory menu for the battleground to be opened

use_safeglobals()

class "VictoryMenu" (GameEvent)

VictoryMenu.AttributeDescriptions = AttributeDescriptionList()
VictoryMenu.AttributeDescriptions:AddAttribute('int',        'winner_id',  {default=1})
VictoryMenu.AttributeDescriptions:AddAttribute('GameObject', 'stat_hero', {})

function VictoryMenu:__init()
	super("VictoryMenu")
end

return ExportClass("VictoryMenu")
