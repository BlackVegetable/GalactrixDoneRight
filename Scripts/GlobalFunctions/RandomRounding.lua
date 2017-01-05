-- RandomRounding.lua --
-- Determines the rounding behavior for attribute effects based on their proximity to nearest values --

local function RandomRounding (value, div)

	local multi = math.floor(value / div)
	local remainder = value - (div * multi)
	local upChance = remainder / div
	local p = math.random()
	local round

	-- Dice Roll -- Lower rolls win
	if p <= upChance then
		round = "up"
	else
		round = "down"
	end

	return round
end

return RandomRounding

	-- Example, 65 Engineering (+1 per 25 points)
	-- 2 = 65/25
	-- 15 = 65 - 25 * 2
	-- 0.6 = 15 / 25
	-- some roll

	-- if dice roll <= 0.6 then
	-- round up
	-- otherwise, round down
