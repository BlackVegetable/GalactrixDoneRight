-- I065
-- EM Bomb - Causes an explosion on a chosen grid, destroying the gem there and all gems surrounding it.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GCPU")
	item:ClearGems(world, item:GetAdjacentGems(world, gemList), true, true)
	--[[
	local gems_to_destroy = { }
	local i = 1
	while i <= 3 and #gemList >= 1 do
		local gemVal = world:MPRandom(1, #gemList)
		table.insert(gems_to_destroy, gemList[gemVal])
		table.remove(gemList, gemVal)
		i = i + 1
	end

	item:ClearGems(world, item:GetAdjacentGems(world, gems_to_destroy), true, true)
	--]]
end

local function should_ai_use_item(item, world, player)

	local gemList = world:GetGemList("GCPU")
	local weight = math.random(1,100)

	if #gemList <= 2 then
		weight = 0
	else
		weight = weight - 30 + (#gemList * 9)
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN1";
	weapon_requirement = 12;
	engine_requirement = 0;
	cpu_requirement = 9;
	recharge = 7;
	rarity = 3;
	cost = 12000;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
