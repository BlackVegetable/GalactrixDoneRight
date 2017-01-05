function SolarSystemMenu:PlatformVars()
	self.exit_key = Keys.SK_ESCAPE
	self.save_key = Keys.SK_F1
	
	if _G.DEBUGS_ON then
		self.debug_key = Keys.SK_F2
		self.hack_key = Keys.SK_F8
		self.next_ship_key = Keys.SK_F7
	end
	
	self.subtract_screen_space = 0
--	self.intel_key = Keys.SK_F3
--	self.credits_key = Keys.SK_F4
--	self.powers_key = Keys.SK_F5
--	self.powers_disable_key = Keys.SK_F6
end

function SolarSystemMenu:OnTimer(time)
	local world = self:GetWorld()
	
	if self.state ~= _G.STATE_MENU then
		if _G.Hero.cut_scene then
			_G.PlayCutscene(_G.Hero.cut_scene)
			return Menu.MESSAGE_HANDLED
		elseif _G.Hero.quest_battle then
			local function restoreMenu()
				SCREENS.SolarSystemMenu.state = _G.STATE_IDLE
			end
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero,restoreMenu)
			_G.Hero.quest_battle = nil
		end
	end
	

	
	
	if world then
		if world.current_satellite and self.state ~= _G.STATE_MENU then--If a satellite is selected
			local target_diff_x = world.current_satellite:GetX() - _G.Hero:GetX()
			local target_diff_y = world.current_satellite:GetY() - _G.Hero:GetY()
			
			 local distance_diff = math.sqrt(target_diff_x*target_diff_x + target_diff_y*target_diff_y)
			
			if distance_diff <= 20 and SCREENS.SolarSystemMenu:GetWorld().planet_open ==1 and _G.Hero:GetAttribute("ai")==0 and not _G.is_open("PopupMenu") then
				self.current_speed = 0
				LOG("Open Popup Menu")
				SCREENS.SolarSystemMenu:GetWorld():ArrivedAtPlanet(self)
			end
		end
	end
	
	self.time_delta = time - self.last_time
	
	if self.time_delta > 40 then	
		self.last_time = time
		self:GetWorld():MoveShips(true)
	end		

	if not Sound.IsMusicPlaying() then
		local chance = math.random(1,3)
		if _G.GLOBAL_FUNCTIONS.DemoMode() then
			chance = 1
		end
		PlaySound("music_map" .. chance)
	end		
	

	return cGameMenu.OnTimer(self, time)
end



local TWO_PI = math.pi + math.pi


function SolarSystemMenu:OnDraw(time)
	if self.world.current_satellite and self.world.current_satellite:HasAttribute("ai") then
		if _G.is_open("LocationHighlight") then
			SCREENS.LocationHighlight:Move(self.world.current_satellite:GetX()+(GetScreenWidth()-_G.MAX_WIDESCREEN)/2, _G.SCREENHEIGHT-self.world.current_satellite:GetY())
		end
	end	
	
	local ship = _G.Hero:GetAttribute("curr_ship")
	
	if ship.classIDStr == "SAGS" then
		if not _G.SHIP_LIGHT then
			LOG("ACHERONGHOSTSHIP LIGHTS ON")
			_G.SHIP_LIGHT = true
			jigl.set_light_enabled(1,true)
			jigl.set_light_type(1,jigl.light_type.point)
			jigl.set_light_color(1,0.4,0.4,1,1) 
			--[[
			jigl.set_light_type(2,jigl.light_type.point)
			jigl.set_light_color(2,0.4,0.4,1,1) 
			jigl.set_light_enabled(2,true)		
			jigl.set_light_type(3,jigl.light_type.point)
			jigl.set_light_color(3,0.4,0.4,1,1) 	
			jigl.set_light_enabled(3,true)		
			jigl.set_light_type(4,jigl.light_type.point)
			jigl.set_light_color(4,0.4,0.4,1,1) 	
			jigl.set_light_enabled(4,true)			
			--]]
		end
		local adjust_x =  _G.Hero:GetX() - _G.SCREEN_WIDTH/2 + (_G.SCREEN_WIDTH-1366)/2
		local adjust_y = _G.Hero:GetY() - _G.SCREEN_HEIGHT/2
		jigl.set_light_position(1,adjust_x,adjust_y,-300) -- <-- note: position, not direction
		--jigl.set_light_position(1,adjust_x-40,adjust_y+40,-100) -- <-- note: position, not direction
		--[[
		jigl.set_light_position(2,adjust_x+40,adjust_y-40,-100) -- <-- note: position, not direction
		jigl.set_light_position(3,adjust_x+40,adjust_y+40,-100) -- <-- note: position, not direction
		jigl.set_light_position(4,adjust_x-40,adjust_y-40,-100) -- <-- note: position, not direction
		--]]
	else
		if _G.SHIP_LIGHT then
			_G.SHIP_LIGHT = false			
			jigl.set_light_enabled(1,false)
			--[[
			jigl.set_light_enabled(2,false)
			jigl.set_light_enabled(3,false)
			jigl.set_light_enabled(4,false)
			--]]
			LOG("ACHERONGHOSTSHIP LIGHTS OFF")
		end
	end

	-- update rotation of 3D satellites here --
	for i,s in pairs(self:GetWorld().SatelliteList) do
		--LOG(tostring(s.classIDStr))
		local satellite_view = s:GetView()
		local mv = CastToModel3DView(satellite_view)
		
		-- this will only work on model3dviews.
		if mv and mv.__ok then
			if not s.latent_rotation then
				mv:Rotate(s.rotation_speedx, s.rotation_speedy, s.rotation_speedz)
			else
				s.init_rotationx = s.init_rotationx + s.rotation_speedx
				s.init_rotationy = s.init_rotationy + s.rotation_speedy
				s.init_rotationz = s.init_rotationz + s.rotation_speedz
				if s.init_rotationz > TWO_PI then
					s.init_rotationz = s.init_rotationz - TWO_PI
				end
				mv:SetRotation(s.init_rotationx, s.init_rotationy,s.init_rotationz)
			end
		end
	end
	
	
	return cGameMenu.OnDraw(self, time)	
end

function SolarSystemMenu:OnMouseMove(id, x, y, up,init)
	--LOG("SolarSystemMenu:OnMouseMove(id="..tostring(id))
	if self:GetWorld() and id == 100 then--GamePad widget
		self:GetWorld().mouseX = x
		self:GetWorld().mouseY = y

		if (not init) then
			self.allow_enemy_encounters = true
		end
		
	end

	return Menu.MESSAGE_HANDLED
end


function SolarSystemMenu:UpdateCursorPosition()
	local pos = Interface.GetCurrentCursor():GetPosition()
	self:OnMouseMove(100,pos.x + (1366-_G.SCREEN_WIDTH)/2,pos.y,nil,true)--Sets ship target to cursor positiion
end


function SolarSystemMenu:HideWidgets()

end

function SolarSystemMenu:ShowWidgets()

end


function SolarSystemMenu:SetupMiniMap()	
	
	--[[
	local function IsPrimaryQuest(id)
		local chapter = string.sub(id,3,3)
		if chapter == "0" or chapter == "1" or chapter == "2" or chapter == "3" or chapter == "4" then
			return true
		end
		return false
	end
	
	-- Get faction home coords & set a ping
	local fpx = self.sun:GetAttribute("xpos")
	local fpy = self.sun:GetAttribute("ypos")
	if fpx == 0 and fpy == 0 then
		SCREENS.SystemInfoMenu:hide_widget("icon_ping")
	else
		SCREENS.SystemInfoMenu:activate_widget("icon_ping")
		SCREENS.SystemInfoMenu:set_widget_position("icon_ping",   114+fpx/8-7,   -142+(1024-fpy)/8-7)
	end

	-- Now set pings for all quest destinations
--[-[
	local valid_destinations = {}
	local numDestinations = 0
	local quest_idloc = GetQuestIdsAndObjectiveLocations(_G.Hero)
	for s,list in pairs(quest_idloc) do

		if self.allStars[list[2] ] then

			table.insert(valid_destinations, list)
			numDestinations = numDestinations + 1
		end
	end	
	
	for i = 1, 8 do
		local ico = "icon_point"..tostring(i)
		if i > numDestinations then

			SCREENS.SystemInfoMenu:hide_widget(ico)
		else
			local list = valid_destinations[i]
			local fpx = self.allStars[list[2] ].xpos
			local fpy = self.allStars[list[2] ].ypos

			
			local spr = "img_dl2_point"
			if IsPrimaryQuest(list[1]) then
				spr = "img_dl_point"
			end
			SCREENS.SystemInfoMenu:set_widget_position(ico,   114+fpx/8-7,   -142+(1024-fpy)/8-7)
			SCREENS.SystemInfoMenu:set_image(ico, spr)
			SCREENS.SystemInfoMenu:activate_widget(ico)
		end
	end	
	--]-]
	
	
	
	local valid_destinations = {}
	local numDestinations = 0
	local quest_idloc = GetQuestIdsAndObjectiveLocations(_G.Hero)
	local keys={}
	--creates list of quest locations
	--primary will overwrite secondary
	for s,list in pairs(quest_idloc) do
		if self.allStars[list[2] ] then
			if IsPrimaryQuest(list[1])  then
				keys[list[2] ]=1
				valid_destinations[list[2] ]= list
			elseif not keys[list[2] ] then
				keys[list[2] ]=2
				valid_destinations[list[2] ]= list
			end
		end
	end	
	
	numDestinations = #valid_destinations
	for i = 1, 8 do
		if i > numDestinations then
			SCREENS.SystemInfoMenu:hide_widget("icon_point"..tostring(i))--hide any unused widgets
		else
			SCREENS.SystemInfoMenu:activate_widget("icon_point"..tostring(i))			
		end
	end
	local counter = 0
	for i,v in pairs(valid_destinations) do
		counter = counter + 1
		if counter > 8 then--limit widgets drawn to 8
			break
		end
		local list = v
		local fpx = self.allStars[i].xpos
		local fpy = self.allStars[i].ypos

		local ico = "icon_point"..tostring(counter)
		local spr = "img_dl2_point"
		if IsPrimaryQuest(list[1]) then			
			spr = "img_dl_point"
		end
		SCREENS.SystemInfoMenu:set_widget_position(ico,   114+fpx/8-7,   -142+(1024-fpy)/8-7)
		SCREENS.SystemInfoMenu:set_image(ico, spr)
		SCREENS.SystemInfoMenu:activate_widget(ico)
	end		
	
	for i = counter+1, 8 do
		SCREENS.SystemInfoMenu:hide_widget("icon_point"..tostring(i))--hide any unused widgets
	end	
	
--]]		
end

