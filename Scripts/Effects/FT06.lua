-- FT06
-- Time Warp - Miss this turn

local function new_turn(effectObj, event)
	local player = effectObj:GetAttribute("player")
	local player_id = player:GetAttribute("player_id")
	if not player.missTurn then
		local e = GameEventManager:Construct("EndTurn")
		GameEventManager:Send(e, event:GetAttribute("BattleGround"))
		player.missTurn = true
		PlaySound(effectObj:GetAttribute("sound"))
		--world:DrainEffect("Effect",player_id,"weapon",3)
	end
end

return {
	name = "[FT06_NAME]";
	desc = "[FT06_DESC]";
	sound = "snd_absorb";
	NewTurn = new_turn;
}
