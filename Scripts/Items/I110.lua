-- I110
-- Spectral Minelayer - Creates 4 random +1 Mines on the board

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:TransformGems(world, item:GetRandomGems(4, {"GDMG", "GDM3", "GDM5", "GDMX"}, world), true, "GDMG")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local gemList = world:GetGemList("GDMG", gemList)
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)


	if #gemList < 3 then
		weight = 0
	else
		weight = weight + (#gemList * 3)
	end


	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 3;
	engine_requirement = 3;
	cpu_requirement = 3;
	recharge = 2;
	rarity = 6;
	cost = 950;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
