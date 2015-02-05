function MapMenu:PlatformVars()
	self.exit_key = Keys.SK_ESCAPE
	self.save_key = Keys.SK_F1
	self.load_key = Keys.SK_F2
	self.hack_key = Keys.SK_F9
	self.halo_alpha = 0.33
	
	self.map_offset_y = 0
end

--Used for 3D view correction
function MapMenu:GetHeroMapOffset(hero)

	local curr_x = hero:GetX()
	local curr_y = hero:GetY()		
	--local offset = self:GetViewOffset()	
	--local map_width = 0
	--if _G.SCREEN_WIDTH ~= 1024 then
	--	map_width = (_G.SCREEN_WIDTH-1024)/2
	--end
	local map_width = 1024
	if map_width ~= _G.SCREEN_WIDTH then
		map_width = 1366
	end

	
	--return curr_x + offset.x - map_width/2, curr_y + offset.y - _G.SCREEN_HEIGHT/2	
	--return curr_x + offset.x, curr_y + offset.y
	return curr_x, curr_y
	
end



--[[
function MapMenu:OnMouseLeftButton(id, x, y, up)
	if id == 10 and up then
        local coords = self:ConvertScreenCoordsToWorldCoords(x, y)

    end

    return cGameMenu.OnMouseLeftButton(self, id, x, y, up)
end
--]]

function MapMenu:OnMouseLeftButton(id, x, y, up)
	if id == 10 and up then
        local coords = self:ConvertScreenCoordsToWorldCoords(x, y)

		self.clicked = false
		self.horizontal_scroll_rate = 0
		self.vertical_scroll_rate = 0		
	elseif id == 10 then
		self.original_offset = self:GetViewOffset()
		self.original_x = x
		self.original_y = y
		self.clicked = true
		
		self.horizontal_scroll_rate = 0
		self.vertical_scroll_rate = 0
    end

    return cGameMenu.OnMouseLeftButton(self, id, x, y, up)
end

function MapMenu:OnMouseMove(id, x, y, up)
    local world = self:GetWorld()
    local view = world:GetView()
    local scale = view:GetScale()
    local width = view:GetExtentsX()
    local height = view:GetExtentsY()		
	
    x = x or 0
    y = y or 0

    local screen_width = GetScreenWidth()
    local screen_height = _G.SCREENHEIGHT
    local border = 50
	local pad_left_offset = 0
	
	if screen_width > 1024 then -- 1024 is the default virtual resolutions width (4x3 aspect ratio)
		border = 80
		
		if screen_width < 1366 then -- 1366 is the virtual resolutions width when in 16x9 aspect ratio
			pad_left_offset = (1366 - screen_width) / 2
		end
	end
	
    if id == 10 then -- MapMenuPlatformWorldPad
		if self.clicked then	
			local new_x = self.original_offset.x+x-self.original_x
			local new_y = self.original_offset.y+self.original_y-y
	
			if new_x*-1+screen_width > width then
				new_x = width*-1+screen_width
			end
			
			if new_y*-1+screen_height > height then
				new_y = height*-1+screen_height
			end
			
			if new_x > 0 then
				new_x = 0
			end
			
			if new_y > 0 then
				new_y = 0
			end		
			
			self:SetViewOffset(new_x, new_y)
	
		else
	        local world = self:GetWorld()
	
	        -- Vertical Movement
	        if y < border then
	            -- up
	            self.vertical = -1
	        elseif (screen_height - border) < y then
	            -- down
	            self.vertical = 1
	        else
	            self.vertical = 0
	        end
	
	        -- Horizontal Movement
	        if x < (border + pad_left_offset) then
	            -- left (world map scrolls right)
				--assert(false, "left side" .. x)
	            self.horizontal = 1
	        elseif (screen_width - (border + pad_left_offset)) < x then
	            -- right (world map scrolls left)
	            --assert(false, "right side" .. x)
				self.horizontal = -1
	        else
	        	--assert(false, "neither width:" .. width .. ", x:" .. x)
	            self.horizontal = 0
	        end
		end
    end

    return cGameMenu.OnMouseMove(self, id, x, y, up)
end


function MapMenu:UpdateStarPosition(star)
	local world = self:GetWorld()
	
	world:UnHighlightPath(world.path)
	world.path = GetPath(world.graph, world.curr_star, world.dest_star, self:GetPathValidation())
	world:HighlightPath(world.path)	
	
	_G.GLOBAL_FUNCTIONS.DisplaySystemInfo(star,SCREENS.SystemInfoMenu)		
end

function MapMenu:ChangeSystemInfo(star, menu)
	_G.GLOBAL_FUNCTIONS.DisplaySystemInfo(star,menu)
end


function MapMenu:OnDraw(time)

	if not self.clicked then
	    local time_delta = time - self.last_time
		
		local vertical_scroll = 0
		local horizontal_scroll = 0
		
	    if self.vertical ~= 0 then
	    	if self.vertical_direction ~= 0 and self.vertical ~= 0 and self.vertical_direction ~= self.vertical then
	    		self.vertical_scroll_rate = -self.vertical_scroll_rate
	    	end
	    	self.vertical_direction = 0
	
	    	if self.vertical_scroll_rate <= 490 then
	    		self.vertical_scroll_rate = self.vertical_scroll_rate + 10
	    	end
	        vertical_scroll = self.vertical*self.vertical_scroll_rate*time_delta/1000
	    end
		
	    if self.horizontal ~= 0 then
	    	if self.horizontal_direction ~= 0 and self.horizontal ~= 0 and self.horizontal_direction ~= self.horizontal then
	    		self.horizontal_scroll_rate = -self.horizontal_scroll_rate
	    	end
	    	self.horizontal_direction = 0
	
	    	if self.horizontal_scroll_rate <= 490 then
	    		self.horizontal_scroll_rate = self.horizontal_scroll_rate + 10
	    	end
	        horizontal_scroll = self.horizontal*self.horizontal_scroll_rate*time_delta/1000        
	    end	
		
		
		if self.last_vertical ~= 0 and self.vertical == 0 then
			self.vertical_scroll_rate = self.vertical_scroll_rate - 10
			self.vertical_direction = self.last_vertical
		end
		
		if self.last_horizontal ~= 0 and self.horizontal == 0 then
			self.horizontal_scroll_rate = self.horizontal_scroll_rate - 10
			self.horizontal_direction = self.last_horizontal
		end	
		
		if self.vertical_scroll_rate < 500 and self.vertical_direction ~=0 then
			vertical_scroll = self.vertical_direction*self.vertical_scroll_rate*time_delta/1000
			
			if self.vertical_scroll_rate >= 10 then
				self.vertical_scroll_rate = self.vertical_scroll_rate - 10
			end	
		end
		
		if self.horizontal_scroll_rate < 500 and self.horizontal_direction ~=0 then
			horizontal_scroll = self.horizontal_direction*self.horizontal_scroll_rate*time_delta/1000
			
			if self.horizontal_scroll_rate >= 10 then
				self.horizontal_scroll_rate = self.horizontal_scroll_rate - 10
			end	
		end	
		
		if vertical_scroll ~= 0 or horizontal_scroll ~= 0 then
			self:UpdateViewOffset(horizontal_scroll, vertical_scroll)
		end	
	
		self.last_time = time
		self.last_vertical = self.vertical
		self.last_horizontal = self.horizontal
	else
		self.horizontal_scroll_rate = 0
		self.vertical_scroll_rate = 0
	end
	local curr_x,curr_y = self:GetHeroMapOffset(_G.Hero)
	--LOG("OnDraw x="..tostring(curr_x + offset.x).." y="..tostring(curr_y + offset.y))
	--_G.Hero:Update3dView(curr_x + 1366/2,curr_y + 768/2)
	_G.Hero:Update3dView(curr_x,curr_y)
	if self.gp_cursor then
		self.gp_cursor:MoveCursor()
		local pos = { x = self.gp_cursor:GetX(), y = self.gp_cursor:GetY() }
		local offset = self:GetViewOffset()
		self:OnMouseMove(10,pos.x+offset.x,_G.SCREEN_HEIGHT - (pos.y+offset.y),true)--Sets ship target to cursor positiion
	end

	return cGameMenu.OnDraw(self, time)
end





function MapMenu:UpdateViewOffset(x, y)

    local screen_width = GetScreenWidth();
    local screen_height = _G.SCREENHEIGHT
    local offset = self:GetViewOffset()
    local world = self:GetWorld()
    local view = world:GetView()
    local scale = view:GetScale()
    local width = view:GetExtentsX()
    local height = view:GetExtentsY()

	local width_offset = 0

	if screen_width > 1024 and screen_width < 1366 then -- 1366 is the virtual resolutions width when in 16x9 aspect ratio
		width_offset = (1366 - screen_width) / 2
	end

	offset.y = offset.y + y
	offset.x = offset.x + x	
	

	if -offset.y < 0 then
		offset.y = 0
	elseif height-screen_height < -offset.y then
		offset.y = screen_height-height
	end

	if -offset.x < 0 then
		offset.x = 0
	elseif width-screen_width < -offset.x then
		offset.x = screen_width-width
	end	

    self:SetViewOffset(offset.x, offset.y)
	--self:GetWorld():ResizeStars(offset.y)
end
