-- FC15
-- Aggression Drone - Deals 3 hp/sp damage per turn.

local function new_turn(effectObj, event)
--	local player = effectObj:GetAttribute("player")

--	local battleGround = _G.SCREENS.GameMenu.world
--	effectObj:DeductEnergy(player, "shield", 3)
--	battleGround:DamagePlayer(player,player,3,true,"RedPath")

end

return {
	name = "[FC15_NAME]";
	desc = "[FC15_DESC]";
	sound = "snd_drone";
	ModifyMatches = modify_match;
}
