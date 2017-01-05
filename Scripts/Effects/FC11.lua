-- FC11
-- Evasive Action -- ~30% chance to avoid 75% of damage

local function ship_damage(effectObj, event)
	if event:GetAttribute("source").offset_x then -- damage-dealer is battleground, not hero - therefore ignore
		return
	end
	local world = SCREENS.GameMenu.world

	local num = math.random()
	local myHero = 	_G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	local size = myHero:GetAttribute("curr_ship"):GetAttribute("max_items")
	local dam = event:GetAttribute("amount")
	local pilot = myHero:GetCombatStat("pilot")
	local composite = 0

	composite = composite + pilot

	if size == 3 then
		composite = composite * 2
	elseif size == 4 then
		composite = composite * 1.5
	elseif size == 5 then
		composite = composite
	end

	local missRate = composite / 210
	if missRate >= 0.75 then
		missRate = 0.75
	elseif missRate <= 0.1 then
		missRate = 0.1
	end

	if _G.ALLY_STUNNED == true then
		missRate = 0
	end

	if num <= missRate then
		event:SetAttribute("amount", dam * 0.25)
		PlaySound(effectObj:GetAttribute("sound"))
	end


end

return {
	name = "[FC11_NAME]";
	desc = "[FC11_DESC]";
	sound = "snd_absorb";
	ShipDamage = ship_damage;
}
