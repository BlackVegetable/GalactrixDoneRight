-- I112
-- Shock Minelayer - Creates a single random +10 Mine on the board

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = { world:MPRandom(1,55) }
	item:TransformGems(world, gemList, true, "GDMX")
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IMN1";
	weapon_requirement = 0;
	engine_requirement = 2;
	cpu_requirement = 6;
	recharge = 2;
	rarity = 1;
	cost = 12420;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
