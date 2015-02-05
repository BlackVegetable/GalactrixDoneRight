-- I105
-- Laser Generator - Destroys all mines on the board, giving you 1 point of Red Energy for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG", gemList)
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)
	item:ClearGems(world, gemList, false)
	item:AwardEnergy(world, player, "weapon", #gemList)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local gemList = world:GetGemList("GDMG", gemList)
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)

	weight = weight + ((#gemList - 3) * 5)

	if #gemList == 0 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 0;
	engine_requirement = 5;
	cpu_requirement = 0;
	recharge = 1;
	rarity = 4;
	cost = 1130;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
