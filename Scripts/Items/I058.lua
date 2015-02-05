-- I058
-- Cobalt Beam - Drains up to +10 Shield Energy from your enemy, adding them to your own Shield Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = math.min(world:GetEnemy(player):GetAttribute("shield"), 10)
	local enemy = world:GetEnemy(player)

	item:DeductEnergy(world, enemy, "shield", amt)
	item:AwardEnergy(world, player, "shield", amt)

	world:DrainEffect("shield",enemy:GetAttribute("player_id"),"shield",player:GetAttribute("player_id"))
end

local function should_ai_use_item(item, world, player)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	local weight = math.random(1,100)
	local amt = math.min(world:GetEnemy(player):GetAttribute("shield"), 10)
	local enemy = world:GetEnemy(player)
	local deficit = player:GetAttribute("shield_max") - player:GetAttribute("shield")

	if amt < 10 then
		weight = weight - ((10 - amt) * 4)
	end
	if deficit < 10 then
		weight = weight - ((10 - deficit) * 3)
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


	icon = "img_IWM1";
	weapon_requirement = 12;
	engine_requirement = 5;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 4;
	cost = 15090;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
