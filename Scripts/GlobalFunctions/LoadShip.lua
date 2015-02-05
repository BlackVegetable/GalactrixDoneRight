
local function LoadShip(shipCode,ship)	
	--return dofile("Assets/Scripts/Ships/"..shipCode..".lua")
	if not ship then
		ship = GameObjectManager:Construct("Ship")
	end
	ship:SetAttribute("model",string.format("[%s_NAME]", shipCode))
	ship:SetAttribute("portrait",string.format("img_%s", shipCode))
	
	if SHIPS[shipCode].model then
		ship:SetAttribute("3d_model",SHIPS[shipCode].model)
	end
	ship:SetAttribute("cost",SHIPS[shipCode].cost)
	
	ship:SetAttribute("hull",SHIPS[shipCode].hull)
	ship:SetAttribute("shield",SHIPS[shipCode].shield)
	ship:SetAttribute("max_items",SHIPS[shipCode].max_items)
	ship:SetAttribute("weapons_rating",SHIPS[shipCode].weapons_rating)
	ship:SetAttribute("engine_rating",SHIPS[shipCode].engine_rating)
	ship:SetAttribute("cpu_rating",SHIPS[shipCode].cpu_rating)
	ship:SetAttribute("cargo_capacity",SHIPS[shipCode].cargo_capacity)
	
	
	ship:SetAttribute("turn_speed",SHIPS[shipCode].turn_speed)
	ship:SetAttribute("max_speed",SHIPS[shipCode].max_speed)
	ship:SetAttribute("acceleration",SHIPS[shipCode].acceleration)
	ship:SetAttribute("decceleration",SHIPS[shipCode].decceleration)
	ship:SetAttribute("engines",SHIPS[shipCode].engines)
	
	ship.particle_offset = 0
	if SHIPS[shipCode].particle_offset then
		ship.particle_offset = SHIPS[shipCode].particle_offset
	end

	ship.particle_offsets_2 = {1,1}	
	if SHIPS[shipCode].particle_offsets_2 then -- left particle
		ship.particle_offsets_2 = SHIPS[shipCode].particle_offsets_2
	end
	
	ship.particle_offsets_3 = {0,0}
	if SHIPS[shipCode].particle_offsets_3 then -- left particle
		ship.particle_offsets_3 = SHIPS[shipCode].particle_offsets_3
	end	
	
	ship.model_scale = 0.5
	if SHIPS[shipCode].model_scale then
		ship.model_scale = SHIPS[shipCode].model_scale
	end
	
	ship.classIDStr = shipCode	
	
	return ship
end

return LoadShip