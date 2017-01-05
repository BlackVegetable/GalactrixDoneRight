-- I150
-- Threat Scanner - Adds +1 Red Energy for each Mine on the board.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)
	local amt = #gemList
	item:AwardEnergy(world, player, "weapon", amt)
end

local function should_ai_use_item(item, world, player)
	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)
	local weight = math.random(1,90)
	local deficit = player:GetAttribute("weapon_max") - player:GetAttribute("weapon")


	if #gemList < 5 then
		weight = 0
	elseif #gemList < 11 then
		weight = weight + ((#gemList - 4) * 3)
	else
		weight = 0 -- If there are too many Damage Gems, it is much more likely a damage move would be preferable.
	end

	if deficit == 0 then -- Will never have to worry about this.  Don't know why I programmed these two lines.
		weight = 0
	elseif (deficit - 2) >= #gemList then -- This line could be reached.
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 2;
	cpu_requirement = 2;
	recharge = 1;
	rarity = 7;
	cost = 450;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gemred";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
