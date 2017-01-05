-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "ActivateItemEffect" (GameEvent)

ActivateItemEffect.AttributeDescriptions = AttributeDescriptionList()
ActivateItemEffect.AttributeDescriptions:AddAttribute('int', 'player_id',   {default=1})
ActivateItemEffect.AttributeDescriptions:AddAttribute('int', 'item_id', {default=1})
ActivateItemEffect.AttributeDescriptions:AddAttribute('int', 'index', {default=1})


function ActivateItemEffect:__init()
	super("ActivateItemEffect")
	self:SetSendToSelf(true)
end

function ActivateItemEffect:do_OnReceive()

	local world = _G.SCREENS.GameMenu.world
	
 
	local item_id = self:GetAttribute("item_id")
	local player_id = self:GetAttribute("player_id")
	local index = self:GetAttribute("index")
	
	-- Add a special effect
	local x = world.coords[player_id]["item"][item_id][1]
	local y = world.coords[player_id]["item"][item_id][2]
	
	if player_id == 1 then
		x = x + index*10
	else
		x = x + 160 - index*10
	end
	y = 768 - y
	
	local effect = "NovaBarFilling"
	if index == 16 then
		effect = "NovaBarFilled"
	end
	
	AttachParticles(world, effect, x,y)
	AttachParticles(world, effect, x,y-32)
	
	-- Sound
	if index == 1 then
		PlaySound("snd_itemwarmup")
	end
end

return ExportClass("ActivateItemEffect")
