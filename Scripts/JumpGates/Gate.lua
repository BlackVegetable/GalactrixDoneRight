-- Gate
--	this class defines the basic behaviour of the Gate objects
--	there is one instance of 

use_safeglobals()

local Satellite = import("Satellites/Satellite")

class "Gate" (Satellite)

-- BEGIN ATTRIBUTE DESCRIPTIONS
Gate.AttributeDescriptions = AttributeDescriptionList(Satellite.AttributeDescriptions)
--Gate.AttributeDescriptions:AddAttribute('string',		'description',			{default="[GATE_DESC]"} )
--Gate.AttributeDescriptions:AddAttribute('string', 		'type', 				{default="[GATE_TYPE]"})
Gate.AttributeDescriptions:AddAttribute('int',			'hacked',				{default=0} )
--MiniGame Time Limit in Seconds

--Gate.AttributeDescriptions:AddAttribute('int',		'keys',						{default=5} )
--Gate.AttributeDescriptions:AddAttribute('int',		'time_limit',				{default=90} )



Gate.rotation_speedx = 0.00
Gate.rotation_speedy = 0.0
Gate.rotation_speedz = 0.01


Gate.init_rotationx = 0.0
Gate.init_rotationy = 0.0
Gate.init_rotationz = 0.0

Gate.latent_rotation = true


Gate.gravity = 0 --0,..,6
Gate.board = nil

Gate.keys = 5
Gate.time = 90
Gate.models = {"jumpgatehacked","jumpgateunhacked"}


function Gate:__init()
	super("Gate")

	-- we have to init the attributes if we want to set them in the ctor
	self:InitAttributes()
	

	self.text_offset_x = 0	
	self.satellite_overlay_offset = 0		

	self:PlatformVars()
	
	--LOG("init " .. ClassIDToString(clid))
	self.classIDStr = "Gate"--ClassIDToString(clid)
	
	
	self.init_rotationx = math.random(-3,3)/10
	self.init_rotationy = math.random(-3,3)/10
	self.init_rotationz = 0	
	
end


function Gate:ShowText()
	-- Reformat text into multiple lines
	local star1 = _G.DATA.JumpGatesTable[self.classIDStr][1]
	local star2 = _G.DATA.JumpGatesTable[self.classIDStr][2]
	local toStar = star1	
	if (Hero:GetAttribute("curr_system") == star1) then
		toStar = star2
	end
	local systemName = translate_text("["..toStar.."_NAME]")
	local suffixGateName = translate_text("[GATE_SUFFIX_NAME]")
	local myName = systemName.." "..suffixGateName
	self.gateName = myName
	
	self:AddText(myName, self.text_offset_x, -self.text_offset_y-20)
end

--[[
function Gate:ReformatText(myLine)
	-- Takes a line of text and reformats it into a table of lines
	-- Based on "self.text_overlay_width" - the number of characters in a row
	local myLines = {}
	local n = 1
	for w in string.gfind(myLine, "%w+") do
		myLines[n] = w
		n = n + 1
	end
	
	return myLines
end
--]]
	
function Gate:SetHacked()
	self:SetAttribute("hacked",1)
end


function Gate:GetPopupMenu()
	self.menuItems = {}
	
	local quests = self:GetQuests()
	--local quests = GetAvailableQuestsAtLocations(_G.Hero, {self.classIDStr,_G.SCREENS.SolarSystemMenu.sun.classIDStr})
	
	if #quests > 0 then
		table.insert(self.menuItems,"[GET_QUESTS]")
	end
	
	local hackOption = true
	for i,v in pairs(SCREENS.PopupMenu.questActionList) do
		if v.battleground and v.battleground == "B002"  then
			hackOption = false
		end
	end	
	
	if hackOption then
		if self:GetAttribute("hacked") == 1 then
			table.insert(self.menuItems,"[OPEN_GATE]")
		else
			if CollectionContainsAttribute(_G.Hero, "crew", "C002") then --and not GATES[self.classIDStr].quest_hack 
				table.insert(self.menuItems,"[HACK_GATE]")
			end
		end
	end
	
	table.insert(self.menuItems,"[CLOSE]")	
	return self.menuItems
end




--[[
function Gate:UpdateQuestIndicator()
	local quests = GetAvailableQuestsAtLocation(_G.Hero, self.classIDStr) 
	local actions = GetAvailableActions(_G.Hero,self.classIDStr)
	
	local questIndicator = "ZQAC"
	local questIndicator2 = nil
	local textInfo = "ZTXN"
	
	if #actions > 0 then
		questIndicator = "ZQA1"		
		questIndicator2 = "ZQA1"
		
	elseif #quests > 0 then
		questIndicator = "ZQA0"
		questIndicator2 = "ZQA0"
	
	else
		questIndicator = nil
		self:RemoveOverlay("quest_action")
 		self:RemoveOverlay("quest_action2")

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

end
--]]



--[[

function Gate:PlatformVars()
	self.text_offset_y = 30
	self.text_offset_x = 0	
   -- how far from the edge of the titlesafe area should the graphic be placed? 
   -- Remember that sprites are centered so this should generally be half the sprite width.
   self.graphic_offset_from_titlesafe_x = 32 
   self.graphic_offset_from_titlesafe_y = 32
	self.satellite_overlay_offset = 0
	self.popup_width = 410
	self.popup_height = 25		
    self.text_overlay_width = 20 -- number of characters in a row
	self.text_overlay_line_height = 18
 	self.popup_add_hedge = 26	
	self.popup_add_vedge = 21	

	self.indicator_offset_x = 0
	self.indicator_offset_y = 0
end

--]]

function Gate:SetSystemView(starID)
	local sprite = "ZJG2"
	--local jgName = translate_text("[JUMPGATE_]")
	local hacked = false
	if self:GetAttribute("hacked") == 1 then
		hacked = true
		sprite = "ZJG1"
	end
	
	

	local x = self:GetAttribute("sat_xpos")
	local y = self:GetAttribute("sat_ypos")	
	if _G.DATA.JumpGatesTable[self.classIDStr][2]==starID then
		y = _G.SCREENHEIGHT - y
		x = self.maxScreenWidth - x -- We must use max screen width because the coords are atored with that in mind
	end
	
	self:RemoveOverlay("satellite")
	self:RemoveOverlay("text")
	self:RemoveOverlay("name")
	

	self:SetSystemPos(x,y)
	self:ShowText()
	
	--set3DView
		local model = "jumpgateunhacked"
		if hacked then
			model = "jumpgatehacked"
		end
		local view = GameObjectViewManager:Construct("Model3DView",model)
		CastToModel3DView(view):SetPosition(self:GetX(),self:GetY(),100.0)--this doesn't currently work, ships have no position
		CastToModel3DView(view):SetRotation(self.init_rotationx,self.init_rotationy,0.0)--this doesn't currently work, ships have no position
		--CastToModel3DView(view):SetScale(1.25)
		CastToModel3DView(view):SetScale(3.0)
		self:SetView(view)
	
	
		

end

--[[************************************************************************************************************8
--Start of old GatePlatform

dofile("Assets/Scripts/JumpGates/GatePlatform.lua")
--]]

function Gate:PlatformVars()
	self.text_offset_y = 40
	self.text_offset_x = 0	
   -- how far from the edge of the titlesafe area should the graphic be placed? 
   -- Remember that sprites are centered so this should generally be half the sprite width.
   self.graphic_offset_from_titlesafe_x = 32 
   self.graphic_offset_from_titlesafe_y = 32
	self.satellite_overlay_offset = 0
	self.popup_width = 360
	self.popup_height = 25		
    self.text_overlay_width = 20 -- number of characters in a row
	self.text_overlay_line_height = 18
 	self.popup_add_hedge = 26	
	self.popup_add_vedge = 21	

	self.indicator_offset_x = 0
	self.indicator_offset_y = -4
	self.maxScreenWidth = 1366
end



function Gate:DrawGate(lsx, lsy, lex, ley)	
	self:RemoveOverlay("jg_name")
	self:RemoveOverlay("jg_hacked")
	self:RemoveOverlay("satellite")
	self:RemoveOverlay("text")
	self:RemoveOverlay("name")

--start copy

	local viewwhite = GameObjectViewManager:Construct("Line")	
	
	local lineviewwhite = CastToLineView(viewwhite)
	viewwhite:SetSortingValue(4)

	lineviewwhite:SetStart(lsx,lsy)
	lineviewwhite:SetEnd(lex,ley)		
	
	lineviewwhite:SetWidth(1) --Top	
	
	self:AddOverlay("whiteline", viewwhite, 0, 0)		
--end copy	--self:SetView(view)

-- new line		

	local viewwhite2 = GameObjectViewManager:Construct("Line")	
	
	local lineviewwhite2 = CastToLineView(viewwhite2)
	viewwhite2:SetSortingValue(5)

	lineviewwhite2:SetStart(lsx,lsy)
	lineviewwhite2:SetEnd(lex,ley)		
	
	lineviewwhite2:SetWidth(3) --Below Top	
	
	self:AddOverlay("whiteline2", viewwhite2, 0, 0)
--end new line		
	
	local view = GameObjectViewManager:Construct("Line")
	local lineview = CastToLineView(view)
	self:SetView(view)
	view:SetSortingValue(6)
	
	lineview:SetStart(lsx,lsy)
	lineview:SetEnd(lex,ley)		
	
	lineview:SetWidth(5) --Middle		
	
	local viewback = GameObjectViewManager:Construct("Line")		
	
	local lineviewback = CastToLineView(viewback)
	viewback:SetSortingValue(7)

	lineviewback:SetStart(lsx,lsy)
	lineviewback:SetEnd(lex,ley)		
	
	lineviewback:SetWidth(7) --Bottom	
	
	self:AddOverlay("blackline", viewback, 0, 0)

	local viewback2 = GameObjectViewManager:Construct("Line")		
	
	local lineviewback2 = CastToLineView(viewback2)
	viewback2:SetSortingValue(8)

	lineviewback2:SetStart(lsx,lsy)
	lineviewback2:SetEnd(lex,ley)		
	
	lineviewback2:SetWidth(9) --Bottom2	
	
	self:AddOverlay("blackline2", viewback2, 0, 0)

	
	if self:GetAttribute('hacked') == 1 then
		lineviewwhite:SetColor(205, 255, 222, 0)
		lineviewwhite2:SetColor(175, 255, 180, 0)
		lineview:SetColor(67, 255, 180, 0)				
		lineviewback:SetColor(30, 23, 8, 1)	
		lineviewback2:SetColor(15, 23, 8, 1)			
	else
      lineviewwhite:SetColor(64, 64, 64, 128)
		lineviewwhite2:SetColor(64, 64, 64, 128)
		lineview:SetColor(64, 64, 64, 128)				
		lineviewback:SetColor(32, 32, 32, 49)	
		lineviewback2:SetColor(16, 16, 16, 49)	

	end

	--self.lineview = lineview
	self.lineview = lineviewback2	
end

function Gate:Highlight()
	--if self:GetAttribute('hacked') == 1 then
		--self.lineview:SetColor(255, 210, 230, 255)
		self.lineview:SetColor(255, 221, 42, 0)		
	--end
end

function Gate:UnHighlight()
	--if self:GetAttribute('hacked') == 1 then
		--self.lineview:SetColor(255, 120, 193, 255)	
		self.lineview:SetColor(15, 23, 8, 1)--restoring previous color	
	--else
		--self.lineview:SetColor(50, 0,140, 255)
	--end
end

function Gate:GetPathValidation()
	-- Example validation for path finding
	local function IsGateValid(node)
		
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

local function IsPrimaryQuest(id)
	local chapter = string.sub(id,3,3)
	if chapter == "0" or chapter == "1" or chapter == "2" or chapter == "3" or chapter == "4" then
		return true
	end
	return false
end



function Gate:GetQuestsActions(skipActions)
	-- In the generic platform version, assume that we have lots of CPU power and can look through some links
	--  from this gate to check for actions
	local starID = SCREENS.SolarSystemMenu.sun.classIDStr
	local quests = self:GetQuests()
	local actions = {}
	
	local star1 = _G.DATA.JumpGatesTable[self.classIDStr][1]
	local star2 = _G.DATA.JumpGatesTable[self.classIDStr][2]
	local starDest = star2
	if star2 == starID then
		starDest = star1
	end
	
	-- This will give us any actions directly on this gate
	if not skipActions then
		local objectives = GetAvailableObjectives(_G.Hero,self.classIDStr)
		for _,v in pairs(objectives) do
			if v.location[starID]then
				table.insert(actions,v)
			end
		end
	end

	-- Now we should add on any remote actions that this gate gives quickest access to.
	-- For each quest-action that we have... search for the quickest UNLOCKED PATH leading to this system.
	-- If no unlocked path exists, then search for the quickest LOCKED PATH leading to this system.
	-- If the chosen path leads through this gate, then mark an action here.
 	if not skipActions then	
	
		local quest_idloc = GetQuestIdsAndObjectiveLocations(_G.Hero)
		--for s,list in pairs(quest_idloc) do
		--	LOG(string.format("Gate:GetQuestsActions (%s,%s) quest_idloc[%s]={%s,%s}",tostring(starID),tostring(self.classIDStr),tostring(s),tostring(list[1]),tostring(list[2])))
		--end
		local valid_destinations = {}
		local keys={}
		for s,list in pairs(quest_idloc) do
			--LOG(string.format("Gate:GetQuestsActions TEST starID=%s sub=%s",tostring(starID),string.sub(list[2],1,1)))
			if list[2] ~= starID and string.sub(list[2],1,1)=="S" then -- ensure it's not in our system
				if IsPrimaryQuest(list[1])  then
					keys[list[2]]=1
					valid_destinations[list[2]]= list
				elseif not keys[list[2]] then
					keys[list[2]]=2
					valid_destinations[list[2]]= list
				end
			end
		end	
		--for i,v in pairs(valid_destinations) do
		--	LOG(string.format("Gate:GetQuestsActions (%s,%s) valid_destinations[%s]={%s,%s}",tostring(starID),tostring(self.classIDStr),tostring(i),tostring(v[1]),tostring(v[2])))
		--end
		for i,v in pairs(valid_destinations) do
			
			local gate_id = _G.DATA.StarLinks[starID][v[2]]
			--LOG(string.format("Gate:GetQuestsActions (%s,%s) gate_id=%s",tostring(starID),tostring(self.classIDStr),tostring(gate_id)))
			if gate_id == self.classIDStr then
				table.insert(actions,{["location"]=gate_id,["quest_id"]=v[1]})
			end
		end		
	end

	return quests, actions
end



function Gate:InitNode(graph)

	if _G.SCREENS.MapMenu.hacked and _G.SCREENS.MapMenu.hacked[self.classIDStr] then
		--LOG("Hacked")
		self:SetAttribute("hacked", 1)
	end

	local i=1
	local x = 0
	local y = 0	

		
	local neighbour_nodes = graph:GetNeighbours(self)
	local end_x = {}
	local end_y = {}	
	
	-- get the roads endpoints
	for n in neighbour_nodes do
		x = n:GetAttribute("xpos")
		y = n:GetAttribute("ypos")

		end_x[i] = x
		end_y[i] = y
		i=i+1
	end	

	local rdx	= (end_x[1] + end_x[2])/2
	local rdy	= (end_y[1] + end_y[2])/2	

	-- set the roads position
	self:SetPos(rdx,rdy)
	
	self:DrawGate(end_x[1] - rdx, end_y[1] - rdy, end_x[2] - rdx, end_y[2] - rdy)
	
end





return ExportClass("Gate")