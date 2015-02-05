-- FC16
-- Aggression Drone - Deals 1 hp/sp damage per turn and lowers stats by 20%.

local function new_turn(effectObj, event)
--	local player = effectObj:GetAttribute("player")

--	local battleGround = _G.SCREENS.GameMenu.world
--	effectObj:DeductEnergy(player, "shield", 1)
--	battleGround:DamagePlayer(player,player,1,true,"RedPath")

end

return {
	name = "[FC16_NAME]";
	desc = "[FC16_DESC]";
	sound = "snd_drone";
	ModifyMatches = modify_match;
}
