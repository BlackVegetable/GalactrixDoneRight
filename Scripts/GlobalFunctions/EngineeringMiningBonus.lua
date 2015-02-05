-- Engineering Mining Bonus --
-- Determines bonus to matching materials in mining minigame based on Engineering skill.

local function EngineeringMiningBonus(engineering)

	local bonus = 0

	if engineering < 40 then
		bonus = 0
		return bonus
	end
	if engineering < 90 then
		bonus = 1
		return bonus
	end
	if engineering < 140 then
		bonus = 2
		return bonus
	end
	if engineering < 190 then
		bonus = 3
		return bonus
	end
	if engineering < 240 then
		bonus = 4
		return bonus
	end
	if engineering >= 240 then
		bonus = 5
		return bonus
	else
		return 0
	end


end
return EngineeringMiningBonus
