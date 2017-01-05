-- I123
-- Shock Net - Inflicts your enemy with the Time Warp effect (causing them to miss their turn) for 2 turns, +1 more for every 10 Red Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 2 + math.floor(weapon / 10)
	local enemy = world:GetEnemy(player)
	item:AddEffect(world,enemy,"FT06",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local red = player:GetAttribute("weapon")

	if red < 10 then
		weight = weight - 30
	elseif red < 20 then
		weight = weight - 5
	else
		weight = weight + 30
	end

	local enemy = world:GetEnemy(player)

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT01_NAME]" then
				weight = 0
				break
			end
		end
	end

	if weight <= 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 6;
	engine_requirement = 6;
	cpu_requirement = 0;
	recharge = 7;
	rarity = 7;
	cost = 5500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
