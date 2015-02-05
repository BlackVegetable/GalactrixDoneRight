use_safeglobals()

class "MapMenu" (cGameMenu)



function MapMenu:__init()
	super()
	--[[
	for i,v in pairs(SCREENS) do
		LOG(string.format("%s %s %s %s", "Screen:", i, "IsOpen?", tostring(v:IsOpen())))
	end ]]--
	LOG("MapMenu init")

	self:Initialize("Assets\\Screens\\MapMenu.xml")	

	-- movement flags
	self.vertical = 0
    self.horizontal = 0
	self.last_vertical = 0
    self.last_horizontal = 0	
	self.vertical_direction = 0
	self.horizontal_direction = 0
	self.scale = 1
	self.scale_change = 1
	self.last_click_time = 0
	self.vertical_scroll_rate = 0 -- pixels per second
	self.horizontal_scroll_rate = 0 -- pixels per second
	self.last_time = GetGameTime()
	self.clicked = false
	
	self:PlatformVars()

	-- Send an initialize event to the world
	--local event = GameEventManager:Construct("Initialize")
	--GameEventManager:Send( event, self:GetWorld() )	
end

-------------------------------------------------------------
-- Creates Global lists of Stars and JumpGates
-- links jumpgates to stars.
-- Constructs world object MAP0
function MapMenu:CreateWorld()
	LOG("CreateWorld")
	purge_garbage()
	local t1 = GetSystemTime()

	local JumpGateList	= {}
	local StarList		= {}
	_G.JumpGateList	= JumpGateList
	_G.StarList		= StarList
	
	for j,l in pairs(_G.DATA.JumpGatesTable) do
		--_G.JumpGateList[j]=_G.LoadGate(j,_G.GATES.AllJumpGates[j])
		local gate = GameObjectManager:Construct("Gate")
		gate.classIDStr = j
		gate:SetCursorInteract(false)
		JumpGateList[j] = gate
	end

	local t2 = GetSystemTime()

	local strbyte	= string.byte
	local codeJ		= strbyte("J")
	local selfhacked = self.hacked
	for s,list in pairs(_G.DATA.StarTable) do
		local star	= _G.LoadStar(s, _G.STARS.AllStars[s])
		StarList[s]	= star
		local discovered = false
		--For each jumpgate j connected with this star
		for i,j in pairs(list) do
			if strbyte(j)==codeJ then				
				if selfhacked[j] then
					star.hacked = true
					--star:SetAttribute("sprite", "ZST0")
					--star:SetStarMapView()
				end								
				star:PushAttribute("jumpgates", j)			
			end
		end
	end		
	--_G.ClearAutoLoadTables()

	--purge_garbage()
	local t3 = GetSystemTime()
	
	local old_world = self:GetWorld()
	-- set the world object
	local world = GameObjectManager:Construct('MAP0') 
	self:SetWorld(world)
	self.world = world
	self.world.state = _G.STATE_IDLE
	local t4 = GetSystemTime()

	assert(world, "no world")
	local view = GameObjectViewManager:Construct('Map', "MAP1")
	world:SetView(view)
	self.view = view
	self:SetWorld(world)
	if old_world ~= nil then
		-- remove hero from old_world otherwise it will also try and destroy it too
		if _G.Hero ~= nil then
			old_world:RemoveChild(_G.Hero)
		end
		--LOG("Old world Destroyed")
		GameObjectManager:Destroy(old_world)
	end

	local t5 = GetSystemTime()

	LOG("Constructing Gates " .. (t2-t1)/1000 )
	LOG("Loading Stars " .. (t3-t2)/1000 )
	LOG("Constructing World " .. (t4-t3)/1000)
	LOG("destroying old world " .. (t5-t4)/1000)
	LOG("Total " .. (t5-t1)/1000)
	
	self.scale = self.view:GetScale()
	self.width = self.view:GetExtentsX()
	self.height = self.view:GetExtentsY()	
		
	self.screen_width = GetScreenWidth()
	self.screen_height = _G.SCREENHEIGHT
	self.border = 50
	self.pad_left_offset = 0			
end



function MapMenu:GetPathValidation()
	-- Example validation for path finding
	local function IsGateValid(node)
		assert(node ~= nil, "node cannot be nil")
		--LOG("node: " .. ClassIDToString(node:GetClassID()) .. " x pos: " .. node:GetX() .. " y pos: " .. node:GetY())
		
		local classId = ClassIDToString(node:GetClassID())
		
		if classId == "Gate" then
			if node:HasAttribute("hacked") then
				local hacked = node:GetAttribute("hacked")
				
				if hacked == 0 then
					return false
				end
			end
		end
	
		return true
	end	
	
	return IsGateValid
end



function MapMenu:Open(gate)
	if self:IsOpen() then
		return cGameMenu.Open(self)
	end
			
	if gate then
		--setup info for initial movement to nearest star
		self.initGate = gate
		LOG("Set initGate ="..gate)
	end
	_G.Hero:SetMovementController(nil)
	
	return cGameMenu.Open(self)
end


function MapMenu:OnOpen()	

	add_text_file("StarText.xml")
	add_text_file("FactionText.xml")		

	_G.GLOBAL_FUNCTIONS.Backdrop.Close()
	self.hacked = {}
	for i=1, _G.Hero:NumAttributes("hacked_gates") do
		self.hacked[_G.Hero:GetAttributeAt("hacked_gates",i)]=true
	end
	
	
	self:CreateWorld()
	
	self.hacked = nil

	self:Load()
	
	--BEGIN_STRIP_DS
	local function setupCursor()
		if IsGamepadActive()then
			LOG("Created cursor")
			local gp_cursor = GameObjectManager:Construct("SSEL")
			--local pos = _G.Hero:GetPos()
			--gp_cursor:InitCursor(512 + offset.x, 2048 - (384 + offset.y))
			gp_cursor:InitCursor(_G.Hero:GetX(), _G.Hero:GetY(), true)
			--gp_cursor:InitCursor(self.curr_star:GetX(), self.curr_star:GetY(), true)
			self.gp_cursor = gp_cursor
			self:GetWorld():AddChild(gp_cursor)
		end
	end
	_G.NotDS(setupCursor)
	--END_STRIP_DS	
	
	self:InitUI()
	self:SetSystemPos()
	
	local chance = math.random(1,3)
	if _G.GLOBAL_FUNCTIONS.DemoMode() then
		chance = 1
	end
	PlaySound("music_map" .. chance)

	local test = self.initGate

	_G.Hero:SetAttribute("in_system",0)

	
	

	jigl.set_light_type(0,jigl.light_type.point)
	jigl.set_light_color(0,1.0,1.0,0.8,1)
	jigl.set_light_position(0,0,0,-1500) -- <-- note: position, not direction
	jigl.set_light_enabled(0,true)		
	

					
	_G.ShowTutorialFirstTime(9,_G.Hero)	
	self.last_click_time = 0
	return cGameMenu.OnOpen(self)
end

function MapMenu:OnAnimOpen()
	Graphics.FadeFromBlack()
	
	local world = self:GetWorld()
	
	if self.initGate then
		local star = _G.StarList[_G.Hero:GetAttribute("curr_system")]
		local star1 = _G.DATA.JumpGatesTable[self.initGate][1]
		local star2 = _G.DATA.JumpGatesTable[self.initGate][2]
		LOG(string.format("curr_star %s, star1 %s, star2 %s",star.classIDStr,star1,star2))
		
		local actionStar = nil
		if _G.StarList[star1] == star then
			actionStar = _G.StarList[star2]
		else
			actionStar = _G.StarList[star1]		
		end
		world:OnActionStar(actionStar)
		if self.gp_cursor then
			self.gp_cursor:InitCursor(actionStar:GetX(),actionStar:GetY(),true)
		end
	end	
	
	return Menu.MESSAGE_HANDLED	
end

function MapMenu:SetSystemPos()
	local curr_star = Hero:GetAttribute("curr_system")
    local world = self:GetWorld()
    local view = world:GetView()	
 	local map_width = view:GetExtentsX()
    local map_height = view:GetExtentsY()
	
	local star_centre = _G.StarList[curr_star]
	if self.initGate then
		local star1 = _G.DATA.JumpGatesTable[self.initGate][1]
		local star2 = _G.DATA.JumpGatesTable[self.initGate][2]
		
		if _G.StarList[star1] == star_centre then
			--world:OnActionStar(_G.StarList[star2])
			star_centre = _G.StarList[star2]
		else
			--world:OnActionStar(_G.StarList[star1])			
			star_centre = _G.StarList[star1]
		end
	end
	
	local x_pos = star_centre:GetAttribute("xpos") - MAX_WIDESCREEN / 2
	local y_pos = star_centre:GetAttribute("ypos") - SCREENHEIGHT / 2

	--LOG(string.format("%s %d %s %d %s %d", "x_pos:", x_pos, "y_pos:", y_pos, "map_height:", map_height))
	
	if x_pos < 0 then
		x_pos = 0
	elseif x_pos + MAX_WIDESCREEN > map_width then
		x_pos = map_width - MAX_WIDESCREEN
	end
	
	if y_pos < 0 then
		y_pos = 0
	elseif y_pos + SCREENHEIGHT > map_height - 10 then
		y_pos = map_height - 10 - SCREENHEIGHT
	end
	self:SetViewOffset(-x_pos, -y_pos)
	self:UpdateStarPosition(star_centre)
end

--Set up UI info
function MapMenu:InitUI()

	--self:set_text("str_name",Hero:GetAttribute("name"))	
	
end


--Set up UI info
function MapMenu:UpdateUI()
	LOG("UPDATING MAP UI")
	--self:set_text("str_name",Hero:GetAttribute("name"))	
	self.world:AddQuestOverlay()--restore any inadvertently removed overlays	
	
end

function MapMenu:RemoveQuestMarker(quest)
	self.world:RemoveQuestOverlay(quest)
end

----------------------------------------------------------------
-- Resizes Stars based on screen offset
-- Sets position of Hero -- cancels any current movement controller
--        TBD - shift screen scroll position to ensure curr_system is on screen.
-- 
--	Adds Hero to World
function MapMenu:Load()
	local world = self:GetWorld()
	--world:AddNodes()
	local offset = self:GetViewOffset()
	--world:ResizeStars(offset.y)
	--self:UpdateUI()
	
	local star = world.graph:GetNode(_G.Hero:GetCurrSystem())
	
	SCREENS.SystemInfoMenu:Open(star, "MapMenu")
		
	if _G.Hero:HasMovementController() then		
		
		_G.Hero:SetMovementController(nil)
		
	end
	_G.Hero:SetPos(star:GetAttribute("xpos"), star:GetAttribute("ypos"))	
	--LOG(string.format("%s %d, %d", "Load setpos", star:GetAttribute("xpos"), star:GetAttribute("ypos")))
	
	world.curr_star = star
	
	world:AddChild(_G.Hero)
	_G.Hero:SetCursorInteract(false)
	
end



function MapMenu:OnClose()
	self.cursor_snap = nil
	self:DestroyWorld()
	
	if _G.is_open("MiniMapMenu") then
		SCREENS.MiniMapMenu:Close()
	end	
	
	local function RemoveText()
		remove_text_file("StarText.xml")
	end
	_G.CallScreenSequencer("SystemInfoMenu", RemoveText)

	return cGameMenu.OnClose(self)
end

function MapMenu:DestroyWorld()
	local world = self:GetWorld()	
	world.curr_star = nil


	
	world:RemoveNodes()
		
	local num_children = world:GetNumChildren()
	--LOG(string.format("%s %d", "MapMenu number of children before:", num_children))
	
	
	world.graph = nil
	
	for i,s in pairs(_G.StarList) do
		local star = _G.StarList[i]
		GameObjectManager:Destroy(star)
		_G.StarList[i] = nil
		star = nil
	end

	--LOG(string.format("%s %d", "StarsDestroyed", gcinfo()))
	
	for i,s in pairs(_G.JumpGateList) do
		local gate = _G.JumpGateList[i]
		GameObjectManager:Destroy(gate)
		_G.JumpGateList[i] = nil
		gate = nil
	end	

	_G.StarList = nil
	_G.JumpGateList = nil

	
	LOG(tostring(gcinfo()))

	num_children = world:GetNumChildren()

	
	world:RemoveChild(_G.Hero)


	local view = world:GetView()
	view = nil
	world:SetView(nil)
	GameObjectManager:Destroy(world)
	self:SetWorld(nil) 			
	world = nil
	self.world = nil
	self.view = nil
	
	--purge_garbage()		
end

function MapMenu:OnButton(buttonId, clickX, clickY)
	--quit
	if (buttonId == 0) then
		self:Close()
	elseif buttonId == 75 and self:GetWorld().state == _G.STATE_IDLE then
		SCREENS.InventoryFrame:Open("MapMenu",7)
	elseif buttonId == 76 then
		-- open mini map
		SCREENS.MiniMapMenu:Open()
	end
	
	return cGameMenu.OnButton(self, buttonId, clickX, clickY)
end

function MapMenu:OpenSystem(alertEncounter)
	_G.Hero:SetAttribute("in_system",1)
--[[	
	if math.random(1,10) == 1 then
		local function continue()
			LOG("Unhacked a gate")
			local gateList = { }
			-- unhack a random gate in the system
			for i,v in pairs(_G.DATA.StarTable[_G.Hero:GetAttribute("curr_system")]) do
				if string.char(string.byte(v))=="J" then
					table.insert(gateList, v)
				end
			end
			
			local gateID = gateList[math.random(1, #gateList)]
			-- check this line for efficiency
			if not GATES[gateID].quest_hack then
				_G.Hero:EraseAttribute("hacked_gates", gateList[math.random(1, #gateList)])
			end
			--open_message_menu("Gate Failure", "One of the gates in this system has gone offline", nil)
			--_G.CallScreenSequencer("MapMenu", "SolarSystemMenu",alertEncounter, -1, false, true)
		
			_G.CallScreenSequencer("MapMenu", "SolarSystemMenu",alertEncounter, -1, false, true)
		end
		_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, continue)			
		
	else
		--_G.CallScreenSequencer("MapMenu", "SolarSystemMenu",alertEncounter, -1, false)
		
		local function continue()
			_G.CallScreenSequencer("MapMenu", "SolarSystemMenu",alertEncounter, -1, false)
		end
]]--

	local function continue()
		--Graphics.FadeToBlack()
		local function transition()	
			_G.CallScreenSequencer("MapMenu", "SolarSystemMenu",alertEncounter, -1, false)
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu")				
	end
	self:GetWorld().state = _G.STATE_TRANSITION
	_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, continue)
end

function MapMenu:OnTimer(time)

	if not Sound.IsMusicPlaying() then
		local chance = math.random(1,3)
		PlaySound("music_map" .. chance)
	end	

	return cGameMenu.OnTimer(self, time)
end


local function quit_confirm(confirmed)
	if confirmed then
		--_G.DONT_SAVE = false			
		Sound.StopMusic();
		_G.GLOBAL_FUNCTIONS.Backdrop.Open()
		
		local function QuitMapCallback()
			Sound.StopMusic();
			_G.CallScreenSequencer("MapMenu", "SinglePlayerMenu")
		end
		_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, QuitMapCallback)		
	end
end


function MapMenu:OnKey(key)
	if key == self.exit_key and self:GetWorld().state == _G.STATE_IDLE then
		local saveString
		if _G.Hero.auto_save and not _G.GLOBAL_FUNCTIONS.DemoMode() and IsUserSignedIn(PlayerToUser(1))  then
			saveString = translate_text("[WILL_SAVE]")
		else
			saveString = translate_text("[WONT_SAVE]")
		end
		--open_yesno_menu("[QUIT]", string.format("%s %s", translate_text("[QUITSTARMAP]"), saveString), quit_confirm, "[YES]" , "[NO]")
		_G.GLOBAL_FUNCTIONS.Pause.Open("MapMenu","[QUIT]", string.format("%s %s", translate_text("[QUITSTARMAP]"), saveString), quit_confirm, "[YES]" , "[NO]")
	elseif key == self.load_key then
		
	elseif key == self.hack_key then
		_G.Hero:ClearAttributeCollection("hacked_gates")
		for i,v in pairs(_G.DATA.JumpGatesTable) do
			_G.Hero:PushAttribute("hacked_gates",i)
		end	
	
   elseif key == self.log_key then -- only DS had a log_key
		--self:OnButton(75,0,0)
		if self:GetWorld().state == _G.STATE_IDLE  then
			local function transition()
      			_G.CallScreenSequencer("MapMenu", "InventoryFrame", "MapMenu", 7)
			end
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "InventoryFrame")		
		end

   end
	
	return cGameMenu.OnKey(self, key)
end

function MapMenu:OnGamepadDPad(user, dpad, x, y)
	--LOG(string.format("%s %d %s %d %s %d", "x_dir =", x, "y_dir =", y, "user =", user))
	LOG(string.format("OnGamepadDPad x=%d, y=%d",x,y))
	if x==0 and y==0 then
		if self.cursor_snap then
			self.cursor_snap.dpadx = nil
			self.cursor_snap.dpady = nil
		end
		self.gp_cursor:AccelerateCursor(0, 0)
		self.gp_cursor:SetMovementController(nil)
		return Menu.MESSAGE_HANDLED
	end
	self.gp_cursor:SetMovementController(nil)
	if self.world.state <= STATE_TARGET then

		self.gp_cursor:AccelerateCursor(x*8, y*8)
		--self:UpdateCursorPosition(false)	
		local time = GetGameTime() -- + _G.CURSOR_SNAP_DELAY	--Instant Response
		self.cursor_snap={time=time,obj=nil,x=nil,y=nil,dpadx=x,dpady=y}
		--[[
		if x == 0 then
			x = nil
		end
		if y == 0 then
			y = nil
		end
		if not self.cursor_snap then
			local time = GetGameTime() + _G.CURSOR_SNAP_DELAY	--Instant Response
			self.cursor_snap={time=time,obj=nil,dpadx=x,dpady=y}
		else
			local time = GetGameTime() + _G.CURSOR_SNAP_DELAY	--Instant Response
			self.cursor_snap.time=time
			self.cursor_snap.dpadx=x
			self.cursor_snap.dpady=y
			
			
		end
		self:SetCursorSnap()
		
		--]]
	end
	return Menu.MESSAGE_HANDLED	
end


function MapMenu:GetNearestStar(obj,dpadx,dpady)
	LOG("GetNearestStar")
	local x = obj:GetX()
	local y = obj:GetY()
	local nearestObj
	local minDistance = 3000
	
	for j,k in pairs(_G.StarList) do
		local obj = k
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
	LOG("return "..tostring(nearestObj.classIDStr))
	return nearestObj
	
end





dofile("Assets/Scripts/Screens/MapMenuPlatform.lua")

return ExportSingleInstance("MapMenu")
