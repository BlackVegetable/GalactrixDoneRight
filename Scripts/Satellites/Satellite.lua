-- Satellite
--  base class for all Satellites

use_safeglobals()

class "Satellite" (GameObject)

Satellite.AttributeDescriptions = AttributeDescriptionList()
--Satellite.AttributeDescriptions:AddAttribute('string', 'name', {default="Unexplored"})
--Satellite.AttributeDescriptions:AddAttribute('string', 'description', {default=""})
--Satellite.AttributeDescriptions:AddAttribute('string', 'type', {default=""})
Satellite.AttributeDescriptions:AddAttribute('int', 'sat_xpos', {default=512}) 
Satellite.AttributeDescriptions:AddAttribute('int', 'sat_ypos', {default=60}) 
Satellite.AttributeDescriptions:AddAttribute('string', 'sprite', {default="ZTPL"}) 
--Mining MiniGame Time Limit in Seconds


Satellite.init_rotationx = 0.0
Satellite.init_rotationy = 0.0
Satellite.init_rotationz = 0.0


Satellite.rotation_speedx = 0.0
Satellite.rotation_speedy = 0.0
Satellite.rotation_speedz = 0.0

Satellite.gravity = 0 --0,..,6
Satellite.spriteScale = 0.5
Satellite.board = nil
Satellite.spriteList = {"ZSI0","ZSI0","ZSI0"}
Satellite.modelScale = 1.0

function Satellite:__init(clid)
    super(clid)
	self:InitAttributes()

	self.text_overlay_offset_x = 0			
	self.indicator_offset_x = 0	
	self:PlatformVars()
end

function Satellite:GetGravity()
	return self.gravity
end



function Satellite:GetBoard()
	return self.board
end

function Satellite:ShowText()
 	local myName = translate_text(string.format("[%s_NAME]",self.classIDStr))
	self:AddText(myName, self.text_overlay_offset_x, -self.text_overlay_offset_y)
end

function Satellite:AddText(myName,offx,offy)
	local myLines = self:ReformatText(myName)
	local numLines = #myLines
	
	local w,h = self:GetNameBlockSize(myLines)
	local x,y = self:FitNameBlockToScreen(offx, offy, w,h)
	
	--x = offx
	--y = offy
	
	local yLineOffset = 0
	for k,myLine in ipairs(myLines) do
		local view = GameObjectViewManager:Construct("Text")
		local textView = CastToTextView(view)
		textView:SetString(myLine)
		textView:SetAlpha(0.5)
		textView:SetSortingValue(2)
		textView:SetFont("font_info_white")
		
		self:AddOverlay("name"..tostring(k), view, x, y-yLineOffset)
		
		yLineOffset = yLineOffset + self.text_overlay_line_height
	end	
end

function Satellite:GetNameBlockSize(myLines)
	local w = 0
	local h = #myLines * self.text_overlay_line_height
	for _,myLine in ipairs(myLines) do
		local thisw = get_text_length("font_info_white", myLine)
		w = math.max(w,thisw)
	end
	return w,h
end

function Satellite:FitNameBlockToScreen(x,y,w,h)
	
	local sx = self:GetX()
	local sy = self:GetY()
	
	x = x + sx
	y = y + sy
	
	if x-w/2 < _G.MIN_HORIZONTAL+2 then
		x = _G.MIN_HORIZONTAL+2 + w/2
	end	
	if x+w/2 > _G.MAX_HORIZONTAL-2 then
		x = _G.MAX_HORIZONTAL-2 - w/2
	end
	if y-h < _G.MIN_VERTICAL+2 then
		y = _G.MIN_VERTICAL+2 + h
	end
	if y > _G.MAX_VERTICAL-2 then
		y = _G.MAX_VERTICAL-2
	end
	
	return x-sx,y-sy
end


--[[
function Satellite:ShowText()
	-- Reformat text into multiple lines
	local myName = translate_text(string.format("[%s_NAME]",self.classIDStr))
	local myLines = self:ReformatText(myName)
	
	local yLineOffset = 0
	for _,myLine in ipairs(myLines) do
		local view = GameObjectViewManager:Construct("Text")
		local textView = CastToTextView(view)
		textView:SetString(myLine)
		textView:SetAlpha(0.5)
		textView:SetSortingValue(-4)
		textView:SetFont("font_info_white")		
      
      LOG("***")
      LOG(myLine)
      
      -- Adjust so text doesn't go off screen

      
      LOG(string.format("MinHoriz: %d, MaxHoriz: %d", _G.MIN_HORIZONTAL, _G.MAX_HORIZONTAL))
      LOG(string.format("MinVert: %d, MaxVert: %d", _G.MIN_VERTICAL, _G.MAX_VERTICAL))
   
      self.textOffsets ={x = -self.text_overlay_offset_x, y = -self.text_overlay_offset_y-yLineOffset}
      
      self.textOffsets = self:FitLabelToScreen(self.textOffsets, myLine)
      
      --LOG(string.format("XOffset is now %d",self.textOffsets.x))
      
      --LOG(string.format("SatPos: X:%d Y:%d", satXPos, self:GetAttribute("sat_ypos")))
      --LOG(string.format("\n\n%s \nSatPos: \t\tX:%d \tY:%d \nTextOffset: \tX:%d \tY:%d\n", myLine, satXPos, self:GetAttribute("sat_ypos"), xPosOffset, yPosOffset))

      
		self:AddOverlay("name"..tostring(yLineOffset), view, self.textOffsets.x, self.textOffsets.y)
		yLineOffset = yLineOffset + self.text_overlay_line_height
      LOG("\n")
	end	
end

function Satellite:FitLabelToScreen(offsets, myLine)
   LOG(string.format("satXPos:%d", offsets.x))
   local lineLength = get_text_length("font_info_white", myLine)
   local lineXPos = self:GetX() + offsets.x -- the text is drawn centered around this position
   local lineStartXPos = lineXPos - (lineLength /2)
   local lineEndXPos = lineXPos + (lineLength /2)

   LOG(string.format("Offset: X:%d\tY:%d", offsets.x, offsets.y))
   LOG(string.format("Start:%d\tPos:%d\tEnd:%d", lineStartXPos, lineXPos, lineEndXPos))

   if lineEndXPos > _G.MAX_HORIZONTAL then
      offsets.x = offsets.x - (lineEndXPos - _G.MAX_HORIZONTAL)
   end
      
   if lineStartXPos < _G.MIN_HORIZONTAL then
      offsets.x = offsets.x + (_G.MIN_HORIZONTAL - lineStartXPos)
   end
   return offsets
end
--]]

function Satellite:ReformatText(myLine)
	-- Takes a line of text and reformats it into a table of lines
	-- Based on "self.text_overlay_width" - the number of characters in a row
	local myLines = {}
	local n = 1
	myLines[n] = ""
	for w in string.gmatch(myLine, "%S+") do
		if #w + #myLines[n] <= self.text_overlay_width then
			if #myLines[n] == 0 then
				myLines[n] = w
			else
				myLines[n] = myLines[n].." "..w
			end
		else
			n = n + 1
			myLines[n] = w
		end
	end
	
	return myLines
end
	
function Satellite:RemoveText()
		
	self:RemoveOverlay("name")
end
	
function Satellite:HeroArrived()
	LOG("HeroArrived")
	_G.Hero:SetAttribute("curr_loc",self.classIDStr)
	_G.Hero:SetAttribute("curr_loc_obj",self)

	local event = GameEventManager:Construct("ArriveAtLocation")
	event:SetAttribute("location", self.classIDStr)
	if not ProcessQuestEvent(Hero,event) and SCREENS.SolarSystemMenu.state <= _G.STATE_TARGET then
		SCREENS.SolarSystemMenu.state = _G.STATE_MENU
		SCREENS.PopupMenu:Open()	
		local numListItems = SCREENS.PopupMenu:CreateList(self)
		--local listHeight = self.popup_height*numListItems + 2*self.popup_add_vedge
		
		SCREENS.PopupMenu:fit_listbox_width_to_entries("list_satellite")
		local listWidth = SCREENS.PopupMenu:get_widget_w("list_satellite")
		
      local screenWidth = GetScreenWidth()
      if listWidth > screenWidth then
			SCREENS.PopupMenu:set_widget_w("list_satellite",screenWidth)
			listWidth = screenWidth
         
      elseif
         listWidth < self.popup_width then
			LOG("Set Width to "..tostring(self.popup_width))
			SCREENS.PopupMenu:set_widget_w("list_satellite",self.popup_width)
			listWidth = self.popup_width
		end
		
		-- determine the dimension & position
		-- SCF - Add this in later - with a new exe - it will autosize the menu
		--[[
		local edges = 2*self.popup_add_hedge
		local menuList = SCREENS.PopupMenu.menuList
		local maxStringWidth = listWidth-edges
		for k,v in pairs(menuList) do
			local myWidth = get_text_length("font_system",v)
			if myWidth > maxStringWidth then
				maxStringWidth = myWidth
			end	
		end
		if maxStringWidth > listWidth-edges then
			listWidth = maxStringWidth+edges
			--local h = SCREENS.PopupMenu:get_widget_h("list_satellite")
			--LOG("ListHeight = "..tostring(listHeight))
			--SCREENS.PopupMenu:set_widget_size("list_satellite", listWidth, listHeight)
			SCREENS.PopupMenu:set_widget_w("list_satellite", listWidth)
		elseif SCREENS.PopupMenu:get_widget_w("list_satellite") > listWidth then--Reset widget width
			SCREENS.PopupMenu:set_widget_w("list_satellite", listWidth)
		end
		--]]
		
		LOG("GetX()="..tostring(self:GetX()))
		local point = SCREENS.SolarSystemMenu:ConvertWorldCoordsToScreenCoords(self:GetX(), self:GetY())
		local x = point.x
		local y = point.y
		
		--LOG("listWidth = "..tostring(listWidth))
		LOG("point.x="..tostring(point.x))
		LOG("SCREEN_WIDTH = "..tostring(_G.SCREEN_WIDTH))
		local offset = 0
		if _G.SCREEN_WIDTH > 1024 then
			offset = (_G.SCREEN_WIDTH - 1024)/2
		end

		LOG("offset = "..tostring(offset))
		--LOG("maxhor = "..tostring(_G.MAX_HORIZONTAL))
		local max_horizontal = _G.SCREEN_WIDTH - _G.SAFE_HORIZONTAL
		if x + listWidth  > max_horizontal then
			LOG("before adjusted "..tostring(x))
			x = max_horizontal - listWidth
			LOG("adjusted "..tostring(x))
		end
		local listHeight = SCREENS.PopupMenu:get_widget_h("list_satellite")
		if y + listHeight > _G.MAX_VERTICAL then
			y = _G.MAX_VERTICAL - listHeight
		end
		
		local function SetPopupPosDS(x,y)
			SCREENS.PopupMenu:Move(x, y)
		end
		_G.DSOnly(SetPopupPosDS,x,y)
		--BEGIN_STRIP_DS
		local function SetPopupPos(x,y)
			LOG("SetX == "..tostring(x))
			SCREENS.PopupMenu:set_widget_position("list_satellite", x, y) -- move the widget to (5, 10)			
		end
		_G.NotDS(SetPopupPos,x-offset,y)
		--END_STRIP_DS
	elseif SCREENS.SolarSystemMenu:GetWorld() then
		SCREENS.SolarSystemMenu:GetWorld():DeselectSatellite()
	end
end


function Satellite:GetPopupMenu()
	self.menuItems = {}

	table.insert(self.menuItems,"[CLOSE]")
	
	return self.menuItems
end


--BEGIN_STRIP_DS
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
--END_STRIP_DS


function Satellite:GetQuests()	
	local starID = _G.SCREENS.SolarSystemMenu.sun.classIDStr
	local quests = _G.GLOBAL_FUNCTIONS.GetAvailableQuests(starID,self.classIDStr)
	return quests
end	


function Satellite:GetQuestsActions(skipActions)
	local starID = SCREENS.SolarSystemMenu.sun.classIDStr
	local quests = self:GetQuests()
	--local quests = GetAvailableQuestsAtLocation(_G.Hero, self.classIDStr)
	--[[
    for i=1,_G.Hero:NumAttributes("available_quests") do
		local questID = _G.Hero:GetAttributeAt("available_quests", i)
		local star = _G.DATA.QuestStart[questID]	
		if star == SCREENS.SolarSystemMenu.sun.classIDStr then
			if _G.QUESTS[questID].start_locations[self.classIDStr] then
				table.insert(quests,questID)
			end
		end
    end
	--]]
	local actions = {}
	if not skipActions then	
		actions = GetAvailableObjectives(_G.Hero,self.classIDStr)
	end

	return quests, actions
end



--[[*********************************************************************************************
--Start of old SatellitePlatform

dofile("Assets/Scripts/Satellites/SatellitePlatform.lua")

--]]

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
	local position ={}
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
	
	--set3DView
		LOG("Construct ModelView "..tostring(model))
		local view = GameObjectViewManager:Construct("Model3DView",model)
		CastToModel3DView(view):SetPosition(self:GetX(),self:GetY(),100.0)
		CastToModel3DView(view):SetRotation(-1.7+self.init_rotationx,self.init_rotationy,self.init_rotationz)
		CastToModel3DView(view):SetScale(self.modelScale)
		view:SetSortingValue(-3)
		--self:AddOverlay("satellite", view, -self.satellite_overlay_offset, 0)	
		self:SetView(view)
	
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





return ExportClass("Satellite")