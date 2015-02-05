use_safeglobals()


local NUM_ENCOUNTERS = 2


local function InitSystem(sstm, alert)

	sstm.SatelliteList = {}
	sstm.encounters={}
	_G.Hero:SetMovementController(nil)
	_G.Hero.sorting_value = 10
	_G.Hero:SetSystemView()	
	_G.Hero.OnEventMovementFinished = nil

	local star = _G.Hero:GetAttribute("curr_system")
	LOG("initsystem " .. star)

	--Iterate through system satellites - create satellite - scale each one.
	for i,v in pairs(_G.DATA.StarTable[star]) do
		--LOG("first char "..string.char(string.byte(i,1)))
		local satellite
		if string.char(string.byte(v))=="J" then -- if jumpgate satellite
			--if _G.Hero:GetAttribute("show_gates")==1 then
				satellite = JumpGateList[v]

				if CollectionContainsAttribute(_G.Hero, 'hacked_gates', v) then
					satellite:SetAttribute("hacked", 1)
				end		
				satellite:SetSystemView(star)
				sstm:AddChild(satellite)
				sstm.SatelliteList[v] = satellite
			--end
		else
			satellite = LoadSatellite(v)
			satellite:SetSystemView()	
			--sstm:SetSystemScale(satellite)
			sstm:AddChild(satellite)
			sstm.SatelliteList[v] = satellite
		end		
	end
	LOG("initsystem02")
	
	purge_garbage()
	--[[
	if sstm:GetAttribute("max_encounters") > 5 then
		for i,v in pairs(_G.DATA.StarTable[star]) do
			LOG(v)
		end
	end
	]]--
	
	_G.GLOBAL_FUNCTIONS.SetEncounters(sstm, alert)		
	LOG("initsystem03")
	local curr_loc = _G.Hero:GetAttribute("curr_loc")
	LOG("curr_loc "..tostring(curr_loc))
	LOG(tostring(alert))
	

	if (sstm.SatelliteList[curr_loc]) and not alert then
		LOG("SatelliteList pass - set pos")
		curr_loc = sstm.SatelliteList[curr_loc]
		_G.Hero:SetPos(curr_loc:GetX(),curr_loc:GetY())
	elseif curr_loc ~= "" and string.char(string.byte(curr_loc,1),string.byte(curr_loc,2)) == "HE" then
		--encounter victory = last held position
	else
		LOG("Random Pos ")
		--LOG(string.format(" horizontal between %d  &  %d",_G.MIN_HORIZONTAL,_G.MAX_HORIZONTAL))
		--LOG(string.format(" vertical between %d  &  %d",_G.MIN_VERTICAL,_G.MAX_VERTICAL))
		local heroX = math.random(_G.MIN_HORIZONTAL,_G.MAX_HORIZONTAL)
		local heroY = math.random(_G.MIN_VERTICAL,_G.MAX_VERTICAL-SCREENS.SolarSystemMenu.subtract_screen_space)

		--LOG("HeroX="..tostring(heroX))
		--LOG("HeroY="..tostring(heroY))
		local function diff(a,b)
			local c = a-b
			if c < 0 then
				return math.abs(c), -1
			else
				return math.abs(c), 1
			end
		end

		for i,v in pairs(sstm.encounters)do
			local encX = v.enemy:GetX()
			local encY = v.enemy:GetY()

			--LOG("EncX="..tostring(encX))
			--LOG("EncY="..tostring(encY))
			local difX,xmod = diff(encX,heroX)
			local difY,ymod = diff(encY,heroY)

			--LOG("DifX="..tostring(difX))	
			--LOG("DifY="..tostring(difY))			
			if difX < _G.MIN_ENC_DIST and difY < _G.MIN_ENC_DIST then
				v.enemy:SetPos(encX + xmod * _G.MIN_ENC_DIST, encY + ymod * _G.MIN_ENC_DIST)
			end
		end		
		
		_G.Hero:SetPos(heroX,heroY)
	end

	sstm:DeselectSatellite()

	sstm.mouse_x = _G.Hero:GetX()
	sstm.mouse_y = _G.SCREENHEIGHT - _G.Hero:GetY()

	sstm.mouseX = sstm.mouse_x
	sstm.mouseY = sstm.mouse_y
	

	sstm:AddChild(_G.Hero)
	_G.Hero:SetCursorInteract(false)
	local view = _G.Hero:GetView()
	
	_G.Hero:GetView():SetSortingValue(-5)
	
	ClearAutoLoadTables()
end

local SSTMInit = 
{
	InitSystem = InitSystem,
}
return SSTMInit

