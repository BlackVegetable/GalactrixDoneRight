-- I014
-- Cobalt Sensor - Adds +8 to shield power, +1 extra per 8 points of your enemy's Red Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local amt = 8 + math.floor(enemy:GetAttribute("weapon")/8)

	item:AwardEnergy(world, player, "shield", amt)
end

local function should_ai_use_item(item, world, player)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	local weight = math.floor(75 * (1 - (player:GetAttribute("shield") / player:GetAttribute("shield_max"))))
	local enemy = world:GetEnemy(player)
	weight = weight + (math.floor(enemy:GetAttribute("weapon") / 8) * 3)
	return weight
end

return {  psi_requirement = 0;


	icon = "img_ICC2";
	weapon_requirement = 0;
	engine_requirement = 2;
	cpu_requirement = 8;
	recharge = 3;
	rarity = 2;
	cost = 1050;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
