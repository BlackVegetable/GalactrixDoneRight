-- I154 - Lumina Special
-- Luminary Shield - Removes all White Gems from play and adds +4 Shield per Gem destroyed

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GINT")
	item:ClearGems(world, gemList)

	-- Balance Mod Edit --

	local amt = #gemList * 4
	local difference = 0
	item:AwardEnergy(world, player, "shield", amt)

	if player(GetAttribute("shield")) > math.ceil(player:GetAttribute("shield_max") * 0.75) then
		difference = player(GetAttribute("shield")) - math.ceil(player:GetAttribute("shield_max") * 0.75)
		item:AwardEnergy(world, player, "shield", -difference)
	end

end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	if #world:GetGemList("GINT") == 0 then
		return 0
	end

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	local shieldPercent = player:GetAttribute("shield") / player:GetAttribute("shield_max")
	if shieldPercent == 0 then
		weight = weight + (#world:GetGemList("GINT") * 9)
	elseif shieldPercent < 0.3 then
		weight = weight + (#world:GetGemList("GINT") * 7)
	elseif shieldPercent < 0.6 then
		weight = weight + (#world:GetGemList("GINT") * 5)
	elseif shieldPercent < 0.85 then
		weight = weight + ((#world:GetGemList("GINT") - 4) * 3)
	else
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 5;
	cpu_requirement = 14;
	recharge = 6;
	rarity = 10;
	cost = 17500;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
