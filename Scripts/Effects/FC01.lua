-- FC01
-- Dual-Core -- Grants 2 Green Energy and 10% of max shields per turn (min: 3)

local function new_turn(effectObj, event)
	local world = event:GetAttribute("BattleGround")
	local player = effectObj:GetAttribute("player")
	if math.floor(player:GetAttribute('shield_max') / 10) < 3 then
		effectObj:AwardEnergy(player,"shield", 3)
	else
		effectObj:AwardEnergy(player,"shield", math.floor(player:GetAttribute('shield_max') / 10))
	end
	effectObj:AwardEnergy(player, "cpu", 2)
	PlaySound(effectObj:GetAttribute("sound"))
end

return {
	name = "[FC01_NAME]";
	desc = "[FC01_DESC]";
	sound = "snd_shieldsup";
	NewTurn = new_turn;
}
