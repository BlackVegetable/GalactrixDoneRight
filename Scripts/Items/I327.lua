-- I327 --
-- Molecular Spasm - Deals damage, drains both players' energy, attaches a cpu drain and retains some energy all based on your Science skill.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local sci = player:GetCombatStat("science")
	local eSci = enemy:GetCombatStat("science")
	local dam = math.floor(sci / 12) -- Direct Hull Damage
	local turns = 2 + math.floor(sci / 40) -- Turns of CPU Drain
	local retainG = math.floor(sci / 15) -- Retain Green
	local retainE = math.floor(sci / 25) -- Retain Other Energy
	local resistG = math.floor(sci / 15) -- Retain Green Enemy
	local resistE = math.floor(sci / 25) -- Retain Other Energy Enemy

	if dam <=0 then
		dam = 1
	end
	if eSci >= 175 then
		dam = 0
	end
	if eSci >= 200 then
		turns = turns - 2
	elseif eSci >= 100 then
		turns = turns - 1
	end
	if turns <=0 then
		turns = 1
	end

	item:DamagePlayer(player,enemy,dam,true,"RedPath")

	local EnemyShieldDeduction = enemy:GetAttribute("shield") - resistE
	if EnemyShieldDeduction < 0 then
		EnemyShieldDeduction = 0
	end
	item:DeductEnergy(world,enemy,"shield",EnemyShieldDeduction)

	local EnemyWeaponDeduction = enemy:GetAttribute("weapon") - resistE
	if EnemyWeaponDeduction < 0 then
		EnemyWeaponDeduction = 0
	end
	item:DeductEnergy(world,enemy,"weapon",EnemyWeaponDeduction)

	local EnemyEngineDeduction = enemy:GetAttribute("engine") - resistE
	if EnemyEngineDeduction < 0 then
		EnemyEngineDeduction = 0
	end
	item:DeductEnergy(world,enemy,"engine",EnemyEngineDeduction)

	local EnemyCPUDeduction = enemy:GetAttribute("cpu") - resistG
	if EnemyCPUDeduction < 0 then
		EnemyCPUDeduction = 0
	end
	item:DeductEnergy(world,enemy,"cpu",EnemyCPUDeduction)


	for i=1,enemy:NumAttributes("Effects") do
		if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT02_NAME]" then
			local effect = enemy:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,enemy,"FT02",enemy,turns,item.classIDStr)

	local ShieldDeduction = player:GetAttribute("shield") - retainE
	if ShieldDeduction < 0 then
		ShieldDeduction = 0
	end
	item:DeductEnergy(world,player,"shield",ShieldDeduction)

	local WeaponDeduction = player:GetAttribute("weapon") - retainE
	if WeaponDeduction < 0 then
		WeaponDeduction = 0
	end
	item:DeductEnergy(world,player,"weapon",WeaponDeduction)

	local EngineDeduction = player:GetAttribute("engine") - retainE
	if EngineDeduction < 0 then
		EngineDeduction = 0
	end
	item:DeductEnergy(world,player,"engine",EngineDeduction)

	local CPUDeduction = player:GetAttribute("cpu") - retainG
	if CPUDeduction < 0 then
		CPUDeduction = 0
	end
	item:DeductEnergy(world,player,"cpu",CPUDeduction)


end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,75) + (0.5 * (player:GetCombatStat('science') - world:GetEnemy(player):GetCombatStat('science')))
	if weight < 60 then
		if world:GetEnemy(player):GetCombatStat('science') >= 175 then
			weight = 0
		end
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IT4";
	weapon_requirement = 8;
	engine_requirement = 0;
	cpu_requirement = 12;
	recharge = 10;
	rarity = 8;
	cost = 9450;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
