-- I111
-- Shielded Minelayer - Turns all Blue Gems into +1 Mines

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")
	item:TransformGems(world, gemList, true, "GDMG")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
		if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				weight = weight + 15
			end
		end
	end

	local gemListS = world:GetGemList("GSHD")
	local gemList = world:GetGemList("GDMG", gemList)
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)

	if #gemListS <= 2 then
		weight = 0
	else
		weight = weight + (#gemListY * 5) + (#gemList * 3)
	end


	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 5;
	engine_requirement = 10;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 2;
	cost = 5690;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
