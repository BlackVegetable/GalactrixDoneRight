-- FD02
-- Cloaked - All incoming damage is diverted until you damage your enemy

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	event:SetAttribute("amount", 0)
	PlaySound(effectObj:GetAttribute("sound"))
end

return {
	name = "[FD02_NAME]";
	desc = "[FD02_DESC]";
	sound = "snd_absorb";
	ShipDamage = ship_damage;
}
