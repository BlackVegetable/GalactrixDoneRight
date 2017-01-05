-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "ActivateItem" (GameEvent)

ActivateItem.AttributeDescriptions = AttributeDescriptionList()
ActivateItem.AttributeDescriptions:AddAttribute('int', 'player_id', {default=1,serialize= 1})
--ActivateItem.AttributeDescriptions:AddAttribute('GameObject', 'item', {serialize= 1})
ActivateItem.AttributeDescriptions:AddAttribute('int', 'item_id', {default=1,serialize= 1})


function ActivateItem:__init()
	super("ActivateItem")
	self:SetSendToSelf(true)
end

function ActivateItem:do_OnReceive()

	local world = _G.SCREENS.GameMenu.world
	local item_id = self:GetAttribute("item_id")
	local player_id = self:GetAttribute("player_id")
 	LOG(string.format("Item #%d activated for player #%d (ActivateItem:do_OnReceive)",item_id,player_id))
	
	local itemEvent = GameEventManager:Construct("ActivateItemActual")
	itemEvent:SetAttribute("player_id",player_id)
	itemEvent:SetAttribute("item_id",item_id)
	GameEventManager:SendDelayed(itemEvent, world, GetGameTime()+1000)	
	
	-- Special Effects
	for i=1,16 do
		local effectEvent = GameEventManager:Construct("ActivateItemEffect")
		effectEvent:SetAttribute("player_id",player_id)
		effectEvent:SetAttribute("item_id",item_id)
		effectEvent:SetAttribute("index",i)
		GameEventManager:SendDelayed(effectEvent, world, GetGameTime()+(i-1)*60)	
	end
	
	-- Sound Effect
	
	--[[ 
	local world = _G.SCREENS.GameMenu.world
	LOG("ActivateItem OnReceive")

	local player = world:GetAttributeAt("Players",self:GetAttribute("player_id"))
	local item = self:GetAttribute("item")
	
	--player:ActivateItem(world, item)
	item:ActivateItem(world,player)
	--]]

end

return ExportClass("ActivateItem")
