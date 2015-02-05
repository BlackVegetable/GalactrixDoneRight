-- FC13
-- Invincibility -- All damage reduced to 0.  Shields reduced to 0 at end of effect.

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	event:SetAttribute("amount", 0)
	PlaySound(effectObj:GetAttribute("sound"))
end

return {
	name = "[FC13_NAME]";
	desc = "[FC13_DESC]";
	sound = "snd_absorb";
	ShipDamage = ship_damage;
}
