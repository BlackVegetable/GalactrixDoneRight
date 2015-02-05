-- FT04
-- Shield Droid - Your Shield regenerates 4 points at the start of each turn

local function new_turn(effectObj, event)
	local world = event:GetAttribute("BattleGround")
	local player = effectObj:GetAttribute("player")
	effectObj:AwardEnergy(player, "shield", 4)
	PlaySound(effectObj:GetAttribute("sound"))
end

return {
	name = "[FT04_NAME]";
	desc = "[FT04_DESC]";
	sound = "snd_shieldsup";
	NewTurn = new_turn;
}
