-- I066
-- Smart Bomb - Causes an explosion on a chosen grid, destroying the gem there and all gems surrounding it.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local index = world:GetGemFromPos(obj:GetX(), obj:GetY())
	local gemList = { index }
	--item:ExplodeGem(world, gemList, true)
	item:ClearGems(world, item:GetAdjacentGems(world, gemList), true, true)
end

function valid_input(item,obj)
	if obj:HasAttribute("isGem") then
		return true
	end
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,55)

	local bonus = 0
	bonus = bonus + math.floor(#gemList3 * 0.5)
	bonus = bonus + (#gemList5 * 5)
	bonus = bonus + (#gemListX * 10)

	weight = weight + bonus

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 12;
	engine_requirement = 0;
	cpu_requirement = 4;
	recharge = 3;
	rarity = 3;
	cost = 8200;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = _G.STATE_USER_INPUT_GEM;
	input_msg = "[SELECT_GEM]";

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
