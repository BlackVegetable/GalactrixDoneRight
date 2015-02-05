-- FE07
-- Weapon Overload - Doubles incoming Red Energy

local function modify_match(effectObj, effect, amount)
	if effect == "weapon" then
		amount = amount * 2
		PlaySound(effectObj:GetAttribute("sound"))
	end
	return amount
end


return {
	name = "[FE07_NAME]";
	desc = "[FE07_DESC]";
	sound = "snd_amplify";
	ModifyMatches = modify_match;
}
