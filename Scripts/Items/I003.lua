-- I003
-- Booster Drive - Gives you the Boost effect (doubles all Yellow Energy) for 6 turns

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FE02",player,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	-- base off number of yellow gems
	local gemList = world:GetGemList("GENG")
	local useChance = math.min(80, #gemList*10)

	return useChance
end

return {  psi_requirement = 0;


	icon = "img_IT2";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 4;
	recharge = 5;
	rarity = 9;
	cost = 1000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
