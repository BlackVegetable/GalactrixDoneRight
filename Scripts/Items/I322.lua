-- I322
-- Impervious Shielding -- Protects a small ship from all damage for a short time.  Lowers shields to zero afterward.

local function activate(item, world, player, obj,weapon,engine,cpu)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local turns

	if size == 5 then
		turns = 2
	elseif size == 4 then
		turns = 4
	elseif size == 3 then
		turns = 6
	end

	item:AddEffect(world,player,"FC13",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local weight = math.random(25,100)

	return weight
end

return {  psi_requirement = -1;


	icon = "img_ICC5";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 5;
	recharge = 99;
	rarity = 3;
	cost = 10000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_absorb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
