function Satellite:PlatformVars()
	
	 self.satellite_overlay_offset = 26
	 self.satellite_text_overlay_offset = 26
	 self.text_overlay_offset_y = 44
	-- how far from the edge of the titlesafe area should the graphic be placed? 
	-- Remember that sprites are centered so this should generally be half the sprite width.
	self.graphic_offset_from_titlesafe_x = 32 
	self.graphic_offset_from_titlesafe_y = 32
	 self.text_overlay_width = 20 -- number of characters in a row
	 self.text_overlay_line_height = 18
	 self.indicator_offset_y = 0
	 self.popup_width = 360
	 self.popup_height = 25
	 self.popup_add_hedge = 26	
	 self.popup_add_vedge = 21		
	
end

function Satellite:SetSystemPos(x,y)
	LOG("x "..tostring(x)..",y "..tostring(y))
	local table position ={}
   position.x = x
   position.y = y
   position = self:AdjustScreenPos(position)
	LOG("x "..tostring(x)..",y "..tostring(y))
	--self:SetPos(x,y)
	self:SetPos(position.x, position.y)
end

function Satellite:AdjustScreenPos(position)
	if position.x < _G.MIN_HORIZONTAL + self.graphic_offset_from_titlesafe_x then
		position.x = _G.MIN_HORIZONTAL + self.graphic_offset_from_titlesafe_x
	
   elseif position.x > _G.MAX_HORIZONTAL - self.graphic_offset_from_titlesafe_x then
		position.x = _G.MAX_HORIZONTAL - self.graphic_offset_from_titlesafe_x
	
   end
	
   if position.y < _G.SAFE_VERTICAL + self.graphic_offset_from_titlesafe_y then
		position.y = _G.SAFE_VERTICAL +self.graphic_offset_from_titlesafe_y
	
   elseif position.y > _G.MAX_VERTICAL - self.graphic_offset_from_titlesafe_y then
		position.y = _G.MAX_VERTICAL - self.graphic_offset_from_titlesafe_y
	
   end	
   
   return position
end

function Satellite:SetSystemView()
	local sprite1 = "ZTB1"
	--local view = GameObjectViewManager:Construct("Sprite","ZTB1")--Selection Box
	local model = self.models[1]
		
	self:SetSystemPos(self:GetAttribute("sat_xpos"),self:GetAttribute("sat_ypos"))		
	--local view = GameObjectViewManager:Construct("Sprite",self:GetAttribute("sprite"))
	
	--self:SetView(view)
	--view:StartAnimation("stand")	
	--view:SetScale(scale)	
	
	--local view
	local sprite2 = self:GetAttribute("sprite")
	if self.cargo and CollectionContainsAttribute(_G.Hero, "mined_asteroids", self.classIDStr) then
		--view = GameObjectViewManager:Construct("Sprite", "ZT04")
		sprite2 = "ZT04"
		model = self.models[2]
	else
		--view = GameObjectViewManager:Construct("Sprite",self:GetAttribute("sprite"))--Planet animated sprite
	end

	--[[--commented out box around model
	local view = GameObjectViewManager:Construct("Sprite",sprite1)
	self:SetView(view)
	view:SetSortingValue(24)
	view:StartAnimation("stand")		
	--]]
	
	local function set3DView()
		--BEGIN_STRIP_DS
		LOG("Construct ModelView "..tostring(model))
		local view = GameObjectViewManager:Construct("Model3DView",model)
		CastToModel3DView(view):SetPosition(self:GetX(),self:GetY(),100.0)
		CastToModel3DView(view):SetRotation(-1.7+self.init_rotationx,self.init_rotationy,self.init_rotationz)
		CastToModel3DView(view):SetScale(self.modelScale)
		view:SetSortingValue(-3)
		--self:AddOverlay("satellite", view, -self.satellite_overlay_offset, 0)	
		self:SetView(view)
		return true
		--END_STRIP_DS
	end
	if not _G.NotDS(set3DView) then
		local view = GameObjectViewManager:Construct("Sprite",sprite1)
		self:SetView(view)
		view:StartAnimation("stand")	
		view = GameObjectViewManager:Construct("Sprite",sprite2)	
		view:StartAnimation("stand")
		view:SetScale(self.spriteScale)
		view:SetSortingValue(-3)
		self:AddOverlay("satellite", view, -self.satellite_overlay_offset, 0)
		
		
	end	
	self:ShowText()	

	
end


local function IsPrimaryQuest(id)
	local chapter = string.sub(id,3,3)
	if chapter == "0" or chapter == "1" or chapter == "2" or chapter == "3" or chapter == "4" then
		return true
	end
	return false
end


function Satellite:UpdateQuestIndicator()
	local quests, actions = self:GetQuestsActions()
	
	
	local questIndicator = "ZQA1"
	local questIndicator2 = nil
	local textInfo = "ZTXN"
	
	if #actions > 0 then
		questIndicator = "ZQA3"--Side Action
		questIndicator2 = "ZQA3"		
		
		for _,a in pairs(actions) do
			if IsPrimaryQuest(a.quest_id) then
				questIndicator = "ZQA1" -- Primary Action
				questIndicator2 = "ZQA1"
				break
			end
		end
	
		textInfo = "ZTXE"
				
	elseif #quests > 0 then
		
		questIndicator = "ZQA2"
		questIndicator2 = "ZQA2"

		for _,q in pairs(quests) do
			if IsPrimaryQuest(q) then
				questIndicator = "ZQA0"
				questIndicator2 = "ZQA0"
				break
			end
		end
		
		textInfo = "ZTXF"
	
	else
		questIndicator = nil
		self:RemoveOverlay("quest_action")
 		self:RemoveOverlay("quest_action2")

	end
	

	if ClassIDToString(self:GetClassID()) == "Gate" then
		textInfo = nil
	end
	
	if questIndicator then
		local view = GameObjectViewManager:Construct("Sprite",questIndicator)
		view:StartAnimation("stand")
		view:SetSortingValue(-6)
		self:AddOverlay("quest_action", view, -self.indicator_offset_x, self.indicator_offset_y)		
	end
	
	if questIndicator2 then
		local view = GameObjectViewManager:Construct("Sprite",questIndicator)
		view:StartAnimation("stand2")
		view:SetSortingValue(-6)
		self:AddOverlay("quest_action2", view, -self.indicator_offset_x, self.indicator_offset_y)		
	end
	
	if false and textInfo then	
		LOG("Set TextINfo")
		local view = GameObjectViewManager:Construct("Sprite",textInfo)
		view:StartAnimation("stand")
		view:SetSortingValue(-4)
		self:AddOverlay("text", view, self.satellite_text_overlay_offset, 0)			
	end
	
end

