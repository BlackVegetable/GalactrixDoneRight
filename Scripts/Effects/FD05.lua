-- FD05
-- Guardian Droid - All damage is halved if your Shield Energy is greater than 0

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	
	if effectObj:GetAttribute("player"):GetAttribute("shield") > 0 then
		event:SetAttribute( "amount", event:GetAttribute("amount") / 2 )
		PlaySound(effectObj:GetAttribute("sound"))
	end
end

return {
	name = "[FD05_NAME]";
	desc = "[FD05_DESC]";
	sound = "snd_absorb";
	ShipDamage = ship_damage;
}
