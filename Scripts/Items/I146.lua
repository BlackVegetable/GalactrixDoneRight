-- I146
-- Shock Wave - Destroys all blue gems in play. Adds +1 to your Red Energy for each 2 gems destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")
	local amt = math.floor(#gemList / 2)
	item:ClearGems(world,gemList,true)
	item:AwardEnergy(world, player, "weapon", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(11,100) -- The 11 is intentional
	local gemList = world:GetGemList("GSHD")
	local percent = player:GetAttribute("shield") / player:GetAttribute("shield_max")
	local enemy = world:GetEnemy(player)
	local Epercent = enemy:GetAttribute("shield") / enemy:GetAttribute("shield_max")
	local red = player:GetAttribute("weapon")
	local red_max = player:GetAttribute("weapon_max")

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				percent = 1.00 -- Treat as though you have full shields if you cannot regenerate any of them in the first place
			end
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT03_NAME]" then -- Shield Drain
				weight = weight - 5
			end
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC15_NAME]" then -- Agression Drone
				weight = weight - 5
			end
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC16_NAME]" then -- Havoc Drone
				weight = weight - 3
			end
		end
	end

	weight = math.ceil(weight * percent)
	weight = math.ceil(weight * (1 - Epercent))

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				weight = 0 -- Why get rid of them if your opponent can't use them?
			end
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT03_NAME]" then -- Shield Drain
				weight = weight + 5
			end
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC15_NAME]" then -- Agression Drone
				weight = weight + 5
			end
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC16_NAME]" then -- Havoc Drone
				weight = weight + 3
			end
		end
	end

	if #gemList < 3 then
		weight = 0
	else
		weight = weight + (math.floor(#gemList / 2) * 5)
		if (red + math.floor(#gemList / 2)) > (red_max + 4) then
			weight = weight - 35
		end
	end

	if red == red_max then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IFT3";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 1;
	recharge = 3;
	rarity = 3;
	cost = 650;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
