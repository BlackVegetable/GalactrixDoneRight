-- I106
-- Psi-Shield Generator - Destroys all purple gems, adding 1 point to your shields for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GPSI")
	item:ClearGems(world, gemList, false)
	item:AwardEnergy(world, player, "shield", #gemList)
end

local function should_ai_use_item(item, world, player)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	local weight = math.random(1,95)
	local deficit = player:GetAttribute("shield_max") - player:GetAttribute("shield")
	local gemList = world:GetGemList("GPSI")

	if deficit == 0 then
		weight = 0
	elseif deficit < #gemList then
		if deficit < 8 then
			weight = weight - 10
		end
	end

	if #gemList > 6 then
		weight = weight + (3 * (#gemList - 6))
	end

	if #gemList == 0 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_ITS2";
	weapon_requirement = 0;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 3;
	rarity = 2;
	cost = 3570;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
