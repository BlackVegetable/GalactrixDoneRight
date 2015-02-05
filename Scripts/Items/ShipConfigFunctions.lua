-- Ship Config Functions
-- A series of global functions to handle ship loadouts

use_safeglobals()

-- gets a list of ShipIds for ships owned by the specified hero
function GetShips(Hero)
	local numAttributes = Hero:NumAttributes("ship_list")
	local ships = {}

	for i=1,numAttributes do
		table.insert(ships, Hero:GetAttributeAt("ship_list", i):GetAttribute("ship"))
	end

	return ships
end

-- gets a list of items linked to a specified ship
function GetLoadout(Hero, shipNum)
	local numShips = Hero:NumAttributes("ship_list")
	local items = {}
	if (shipNum <= numShips) then
		for i=1,Hero:GetAttributeAt("ship_list",shipNum):NumAttributes("items") do
		   table.insert(items, Hero:GetAttributeAt("ship_list",shipNum):GetAttributeAt("items", i))
		end
		return items
	end
	return nil
end


function AddItemToShip(Hero,itemPos,itemCode)


end

