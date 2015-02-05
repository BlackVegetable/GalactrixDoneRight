-- I108
-- Engine Matrix - Adds +5 to Yellow Energy

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AwardEnergy(world, player, "engine", 5)
end

local function should_ai_use_item(item, world, player)

	local engine_need = 0
	local ship = player:GetAttribute("curr_ship")
	local weight = 0

	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			engine_need = engine_need + ship:GetAttributeAt("battle_items", i):GetAttribute("engine_requirement")
		end
	end

	if (engine_need / ship:GetAttribute("engine_rating")) <= 0.2 then
		weight = math.random(1,20)
	elseif (engine_need / ship:GetAttribute("engine_rating")) <= 0.4 then
		weight = math.random(1,45)
	elseif (engine_need / ship:GetAttribute("engine_rating")) <= 0.6 then
		weight = math.random(1,65)
	elseif (engine_need / ship:GetAttribute("engine_rating")) <= 0.8 then
		weight = math.random(1,85)
	elseif (engine_need / ship:GetAttribute("engine_rating")) <= 1 then
		weight = math.random(15,85)
	end

	if player:GetAttribute("engine") + 5 > player:GetAttribute("engine_max") then
		weight = 0
	elseif
		player:GetAttribute("engine") < 6 then
		weight = weight + 15
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 3;
	engine_requirement = 0;
	cpu_requirement = 5;
	recharge = 2;
	rarity = 5;
	cost = 400;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gemyellow";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
