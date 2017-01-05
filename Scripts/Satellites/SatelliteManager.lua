


function _G.LoadSatellite(satelliteCode)	
	--return dofile("Assets/Scripts/Satellites/"..satelliteCode..".lua")
	
	local satellite = GameObjectManager:Construct(SATELLITES[satelliteCode].id_type)
	
	if SATELLITES[satelliteCode].rumor then
		satellite:SetAttribute("rumor", string.format("R%03d", SATELLITES[satelliteCode].rumor))
		satellite:SetAttribute("moves", SATELLITES[satelliteCode].moves)
		satellite:SetAttribute("intel", SATELLITES[satelliteCode].intel)
	end
	
	--satellite:SetAttribute("name", string.format("[%s_NAME]",satelliteCode))
	satellite:SetAttribute("sat_xpos", SATELLITES[satelliteCode].sat_xpos)
	satellite:SetAttribute("sat_ypos", SATELLITES[satelliteCode].sat_ypos)
	satellite.classIDStr = satelliteCode
	
	if SATELLITES[satelliteCode].gemList then
		satellite.gemList = SATELLITES[satelliteCode].gemList
	end
	if SATELLITES[satelliteCode].cargo then
		satellite.cargo = SATELLITES[satelliteCode].cargo
	end
	
	return satellite
end

