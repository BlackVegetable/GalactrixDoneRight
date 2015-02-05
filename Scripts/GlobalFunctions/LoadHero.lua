


local function EquipHero(hero,item1,item2,item3,item4,item5,item6,item7,item8)

	local loadout = hero:GetAttributeAt("ship_list",hero:GetAttribute("ship_loadout"))
	
	
	if item1 then
		if loadout:NumAttributes("items") < 1 then
			LOG("push 1")
			loadout:PushAttribute("items",item1)
		else
			LOG("set 1")
			loadout:SetAttributeAt("items",1,item1)
		end
	end
	if item2 then
		if loadout:NumAttributes("items") < 2 then
			LOG("push 2")
			loadout:PushAttribute("items",item2)
		else
			LOG("set 2")
			loadout:SetAttributeAt("items",2,item2)
		end
	end	
	if item3 then
		if loadout:NumAttributes("items") < 3 then
		LOG("push 3")
			loadout:PushAttribute("items",item3)
		else
			LOG("set 3")
			loadout:SetAttributeAt("items",3,item3)
		end
	end	
	if item4 then
		if loadout:NumAttributes("items") < 4 then
			LOG("push 4")
			loadout:PushAttribute("items",item4)
		else
			LOG("set 4")
			loadout:SetAttributeAt("items",4,item4)
		end
	end
	if item5 then
		if loadout:NumAttributes("items") < 5 then
			loadout:PushAttribute("items",item5)
		else
			loadout:SetAttributeAt("items",5,item5)
		end
	end
	if item6 then
		if loadout:NumAttributes("items") < 6 then
			loadout:PushAttribute("items",item6)
		else
			loadout:SetAttributeAt("items",6,item6)
		end
	end
	if item7 then
		if loadout:NumAttributes("items") < 7 then
			loadout:PushAttribute("items",item7)
		else
			loadout:SetAttributeAt("items",7,item7)
		end
	end
	if item8 then
		if loadout:NumAttributes("items") < 8 then
			loadout:PushAttribute("items",item8)
		else
			loadout:SetAttributeAt("items",8,item8)
		end
	end
	
end


local function LoadHero(hero)	
	LOG(string.format("LoadHero(%s)",hero))
	--local newHero = dofile("Assets/Scripts/Heroes/"..hero..".lua")
	purge_garbage()

	local newHero = GameObjectManager:Construct("Hero")

	newHero:SetAttribute("male", HEROES[hero].male)
	newHero:SetAttribute("portrait", HEROES[hero].portrait)
	newHero:SetAttribute("init_ship", HEROES[hero].init_ship)
	
	-- add these items temporarily for demo purposes
	--newHero:AddItem("I015")
	--newHero:AddItem("I026")
	--newHero:AddItem("I027")
	
	newHero:InitShip(newHero:GetAttribute("init_ship"))
	newHero.classIDStr = hero;


	local loadout = newHero:GetAttributeAt("ship_list",newHero:GetAttribute("ship_loadout"))
	assert(newHero:GetAttribute("curr_ship"),"Hero Curr Ship empty")

		
	--Initial debugging stuff
	--[[
	local newShip = GameObjectManager:Construct("IL00")
	newShip:SetAttribute("ship", "STST")--Test Ship
	newShip:PushAttribute("items", "I006")
	newHero:PushAttribute("ship_list", newShip)	
	]]--
	
	local numShips = newHero:NumAttributes("ship_list")
	for i=1, numShips do
		local loadout = newHero:GetAttributeAt("ship_list",i)
		LOG(tostring(i).." "..loadout:GetAttribute("ship"))
	end

	purge_garbage()
	
	local function PCDemo()
		local loadout = newHero:GetAttributeAt("ship_list", 1)
		loadout:SetAttribute("ship", "SKTS")
		loadout:PushAttribute("items", "I016")
		loadout:PushAttribute("items", "I006")
		loadout:PushAttribute("items", "I013")
		loadout:PushAttribute("items", "I070")
		newHero:InitShip("SKTS")
	end
	
	--_G.PCOnly(PCDemo)

	InitialiseNewHeroTutorials(newHero)
		
	return newHero	
end
	
local function LoadEnemy(enemy,shipCode,item1,item2,item3,item4,item5,item6,item7,item8)
	--local newEnemy = dofile("Assets/Scripts/Heroes/"..enemy..".lua")
	local newEnemy = GameObjectManager:Construct("Hero")
	newEnemy:SetAttribute("ai", 1)
	newEnemy:SetAttribute("male", 1)
	newEnemy:SetAttribute("init_ship", HEROES[enemy].init_ship)
	newEnemy:SetAttribute("faction", HEROES[enemy].faction)
	if (HEROES[enemy].portrait) then
		newEnemy:SetAttribute("portrait", HEROES[enemy].portrait)	
	end
	
	if HEROES[enemy].name then
		newEnemy:SetAttribute("name", HEROES[enemy].name)
	end
	
	for i=1,8 do
		if HEROES[enemy][string.format("item_%d_min", i)] then
			if _G.Hero and HEROES[enemy][string.format("item_%d_min", i)] <= _G.Hero:GetLevel() then
				if HEROES[enemy][string.format("item_%d", i)] ~= nil then
					newEnemy:SetAttribute(string.format("item_%d", i), HEROES[enemy][string.format("item_%d", i)])
				end
			end
		else
			if HEROES[enemy][string.format("item_%d", i)] ~= nil then
				newEnemy:SetAttribute(string.format("item_%d", i), HEROES[enemy][string.format("item_%d", i)])
			end
		end
	end
	
	newEnemy:SetAttribute('team',2)
	newEnemy.classIDStr = enemy
	
	if not shipCode then
		shipCode = newEnemy:GetAttribute("init_ship")
	end
	newEnemy:InitShip(shipCode)
	assert(newEnemy:GetAttribute("curr_ship"),"Enemy Curr Ship empty")
	EquipHero(newEnemy,item1,item2,item3,item4,item5,item6,item7,item8)
	
	if _G.Hero then
		newEnemy:LevelToHero(_G.Hero)
	end
	
	--Randomly add cargo to enemy
	local cargoBatch = {}
	for i=1, math.random(2,5) do
		cargoBatch[math.random(1,10)] = math.random(2,20)
	end
	
	newEnemy:AddCargoBatch(cargoBatch)
	
	return newEnemy	
end

local function LoadMPEnemy(enemyCode)
	local enemy = nil
	LOG("LoadMPEnemy "..enemyCode)
	if _G.HEROES[enemyCode] then
		LOG("load from enemy autoload "..enemyCode)
		enemy = GameObjectManager:ConstructLocal("Hero")
		LOG("local enemy constructed")
		enemy.classIDStr = enemyCode
		local shipCode = _G.HEROES[enemyCode].init_ship
		--local ship = GameObjectManager:ConstructLocal("Ship")
		--ship = _G.GLOBAL_FUNCTIONS.LoadShip(shipCode,ship)	
		--enemy:SetAttribute("curr_ship",ship)
		--ship.pilot=enemy
		local loadout = GameObjectManager:ConstructLocal("IL00")
		loadout:SetAttribute("ship", shipCode)
		enemy:PushAttribute("ship_list", loadout)
		enemy:SetAttribute("ship_loadout", 1)

		enemy:SetAttribute("name",  HEROES[enemyCode].name )		
		enemy:SetAttribute("faction", HEROES[enemyCode].faction)
		if (HEROES[enemyCode].portrait) then
			enemy:SetAttribute("portrait", HEROES[enemyCode].portrait)	
		end
		--For MP game testing
		--enemy:SetAttribute("ai", 1)
		
		enemy.mp_enemy = true
	
		enemy:SetAttribute("gunnery",  HEROES[enemyCode].base_gunnery  )
		enemy:SetAttribute("engineer", HEROES[enemyCode].base_engineer )
		enemy:SetAttribute("science",  HEROES[enemyCode].base_science  )
		enemy:SetAttribute("pilot",    HEROES[enemyCode].base_pilot    )		
		
		local minLevel = HEROES[enemyCode].min_level
		local intel = 0
		local lvl = 1
		while lvl < minLevel do
			lvl = lvl + 1
			intel = intel + (20 + (lvl * 10))
		end		
		
		enemy:SetAttribute("intel",intel+math.random(7,29))
		
		
		--only fill loadout with items that loadout can handle
		local weap = 0
		local eng = 0
		local cpu = 0
		local weap_rating = _G.SHIPS[shipCode].weapons_rating
		local eng_rating = _G.SHIPS[shipCode].engine_rating
		local cpu_rating = _G.SHIPS[shipCode].cpu_rating
		for i=1, _G.SHIPS[shipCode].max_items do
			if not _G.HEROES[enemyCode]["item_"..tostring(i)] then
				break
			end
			local item = _G.HEROES[enemyCode]["item_"..tostring(i)]

			weap = weap + _G.ITEMS[item].weapon_requirement
			eng = eng + _G.ITEMS[item].engine_requirement
			cpu = cpu + _G.ITEMS[item].cpu_requirement						
			if weap <= weap_rating and eng <= eng_rating and cpu <= cpu_rating then
				LOG("push item "..item)
				loadout:PushAttribute("items",item)--add ship default item to loadout config
			else--undo add
				weap = weap - _G.ITEMS[item].weapon_requirement
				eng = eng - _G.ITEMS[item].engine_requirement
				cpu = cpu - _G.ITEMS[item].cpu_requirement						
			end
			
		end
	else
		LOG("don't load from enemy autoload "..enemyCode)		
	end
	return enemy
end



return {["LoadHero"]=LoadHero;
	["LoadEnemy"]=LoadEnemy;
	["LoadMPEnemy"]=LoadMPEnemy;
}
