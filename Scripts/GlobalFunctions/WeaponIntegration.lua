-- Weapon Integration -- Calculates the bonus Red Energy gained when matching gems produces 6 or more Green or Yellow energy.

local function WeaponIntegration(gunnery)

local WeaponIntegration
	if gunnery < 150 then
		WeaponIntegration = 0
	else if gunnery > 150 && gunnery < 240 then
		WeaponIntegration = 1
	else
		WeaponIntegration = 2
	end

end
return WeaponIntegration
