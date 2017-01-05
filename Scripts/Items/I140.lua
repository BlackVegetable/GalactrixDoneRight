-- I140
-- Fireball Thruster - Destroys selected gem plus all gems around it. Full effect is given for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = { world:GetGemFromPos(obj:GetX(),obj:GetY()) }

	--item:ExplodeGem(world, gemList, true)
	item:ClearGems(world, item:GetAdjacentGems(world, gemList), true, true)
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,70)

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


	icon = "img_IEC5";
	weapon_requirement = 4;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 1;
	cost = 5210;

	end_turn = 1;  passive = 0;
	user_input = _G.STATE_USER_INPUT_GEM;
	input_msg = "[SELECT_GEM]";
	status_on_enemy = 0;
	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
	ValidateInput = valid_input;
	GetAIUserInput = get_ai_input;
}
