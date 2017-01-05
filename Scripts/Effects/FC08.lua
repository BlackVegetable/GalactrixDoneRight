-- FC08
-- Blind Spot -- +3~10 Damage when matching mines.  Cancelled by Hull Damage and Affected by Ship Size

local function modify_match(effectObj, effect, amount)

	local myHero = 	_G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	local size = myHero:GetAttribute("curr_ship"):GetAttribute("max_items")

	if effect == "damage" then
		PlaySound(effectObj:GetAttribute("sound"))
		if size == 3 then
			amount = amount + 10
		elseif size == 4 then
			amount = amount + 6
		elseif size == 5 then
			amount = amount + 4
		elseif size >= 6 then
			amount = amount + 3
		end
	end

	return amount
end

return {
	name = "[FC08_NAME]";
	desc = "[FC08_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
