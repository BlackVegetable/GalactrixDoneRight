-- I054
-- Damage Assimilator - Destroys all Mines on the board. For each Mine destroyed, it adds +2 to maximum Red Energy (for the rest of this battle).

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")

	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)
   local amt = (2 * #gemList)
	item:ClearGems(world, gemList)
	item:IncreaseMaxEnergy(world, player, "weapon", amt)
end

local function should_ai_use_item(item, world, player)

	local gemList = world:GetGemList("GDMG")

	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)

	local weight = math.random(1,100)
	if #gemList <= 2 then
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


	icon = "img_IFT4";
	weapon_requirement = 10;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 99;
	rarity = 1;
	cost = 6870;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
