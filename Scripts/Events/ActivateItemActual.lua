-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "ActivateItemActual" (GameEvent)

ActivateItemActual.AttributeDescriptions = AttributeDescriptionList()
ActivateItemActual.AttributeDescriptions:AddAttribute('int', 'player_id',   {default=1})
--ActivateItemActual.AttributeDescriptions:AddAttribute('GameObject', 'item', {})
ActivateItemActual.AttributeDescriptions:AddAttribute('int', 'item_id', {default=1})


function ActivateItemActual:__init()
	super("ActivateItemActual")
	self:SetSendToSelf(true)
end

function ActivateItemActual:do_OnReceive()

	local world = _G.SCREENS.GameMenu.world
	
 
	local item_id = self:GetAttribute("item_id")
	local player_id = self:GetAttribute("player_id")
	local player = world:GetAttributeAt("Players",player_id)
	LOG(string.format("Item #%d activated for player #%d (ActivateItemActual:do_OnReceive)",item_id,player_id))
	
	-- Figure out the actual item
 	local item = player:GetItemAt(item_id)
	
	item:ActivateItem(world,player)

end

return ExportClass("ActivateItemActual")
