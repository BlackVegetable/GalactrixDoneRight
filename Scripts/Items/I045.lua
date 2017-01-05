-- I045
-- Spectral Analyzer - Adds +15 to the maximum of your Red, Green and Yellow Energies +1 more for every 250 PSI you have (max +10).

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local enemy = world:GetEnemy(player)
	--local highestStat = math.max(enemy:GetAttribute("weapon"), math.max(enemy:GetAttribute("engine"), enemy:GetAttribute("cpu")))
	--local amt = 15 + math.floor(highestStat / 5)

	--item:IncreaseMaxEnergy(world, player, {"engine", "cpu", "weapon"}, amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IS5";
	weapon_requirement = 8;
	engine_requirement = 8;
	cpu_requirement = 8;
	recharge = 99;
	rarity = 4;
	cost = 12000;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
