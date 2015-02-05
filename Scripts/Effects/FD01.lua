-- FD01
-- Adapative Armor - Has a 20% chance to reduce incoming damage to 1 point

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	local world = SCREENS.GameMenu.world
	if world:MPRandom(1,5) == 1 then
		event:SetAttribute("amount",1)
		PlaySound(effectObj:GetAttribute("sound"))
		local player = effectObj:GetAttribute("player")
		local player_id = player:GetAttribute("player_id")
		--world:DrainEffect("Effect",player_id,"life",player_id)
	end
end

return {
	name = "[FD01_NAME]";
	desc = "[FD01_DESC]";
	sound = "snd_absorb";
	ShipDamage = ship_damage;
}
