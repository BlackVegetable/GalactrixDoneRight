use_safeglobals()

local function AwardPlan(hero,planID, successFactor)
	local probability
	local stats = {}
	
	if string.char(string.byte(planID)) == "S" then
		-- calculate probability for an item
		if not CollectionContainsAttribute(_G.Hero, "crew", "C001") then
			LOG("Hero unable to acquire ship plan - does not have Beta Prime on crew")
			return false
		end
		
		probability = 25
		stats = { weap = SHIPS[planID].weapons_rating, eng = SHIPS[planID].engine_rating, cpu = SHIPS[planID].cpu_rating }
		
--[[
		for 1,_G.Hero:GetAttribute("gunnery") do
			if math.random(0,1) == 0 then
				probability = probability + (SHIPS[planID].weapon_requirement / 2)
			end
		end
		for 1,_G.Hero:Get
]]--
	else
		if not CollectionContainsAttribute(_G.Hero, "crew", "C001") and not CollectionContainsAttribute(_G.Hero, "crew", "C000") then
			LOG("Hero unable to acquire item plans - does not have Beta/Kirine on crew")
			return false
		end
		stats = { weap = ITEMS[planID].weapon_requirement, eng = ITEMS[planID].engine_requirement, cpu = ITEMS[planID].cpu_requirement }
		probability = 50
	end
	probability = probability + (successFactor * 20)
	--LOG(string.format("Weap = %d     Eng = %d      CPU = %d",stats.weap, stats.eng, stats.cpu))
	
	for i=1,_G.Hero:GetCombatStat("gunnery") do
		if math.random(0,1) == 0 then
			probability = probability + (stats.weap / 2)
		end
	end
	
	for i=1,_G.Hero:GetCombatStat("engineer") do
		if math.random(0,1) == 0 then
			probability = probability + (stats.eng / 2)
		end
	end	
	
	for i=1,_G.Hero:GetCombatStat("science") do
		if math.random(0,1) == 0 then
			probability = probability + (stats.cpu / 2)
		end
	end	
	
	local chance = math.random(0,100)
	if chance <= probability then
		if CollectionContainsAttribute(_G.Hero, "plans", planID) == false then
			LOG(string.format("Hero awarded plan %s",tostring(planID)))	
			_G.Hero:PushAttribute("plans", planID)
			
		
			hero:SetToSave()			
			return true
		else
			LOG(string.format("Player already has plan %s",tostring(planID)))	
			return false
		end
	else
		LOG(string.format("Hero failed to acquire plan %s",tostring(planID)))
		return false
	end
end


local function AddCargo(hero,cargo_in,amount)
	LOG("AddCargo")
	local num_cargo = 0
	local total_new_cargo = 0
	local cargoID
	local cargo_list={0,0,0,0,0,0,0,0,0,0}
	if type(cargo_in) ~= "table" then
		cargoID = cargo_in
		num_cargo = 1
		cargo_list[cargoID]=amount
		total_new_cargo = amount
	else
		for i,v in pairs(cargo_in) do
			cargo_list[i]=cargo_in[i]
			if v > 0 then
				num_cargo = num_cargo + 1--counts number of cargo types that are being added.
				total_new_cargo = total_new_cargo + v--Adds up total cargo to add.
			end
		end		
	end
	local total = 0
	local capacity = 0
	
	--get total cargo capacity across all ships
	for i=1, hero:NumAttributes("ship_list") do
		local ship = hero:GetAttributeAt("ship_list",i):GetAttribute("ship")
		capacity = capacity + SHIPS[ship].cargo_capacity
	end		
	
	
	
	
	--get total weight of all current cargo - setup in table.
	local current_cargo = {0,0,0,0,0,0,0,0,0,0}
	for i=1, _G.NUM_CARGOES do
		local this_cargo = hero:GetAttributeAt("cargo",i)
		current_cargo[i]=this_cargo
		total = total + this_cargo
	end


	--LOG(string.format("Capacity = %d, Current Total = %d, Add Total = %d",capacity, total, total_new_cargo))
	--assert(total <= capacity,string.format("Cargo capacity exceeded %d > %d",total,capacity))
	
	
	
	if total + total_new_cargo <= capacity then--if cargo not going to exceed capacity - just add it.
		for i=1, _G.NUM_CARGOES do
			hero:SetAttributeAt("cargo",i,current_cargo[i]+ cargo_list[i])
		end
		cargo_list = {0,0,0,0,0,0,0,0,0,0}
	else
		
		local chunk = math.floor((capacity - total) / num_cargo)--get avg amount to add to start with.
		--LOG(string.format("Chunk = %d",chunk))
		
		for i=_G.NUM_CARGOES,1,-1 do
			if cargo_list[i] > 0 then
				local amount = math.min(chunk,cargo_list[i])
				current_cargo[i] = current_cargo[i] + amount
				total = total + amount
				cargo_list[i] = cargo_list[i] - amount
			end			
		end
		
		

		for i=_G.NUM_CARGOES,1,-1 do--add remain cargo until exceed amount
			amount = cargo_list[i]
			--LOG("amount "..tostring(amount))
			local temp_total = amount + total
			if temp_total > capacity then
				--LOG("would exceed capacity")
				amount = amount - (temp_total - capacity)
					
				--LOG("adjusted amount "..tostring(amount))
			end
			current_cargo[i] = current_cargo[i] + amount
			cargo_list[i] = cargo_list[i] - amount
			total = total + amount
			if total >= capacity then
				--LOG("break")
				break
			end
		end		
		
		
		local total = 0
		for i,v in pairs(current_cargo) do
			--[[
			--LOG(tostring(i))
			--LOG(string.format("Before amount %d",hero:GetAttributeAt("cargo",i)))
			--LOG(string.format("After amount = %d",v))
			--total = total + v
			--LOG(string.format("accumilative total %d",total))
			--]]
			hero:SetAttributeAt("cargo",i,v)
		end
	end
	
	
	--Debug Testing Only!!!

	local total = 0
	local capacity = 0	
	--get total cargo capacity across all ships
	for i=1, hero:NumAttributes("ship_list") do
		local ship = hero:GetAttributeAt("ship_list",i):GetAttribute("ship")
		capacity = capacity + SHIPS[ship].cargo_capacity
	end		
	
	--get total weight of all current cargo - setup in table.
	for i=1, _G.NUM_CARGOES do
		local this_cargo = hero:GetAttributeAt("cargo",i)
		total = total + this_cargo		
	end

	--LOG(string.format("Capacity = %d, Current Total = %d, Add Total = %d",capacity, total, total_new_cargo))
	--assert(total <= capacity,string.format("Cargo capacity exceeded %d > %d",total,capacity))	
	

	hero:SetToSave()	
	
	return cargo_list
end


--Here to add a variable amount of cargo - instead of all cargos levelling out
local function AddCargoBatch(hero, itemTable)
	for k,v in pairs(itemTable) do
		AddCargo(hero, k, v)
	end
end

local function RemoveCargo(hero,cargoID,amount)
	LOG(string.format("RemoveCargo(%s, %s)", tostring(cargoID), tostring(amount)))

	amount = math.floor(amount)	
	amount = math.abs(amount) --always deal in positive whole amounts.
	
	
	local current = hero:GetAttributeAt("cargo",cargoID)
	
	current = current - amount
	
	if current < 0 then
		amount = amount + current
		current = 0
	end
	hero:SetAttributeAt("cargo",cargoID,current)
	

	hero:SetToSave()	
	
	return amount--returns amount removed
end




local function AddItem(hero,newItemID,show)
	LOG(string.format("AddItem %s %s",tostring(show),newItemID))
	local equipped = ""

	local add_item = false
	if not _G.CollectionContainsAttribute(hero,"items",newItemID) then--DS Only -- should be removed for PC where multiple items are allowed.
		hero:PushAttribute("items",newItemID)
		add_item = true
	end
	
	local ship = hero:GetAttribute("curr_ship")
	local max_items = ship:GetAttribute("max_items")
	local loadout = hero:GetCurrLoadout()
	local max_engine = ship:GetAttribute("engine_rating")
	local max_weapon = ship:GetAttribute("weapons_rating")
	local max_cpu = ship:GetAttribute("cpu_rating")
	
	if loadout:NumAttributes("items") < max_items then
		local total_engine = ITEMS[newItemID].engine_requirement
		local total_weapon = ITEMS[newItemID].weapon_requirement
		local total_cpu = ITEMS[newItemID].cpu_requirement
		
		for i=1, loadout:NumAttributes("items") do
			local itemID = loadout:GetAttributeAt("items",i)
			total_engine = total_engine + ITEMS[itemID].engine_requirement
			total_weapon = total_weapon + ITEMS[itemID].weapon_requirement
			total_cpu = total_cpu + ITEMS[itemID].cpu_requirement
		end
		
		if add_item and total_engine <= max_engine and total_weapon <= max_weapon and total_cpu <= max_cpu then
			loadout:PushAttribute("items",newItemID)
			equipped = "[EQUIPPED]"
		end
	end
	local function receiveItem()
		LOG("recieveItem Callback")
		local e = GameEventManager:Construct("ItemReceived")
		e:SetAttribute("item",newItemID)
		_G.ProcessQuestEvent(hero,e)		
	
		hero:SetToSave()		
	end
	local function getIcon(id)
		return ITEMS[id].icon
	end
	local icon = _G.NotDS(getIcon,newItemID)
	
	if show then
		--add_text_file("ItemText.xml")
		hero:OpenQuestRewards(receiveItem)
		SCREENS.QuestRewardsMenu:AddListItem(icon, "[GAIN_ITEM]", translate_text(string.format("[%s_NAME]", newItemID)))
		SCREENS.QuestRewardsMenu:SetInventoryTab(3)--Fitout
	else
		receiveItem()
	end
	

end

local function RemoveItem(hero,itemID,show)
	LOG("RemoveItem "..tostring(show).." "..itemID)
	local unequipped = ""
	
	local ship = hero:GetAttribute("curr_ship")
	--local loadout = hero:GetCurrLoadout()
	local numItems = 0
	local numItemsInLoadout = 0
	local unequipped
	
	hero:EraseAttribute("items",itemID)
	
	for i=1, hero:NumAttributes("items") do
		if itemID == hero:GetAttributeAt("items",i) then
			numItems = numItems + 1
		end
	end		
	
	for k=1,hero:NumAttributes("ship_list") do
		local loadout = hero:GetAttributeAt("ship_list", k)
		for i=1, loadout:NumAttributes("items") do
			if itemID == loadout:GetAttributeAt("items",i) then
				numItemsInLoadout = numItemsInLoadout + 1
			end
		end
	
		if numItems < numItemsInLoadout then
			loadout:EraseAttribute("items",itemID)
			unequipped = "[UNEQUIPPED]"
		end
	end

	
	if show then
		local function getIcon(id)
			return ITEMS[id].icon
		end
		local icon = _G.NotDS(getIcon,itemID)	
		hero:OpenQuestRewards()	
		SCREENS.QuestRewardsMenu:AddListItem(icon,"[LOST_ITEM]",string.format("%s%s",translate_text(ITEMS[itemID].name)),translate_text(unequipped))
	end		
	hero:SetToSave()
end

local function AddShip(hero,shipID,show)
	LOG(string.format("AddShip %s %s",tostring(show),shipID))
	local numShips = hero:NumAttributes("ship_list")
	if numShips == 3 then
		return
	end
	
	local loadout = GameObjectManager:Construct("IL00")
	loadout:SetAttribute("ship",shipID)
	hero:PushAttribute("ship_list",loadout)
	
	local function receiveShip()
		LOG("recieveShip Callback")
		local e = GameEventManager:Construct("ItemReceived")
		e:SetAttribute("item",shipID)
		_G.ProcessQuestEvent(hero,e)
			
		hero:SetToSave()		
	end

	local function getIcon(id)
		return string.format("img_%s", id)
	end
	local icon = _G.NotDS(getIcon,shipID)
	
	if show then
		hero:OpenQuestRewards(receiveShip)
		SCREENS.QuestRewardsMenu:AddListItem(icon, "[GAIN_SHIP]", string.format("%s%s",translate_text(string.format("[%s_NAME]", shipID)),""))	
		SCREENS.QuestRewardsMenu:SetInventoryTab(2)--ShipSelect
	else
		receiveShip()
	end	
	
end


local function AddPlan(hero,planID,show)
	LOG(string.format("AddPlan %s %s",tostring(show),planID))
	if not _G.CollectionContainsAttribute(hero,"plans",planID) then
		hero:PushAttribute("plans",planID)
		hero:SetToSave()
	end
	
end



local HeroStateInventory = 
{
	RemoveCargo = RemoveCargo,
	AddCargo = AddCargo,
	AddCargoBatch = AddCargoBatch,
	AwardPlan = AwardPlan,
	
	AddItem = AddItem,
	RemoveItem = RemoveItem,
	AddPlan = AddPlan,
	AddShip = AddShip,
	
}

return HeroStateInventory

