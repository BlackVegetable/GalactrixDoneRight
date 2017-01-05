-- I155 - Quesadan Special
-- Quesadan Relic - Removes all White Gems from play, adding +1 to Shields and Life points for every 2 Gems removed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GINT")
	local amt = math.floor((#gemList)/2)

	item:AwardEnergy(world, player, "life", amt)
	item:AwardEnergy(world, player, "shield", amt)
	item:ClearGems(world, gemList)
end

local function should_ai_use_item(item, world, player)
	if player:GetAttribute("shield") > player:GetAttribute("shield_max") - 5 then
		if player:GetAttribute("life") > player:GetAttribute("life_max") - 5 then
			return 0
		end
	end
	local weight = math.random(1,100)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				weight = math.floor(weight / 2)
			end
		end
	end

	return weight
end

return {  psi_requirement = 0;
	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 9;
	recharge = 5;
	rarity = 10;
	cost = 16900;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
