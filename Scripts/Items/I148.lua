-- I148
-- Multi-Thrusters - Destroys the selected column of gems and one column either side.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gem = world:GetGemFromPos(obj:GetX(),obj:GetY())
	local gemList = { gem }
	if world.hexAdjacent[gem][2] ~= -1 then
		table.insert(gemList, world.hexAdjacent[gem][2])
	else
		if world.hexAdjacent[gem][3] ~= -1 then
			table.insert(gemList, world.hexAdjacent[gem][3])
		end
	end

	if world.hexAdjacent[gem][5] ~= -1 then
		table.insert(gemList, world.hexAdjacent[gem][5])
	else
		if world.hexAdjacent[gem][6] ~= -1 then
			table.insert(gemList, world.hexAdjacent[gem][6])
		end
	end

	item:DestroyColumn(world, gemList, true)
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,95)

	local bonus = 0
	bonus = bonus + math.floor(#gemList3 * 0.5)
	bonus = bonus + (#gemList5 * 5)
	bonus = bonus + (#gemListX * 10)

	weight = weight + bonus

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IEC3";
	weapon_requirement = 2;
	engine_requirement = 15;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 1;
	cost = 8500;

	end_turn = 1;  passive = 0;
	user_input = _G.STATE_USER_INPUT_GEM;
	input_msg = "[SELECT_COLUMN]";
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
	ValidateInput = valid_input;
	GetAIUserInput = get_ai_input;
}
