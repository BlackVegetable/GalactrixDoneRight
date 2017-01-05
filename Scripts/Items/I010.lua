-- I010
-- Destabilization Field - Inflicts Destabilization effect on the enemy (allowing shield to leak 5 points of damage) for 6 turns

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	for i=1,enemy:NumAttributes("Effects") do
		if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD04_NAME]" then
			local effect = enemy:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,enemy,"FD04",enemy,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	-- do not use when enemy has low/no shield. Otherwise random.
	if world:GetEnemy(player):GetAttribute("shield") <= 5 then
		return 0
	else
		if world:GetEnemy(player):GetAttribute("shield") >= 100 then
			return math.random(20, 90)
		else
			return math.random(1,85)
		end
	end
end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 8;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 8;
	rarity = 4;
	cost = 850;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
