-- I008
-- Mine Sweeper - Removes every mine on the board. You gain no effect for gems destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")

	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)

	item:ClearGems(world, gemList)
end

local function should_ai_use_item(item, world, player)
	--return (player:GetAttribute("life") / player:GetAttribute("life_max")*90)
	local enemy = world:GetEnemy(player)
	local eHP = enemy:GetAttribute("life") / enemy:GetAttribute("life_max")

	local weight = eHP * 85

	return weight


end

return {  psi_requirement = 0;


	icon = "img_IEC4";
	weapon_requirement = 3;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 8;
	cost = 350;

	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
