-- FT07
-- Weapon Drain - Your Red Energy loses 2 points each turn

local function new_turn(effectObj, event)
	local player = effectObj:GetAttribute("player")
	--[[
	local e = GameEventManager:Construct("LoseEnergy")
	local world = event:GetAttribute("BattleGround")
	e:SetAttribute("amount", 2)
	e:SetAttribute("effect", "weapon")
	GameEventManager:Send(e, effectObj:GetAttribute("player"))
	PlaySound(effectObj:GetAttribute("sound"))
	local coords = world.coords[player:GetAttribute("player_id")]["weapon"]
	_G.ShowMessage(world, "-2", "font_numbers_red", coords[1]-world.offset_x, coords[2], false)
	--]]
	effectObj:DeductEnergy(player, "weapon", 3)
end

return {
	name = "[FT07_NAME]";
	desc = "[FT07_DESC]";
	sound = "snd_absorb";
	NewTurn = new_turn;
}
