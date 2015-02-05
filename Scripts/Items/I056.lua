-- I056
-- Synaptic Assimilator - Destroys all Purple Gems on the board. For each gem destroyed, it adds +1 to your Psi Points.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GPSI")
	local amt = #gemList
	item:ClearGems(world, gemList)
	item:AwardEnergy(world, player, "psi", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,80)

	local gemList = world:GetGemList("GPSI")
	local amt = #gemList

	if amt <= 1 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IFT2";
	weapon_requirement = 3;
	engine_requirement = 3;
	cpu_requirement = 11;
	recharge = 3;
	rarity = 2;
	cost = 3150;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
