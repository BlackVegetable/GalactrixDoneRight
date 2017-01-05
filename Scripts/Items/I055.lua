-- I055
-- Language Assimilator - Destroys all White Gems on the board. For each gem destroyed, it adds +1 to your Green Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GINT")
	local amt = #gemList
	item:ClearGems(world, gemList)

	item:AwardEnergy(world, player, "cpu", amt)
end

local function should_ai_use_item(item, world, player)

	local gemList = world:GetGemList("GINT")
	local amt = #gemList
	local weight = math.random(1,90)

	if amt <= 2 then
		weight = 0
	else
		weight = weight - 20 + (#gemList * 5)
	end

	if weight <= 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IFT3";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 1;
	cost = 2100;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
