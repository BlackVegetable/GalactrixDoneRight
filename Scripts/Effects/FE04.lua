-- FE04
-- Overclocking - Doubles incoming Green energy

local function modify_match(effectObj, event)
	if effect == "cpu" then
		amount = amount * 2
		PlaySound(effectObj:GetAttribute("sound"))
	end
	return amount
end


return {
	name = "[FE04_NAME]";
	desc = "[FE04_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
