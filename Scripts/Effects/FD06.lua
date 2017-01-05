-- FD06
-- Interceptor Droid - All incoming damage of 3+ is reduced by 5 points

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	
	if event:GetAttribute("amount") >= 3 then
		event:SetAttribute("amount", event:GetAttribute("amount")-5 )
		if event:GetAttribute("amount") <0 then
			event:SetAttribute("amount", 0)
			end
		PlaySound(effectObj:GetAttribute("sound"))
	end
	
end

return {
	name = "[FD06_NAME]";
	desc = "[FD06_DESC]";
	sound = "snd_absorb";
	ShipDamage = ship_damage;
}
