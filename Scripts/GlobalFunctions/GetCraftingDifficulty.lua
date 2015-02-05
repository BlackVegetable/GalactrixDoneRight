
local function GetCraftingDifficulty(is_ship,itemID,w,e,c)
	--[[--old code
	local cost
	if string.char(string.byte(item)) == "S" then
		cost = SHIPS[item].cost
		if cost < 120001 then
			return 1
		elseif cost < 300001 then
			return 2
		elseif cost < 700001 then
			return 3
		else
			return 4
		end		
	else
		cost = ITEMS[item].cost
		if cost < 1501 then
			return 1
		elseif cost < 4001 then
			return 2
		elseif cost < 8001 then
			return 3
		else
			return 4
		end
	end
	--]]
	--[[
	local cost=0
	cost = w + e + c				
	if is_ship then
		cost = SHIPS[itemID].cost
		if cost < 120001 then
			return 1
		elseif cost < 300001 then
			return 2
		elseif cost < 700001 then
			return 3
		else
			return 4
		end		
	else
		local num_types = 0
		if w > 0 then
			num_types = num_types + 1
		end
		if w > 0 then
			num_types = num_types + 1
		end
		if w > 0 then
			num_types = num_types + 1
		end					
		local extra = math.floor((3-num_types)*cost/2)
		--cost = ITEMS[itemID].cost
		cost = cost + extra
		if cost < 10 then
			return 1
		elseif cost < 16 then
			return 2
		elseif cost < 22 then
			return 3
		else
			return 4
		end
	end
	--]]
		
	
end

return GetCraftingDifficulty