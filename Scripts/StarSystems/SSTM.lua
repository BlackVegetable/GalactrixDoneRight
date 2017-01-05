-- StarSystem
--	this class defines the basic behaviour of the SolarSystemMenu screen
--	

use_safeglobals()



class "SSTM" (GameObject)


SSTM.AttributeDescriptions = AttributeDescriptionList()
SSTM.AttributeDescriptions:AddAttribute('int', 'ui_delay', {default=1500})
SSTM.AttributeDescriptions:AddAttribute('string', 'selected', {default=""})
--SSTM.AttributeDescriptions:AddAttribute('string',		'star',						{default="S000"} )
--SSTM.AttributeDescriptions:AddAttribute('string',		'battle',						{default=""} )
--SSTM.AttributeDescriptions:AddAttribute('string',		'sprite',						{default="ZSU1"} )


local GRID_WIDTH = 8

function SSTM:__init()
	super("SSTM")
	self:InitAttributes()

	self.roman_numerals={[1]="I",[2]="II",[3]="III",[4]="III",[5]="III"}
	
	
	self.mouse_x = _G.Hero:GetX()
	self.mouse_y = _G.Hero:GetY()

	self.mouseX = self.mouse_x
	self.mouseY = self.mouse_y
	
	self.encounters={}
	--self.StartMovement()

	
--	self:SetAttribute("max_encounters", 1)
	
	
	local e = GameEventManager:Construct("UpdateUI");
	local nextTime = GetGameTime() + self:GetAttribute("ui_delay")
	GameEventManager:SendDelayed( e, _G.Hero, nextTime );	
end

local NUM_ENCOUNTERS = 2

function SSTM:InitSystem(alert)
	local SSTMInit = import "SSTMInit"
	SSTMInit.InitSystem(self,alert)
	SSTMInit = nil
	purge_garbage()
end



function SSTM:DisappearEncounter(encounter)
	LOG("'Disappearing' Encounter")
	--BEGIN_STRIP_DS
	local function RemoveFromList()
		for i,v in pairs(self.encounters) do
			if v == encounter then
				table.remove(self.encounters, i)
				break
			end
		end
	end
	_G.NotDS(RemoveFromList)
	--END_STRIP_DS
	local function RemoveDSEncounter()
		SCREENS.SolarSystemMenu.encounter = nil
		SCREENS.SolarSystemMenu.encounter_friendly = nil		
		SCREENS.SolarSystemMenu.encounter_targeting = nil
	end
	_G.DSOnly(RemoveDSEncounter)
	
	if _G.Hero:GetAttribute("curr_loc_obj") == self.current_satellite then
		SCREENS.SolarSystemMenu:GetWorld():DeselectSatellite()
	end
	
	_G.Hero.num_encounters = _G.Hero.num_encounters - 1
	
	local enemy = encounter.enemy	
	encounter.enemy = nil
	self:RemoveChild(enemy)
	GameObjectManager:Destroy(enemy)
	
end

function SSTM:SetHeroDestination(x, y)
	if not self.current_satellite then
		y = _G.SCREENHEIGHT - y
	
		self.mouse_x = x
		self.mouse_y = y
	else
		LOG("current_satellite set")
		self.mouse_x = self.current_satellite:GetX()
		self.mouse_y = self.current_satellite:GetY()
		--LOG("Set dest "..self.current_satellite.classIDStr.." x="..tostring(self.mouse_x).." y="..tostring(self.mouse_y))
	end
end

function SSTM:MoveShips(moveEncounters)
	--if self.mouseX and self.mouseY then
	
		if SCREENS.SolarSystemMenu.state <= _G.STATE_TARGET then-- OR STATE_FLIGHT
			self:SetHeroDestination(self.mouseX, self.mouseY)	
						
			local target = false
			
			if self.current_satellite and self.current_satellite:HasAttribute("ai") then
				target = true
				--[[
				if SCREENS.LocationHighlight:IsOpen() then
					SCREENS.LocationHighlight:Move(self.current_satellite:GetX()+(GetScreenWidth()-_G.MAX_WIDESCREEN)/2, SCREENHEIGHT-self.current_satellite:GetY())
				end
				
				--]]
			end
	
			--LOG("Pre Hero MoveShip state="..tostring(SCREENS.SolarSystemMenu.state))
			_G.Hero:MoveShip(self.mouse_x, self.mouse_y, target)
	
			local heroX = _G.Hero:GetX()
			local heroY = _G.Hero:GetY()
	
			if moveEncounters then
				for i,e in pairs(self.encounters) do
					e:MoveEncounter(_G.Hero,not SCREENS.SolarSystemMenu.allow_enemy_encounters)
				end
			end
		else
			_G.Hero:SetMovementController(nil)
			for i,e in pairs(self.encounters) do
				e.enemy:SetMovementController(nil)
			end
		end
	--end
end

--Now only starts the Unhack animation, then sends to hero.
--
function SSTM:OnEventUnhackGate(event)
	LOG("SSTM:UnhackGate ")
	
	if SCREENS.SolarSystemMenu.state <= _G.STATE_TARGET then
		local gateID = event:GetAttribute("gateID")
		local gate = _G.JumpGateList[gateID]		
		if gateID and gate and gate:GetAttribute("hacked")==1 then
			local view = gate:GetView()
			view:StartAnimation("unhack")
			gate.unhacking = true
			GameEventManager:SendDelayed(event,_G.Hero,GetGameTime()+math.random(3000,6000))
		else
			LOG("Something is fucked")
		end
	else
		LOG("menu state = "..tostring(SCREENS.SolarSystemMenu.state))
		GameEventManager:SendDelayed(event,self,GetGameTime()+math.random(2000,10000))
	end
	
	
end



--function SSTM:OnEventTick(event)
	--assert(false, "send event to receivers that are registered")
--end

--function SSTM:OnEventDraw(event)
	--assert(false, "send event to receivers that are registered")
--end






function SSTM:OnEventCursorAction(event)
	local obj	= event:GetAttribute("object")
	local x		= event:GetAttribute("x")
	local y		= event:GetAttribute("y")
	
	LOG("OnEventCursorAction: up="..tostring(event:GetAttribute("up")))
	if event:GetAttribute("up") or SCREENS.SolarSystemMenu.state >= _G.STATE_ENCOUNTER then
		return
	end
	
	
	
	--If Popup Menu is open, AND clicking on the same game object used to open it in the first place
	if _G.is_open("PopupMenu") and SCREENS.PopupMenu.satellite == obj then
		return
	end
	
	
	
	
 	self.mouse_x = x
	self.mouse_y = y
	
	local target = false
	
	--[[
	if self.current_satellite and self.current_satellite:HasAttribute("ai") then
		LOG("current_satellite is ai")
		target = true
		if SCREENS.LocationHighlight:IsOpen() then
			SCREENS.LocationHighlight:Move(self.current_satellite:GetX(), SCREENHEIGHT-self.current_satellite:GetY())
		end
	end		
	--]]
	
	if obj and obj ~= self then

		local name = obj.classIDStr
		if not name then
			return
		end
	
		LOG("OnEventCursorAction "..tostring(name))
		self:SetAttribute("selected",name)
		-- Check connected set
		
		local star = _G.Hero:GetAttribute("curr_system")
		
		LOG("oncursor action "..name)
		
		local satellite = obj
		if obj:HasAttribute("sat_xpos") then--satellite attribute
			satellite = self.SatelliteList[name]
			self.mouse_x = satellite:GetX()
			self.mouse_y = satellite:GetY()
		end
		
		self:SelectSatellite(satellite)		
		
		
		if _G.WAIT_FOR_ARRIVAL == 0 then			
			self:ArrivedAtPlanet()
		end	
	else
		self:DeselectSatellite()
		if _G.is_open("LocationHighlight") then		
			SCREENS.LocationHighlight:CloseMe()
		end
	end
	
	if not SCREENS.SolarSystemMenu.encounter_targeting then
		_G.Hero:MoveShip(self.mouse_x, self.mouse_y, false)
	end  				
	
	--
	SCREENS.PopupMenu:Close()
	
end



--Send delayed event to display PopUp
--Only sent if in state STATE_FLIGHT
--[[
function SSTM:OnEventCursorEntered(event)
	
	local obj	= event:GetAttribute("object")
	local x		= event:GetAttribute("x")
	local y		= event:GetAttribute("y")
	
	if not obj or SCREENS.SolarSystemMenu.state ~= _G.STATE_FLIGHT then
		return
	end
	
		
	if obj:HasAttribute("sat_xpos") then--satellite
		self.popup_item = obj
		local event = GameEventManager:Construct("OpenPopup")
		event:SetAttribute("object",obj)
		event:SetAttribute("x",x)
		event:SetAttribute("y",y)
		GameEventManager:SendDelayed(event,self,GetGameTime()+1500)	--1.5 seconds delay
	elseif false and obj:HasAttribute("ai") then
	-- popup info about encounters? cargo etc.
	end
end
--]]

--[[
function SSTM:OnEventCursorExited(event)
	local obj	= event:GetAttribute("object")
	local x		= event:GetAttribute("x")
	local y		= event:GetAttribute("y")
	
	if self.popup_item then
		if obj == self.popup_item then
			self.popup_item = nil
			close_custompopup_menu()
		end
	end
	
end
--]]

--[[
function SSTM:OnEventOpenPopup(event)
	local obj	= event:GetAttribute("object")
	local x		= event:GetAttribute("x")
	local y		= event:GetAttribute("y")
	
	if SCREENS.SolarSystemMenu.state ~= _G.STATE_FLIGHT then
		close_custompopup_menu()
		return
	end
	
	if obj and obj == self.popup_item then
		local edge = 0
		if _G.GetScreenWidth() > 1024 then
			edge = (_G.GetScreenWidth() - 1024)/2
		end
		
		x = obj:GetX()+60
		y = 768 - obj:GetY()
		
		LOG(tostring(self.mouseX)..", "..tostring(self.mouseY))	
			
		
		open_custompopup_menu( "//TITLE/1/font_system//TEXT//8/35/font_info_white//HELP/8/60/font_info_gray//BACKGROUND/img_black//BORDER/0/121/192/255//",
			string.format("//%s//%s %s//%s//",translate_text(string.format("[%s_NAME]",obj.classIDStr)),translate_text("[TYPE_]"),translate_text(obj:GetAttribute("type")),obj:GetAttribute("description")),
			x-edge,y,0,200)		

		
	end	
	purge_garbage()
end
--]]

function SSTM:ArrivedAtPlanet(hero)
	LOG("ArrivedAtPlanet")
	if self.current_satellite and not SCREENS.SolarSystemMenu.encounter_targeting then
		LOG("current_satellite " .. self.current_satellite.classIDStr)
		--self:StopMovement()	
		
		local function StopMovement()
			self.mouseX = _G.Hero:GetX()
			self.mouseY = _G.SCREENHEIGHT - _G.Hero:GetY()
			_G.Hero:SetMovementController(nil)
		end
		
		_G.DSOnly(StopMovement)		
		
		self.current_satellite:HeroArrived()
		SCREENS.LocationHighlight:CloseMe()
	end
end

function SSTM:SelectSatellite(satellite)
	if SCREENS.SolarSystemMenu.state <= _G.STATE_TARGET then
		SCREENS.SolarSystemMenu.state=_G.STATE_TARGET
	end
	
	if self.current_satellite ~= satellite then
		LOG("Satellite Selected "..satellite.classIDStr)
		self:DeselectSatellite()
	
		local view = GameObjectViewManager:Construct("Sprite", "ZTGT")
		view:StartAnimation("stand")
		--self.satellite = satellite
		
		satellite:AddOverlay("crosshair_anim", view, 0, 0)	
		
		local function ShowTarget()
			if satellite:HasAttribute("ai") then				
				local view = GameObjectViewManager:Construct("Sprite", "ZQBQ")
				view:StartAnimation("stand")
				satellite:AddOverlay("target", view, 0, 0)	
			end
		end
		_G.DSOnly(ShowTarget)		
		
		if _G.is_open("LocationHighlight") then
			SCREENS.LocationHighlight:SetCenterPoint(satellite)
		else
			SCREENS.LocationHighlight:Open(satellite)
			SCREENS.LocationHighlight:SetCenterPoint(satellite)
		end
		
		
		
		self.current_satellite = satellite
		if not self.current_satellite.unhacking then
			LOG("StartAnimation(highlight)")
			self.current_satellite:GetView():StartAnimation("highlight")
		end		
		
		
		PlaySound("snd_targetlock") -- Bort - this sound plays when clicked on a destination in solar system (smaller map) screen
		--self.current_satellite:ShowText()
		
		self.planet_open = 1
		--SCREENS.LocationHighlight:SetCenterPoint(satellite)
	end

end
	




function SSTM:DeselectSatellite()
	LOG("DeselectSat")
	if self.current_satellite and self.current_satellite:GetView() then
		if not self.current_satellite.unhacking then
			self.current_satellite:GetView():StartAnimation("stand")		
		end
		self.current_satellite:RemoveOverlay("crosshair_anim")
		self.current_satellite:RemoveOverlay("target")	
	end	
	self.current_satellite = nil
	self.planet_open = 0
end



return ExportClass("SSTM")
