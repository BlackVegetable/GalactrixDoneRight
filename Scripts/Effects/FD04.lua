-- FD04
-- Destabilization - Shields leak through the first 5 points of damage

local function ship_damage(effectObj, event)
	if event:GetAttribute("direct") == 1 then
		return
	end
	local amount = event:GetAttribute("amount")
	local directAmount
	if amount == 1 then
	   -- effect should not apply to destruction of individual gems
		return
	end
	if amount < 5 then
		-- all damage goes to hull
		directAmount = amount
		amount = 0
	else
		amount = amount - 5
		directAmount = 5
	end
	
	LOG("Nothing")
	local e = GameEventManager:Construct("ShipDamage")
	e:SetAttribute("amount", directAmount)
	e:SetAttribute("source", event:GetAttribute("source"))
	e:SetAttribute("BattleGround", event:GetAttribute("BattleGround"))
	e:SetAttribute("target", event:GetAttribute("target"))
	e:SetAttribute("direct", 1)
	--GameEventManager:Send(e, event:GetAttribute("BattleGround"):GetEnemy(effectObj:GetAttribute("player")))
	GameEventManager:Send(e, effectObj:GetParent())
	LOG("Sent event")
	event:SetAttribute("amount", amount)
	LOG("Finished ship damage event")
	PlaySound(effectObj:GetAttribute("sound"))
end

return {
	name = "[FD04_NAME]";
	desc = "[FD04_DESC]";
	sound = "snd_amplify";
	ShipDamage = ship_damage;
}
