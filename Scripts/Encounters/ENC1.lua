-- ENC1
--  base class for all ENC1s

use_safeglobals()






class "ENC1" (GameObject)

ENC1.AttributeDescriptions = AttributeDescriptionList()
ENC1.AttributeDescriptions:AddAttribute('int', 'patrolling', {default=0})--1/0
ENC1.AttributeDescriptions:AddAttribute('int', 'severity', {default=3})--1/2/3 3== less severe divide safe distance by severity
ENC1.AttributeDescriptions:AddAttribute('int', 'safe_distance', {default=0})--
ENC1.AttributeDescriptions:AddAttribute('int', 'neutral', {default=0}) -- if 1, this encounter ie forced to be neutral - otherwise hostile



function ENC1:__init()
    super("ENC1")
	self:InitAttributes()
	self.classIDStr = "ENC1"
	
	self.docked = false
	self.encounter_dist = 25
	self.contraband_detected = false
	
	self.orbit = math.random(10,30)
	self.varianceX = math.random(-20,20)
	self.varianceY = math.random(-20,20)
	
	if math.random(1,2)==1 then
		self.orbit = -self.orbit-- = -30 <> -10 or 10 <> 30
	end
	
	
	
	self:InitCoords()
 	
	
end



function ENC1:SetEnemy(enemyCode,sprite)
	self.enemy = _G.GLOBAL_FUNCTIONS.LoadHero.LoadEnemy(enemyCode)
	local sstm = SCREENS.SolarSystemMenu:GetWorld()
	self.enemy.sorting_value = #sstm.encounters+1
	self.enemy:SetSystemView(sprite)
	
	self.enemy:AddChild(self)--encounter object is child to enemy object

	
	self.enemy.encounter = self
end



--Determine target object/position
function ENC1:InitMovement(hero)
	LOG("InitMovement")
	
	--LOG(string.format("x=%d,y=%d",self.enemy:GetX(),self.enemy:GetY()))
	if self.targetObj and SCREENS.SolarSystemMenu.allow_enemy_encounters then
		LOG("targetObj")
		self.targetX = self.targetObj:GetX()+self.varianceX
		self.targetY = self.targetObj:GetY()+self.varianceY
	elseif self:GetAttribute("patrolling")==1 then-- get random spot in system
		LOG("patrolling")
		self.patrolNum = self.patrolNum + 1
		if self.patrolNum > #self.patrol then
			self.patrolNum = 1
		end
		self.targetX = self.patrol[self.patrolNum].x
		self.targetY = self.patrol[self.patrolNum].y
	else
		
		self.docked = false		
		local satellite = math.random(1,#_G.DATA.StarTable[hero:GetAttribute("curr_system")])
		satellite = _G.DATA.StarTable[hero:GetAttribute("curr_system")][satellite]
		LOG("New Satellite "..satellite)
		satellite = SCREENS.SolarSystemMenu:GetWorld().SatelliteList[satellite]
		self.targetX = satellite:GetX() + self.orbit
		self.targetY = satellite:GetY() + self.orbit
	end

	LOG("targetX="..tostring(self.targetX))
	LOG("targetY="..tostring(self.targetY))
end



function ENC1:MoveEncounter(hero, neverTarget)
	
	if self.targetObj and not neverTarget then
		self.targetX = self.targetObj:GetX()
		self.targetY = self.targetObj:GetY()
	end

	self.enemy:MoveShip(self.targetX, self.targetY, self.targetObj,self)
	
		
	if not self.docked and SCREENS.SolarSystemMenu.state < _G.STATE_ENCOUNTER then
		self:CheckEncounter(hero, neverTarget)
	end
	
	
end






--Checks whether near to destination x/y
--if targetting Hero - launches encounter.
function ENC1:CheckEncounter(hero, neverTarget)
	local enemyX = self.enemy:GetX()
	local enemyY = self.enemy:GetY()	
	
	-- check to see if the ships are within range of each other
	local heroDistX,heroDistY
	
	local targetDistance = COLLISION_DISTANCE
	if not self.targetObj and self:GetAttribute("patrolling")==1 then
		targetDistance = targetDistance + targetDistance--2 times original target distance.
	end
	
	if not self.targetObj and not neverTarget then--do not get alerted to hero 
		heroDistX = hero:GetX()
		heroDistY = hero:GetY()
		if heroDistX > enemyX then
			heroDistX = heroDistX - enemyX
		else 
			heroDistX = enemyX - heroDistX
		end
		if heroDistY > enemyY then
			heroDistY = heroDistY - enemyY
		else 
			heroDistY = enemyY - heroDistY
		end
		
		local contraband = hero:GetAttributeAt("cargo",_G.CARGO_CONTRABAND)
		local standing = hero:GetFactionStanding(self.enemy:GetAttribute("faction"))

		if heroDistX < self:GetAttribute("safe_distance") and heroDistY < self:GetAttribute("safe_distance")  then		
			if contraband > 0 and self:GetAttribute("patrolling")==1 then
				--policing encounter in non-enemy systems
				self:AlertToHero(hero,contraband)
			elseif standing < _G.STANDING_NEUTRAL then
				--LOG("faction "..tostring(self.enemy:GetAttribute("faction")))
				--LOG("less than neutral alert "..tostring(standing))
				self:AlertToHero(hero)
			end
			
		end
	end
	

	local distX= math.abs(self.targetX - enemyX)
	local distY= math.abs(self.targetY - enemyY)	
	
	if distX < targetDistance and distY < targetDistance then
		if self.targetObj and not neverTarget then--targetting hero		
			LOG(tostring(self.enemy.classIDStr).." CLose to "..tostring(self.targetObj.classIDStr))

			_G.Hero:SetAttribute("curr_loc",self.classIDStr) 
			_G.Hero:SetAttribute("curr_loc_obj",self) 
			
			SCREENS.SolarSystemMenu.state = _G.STATE_ENCOUNTER				
			_G.GLOBAL_FUNCTIONS.EncounterBattle("SolarSystemMenu",self,_G.Hero,self.enemy)
		else
			--LOG("Arrived at dest - set new dest")
			local e
			if self:GetAttribute("patrolling")== 0 then
				self.docked = true
				self.enemy:SetCursorInteract(false)
				
				local delay = math.random(8000,20000)
				e = GameEventManager:Construct("SetNewDest")
				e:SetAttribute("heroObj",hero)			
				GameEventManager:SendDelayed(e,self,GetGameTime()+delay)	
			else
				self:OnEventSetNewDest(e,hero)
			end
			
		end
	end	
	
end


function ENC1:AlertToHero(hero, contraband)
	LOG("AlertToHero")
	if _G.Hero:GetAttribute("psi_powers") < 7 and self:GetAttribute("neutral") ~= 1 then
		if contraband then
			PlaySound("snd_alarm")
			self.enemy:SetSystemView(_G.DATA.Standings[_G.STANDING_SUSPECT].sprite)
			_G.EncounterMessage(self,"[CONTRA_DETECT]",self.enemy:GetX(),self.enemy:GetY())			
			self.contraband_detected = true
		--elseif self.targetObj ~= hero then--This may be good for NotDS??
			--_G.EncounterMessage(self,"[ENCOUNTER]",self.enemy:GetX(),self.enemy:GetY(),true,15)			
		end
		if self.targetObj ~= hero then
			Gamepad.Rumble(PlayerToUser(1), 0.5, 450)
		end
		self.targetObj = hero
	end
end


function ENC1:OnEventSetNewDest(event,hero)
	LOG("OnEventSetNewDest")
	if _G.is_open("SolarSystemMenu") then
		if not hero then
			hero = event:GetAttribute("heroObj")
		end
		self:InitMovement(hero)
		if self.enemy then
			self.enemy:SetCursorInteract(true)
		end
	end
	
end


function ENC1:InitCoords()
	--BEGIN_STRIP_DS
	local function InitCoords()
		self.patrol = {{x=math.max(50,_G.MIN_HORIZONTAL),y=50},
						{x=math.min(1200,_G.MAX_HORIZONTAL),y=50},
						{x=math.min(1200,_G.MAX_HORIZONTAL),y=700},
						{x=math.max(50,_G.MIN_HORIZONTAL),y=700},
						{x=math.min(1200,_G.MAX_HORIZONTAL),y=50},
						{x=750,y=400},
						{x=math.min(1200,_G.MAX_HORIZONTAL),y=700},
						{x=500,y=600},
						{x=750,y=150},
						{x=math.max(200,_G.MIN_HORIZONTAL),y=400}}	
					   
		self.patrolNum = math.random(1,#self.patrol)
	end
	
	_G.NotDS(InitCoords)
	--END_STRIP_DS
	
	local function InitCoordsDS()	
		self.patrol = {{x=15,y=10},
						   {x=230,y=62},
						   {x=230,y=150},
						   {x=30,y=130},
						   {x=230,y=55},
						   {x=200,y=95},
						   {x=230,y=142},
						   {x=100,y=140},
						   {x=200,y=50},
						   {x=40,y=95}}	
					   
		self.patrolNum = math.random(1,#self.patrol)			
		
	end
	_G.DSOnly(InitCoordsDS)
end





return ExportClass("ENC1")
