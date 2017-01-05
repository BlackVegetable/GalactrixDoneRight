-- I107
-- Data Matrix - Adds +5 to Green Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AwardEnergy(world, player, "cpu", 5)
end

local function should_ai_use_item(item, world, player)

	local cpu_need = 0
	local ship = player:GetAttribute("curr_ship")
	local weight = 0

	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			cpu_need = cpu_need + ship:GetAttributeAt("battle_items", i):GetAttribute("cpu_requirement")
		end
	end

	if (cpu_need / ship:GetAttribute("cpu_rating")) <= 0.2 then
		weight = math.random(1,20)
	elseif (cpu_need / ship:GetAttribute("cpu_rating")) <= 0.4 then
		weight = math.random(1,45)
	elseif (cpu_need / ship:GetAttribute("cpu_rating")) <= 0.6 then
		weight = math.random(1,65)
	elseif (cpu_need / ship:GetAttribute("cpu_rating")) <= 0.8 then
		weight = math.random(1,85)
	elseif (cpu_need / ship:GetAttribute("cpu_rating")) <= 1 then
		weight = math.random(15,85)
	end

	if player:GetAttribute("cpu") + 5 > player:GetAttribute("cpu_max") then
		weight = 0
	elseif
		player:GetAttribute("cpu") < 6 then
		weight = weight + 15
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS5";
	weapon_requirement = 4;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 2;
	rarity = 5;
	cost = 400;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gemgreen";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
