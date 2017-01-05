-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "ClearEffects" (GameEvent)

ClearEffects.AttributeDescriptions = AttributeDescriptionList()
ClearEffects.AttributeDescriptions:AddAttribute('int', 'player_id', {default=1,serialize= 1})
ClearEffects.AttributeDescriptions:AddAttribute('GameObject', 'effect', {default=1,serialize= 1})


function ClearEffects:__init()
	super("ClearEffects")
	self:SetSendToSelf(true)
end

function ClearEffects:do_OnReceive()

	local world = _G.SCREENS.GameMenu.world
	LOG("ClearEffects OnReceive - DestroyGems")

	local player = world:GetAttributeAt("Players",self:GetAttribute("player_id"))
	local item = player:GetItemAt(self:GetAttribute("item_id"))
	
	item:ClearEffects(world,player)

end

return ExportClass("ClearEffects")
