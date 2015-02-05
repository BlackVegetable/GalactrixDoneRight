
local function DiminishingReturns(val, scale)
	if val < 0 then
		return -DiminishingReturns(-val, scale)
	end
	local mult = val / scale
	local trinum = (math.sqrt(8.0 * mult + 1.0) - 1.0) / 2.0
	return trinum * scale
end

return DiminishingReturns