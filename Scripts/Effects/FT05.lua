-- FT05
-- Time Loop - You have 25% chance of an extra turn

local function new_turn(effectObj, event)
	local world = event:GetAttribute("BattleGround")
	local player = effectObj:GetAttribute("player")
	local player_id = player:GetAttribute("player_id")
	if world:MPRandom(1,4) == 1 then
		world:AwardExtraTurn(-30)
		PlaySound(effectObj:GetAttribute("sound"))
		--world:DrainEffect("Effect",player_id,"intel",3)
	end
end

return {
	name = "[FT05_NAME]";
	desc = "[FT05_DESC]";
	sound = "snd_distortion";
	NewTurn = new_turn;
}
