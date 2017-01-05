-- I147
-- Linear thruster - Destroys the selected column of gems.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = { world:GetGemFromPos(obj:GetX(),obj:GetY()) }
	item:DestroyColumn(world, gemList, true)
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,85)

	local bonus = 0
	bonus = bonus + math.floor(#gemList3 * 0.5)
	bonus = bonus + (#gemList5 * 5)
	bonus = bonus + (#gemListX * 10)

	weight = weight + bonus

	return weight

end

function valid_input(item,obj)
	if obj:HasAttribute("isGem") then
		return true
	end
end

return {  psi_requirement = 0;


	icon = "img_IEC4";
	weapon_requirement = 4;
	engine_requirement = 10;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 2;
	cost = 3500;

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
