-- I104
-- Data Generator - Destroys all white gems, giving you 1 point of Green Energy for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GINT")
	local amt = #gemList
	item:ClearGems(world, gemList, false)
	item:AwardEnergy(world, player, "cpu", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local gemList = world:GetGemList("GINT")

	weight = weight - 40 + (10 * #gemList)
	if #gemList == 0 then
		weight = 0
	end
	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS4";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 4;
	recharge = 3;
	rarity = 4;
	cost = 1250;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
