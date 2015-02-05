-- I020
-- Shield Wave - Removes all blue gems on the board.   Adds +1 to your shield for each 2 gems removed

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")
	local amt = math.floor(#gemList/2)

	if amt > 0 then
		item:AwardEnergy(world, player, "shield", amt)
	end

	item:ClearGems(world, gemList)
end

local function should_ai_use_item(item, world, player)
	local gemList = world:GetGemList("GSHD")

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	if #gemList == 0 then
		return 0
	else
		return math.min(85, #gemList * 12)
	end
end

return {  psi_requirement = 0;


	icon = "img_IS4";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 2;
	recharge = 4;
	rarity = 2;
	cost = 1650;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
