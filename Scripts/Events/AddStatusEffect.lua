-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "AddStatusEffect" (GameEvent)

AddStatusEffect.AttributeDescriptions = AttributeDescriptionList()
AddStatusEffect.AttributeDescriptions:AddAttributeCollection('GameObject', 'effect', {serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('GameObject', 'targetObj', {serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('string', 'effect_id', {default="",serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('string', 'item_id', {default="",serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('int', 'player_id', {default=1,serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('int', 'counter', {default=1,serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('int', 'sound', {default=1,serialize= 1})

AddStatusEffect.AttributeDescriptions:AddAttribute('int', 'param1', {default=1,serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('int', 'param2', {default=1,serialize= 1})
AddStatusEffect.AttributeDescriptions:AddAttribute('int', 'param3', {default=1,serialize= 1})


function AddStatusEffect:__init()
	super("AddStatusEffect")
	self:SetSendToSelf(false)
end

function AddStatusEffect:do_OnReceive()

	local world = _G.SCREENS.GameMenu.world
	LOG("AddStatusEffect OnReceive")
	if self:NumAttributes("effect") == 0 then
		
		local effect = GameObjectManager:Construct("EFCT")
		self:PushAttribute("effect",effect)
		self:SetSendToSelf(true)
		GameEventManager:Send(self)		
		
	else
		local player = world:GetAttributeAt("Players",self:GetAttribute("player_id"))
		local itemID = self:GetAttribute("item_id")
		
		local effectID = self:GetAttribute("effect_id")
		local effect = _G.LoadEffect(effectID,self:GetAttributeAt("effect",1))
		
	
	
		effect:SetAttribute("counter",self:GetAttribute("counter"))

		effect:SetAttribute("player",player)
		effect:SetAttribute("icon",_G.ITEMS[itemID].icon)
		effect:SetAttribute("item",itemID)
		
		local obj = self:GetAttribute("targetObj")
		
		obj:AddChild(effect)
		obj:PushAttribute("Effects",effect)
		
		effect:InitEffect()
			
		
		--LOG("Effect "..effectID.." added to "..ClassIDToString(obj:GetClassID()).." for "..tostring(duration).." turns")
			
		--Send End Turn event after Effect has been applied
		local e = GameEventManager:Construct("EndTurn")
		GameEventManager:SendDelayed( e, world, GetGameTime() + 1250)		
	end

end

return ExportClass("AddStatusEffect")
