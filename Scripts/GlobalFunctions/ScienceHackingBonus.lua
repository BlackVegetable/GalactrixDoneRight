-- Science Hacking Bonus --
-- Determines how many fewer keys gates will take based on Science skill

local function ScienceHackingBonus(science)

	if science < 25 then
		return 0
	elseif science < 60 then
		return 1
	elseif science < 100 then
		return 2
	elseif science < 145 then
		return 3
	elseif science < 195 then
		return 4
	elseif science < 245 then
		return 5
	else
		return 6
	end

end
return ScienceHackingBonus
