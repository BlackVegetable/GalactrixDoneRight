local PI = math.pi

function Hero:MoveShip(destX, destY, chasing,encounter)
	local targetX = destX
	local targetY = destY
	local ship = self:GetAttribute("curr_ship")
	
	local view = self:GetView()
	
	if not view or not ship then
		return
	end

	local posX = self:GetX()
	local posY = self:GetY()
	local varX = 0
	local varY = 0
	
	if encounter then
		varX = encounter.varianceX
		varY = encounter.varianceY
	end
	
	
	if not self:HasMovementController() then	 
		if SHIPS[ship.classIDStr].model then
			self.m = MovementManager:Construct("StarmapSpaceship")
			self.m:SetAttribute("BankLow",-80)-- -60
			self.m:SetAttribute("BankHigh",80)-- 70
		else
			self.m = MovementManager:Construct("Inertia")
		end
	end

	self.m:SetAttribute("MaxAcceleration", ship:GetAttribute("acceleration")+varX) --pc 80
	self.m:SetAttribute("MaxTurning", ship:GetAttribute("turn_speed")+varY) -- pc 80
	self.m:SetAttribute("MaxSpeed", ship:GetAttribute("max_speed")+varX) -- pc 300
	
	
	if chasing then
		local difX = targetX - posX
		local difY =  targetY - posY
		targetX = targetX + 10 * difX
		targetY = targetY + 10 * difY
	end
	
	--LOG(string.format("setTarget %d,%d",targetX,targetY))
	self.m:SetAttribute("EndX", targetX)
	self.m:SetAttribute("EndY", targetY)
	
	local curr_dir = self:GetView():GetDir()
	
	local particles = true
	if not self:HasMovementController() then
		particles = false
		self.m:SetAttribute("CurrentSpeed", 0)
		self.m:SetAttribute("CurrentDirection", curr_dir * 180 / PI)
		self:SetMovementController(self.m)
	end	
	
	--local sprite_angle = self.m:GetAttribute("CurrentDirection")  * PI / 180 - 3*PI/2
	--sprite_angle = 2*PI-sprite_angle		
	--self.view:SetDir(sprite_angle)
	--self.view:SetAutoDir(true)
	
	--LOG("current_speed " .. self.m:GetAttribute("CurrentSpeed"))
	--LOG("current_direction " .. self.m:GetAttribute("CurrentDirection"))
	
	
	if self.m then
		local ninety = PI/2
		local hero_angle = self.m:GetAttribute("CurrentDirection")*PI/180 - ninety
		hero_angle = -hero_angle
		if hero_angle > 2*PI then
			hero_angle = hero_angle - 2*PI
		elseif hero_angle < 0 then
			hero_angle = 2*PI + hero_angle
		end		
		
		local engine_angle = ninety + hero_angle
		if engine_angle > 2*PI then
			engine_angle = engine_angle - 2*PI
		elseif engine_angle < 0 then
			engine_angle = 2*PI + engine_angle
		end
		
		local model_offset = 0
				
		--local curr_x = self:GetX() - 1366/2
		--local curr_y = self:GetY() - 768/2
		if view and SHIPS[ship.classIDStr].model then--3D ship view only
			--model_offset = 10
			--self:Update3dView()
		end
		
		local engines_number = ship:GetAttribute("engines")
		local engine_1_x = 0
		local engine_1_y = 0
		local engine_2_x = 0
		local engine_2_y = 0
						
		local hero_sin = math.sin(hero_angle)
		local hero_cos = math.cos(hero_angle)
		if engines_number == 2 then
			engine_1_x = (7+ship.particle_offsets_2[1]) * math.sin(engine_angle)
			engine_1_y = (7+ship.particle_offsets_2[1]) * math.cos(engine_angle)
			--engine_2_x = -7 * math.sin(engine_angle)
			--engine_2_y = -7 * math.cos(engine_angle)		
		elseif engines_number == 3 then
			engine_1_x = (9 + ship.particle_offsets_2[1]) * math.sin(engine_angle)
			engine_1_y = (9 + ship.particle_offsets_2[1]) * math.cos(engine_angle)
			--engine_2_x = -9 * math.sin(engine_angle)
			--engine_2_y = -9 * math.cos(engine_angle)		
		end
		
		--LOG("hero_angle " .. hero_angle)
		--LOG("self.particle = "..tostring(self.particle))
		local ship1 = "Ship_"..tostring(self.particle)
		local ship2 = "Ship2_"..tostring(self.particle)
		
		local particle_offset = 20 + ship.particle_offset
		
		
		if particles then
			if engines_number == 1 then
				AttachParticles(self, ship1, (-particle_offset) * hero_sin, (-particle_offset) * hero_cos)
				--AttachParticles(self, ship2, (-particle_offset - model_offset) * hero_sin, (-particle_offset - model_offset) * hero_cos)
			elseif engines_number == 2 then
				AttachParticles(self, ship1, -particle_offset * hero_sin + engine_1_x, -particle_offset * hero_cos + engine_1_y)
				AttachParticles(self, ship1, -particle_offset * hero_sin - engine_1_x, -particle_offset * hero_cos - engine_1_y)--  -
				--AttachParticles(self, ship2, -26 * hero_sin + engine_1_x, -25 * hero_cos + engine_1_y)
				--AttachParticles(self, ship2, -26 * hero_sin - engine_1_x, -25 * hero_cos - engine_1_y)--  -			
			elseif engines_number == 3 then
				AttachParticles(self, ship1, (-particle_offset - ship.particle_offsets_2[2]) * hero_sin + engine_1_x, (-particle_offset - ship.particle_offsets_2[2]) * hero_cos + engine_1_y)
				AttachParticles(self, ship1, (-particle_offset - ship.particle_offsets_2[2]) * hero_sin - engine_1_x, (-particle_offset - ship.particle_offsets_2[2]) * hero_cos - engine_1_y)--  -
				AttachParticles(self, ship1, -particle_offset * hero_sin, -particle_offset * math.cos(hero_angle))		
				--AttachParticles(self, ship2, -25 * hero_sin + engine_1_x, -20 * hero_cos + engine_1_y)
				--AttachParticles(self, ship2, -25 * hero_sin - engine_1_x, -20 * hero_cos - engine_1_y)--  -
				--AttachParticles(self, ship2, -25 * hero_sin, -20 * math.cos(hero_angle))				
			elseif engines_number == 4 then
				--Lumina Archive Ship
			end
			self.time_delta = 0
		end
		
		
		
		
		
	end	
end

--Currently only used by MapMenu
function Hero:Update3dView(x,y,bank)
	
	local ship = self:GetAttribute("curr_ship")
	local view = self:GetView()	
	if not SHIPS[ship.classIDStr].model or not view then
		return
	end
	local ninety = PI/2
	local hero_angle = -view:GetDir()+ninety
	--CastToModel3DView(view):SetRotation(-1.57079632,0.0,0.0) -- 4.71238898
	--CastToModel3DView(view):SetRotation(-hero_angle-1.57079632,4.71238898,1.57079632)
	--CastToModel3DView(view):SetRotation(0.0,3.141592,hero_angle)--
	--CastToModel3DView(view):SetRotation(0.0,banking,0.0)--
	--CastToModel3DView(view):SetRotation(0.0,0,-hero_angle)--
	--x = math.sin(banking)
	--y = math.cos(banking)
	--LOG("banking x="..tostring(x).." y="..tostring(y))
	if not bank then
		CastToModel3DView(view):SetPosition(x, y, 0.0)
		CastToModel3DView(view):SetRotation(0.0,0.0,-hero_angle)--
	end
	--CastToModel3DView(view):Rotate(0.0,PI,0.0)
	
end

function Hero:UpdatePlayerShield(player_id,newShield,shieldMax)
	local shields_remaining = newShield/shieldMax*10;
	--local player_id = self:GetAttribute("player_id")
	_G.SCREENS.GameMenu:set_text_raw(string.format("str_shield_%d",player_id),tostring(newShield))
	local shieldStr = string.format("icon_shield_%d_",player_id)
	for j=10, shields_remaining +1 ,-1 do
		_G.SCREENS.GameMenu:set_alpha(string.format("%s%d",shieldStr,j), 0)
	end
	
	for j=1,shields_remaining,1 do
		_G.SCREENS.GameMenu:set_alpha(string.format("%s%d",shieldStr,j), 1)
	end	
end	

