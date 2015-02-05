-- FE02
-- Boost - Doubles incoming Yellow Energy

local function modify_match(effectObj, effect, amount)
	if effect == "engine" then
		amount = amount * 2
		PlaySound(effectObj:GetAttribute("sound"))
	end
	return amount
end


return {
	name = "[FE02_NAME]";
	desc = "[FE02_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
