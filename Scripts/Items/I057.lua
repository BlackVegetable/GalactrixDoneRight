-- I057
-- Tractor Beam - Drains up to +8 points of Yellow energy from your enemy, adding them to your own.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = math.min(world:GetEnemy(player):GetAttribute("engine"), 8)
	local enemy = world:GetEnemy(player)

	item:DeductEnergy(world, enemy, "engine", amt)
	item:AwardEnergy(world, player, "engine", amt)

	world:DrainEffect("engine",enemy:GetAttribute("player_id"),"engine",player:GetAttribute("player_id"))
end

local function should_ai_use_item(item, world, player)

	local amt = math.min(world:GetEnemy(player):GetAttribute("engine"), 8)
	local self = player:GetAttribute("engine")
	local self_max = player:GetAttribute("engine_max")
	local deficit = self_max - self
	local enemy = world:GetEnemy(player)
	local weight = math.random(1,100)

	if amt < 8 then
		weight = weight - ((8 - amt) * 4)
	end
	if deficit < 8 then
		weight = weight - ((8 - deficit) * 3)
	end
	if amt == 0 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 8;
	engine_requirement = 0;
	cpu_requirement = 4;
	recharge = 1;
	rarity = 8;
	cost = 890;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_gemyellow";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
