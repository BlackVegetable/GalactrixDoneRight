-- FT03
-- Shield Drain - Your Shield loses 4 points each turn

local function new_turn(effectObj, event)
	local player = effectObj:GetAttribute("player")
	--[[
	local e = GameEventManager:Construct("LoseEnergy")
	local world = event:GetAttribute("BattleGround")
	e:SetAttribute("amount", 3)
	e:SetAttribute("effect", "shield")
	GameEventManager:Send(e, effectObj:GetAttribute("player"))
	PlaySound(effectObj:GetAttribute("sound"))
	local coords = world.coords[player:GetAttribute("player_id")]["shield"]
	_G.ShowMessage(world, "-3", "font_numbers_blue", coords[1]-world.offset_x, coords[2], false)

	--]]
	effectObj:DeductEnergy(player, "shield", 4)
end

return {
	name = "[FT03_NAME]";
	desc = "[FT03_DESC]";
	sound = "snd_shieldsdown";
	NewTurn = new_turn;
}
