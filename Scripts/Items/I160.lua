-- I160 - Elysian Special
-- Elysian Pacifier - removes all mines, +1 life for each mine removed

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)

	item:AwardEnergy(world, player, "life", #gemList)

	item:ClearGems(world, gemList)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,88)
	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)
	local deficit = player:GetAttribute("life_max") - player:GetAttribute("life")

	if deficit <= 5 then
		weight = 0
	end

	if #gemList <= 5 then
		weight = 0
	end

	weight = weight + (3 * math.min(#gemList, deficit))

	return weight



end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 4;
	recharge = 4;
	rarity = 10;
	cost = 15900;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_degauss";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
