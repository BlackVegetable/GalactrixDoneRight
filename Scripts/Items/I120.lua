-- I120
-- Supanova Module - Gives you the Nova effect (Any Nova fills up your energy bars) for 5 turns, +1 more for every 3 Green Gems in play

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(#world:GetGemList("GCPU") / 3)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS02_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	item:AddEffect(world,player,"FS02",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,85)
	local gemList = world:GetGemList("GCPU")

	weight = weight + (math.floor(#gemList / 3) * 5)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS02_NAME]" then
				weight = 0
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS4";
	weapon_requirement = 0;
	engine_requirement = 2;
	cpu_requirement = 6;
	recharge = 5;
	rarity = 2;
	cost = 11570;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
