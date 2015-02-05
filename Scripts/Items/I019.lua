-- I019
-- Military Sweeper - Removes all Mines on the board. Adds +1 Red Energy for each Mine removed and drains that amount from your opponent.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)
	local amt = #gemList

	item:ClearGems(world, gemList)
	item:AwardEnergy(world, player, "weapon", amt)
	item:DeductEnergy(world, enemy, "weapon", amt)

	world:DrainEffect("weapon",enemy:GetAttribute("player_id"),"weapon",player:GetAttribute("player_id"))
end

local function should_ai_use_item(item, world, player)
	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)

	if #gemList == 0 then
		return 0
	else
		return math.min(90, #gemList * 12)
	end
end

return {  psi_requirement = 0;


	icon = "img_IT4";
	weapon_requirement = 3;
	engine_requirement = 10;
	cpu_requirement = 3;
	recharge = 5;
	rarity = 5;
	cost = 5500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
