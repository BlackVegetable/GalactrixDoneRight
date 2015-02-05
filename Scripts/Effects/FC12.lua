-- FC12
-- Density Field -- Engine gained is increased for small ships, decreased for large ships

local function modify_match(effectObj, effect, amount)

	local myHero = _G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	if effect == "engine" then
		if myHero:GetAttribute("curr_ship"):GetAttribute("max_items") == 3 then
			amount = amount * 3
			PlaySound(effectObj:GetAttribute("sound"))
		elseif myHero:GetAttribute("curr_ship"):GetAttribute("max_items") == 4 then
			amount = amount * 2
			PlaySound(effectObj:GetAttribute("sound"))
		elseif myHero:GetAttribute("curr_ship"):GetAttribute("max_items") == 5 then
			amount = amount + 1
			PlaySound(effectObj:GetAttribute("sound"))
		elseif myHero:GetAttribute("curr_ship"):GetAttribute("max_items") == 6 then
			amount = amount - 1
			PlaySound(effectObj:GetAttribute("sound"))
		elseif myHero:GetAttribute("curr_ship"):GetAttribute("max_items") == 7 then
			if amount / 2 > amount - 1 then
				amount = amount - 1
			else
				amount = math.ceil(amount / 2)
			end
			PlaySound(effectObj:GetAttribute("sound"))
		elseif myHero:GetAttribute("curr_ship"):GetAttribute("max_items") == 8 then
			amount = math.ceil(amount / 3)
			PlaySound(effectObj:GetAttribute("sound"))
		end
	end

	return amount
end

return {
	name = "[FC12_NAME]";
	desc = "[FC12_DESC]";
	sound = "snd_gravity";
	ModifyMatches = modify_match;
}
