
local function ClearShip(ship)
	if ship then
		GameObjectManager:Destroy(ship)
	end
end

return ClearShip