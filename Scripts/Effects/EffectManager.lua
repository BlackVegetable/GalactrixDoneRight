



-------------------------------------------------------------------------------
--player - casting player obj ref
-- effectID     - "F001"
-- obj = object to apply effect f to
-- duration in turn cycles to apply it.
-- itemCode - 4cc of item that applied effect
function _G.AddEffect(player,effectID,obj,duration,itemCode)
	local world = SCREENS.GameMenu.world
	if world.host then
		local effectEvent = GameEventManager:Construct("AddStatusEffect")
		effectEvent:SetAttribute("player_id",player:GetAttribute("player_id"))
		effectEvent:SetAttribute("item_id",itemCode)
		effectEvent:SetAttribute("effect_id",effectID)
		effectEvent:SetAttribute("targetObj",obj)
		effectEvent:SetAttribute("counter",duration)
		
		GameEventManager:Send(effectEvent,world.host_id)
	end

end
	

function _G.LoadEffect(effectID,effect)
	if not effect then
		effect = GameObjectManager:Construct("EFCT")		
	end
	
	effect.classIDStr = effectID
	effect:SetAttribute("name",  EFFECTS[effectID].name)
	effect:SetAttribute("desc",  EFFECTS[effectID].desc)
	effect:SetAttribute("sound", EFFECTS[effectID].sound)
	
	--Handle custom functions if set
	if EFFECTS[effectID].SetParams then
		effect.SetParams = EFFECTS[effectID].SetParams
	end	
	
	if EFFECTS[effectID].GetGravity then
		effect.GetGravity = EFFECTS[effectID].GetGravity
	end	
	
	if EFFECTS[effectID].ReceiveEnergy then
		LOG("Receive Energy Overridden")
		effect.MutateEventReceiveEnergy = EFFECTS[effectID].ReceiveEnergy
	end		
	
	if EFFECTS[effectID].ShipDamage then
		effect.MutateEventShipDamage = EFFECTS[effectID].ShipDamage
	end	
	
	if EFFECTS[effectID].ModifyMatches then
		effect.ModifyMatches = EFFECTS[effectID].ModifyMatches
	end
	
	if EFFECTS[effectID].NewTurn then
		effect.MutateEventNewTurn = EFFECTS[effectID].NewTurn
	end
		
	if EFFECTS[effectID].InitEffect then
		effect.InitEffect = EFFECTS[effectID].InitEffect
	end
		
	return effect
end

