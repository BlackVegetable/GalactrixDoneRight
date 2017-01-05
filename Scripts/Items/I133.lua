-- I133
-- Data Synapse - Destroys all purple gems.  Adds +1 to Intel for each 2 gems destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GPSI")
	local amt = math.floor(#gemList / 2)
	item:ClearGems(world,gemList,false)
	item:AwardEnergy(world, player, "intel", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICB5";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 7;
	recharge = 3;
	rarity = 4;
	cost = 1100;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
