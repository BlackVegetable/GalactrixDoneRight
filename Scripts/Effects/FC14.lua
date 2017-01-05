-- FC14
-- Entropy Field -

local function modify_match(effectObj, effect, amount)

	local myHero = _G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	local battleGround = _G.SCREENS.GameMenu.world

	if effect == "psi" then
		battleGround:DamagePlayer(myHero,myHero,2,true,"RedPath")
		effectObj:DeductEnergy(myHero,"shield",2)
	end
	return amount
end

return {
	name = "[FC14_NAME]";
	desc = "[FC14_DESC]";
	sound = "snd_gravity";
	ModifyMatches = modify_match;
}
