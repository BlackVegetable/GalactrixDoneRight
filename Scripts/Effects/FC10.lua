-- FC10
-- Critical Trajectory -- Ship has a ~25% chance to deal a "critical" hit.

local function modify_match(effectObj, effect, amount)

	local myHero = 	_G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	local size = myHero:GetAttribute("curr_ship"):GetAttribute("max_items")
	local firstAmount = amount

	if effect == "damage" then
		local num = math.random()
		if size == 3 then
			if num <= 0.50 then
			amount = math.floor(amount * 1.5)
			PlaySound(effectObj:GetAttribute("sound"))
			end
		end
		if size == 4 then
			if num <= 0.35 then
			amount = math.floor(amount * 1.5)
			PlaySound(effectObj:GetAttribute("sound"))
			end
		end
		if size == 5 then
			if num <= 0.20 then
			amount = math.floor(amount * 1.5)
			PlaySound(effectObj:GetAttribute("sound"))
			end
		end
	end

	if amount >= firstAmount + 15 then
		amount = firstAmount + 15
	end

	return amount
end

return {
	name = "[FC10_NAME]";
	desc = "[FC10_DESC]";
	sound = "snd_laser";
	ModifyMatches = modify_match;
}
