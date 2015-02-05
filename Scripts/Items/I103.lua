-- I103
-- Telekinetic Generator - Destroys all purple gems, giving you 1 point of Yellow Energy for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GPSI")
	item:ClearGems(world, gemList, false)
	item:AwardEnergy(world, player, "engine", #gemList)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local deficit = player:GetAttribute("engine_max") - player:GetAttribute("engine")
	local gemList = world:GetGemList("GPSI")

	if deficit == 0 then
		weight = 0
	elseif deficit < #gemList then
		if deficit < 8 then
			weight = weight - 10
		end
	end

	if #gemList > 6 then
		weight = weight + (3 * (#gemList - 6))
	end

	if #gemList == 0 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS2";
	weapon_requirement = 5;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 1;
	rarity = 4;
	cost = 1200;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
