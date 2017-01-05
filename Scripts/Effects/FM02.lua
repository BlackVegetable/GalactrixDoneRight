-- FM02
-- Minefield - All damage matches made double in effect

local function modify_match(effectObj, effect, amount)
	if effect == "damage" then
		amount = amount * 2
		PlaySound(effectObj:GetAttribute("sound"))
	end
	
	return amount
end

return {
	name = "[FM02_NAME]";
	desc = "[FM02_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
