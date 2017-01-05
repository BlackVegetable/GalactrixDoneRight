

local function RestrictEncounterList(hero, enemyList)
	local level = hero:GetLevel()
	local restrictedList = {}
	for i=1, #enemyList do
		if HEROES[enemyList[i]].min_level <= level  and HEROES[enemyList[i]].max_level >= level then
			table.insert(restrictedList, enemyList[i])
		end
	end
	if #restrictedList == 0 then
		for i=1, #enemyList do
			if HEROES[enemyList[i]].min_level > level then
				LOG("added higher-level enemy to list")
				table.insert(restrictedList, enemyList[i])
				return { enemyList[i] }
			end
		end
		if #restrictedList == 0 then
			for i=1, #enemyList do
				if HEROES[enemyList[i]].max_level < level then
					LOG("added lower-level enemy to list")
					table.insert(restrictedList, enemyList[i])
					return { enemyList[i] }
				end
			end
		end
	end
	return restrictedList
end

--Determines random encounter for Hero based on hero/system faction alliances
--also determines based on existing encounters
local function GetEncounter(heroObj,world,faction,police, enemies, neutral)
	local standing = _G.Hero:GetFactionStanding(faction)
	
	-- here we restrict which encounter is selected based on level
	enemies = RestrictEncounterList(_G.Hero, enemies)
	local enemy = enemies[math.random(1, #enemies)]
	
	local encounter
	
	if enemy ~= nil then-- This is where we will exclude recently beaten encounters recurring
		local severity = math.random(1,3)
		local safe_dist = _G.DATA.Standings[standing].min_safe_distance
		local patrolling = 0
		
		if police then
			patrolling = 1			
			safe_distance = 700
		end		

		
		local locations = _G.DATA.StarTable[_G.Hero:GetAttribute("curr_system")]
		local location = _G.Hero:GetAttribute("curr_loc")
		local limit = 5
		local counter = 0
		while location == _G.Hero:GetAttribute("curr_loc") do
			if counter>limit then
				return encounter
			end			
			local i = math.random(1,#locations)
			location = locations[i]
			counter = counter+1
			
		end
		location = world.SatelliteList[location]
		
		encounter = GameObjectManager:Construct("ENC1")
		if neutral then
			encounter:SetAttribute("neutral", 1)
		end
		encounter:SetAttribute("safe_distance",safe_dist/severity)
		encounter:SetAttribute("patrolling",patrolling)

		--LOG("Enemy = " .. tostring(enemy))
		standing = _G.Hero:GetFactionStanding(HEROES[enemy].faction)
		
		if encounter:GetAttribute("neutral") == 1 then
			standing = math.max(standing, _G.STANDING_NEUTRAL)
		end
		local sprite = _G.DATA.Standings[standing].sprite
		--LOG("Encounter standing sprite "..sprite)
		encounter:SetEnemy(enemy, sprite)
		encounter.enemy:SetPos(location:GetX(),location:GetY())
		--LOG(string.format("Set encounter %s at %d,%d",sprite,encounter.enemy:GetX(),encounter.enemy:GetY()))
		
	end	
	
	return encounter
end


return GetEncounter