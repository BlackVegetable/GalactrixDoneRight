-- I321
-- Density Field -- Increases the engine gained by smaller ships while decreasing it for larger ones, lasts 8T.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FC12",world,8,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local enemy = world.GetEnemy(player)
	local eSize = enemy:GetAttribute("curr_ship"):GetAttribute("max_items")
	local weight = math.random(1,90)

	weight = weight + (eSize - size) * 10
	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IFT4";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 6;
	recharge = 6;
	rarity = 3;
	cost = 3000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
