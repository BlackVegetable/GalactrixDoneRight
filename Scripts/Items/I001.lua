-- I001
-- Disruption Field - Prevents enemy shields from regenerating for 6 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				local effect = enemy:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	item:AddEffect(world,enemy,"FE03",enemy,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	-- disable enemy's ability to regen shields when they are low
	local enemy = world:GetEnemy(player)
	return (1-(enemy:GetAttribute("shield") / enemy:GetAttribute("shield_max")))*85
end

return {  psi_requirement = 0;


	icon = "img_ITS4";
	weapon_requirement = 3;
	engine_requirement = 2;
	cpu_requirement = 1;
	recharge = 3;
	rarity = 6;
	cost = 1000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
