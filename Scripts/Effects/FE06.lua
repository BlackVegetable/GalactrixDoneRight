-- FE06
-- Sub-Light - Adds +2 to all generated energy

local function modify_match(effectObj, effect, amount)
	LOG(string.format("Modified match %s %d", effect, amount))
	if effect == "weapon" or effect == "engine" or effect == "cpu" or effect == "shield" then
		amount = amount + 2
		PlaySound(effectObj:GetAttribute("sound"))
	end
	
	return amount
end


return {
	name = "[FE06_NAME]";
	desc = "[FE06_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
