-- I102
-- Siphon Field - Destroys all blue gems in play. Drains 2 points from the enemy's shields for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")
	local enemy = world:GetEnemy(player)
	local amt = #gemList * 2
	item:ClearGems(world, gemList, false)
	item:DeductEnergy(world, enemy, "shield", amt)


	world:DrainEffect("shield",enemy:GetAttribute("player_id"),"shield",player:GetAttribute("player_id"))
end

local function should_ai_use_item(item, world, player)
	local num = math.random(1,100)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				num = num - 20
			end
		end
	end

	return num

end

return {  psi_requirement = 0;


	icon = "img_ITS1";
	weapon_requirement = 3;
	engine_requirement = 8;
	cpu_requirement = 2;
	recharge = 3;
	rarity = 2;
	cost = 4520;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
