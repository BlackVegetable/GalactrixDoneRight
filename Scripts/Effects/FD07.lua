-- FD07
-- Mass Driver - Adds +1 damage for every 2 Yellow gems in play

local function modify_match(effectObj, effect, amount)
	if effect == "damage" then
		local world = SCREENS.GameMenu.world
		local bonusAmount = math.floor(#world:GetGemList("GENG") / 2)
		amount = amount + bonusAmount
		PlaySound(effectObj:GetAttribute("sound"))
	end
	return amount
end

return {
	name = "[FD07_NAME]";
	desc = "[FD07_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
