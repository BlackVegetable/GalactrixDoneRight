-- FT02
-- CPU Drain - Your Green Energy loses 3 points each turn

local function new_turn(effectObj, event)
	local player = effectObj:GetAttribute("player")
	--local amount = math.min(2,player:GetAttribute("cpu"))
	--[[
	local e = GameEventManager:Construct("LoseEnergy")
	e:SetAttribute("amount", amount)
	e:SetAttribute("effect", "cpu")
	GameEventManager:Send(e, player)
	PlaySound(effectObj:GetAttribute("sound"))
	local coords = world.coords[player:GetAttribute("player_id")]["cpu"]
	_G.ShowMessage(world, "-"..tostring(amount), "font_numbers_green", coords[1]-world.offset_x, coords[2], false)
	--]]

	effectObj:DeductEnergy(player, "cpu", 3)

end

return {
	name = "[FT02_NAME]";
	desc = "[FT02_DESC]";
	sound = "snd_absorb";
	NewTurn = new_turn;
}
