-- FD03
-- Conductive Armor - Adds +1 to Red, Yellow, and Green Energy when taking damage

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	
	effectObj:AwardEnergy(effectObj:GetAttribute("player"), "weapon", 1)
	effectObj:AwardEnergy(effectObj:GetAttribute("player"), "engine", 1)
	effectObj:AwardEnergy(effectObj:GetAttribute("player"), "cpu",    1)

	PlaySound(effectObj:GetAttribute("sound"))
end

return {
	name = "[FD03_NAME]";
	desc = "[FD03_DESC]";
	sound = "snd_amplify";
	ShipDamage = ship_damage;
}
