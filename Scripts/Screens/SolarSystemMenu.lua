use_safeglobals()

class "SolarSystemMenu" (cGameMenu)


function SolarSystemMenu:__init()
    super()
		
	LOG("SolarSystemMenu init")			
	
	self.width = GetScreenWidth()
	self.height = GetScreenHeight()    

   -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
   self:Initialize("Assets\\Screens\\SolarSystemMenu.xml")
	--self:Initialize("Assets\\Screens\\GameMenu.xml")
	
	--self:set_list_option("satellite_menu", "list_option")
	--self:set_alpha("satellite_menu",100)

    -- set the worlds view object (this screen doesnt use a world view object)
    -- world:SetView( GameObjectViewManager:Construct("Sprite",'MapView') )
	
	self:PlatformVars()
	
	--self.num_encounters = -1
	
	self.ship_models = {}
end

function SolarSystemMenu:OnEventHideLocation(event)
	LOG("Got event OnHideLocation")
	_G.Hero:EraseAttribute("hacked_gates", location)
	_G.JumpGateList[location]:SetAttribute("hacked", 0)
	self:RefreshGateSprites()
end

function SolarSystemMenu:Open(star_encounter, num_encounters, neutral_encounters, gate_failed, questEvent, encounter_timer)
	if self:IsOpen() then
		return cGameMenu.Open(self)
	end	
	
	self.ship_models = {}	
	if questEvent then
		questEvent()
	end
	self.star_encounter = star_encounter

	self.entryGate = _G.Hero:GetAttribute("curr_loc")
	if num_encounters then
		--self.num_encounters = -1
	end
	if neutral_encounters == false then
		--self.neutral_encounters = false
	end
	self.gate_failed = gate_failed
	
	self.allow_enemy_encounters = false
	
	if encounter_timer then
		self.encounter_timer = encounter_timer
	end

	
	_G.SHIP_LIGHT = false		

	return cGameMenu.Open(self)
end



function SolarSystemMenu:OnOpen()	
	self:SetSystemBackground()
	add_text_file("QuestText.xml")
	add_text_file("StarSystemText.xml")
	add_text_file("StarText.xml")
	add_text_file("FactionText.xml")
	add_text_file("CrewText.xml")		
	
	
	self.time_delta = 0
	self.last_time = GetGameTime()	
	
	-- Send init event to World	
	_G.GLOBAL_FUNCTIONS.Backdrop.Close()
	
	self:CreateWorld()

	--LOG(string.format("%s %s", "Open System", ClassIDToString(self:GetWorld():GetClassID())))
	if _G.Hero.num_encounters == -1 then
		--self.num_encounters = #_G.DATA.StarTable[self:GetWorld(:GetClassID()] - 1)
		_G.Hero.num_encounters = math.random(1,4)
	end

	self:GetWorld():InitSystem(self.star_encounter)

	
	if IsGamepadActive() and GetScreenWidth() >= 1024 then -- running xbox
		local gp_cursor = GameObjectManager:Construct("SSEL")
		gp_cursor:InitCursor(_G.Hero:GetX(), _G.Hero:GetY(), false)--512+171=Center of world space
		self.gp_cursor = gp_cursor
		self.world:AddChild(gp_cursor)
	end
	
	self:UpdateCursorPosition()
	self:SetStartState()	
	
	
	local e = GameEventManager:Construct("UpdateQuestUI")
	GameEventManager:SendDelayed(e,_G.Hero,5000)--Temp Delay - to be removed - or at least reduced to very small
	--self:UpdateUI()
	
	

	
	--LOG(string.format("%s %d", "Star_encounter =", self.star_encounter))

	local chance = math.random(1,3)
	if _G.GLOBAL_FUNCTIONS.DemoMode() then
		chance = 1
	end
	PlaySound("music_map" .. chance)

	if self.star_encounter == _G.ABANDON_ENCOUNTER then
		self:GetWorld():DeselectSatellite()
	end
	self.star_encounter = nil
	
	
	

	if(_G.ShowTutorialFirstTime(1,_G.Hero) == false) then -- Was crashing DS - removed temporarily
	end
	
	

	local starID = _G.Hero:GetAttribute("curr_system")	
	-- handle gate unhacking
	if math.random(1,20) == 1 then
		LOG("Unhacked a gate")
		local gateList = { }
		-- unhack a random gate in the system
		local lastGate = _G.Hero:GetLastGate()
		local numGates = _G.StarList[starID]:NumAttributes("jumpgates")
		
		if numGates > 1 then-- don't unhack only gate
			for i=1, numGates do
				local gate = _G.StarList[starID]:GetAttributeAt("jumpgates",i)
				LOG("i="..tostring(i)..", V = " .. tostring(gate) .. "  lastGate = " ..tostring(lastGate))
				if gate ~= lastGate then--don't unhack the gate we came in on.
					LOG("Inserted gate into list " .. tostring(gate))
					table.insert(gateList, gate)
				end
			end
				
			local unhackID = math.random(1, #gateList)
			local gateID = gateList[unhackID]
			LOG("Try unhack Gate = "..gateID)
			if not GATES[gateID].quest_hack and not (_G.JumpGateList[gateID]:GetAttribute("hacked") == 0) then
				self:UnhackGate(gateID)
				--local event = GameEventManager:Construct("UnhackGate")
				--event:SetAttribute("gateID",gateID)
				
				--GameEventManager:SendDelayed(event,self:GetWorld(),GetGameTime()+math.random(2000,10000))
			end
			
		end
	end
	
	self:SetStartState()
	
	
	
	if _G.XBOXLive then
		-- Let our xbox friends know which star system we are at
		SetXboxContext(1, XboxContext.X_CONTEXT_PRESENCE, _G.XLAST.CONTEXT_PRESENCE_PRES_LOCATION)
		SetXboxContext(1, _G.XLAST.CONTEXT_STARS, _G.XLAST[string.format("CONTEXT_STARS_%s", string.upper(starID))])	
	end

	return cGameMenu.OnOpen(self)
end



function SolarSystemMenu:SetSystemBackground(star)

	local faction
		if not star then
			faction = _G.DATA.Factions[_G.STARS[_G.Hero:GetAttribute("curr_system")].faction]
		else
			faction = _G.DATA.Factions[star:GetFaction()]
		end
		-- Non-DS Platforms
		self:set_image("icon_system_back", faction.system_bg)
		self:set_image("icon_system_back_left", faction.system_bg .. "S0")
		self:set_image("icon_system_back_right", faction.system_bg .. "S1")	
	
	for i=0, 31 do
	
		jigl.set_light_enabled(i,false)			
	end
	
	-- creates a point light in the centre of our world
	LOG("jigl val="..tostring(_G.SCREEN_WIDTH))
	jigl.set_light_enabled(0,true)	
	jigl.set_light_type(0,jigl.light_type.point)
	jigl.set_light_color(0,faction.r,faction.g,faction.b,1)
	-- 390- _G.SCREEN_WIDTH/2 + (_G.SCREEN_WIDTH-1366)/2
	--y = 768-200-_G.SCREEN_HEIGHT/2
	jigl.set_light_position(0,390- _G.SCREEN_WIDTH/2 + (_G.SCREEN_WIDTH-1366)/2 ,200,-1500) -- <-- note: position, not direction
	--jigl.set_light_position(0,0,0,-1500) -- <-- note: position, not direction

	
	
end



function SolarSystemMenu:UnhackGate(gateID, instant)
	local event = GameEventManager:Construct("UnhackGate")
	event:SetAttribute("gateID",gateID)
	if instant then
		event:SetAttribute("instant",1)
		GameEventManager:Send(event,_G.Hero)
	else
		GameEventManager:SendDelayed(event,self:GetWorld(),GetGameTime()+math.random(2000,10000))
	end
end

function SolarSystemMenu:OnAnimOpen()
	if not _G.Hero.in_conversation then
		Graphics.FadeFromBlack()
	end
	
	return Menu.MESSAGE_HANDLED	
end

function SolarSystemMenu:CreateWorld()
	LOG("CreateWorld")
	local star = _G.Hero:GetAttribute("curr_system")

	_G.InitMapObjects()	
	StarList[star] = LoadStar(star,_G.STARS[star])
	self.sun = StarList[star]

	local list = _G.DATA.StarTable[star]
	--For each jumpgate j connected with this star
	for i,j in pairs(list) do
		if string.char(string.byte(j))=="J" then
		
			_G.JumpGateList[j] = LoadGate(j,_G.GATES[j])

					
			
			StarList[star]:PushAttribute("jumpgates", j)
		end
	end					
	local old_world = self:GetWorld()

	-- set the world object
	local world = GameObjectManager:Construct('SSTM')
	
	--local view = GameObjectViewManager:Construct('Map')
	--world:SetView(view)
	self:SetWorld(world)
	self.world = world
	--world:SetPos(-512, 0)

	world:AddChild(self.sun)


	if old_world ~= nil then
		-- remove hero from old_world otherwise it will also try and destroy it too
		if _G.Hero ~= nil then
			old_world:RemoveChild(_G.Hero)
		end
		GameObjectManager:Destroy(old_world)
	end
	
	
	local faction = self.sun:GetFaction()
	if (faction ~= _G.FACTION_NONE) and (faction ~= _G.FACTION_SOULLESS) and (_G.Hero:GetFactionData(faction) == _G.FACTION_UNKNOWN) then
		_G.Hero:PushAttribute("encountered_factions", faction)
	end
	

	SCREENS.SystemInfoMenu:Open(self.sun, "SolarSystemMenu")--has to be after SetWorld() call
	--SCREENS.MiniMapMenu:Open(self.sun, "SolarSystemMenu")--has to be after SetWorld() calll
	

		
	_G.Hero:SetAttribute("in_system", 1)
	_G.Hero:SetCursorInteract(false)
	
	

end

function SolarSystemMenu:RefreshGateSprites()
	LOG("Refreshed gates")
	local starID = _G.Hero:GetAttribute("curr_system")
	local star = _G.StarList[starID]
	for i = 1,star:NumAttributes("jumpgates") do
		_G.JumpGateList[star:GetAttributeAt("jumpgates", i)]:SetSystemView(starID)
	end
end

function SolarSystemMenu:OnGainFocus()
	--self:UpdateUI()
	LOG("SolarSystemMenu:OnGainFocus")
	if is_yesno_menu_open() then
		LOG("yesNo menu still open")
		move_yesno_menu_to_front()	
	end
	
	self:UpdateCursorPosition()
	self:SetStartState()	
	
	return cGameMenu.OnGainFocus(self)
end

function SolarSystemMenu:OnLoseFocus()
	LOG("SolarSystem:OnLoseFocus()")
	
	return Menu.MESSAGE_HANDLED
end


function SolarSystemMenu:SetStartState()
	if not _G.Hero.conversation_callback then	
		if _G.is_open("LocationHighlight") then
			self.state = _G.STATE_TARGET
		else
			self.state = STATE_FLIGHT
		end	
	end
end





-- cGameMenu automatically sends events to the menu and to the game object when you click on one.
-- TODO: does this still get called?
function SolarSystemMenu:OnEventGameObjectClicked(event)
    local object = event:GetAttribute('object')
    assert(object)
end

function SolarSystemMenu:OnButton(buttonId, clickX, clickY)
	if (buttonId == 0) then
		-- Close

	elseif buttonId == 75 then
	-- open quest log
		
		SCREENS.SolarSystemMenu.state = _G.STATE_MENU
		
		--BEGIN_STRIP_DS
		local function OpenInventoryNotDS()
			SCREENS.InventoryFrame:Open("SolarSystemMenu", 7)
		end
		_G.NotDS(OpenInventoryNotDS)
		--END_STRIP_DS
--[[
		local function OpenInventoryDS()
			local function transition()
				_G.CallScreenSequencer("SolarSystemMenu", "InventoryFrame", "SolarSystemMenu", 7,nil,nil, SCREENS.SolarSystemMenu.encounter_timer)
			end
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "InventoryFrame", "SolarSystemMenu")			
		end
		_G.DSOnly(OpenInventoryDS)				
]]--
	elseif buttonId == 76 then
		-- open mini map			
		self.state = _G.STATE_MENU		
		SCREENS.MiniMapMenu:Open()
	end

   return Menu.OnButton(self, buttonId, clickX, clickY)
end

function SolarSystemMenu:OnClose()
	
	self.state = 0--no state
	
	--Close These menus before other objects are destoyed
	close_custompopup_menu()
	SCREENS.LocationHighlight.satellite = nil
	SCREENS.LocationHighlight:CloseMe()	
	
	SCREENS.PopupMenu.satellite = nil
	SCREENS.PopupMenu:Close()

	self.entryGate = nil
	
	self.cursor_snap = nil
	
	local world = self:GetWorld()
	
	if self.gp_cursor then
		world:RemoveChild(self.gp_cursor)
		GameObjectManager:Destroy(self.gp_cursor)
		self.gp_cursor = nil
	end
	
	for i,s in pairs(world.SatelliteList) do
		local satellite = world.SatelliteList[i]
		local classIdStr = ClassIDToString(satellite:GetClassID())			
		world:RemoveChild(satellite)		
		GameObjectManager:Destroy(satellite)
		world.SatelliteList[i] = nil
		satellite = nil
	end				
	
	for i,s in pairs(_G.StarList) do
		_G.StarList[i].view = nil
		_G.StarList[i].viewanim = nil			
		_G.StarList[i] = nil
	end

	for i,s in pairs(_G.JumpGateList) do	
		_G.JumpGateList[i] = nil
	end	

	_G.StarList = nil
	_G.JumpGateList = nil
	world.SatelliteList = nil

	--purge_garbage()
	
	LOG(tostring(gcinfo()))		
		
	world:RemoveChild(_G.Hero)
	
	_G.Hero:SetView(nil)
	_G.Hero.view = nil
	
	for index, encounter in ipairs(world.encounters) do
		if encounter.enemy then
			if encounter.enemy:GetParent() == world then -- the HERO that shouldnt be deleted (the one going into the next encounter) is detached from the world
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearEnemy(encounter.enemy)
			end
		end
	end
	
	world.encounters=nil	
		
	local num_children = world:GetNumChildren()

	for i=0,num_children-1 do
		--LOG("child " .. self:GetWorld():GetChild(i))
		local node = world:GetChild(0)
		local classIdStr = ClassIDToString(node:GetClassID())	
		LOG(string.format("%s %s", "Destroy", classIdStr))
		world:RemoveChild(node)
		if node ~= self.enemy then
			GameObjectManager:Destroy(node)
		end	
		node = nil
	end
	
	self.sun = nil
	
	GameObjectManager:Destroy(world)
	world = nil
	self:SetWorld(nil) 	
	self.world = nil
	
	--ClearAutoLoadTables()
	--purge_garbage()
	

	remove_text_file("StarSystemText.xml")
	remove_text_file("StarText.xml")
	remove_text_file("FactionText.xml")
	remove_text_file("CrewText.xml")
	remove_text_file("QuestText.xml")
		
	_G.SCREENS.SystemInfoMenu:Close()

	return cGameMenu.OnClose(self)
end

local function quit_confirm(confirmed)
	if confirmed then						
		_G.GLOBAL_FUNCTIONS.Backdrop.Open()		
		local function QuitMapCallback()
			_G.CallScreenSequencer("SolarSystemMenu","SinglePlayerMenu")
			Sound.StopMusic();
		end
		_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, QuitMapCallback)			
	end
end	

function SolarSystemMenu:OnKey(key)
	if key == self.exit_key then
			
		self.state = _G.STATE_MENU
		open_yesno_menu("[QUIT]", "[QUITSTARMAP]", quit_confirm, "[YES]", "[NO]" )	
	
	elseif key == self.hack_key then
		_G.Hero:ClearAttributeCollection("hacked_gates")
		for i,v in pairs(_G.DATA.JumpGatesTable) do
			_G.Hero:PushAttribute("hacked_gates",i)
		end				
		self:UpdateUI()
	elseif key == self.debug_key then
	LOG("DebugMenu Open")
		SCREENS.DebugMenu:Open()
		self.state = _G.STATE_MENU
	
   	elseif key == self.log_key then -- only DS had a log_key
		--self:OnButton(75,0,0)
      --_G.CallScreenSequencer("SolarSystemMenu", "InventoryFrame", "SolarSystemMenu", 7)
	  local function transition()
	  	_G.LoadAssetGroup("AssetsInventory")			
	  	_G.CallScreenSequencer("SolarSystemMenu", "InventoryFrame", "SolarSystemMenu", 7,nil,nil, SCREENS.SolarSystemMenu.encounter_timer)
	  end
	  SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "InventoryFrame")		
	  --SCREENS.InventoryFrame:Open("SolarSystemMenu", 7)
    elseif key == self.next_ship_key then
		LOG("F7 Key pressed")
		local shipList = {"SAGS",
		"SCBS",
		"SCMA",
		"SCTN",
		"SDMS",
		"SELF",
		"SJHS",
		"SKTS",
		"SLAS",
		"SLHC",
		"SLWS",
		"SMBL",
		"SMPA",
		"SMRM",
		"SPSS",
		"SPWS",
		"SQLS",
		"SSGS",
		"SSHC",
		"SSHL",
		"SSMT",
		"SSWS",
		"STBS",
		"STDG",
		"STDS",
		"STWS",
		"SVDR",
		"SVHC"}
		if not self.shipIndex then
			self.shipIndex = 1
		else
			self.shipIndex = self.shipIndex + 1
			if self.shipIndex > #shipList then
				ClearAutoLoadTables()
				purge_garbage()
				self.shipIndex = 1
			end
		end
		local shipCode = shipList[self.shipIndex]
		LOG(tostring(self.shipIndex).." Set ship "..shipCode)
		local old_ship = _G.Hero:GetAttribute("curr_ship")
		local new_ship = _G.GLOBAL_FUNCTIONS.LoadShip(shipCode)
		new_ship.pilot = _G.Hero
		_G.Hero:SetAttribute("curr_ship",new_ship)
		GameObjectManager:Destroy(old_ship)
		local loadout = _G.Hero:GetAttributeAt("ship_list",_G.Hero:GetAttribute("ship_loadout"))
		loadout:SetAttribute("ship",shipList[self.shipIndex])
		_G.Hero:SetSystemView()
		_G.EncounterMessage(self:GetWorld(),string.format("[%s_NAME]",shipCode),683,384)
   	else  
		--LOG(string.format("%s %s %s", "No Key match", tostring(key), tostring(Keys.SK_F7)))
	end	
 
   return Menu.MESSAGE_NOT_HANDLED
end


--[[
function SolarSystemMenu:OnGamepadButton(user, button, on)
	--LOG(string.format("%s %d   %s %s", "Button detected. ID =", button, "on = ", tostring(on))
	
	-- start button released
	if button == 7 and on == false then
		
		
		open_yesno_menu("[QUIT]", "[QUITSTARMAP]", quit_confirm, "[YES]", "[NO]" )	
	end
	
	return Menu.OnGamepadButton(self, button, on, user)
end
]]--


function SolarSystemMenu:OpenStarMap(gateID)
	LOG("OpenStarMap "..gateID)
	--_G.CallScreenSequencer("SolarSystemMenu", "MapMenu",gateID)
	
	_G.Hero:SetMovementController(nil)
	SetFadeToBlack(false)
	local function transition()
		_G.CallScreenSequencer("SolarSystemMenu", "MapMenu",gateID)
	end
	--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, "MapMenu", "SolarSystemMenu")
	SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "MapMenu", "SolarSystemMenu")
	--_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, continue)	
end


function SolarSystemMenu:UpdateUI()

	--LOG("SolarSystemMenu UpdateUI")
	if self:IsOpen() and self:GetWorld() then	
		LOG("isopen -> updateUI")
					    
		local world = self:GetWorld()
		--MemLeak.begin_analysis()

		--For each Satellie - gets quest actions - updates Icon
		for i,v in pairs(world.SatelliteList) do
			v:UpdateQuestIndicator()
		end
		--MemLeak.end_analysis()
		

	end
	
	self:SetupMiniMap()

end


function SolarSystemMenu:GetNearestSatellite(obj,dpadx,dpady)
	local x = obj:GetX()
	local y = obj:GetY()
	local nearestObj
	local minDistance = 3000
	
	local lists = {{self.world.SatelliteList,function(a)return a; end}}
	--,{self.world.encounters,function(a)return a.enemy; end}}
	
	for i,v in pairs(lists) do
		for j,k in pairs(v[1]) do
			local obj = v[2](k)
			local xDif = x-obj:GetX()
			local yDif = y-obj:GetY()
			local negX = false
			local negY = false
			if xDif < 0 then
				negX = true
				xDif = math.abs(xDif)
			end
			if yDif < 0 then
				negY = true
				yDif = math.abs(yDif)
			end			
			--if xDif ~= 0 or yDif ~= 0 then--if not object that cursor is sitting above
			
				if (dpadx or dpady) and not(dpadx and dpady) then
					--[[
					if dpadx then
						--LOG(string.format("dpadx=%d, negX=%s, xDif=%d, minDist=%d",dpadx,tostring(negX),xDif,minDistance))
						if dpadx < 0 and not negX and xDif < minDistance then--left
							nearestObj = obj
							minDistance = xDif
						elseif dpadx > 0 and negX and xDif < minDistance then--right
							nearestObj = obj
							minDistance = xDif						
						end			
					else--dpady
						if dpady < 0 and not negY and yDif < minDistance then--up
							nearestObj = obj
							minDistance = yDif
						elseif dpady > 0 and negY and yDif < minDistance then--down
							nearestObj = obj
							minDistance = yDif						
						end								
					end
					--]]
				else
					local distance = math.sqrt(xDif*xDif + yDif*yDif)
					if distance < minDistance then
						nearestObj = obj
						minDistance = distance
					end
				end
			--end
		end
	end
	return nearestObj
	
end






dofile("Assets/Scripts/Screens/SolarSystemMenuPlatform.lua")

return ExportSingleInstance("SolarSystemMenu")
