
local function GetCraftingCost(itemID)

	local cargo_cost = {0,0,0,0,0,0,0,0,0} 
	local cargo_map = {1,2,3,4,5,6,7,8,9}
	local offset = 0
	
	--offset = math.random(0,9)
	
	if string.char(string.byte(itemID))== "I" then--item
		local item = _G.ITEMS[itemID]
		offset = item.rarity
		if item.weapon_requirement >= item.engine_requirement and item.weapon_requirement >= item.cpu_requirement then
			cargo_cost[_G.CARGO_LUXURIES]= 3 + item.weapon_requirement
			cargo_cost[_G.CARGO_MINERALS]= 5 + item.engine_requirement
			cargo_cost[_G.CARGO_TEXTILES]= 4 + item.cpu_requirement
		elseif item.engine_requirement >= item.weapon_requirement and item.engine_requirement >= item.cpu_requirement then
			cargo_cost[_G.CARGO_ALLOYS]=   5 + item.weapon_requirement
			cargo_cost[_G.CARGO_GOLD]=     3 + item.engine_requirement
			cargo_cost[_G.CARGO_TEXTILES]= 4 + item.cpu_requirement		
		else
			cargo_cost[_G.CARGO_ALLOYS]= 4 + item.weapon_requirement
			cargo_cost[_G.CARGO_TECH]=   5 + item.engine_requirement
			cargo_cost[_G.CARGO_GEMS]=   3 + item.cpu_requirement		
		end
		
	else--crafting ship
		local ship = _G.SHIPS[itemID]
		--offset = ship.max_items
		cargo_cost[_G.CARGO_FOOD]= ship.engines
		cargo_cost[_G.CARGO_TEXTILES]= ship.hull
		cargo_cost[_G.CARGO_MINERALS]= ship.weapons_rating
		cargo_cost[_G.CARGO_ALLOYS]= math.floor(ship.cargo_capacity/5)
		cargo_cost[_G.CARGO_TECH]= ship.shield
		cargo_cost[_G.CARGO_LUXURIES]= ship.engine_rating
		cargo_cost[_G.CARGO_MEDICINE]= ship.cpu_rating
		cargo_cost[_G.CARGO_GEMS]= ship.cpu_rating
		cargo_cost[_G.CARGO_GOLD]= ship.max_items
		
		
	end
	
	cargo_cost[_G.CARGO_CONTRABAND]=0  --Guarantees Contraband never used
	
	return cargo_cost
end


local function HasRequiredCargo(hero,cargo_list)
	LOG("HasRequiredCargo")	
	for i,v in pairs(cargo_list) do
		LOG(string.format("i=%d, v=%d, cargo=%d",i,v,hero:GetAttributeAt("cargo",i)))		
		if hero:GetAttributeAt("cargo",i) < v then
			LOG("Return False")
			return false
		end
	end
	return true
end


local function SubtractCraftingCost(hero,itemID)
	LOG("SubtractCraftingCost")
	local cargo_cost = GetCraftingCost(itemID)
	
	for i,v in pairs(cargo_cost) do
		hero:RemoveCargo(i,v)
	end
	
end


return {["GetCraftingCost"]=GetCraftingCost;
		["SubtractCraftingCost"]=SubtractCraftingCost;
		["HasRequiredCargo"]=HasRequiredCargo;
}
