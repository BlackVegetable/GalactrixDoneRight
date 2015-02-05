-- FM01
-- Gas Nebula - All energy matches made double in effect

local function modify_match(effectObj, effect, amount)
	if effect == "weapon" or effect == "engine" or effect == "cpu" or effect == "shield" then
		amount = amount * 2
		PlaySound(effectObj:GetAttribute("sound"))
	end
	
	return amount
end

return {
	name = "[FM01_NAME]";
	desc = "[FM01_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
