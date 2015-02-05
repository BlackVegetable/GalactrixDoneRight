-- I067
-- Shield Droid - Activates a Shield Droid on your ship for 5 turns (causing your Shield to regenerate 4 points at the start of each turn).

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FT04",player,5,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	local deficit = player:GetAttribute("shield_max") - player:GetAttribute("shield")
	local weight = math.random(1,100)

	weight = weight + ((deficit - 14) * 3)

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IUP1";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 10;
	recharge = 5;
	rarity = 5;
	cost = 5000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_droid";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
