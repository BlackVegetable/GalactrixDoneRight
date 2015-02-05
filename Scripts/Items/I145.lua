-- I145
-- Null Wave - Destroys all blue gems in play. You gain no effect from the gems. Does not end your turn.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")

	item:ClearGems(world,gemList,false)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(21,105) -- The 21 is intentional, as is the 105
	local gemList = world:GetGemList("GSHD")
	local percent = player:GetAttribute("shield") / player:GetAttribute("shield_max")
	local enemy = world:GetEnemy(player)
	local Epercent = enemy:GetAttribute("shield") / enemy:GetAttribute("shield_max")

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
		weight = weight + math.floor(#gemList / 2)
	end

	if weight < 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 5;
	recharge = 3;
	rarity = 4;
	cost = 1200;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
