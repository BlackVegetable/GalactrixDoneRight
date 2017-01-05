

local function GetShipClass(max_items)
	if max_items == 3 then
		return "[SHUTTLE]"
	elseif max_items == 4 then
		return "[FRIGATE]"
	elseif max_items == 5 then
		return "[LIGHT_CRUISER]"
	elseif max_items == 6 then
		return "[HEAVY_CRUISER]"
	elseif max_items == 7 then
		return "[DREADNAUGHT]"
	elseif max_items >= 8 then
		return "[CAPITAL]"
	end
end

return GetShipClass
