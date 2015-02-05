-- I021
-- Auto-Repair Scanner - Repairs +8 damage, +1 more for each  4 Green Gems on the board.  Drains your green energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GCPU")
	local amt = 8 + math.floor(#gemList / 4)

	item:AwardEnergy(world, player, "life", amt)
	item:DeductEnergy(world, player, "cpu", player:GetAttribute("cpu_max"))

end

local function should_ai_use_item(item, world, player)

	local weight = 0
	if player:GetAttribute("life") == player:GetAttribute("life_max") then
		weight = 0
	else
		weight = math.floor(95 * (1-(player:GetAttribute("life") / player:GetAttribute("life_max"))))
	end


	local cpu_need = 0
	local ship = player:GetAttribute("curr_ship")


	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			cpu_need = cpu_need + ship:GetAttributeAt("battle_items", i):GetAttribute("cpu_requirement")
		end
	end

	if cpu_need >= 12 then
		weight = weight - 10
	end

	if cpu_need >= 20 then
		weight = weight - 15
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ICC5";
	weapon_requirement = 0;
	engine_requirement = 5;
	cpu_requirement = 10;
	recharge = 5;
	rarity = 3;
	cost = 1450;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_repair";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
