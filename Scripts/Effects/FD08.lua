-- FD08
-- Targeting - Adds +3 to all damage dealt

local function modify_match(effectObj, effect, amount)
	if effect == "damage" then
		PlaySound(effectObj:GetAttribute("sound"))
		amount = amount + 3
	end
	
	return amount
end

return {
	name = "[FD08_NAME]";
	desc = "[FD08_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
