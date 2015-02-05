-- I011
-- Shield Matrix - Adds +5 to shield energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AwardEnergy(world, player, "shield", 5)
end

local function should_ai_use_item(item, world, player)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	if player:GetAttribute("shield") + 5 > player:GetAttribute("shield_max") then
		return 0
	else
		if player:GetAttribute("life") < 20 then
			return math.random(1,120)
		else
			return math.random(25,100)
		end
	end
end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 1;
	recharge = 2;
	rarity = 6;
	cost = 400;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gemblue";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
