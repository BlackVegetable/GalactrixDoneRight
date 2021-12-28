-- I097
-- Memory Field - Inflicts Confusion effect  on the enemy (halving their pilot’s stats) for 5 turns, +1 turn for every 3 Blue Gems in play.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(#world:GetGemList("GSHD") / 3)
	local enemy = world:GetEnemy(player)

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS01_NAME]" then
				local effect = enemy:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end
	item:AddEffect(world,enemy,"FS01",enemy,turns,item.classIDStr)
	--enemy:AddCombatStat("gunnery", 0) -- ensures match bonus is updated according to new stats
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	local eLvl = enemy:GetLevel()
	local stats_max = 4 + (eLvl * 5)
	local stats = enemy:GetCombatStat("gunnery") + enemy:GetCombatStat("engineer") + enemy:GetCombatStat("science") + enemy:GetCombatStat("pilot")
	local condition = (stats / stats_max)

	if condition > 1 then
		weight = weight + 15
	elseif condition == 1 then
		weight = weight + 2
	else
		weight = math.floor(weight - ((1 - condition) * 40))
	end

	local gemList = world:GetGemList("GSHD")

	weight = weight + (math.floor((#gemList - 3) / 3) * 5)

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS01_NAME]" then
				weight = 0
			end
		end
	end


	if weight < 0 then
		weight = 0
	end


	return weight
end

return {  psi_requirement = 0;


	icon = "img_ITS2";
	weapon_requirement = 0;
	engine_requirement = 9;
	cpu_requirement = 6;
	recharge = 4;
	rarity = 1;
	cost = 11900;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
