-- I027
-- Shield Synapse - Destroys all purple gems on the board and adds +1 to your Shield for each 2 gems destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GPSI")
	local amt = math.floor(#gemList/2)
	item:ClearGems(world, gemList)
	item:AwardEnergy(world, player, "shield", amt)

end

local function should_ai_use_item(item, world, player)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				return 0
			end
		end
	end

	return 40 + (math.floor(#world:GetGemList("GPSI") / 2) * 12)
end

return {  psi_requirement = 0;
	icon = "img_ICB2";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 3;
	recharge = 3;
	rarity = 1;
	cost = 2010;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
