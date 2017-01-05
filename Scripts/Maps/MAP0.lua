
-- MAP0
--	star map for galactrix
--	TODO: split the generic Map stuff out into a (Lua) base class and put it in stdlib

use_safeglobals()

class "MAP0" (GameObject)

MAP0.AttributeDescriptions = AttributeDescriptionList()
MAP0.AttributeDescriptions:AddAttribute('int', 'date',		{default=0})


function MAP0:HighlightPath(path)
	if type(path) == "table" then
		for index,node in ipairs(path) do
			
			local classIdStr = ClassIDToString(node:GetClassID())	
			
			if classIdStr == "Gate" then
				node:Highlight()
			end
		end
	end
end


function MAP0:UnHighlightPath(path)
	if type(path) == "table" then
		for index,node in ipairs(path) do
			local classIdStr = ClassIDToString(node:GetClassID())	
			
			if classIdStr == "Gate" then
				node:UnHighlight()
			end
		end
	end
end


function MAP0:__init()	
	super("MAP0")
	self:InitAttributes()
	LOG("Map0 Init()")

	_G.Hero:SetStarMapView()
	--self.state = _G.STATE_FLIGHT
	self.state = _G.STATE_IDLE
	
	self:LoadStars()

	self.path = nil
	self.cancel_movement = 0
	
	self.fading_system = false
end


function MAP0:OnEventInitialize(event)
	LOG("MAP0:OnEventInitialize")
	-- update stars
	-- queue economy tick
	-- queue AI tick
end


-- Load all stars and link them together
function MAP0:LoadStars()
	-- create the graph to hold our map
	-- this creates game objects
	
	
	assert(not self.graph, "graph already loaded!")
	
	
	local graph	= LoadGraph("StarMap")
	self.graph = graph;

	-- add created game objects as our children
	-- this adds all stars and roads
	self:AddNodes()

	purge_garbage()

	-- This should only be uncommented if you want to output a file containing links
	-- of every star & its closest jumpgates
	--[[
	local function GateAlwaysValid(node)			
		return true
	end	
	LOG("local StarLinks = {")
	for star1_id,_ in pairs(_G.DATA.StarTable) do
		local star_str = "          [\""..tostring(star1_id).."\"] = {"
		for star2_id,_ in pairs(_G.DATA.StarTable) do
			local nearest_id=""
			local n1 = self.graph:GetNode(star1_id)
			local n2 = self.graph:GetNode(star2_id)
			local path = GetPath(self.graph, n1,n2, GateAlwaysValid)
			--LOG(string.format("MAP0:LoadStars (%s,%s) Nodes n1=%s, n2=%s",tostring(star1_id),tostring(star2_id),tostring(n1:GetClassID()),tostring(n2:GetClassID())))
			--LOG(string.format("MAP0:LoadStars (%s,%s) path_len=%d",tostring(star1_id),tostring(star2_id),#path))
			--LOG(string.format("MAP0:LoadStars (%s,%s) path[1]=%s path[2]=%s",tostring(star1_id),tostring(star2_id),tostring(path[1]),tostring(path[2])))
			--LOG("-")
			if path[1] and path[1].classIDStr then
				nearest_id = path[1].classIDStr
			end
			star_str = star_str.."[\""..tostring(star2_id).."\"]=\""..tostring(nearest_id).."\", "
		end
		star_str = star_str.."},"
		LOG(star_str)
	end
	LOG("}")
	--]]
	-- End Commented Section
	
	-- This should only be uncommented if you want to output a file containing 
	-- widgets that represent every star and link between them!
	--[[
	for s,list in pairs(_G.DATA.StarTable) do
		local x = _G.STARS.AllStars[s].xpos
		local y = 2048 - _G.STARS.AllStars[s].ypos
		x = math.ceil( (x*448)/2048 + 32 ) - 16
		y = math.ceil( (y*448)/2048 + 13 ) - 16 - 16
		local star_str = "    <Icon       name=\"icon_"..tostring(s).."\" x=\""..tostring(x).."\" y=\""..tostring(y).."\" width=\"32\" height=\"32\" graphic=\"img_mmb_neutral\" />"
		LOG(star_str)
	end
	LOG("")
	for g,list in pairs(_G.DATA.JumpGatesTable) do
		local star1 = list[1]
		local star2 = list[2]
		local x1 = _G.STARS.AllStars[star1].xpos
		local y1 = 2048 - _G.STARS.AllStars[star1].ypos
		local x2 = _G.STARS.AllStars[star2].xpos
		local y2 = 2048 - _G.STARS.AllStars[star2].ypos
		local x = (x1+x2)/2
		local y = (y1+y2)/2
		x = math.ceil( (x*448)/2048 + 32 ) - 4
		y = math.ceil( (y*448)/2048 + 13 ) - 4 - 16
		local jgate_str = "    <Icon       name=\"icon_"..tostring(g).."\" x=\""..tostring(x).."\" y=\""..tostring(y).."\" width=\"8\" height=\"8\" graphic=\"img_mmb_blocked\" />"
		LOG(jgate_str)
	end
	LOG("")
	for g,list in pairs(_G.DATA.JumpGatesTable) do
		local jgate_str = "<Entry name=\"icon_"..tostring(g).."\"/>"
		LOG(jgate_str)
	end
	--]]
	-- End Commented Section
	
	-- TODO: Load additions to the graph.
end

function MAP0:RemoveNodes()
	for node in self.graph:GetNodes() do
		-- add the object as a member of the world
		self:RemoveChild(node)

		-- get the class of this node
		local classID = ClassIDToString(node:GetClassID())
		--LOG("RemoveNodes " .. classID .. " " .. tostring(gcinfo()))
		self:RemoveNode(node, classID)
	end		
end

function MAP0:RemoveNode(node, classIdStr)
	-- dispatch to node initializer
	local handler = "InitNode"..classIdStr;
	--LOG(handler)
	if classIdStr == "Gate" then
		--self:RemoveNodeJumpGate(node, classIdStr)
	else
		node:RemoveOverlay("anim")
		node:SetView(nil)
		node.view = nil
		node.viewanim = nil
	end
end

function MAP0:AddNodes()
	
	for s,star in pairs(_G.StarList) do
		self:AddChild(star)
		
		star:InitNode()
	end
	
	for j,gate in pairs(_G.JumpGateList) do
		self:AddChild(gate)
		
		gate:InitNode(self.graph)
	end		
	

	--collectgarbage()
	self:AddQuestOverlay()	
end

function MAP0:AddQuestOverlay()
	LOG("ADDING QUEST OVERLAYS")
	--local quest_locations = GetAvailableQuestsLocations(_G.Hero)

	--for s,list in pairs(quest_locations) do
		--if _G.StarList[list] then
		
	--for q,list in pairs(_G.DATA.QuestStart) do
		--_G.StarList[s] = _G.LoadStar(s,_G.STARS.AllStars[s])		
			--local questView = GameObjectViewManager:Construct("Sprite","ZQBQ")
			--_G.StarList[list]:AddOverlay("quests", questView, 0, 0)
			--questView:StartAnimation("stand")			
			--questView:SetSortingValue(-16)		
		--end
	--end	
	
	local function IsPrimaryQuest(id)
		local chapter = string.sub(id,3,3)
		if chapter == "0" or chapter == "1" or chapter == "2" or chapter == "3" or chapter == "4" then
			return true
		end
		return false
	end
	
	local keys = {}--1=primaryAction,2=sideAction,3=primaryQuest,4=sideQuest
	
	local quest_idloc = GetQuestIdsAndObjectiveLocations(_G.Hero)
	local spr
	for s,list in pairs(quest_idloc) do
		if  _G.StarList[list[2]] and keys[list[2]] ~= 1 then
			local draw = true
			if IsPrimaryQuest(list[1]) and keys[list[2]]~=1 then--primary Action
				spr = "ZQA1"	
				keys[list[2]] = 1				
			elseif not keys[list[2]] then--side Action
				spr = "ZQA3"
				keys[list[2]] = 2
			else
				draw = false--if fails prev checks -- no need to draw
			end
			if draw  then
				local questView = GameObjectViewManager:Construct("Sprite",spr)
				_G.StarList[list[2]]:AddOverlay("quests", questView, 0, 0)
				questView:StartAnimation("stand")			
				questView:SetSortingValue(1)
			end	
		end
	end		
	
    for i=1,_G.Hero:NumAttributes("available_quests") do
		local questID = _G.Hero:GetAttributeAt("available_quests", i)
		local star = _G.DATA.QuestStart[questID]
    	if not keys[star] or keys[star]==4 then--If no actions already at this Loc - or  side Quest available here.
    		local draw = true
			if IsPrimaryQuest(questID) and keys[star]~=3 then--Primary Quest
				spr = "ZQA0"
				keys[star] = 3
    		elseif not keys[star] then --Side Quest
				spr = "ZQA2"
				keys[star] = 4
    		else
    			draw = false
			end
			if draw  then
				local questView = GameObjectViewManager:Construct("Sprite",spr)
				_G.StarList[star]:AddOverlay("quests", questView, 0, 0)
				questView:StartAnimation("stand")
				questView:SetSortingValue(1)
    		end
	    end
    end
end

function MAP0:RemoveQuestOverlay(quest)
	local quest_idloc = GetQuestIdsAndObjectiveLocations(_G.Hero)
	
	for s,list in pairs(quest_idloc) do
		if(list[1] == quest and string.sub(list[2], 1, 1)=='S')then
			_G.StarList[list[2]]:RemoveOverlay("quests")
		end
	end
end

function MAP0:OnEventCursorAction(event,object,x,y,up)
	if event then
		object = event:GetAttribute("object")
		up = event:GetAttribute("up")
	end
	
	if not up then
	LOG("Not Up")
		return
	end
	
	if self.fading_system then
		return
	end
	
	--LOG("CursorAction obj "..ClassIDToString(object:GetClassID()))

	-- TODO:	need a better way to detect object type
	--			this only works if its exact type.
	--LOG("OnCursorAction - state="..tostring(self.state))
	if object:GetClassID() == GetClassID("Star") and self.state ~= _G.STATE_ENCOUNTER then
    	-- if its a star forward to star handling code
		--self.state = _G.STATE_FLIGHT
		self:OnActionStar(object)
	end
end


function MAP0:OnEventCursorEntered(event)
    local object = event:GetAttribute("object")
	if object:GetClassID() == GetClassID("Star") then
		self:OnOffStar()
		self:OnOverStar(object)
	else
		self:OnOffStar()
	end
end




function MAP0:OnOffStar()
	if not _G.Hero:HasMovementController() then
		self:UnHighlightPath(self.path)
	end
	
	if self.graph then
		for node in self.graph:GetNodes() do
			if node:GetClassID() == GetClassID("Star") then
				node:StopSpin()
			end
		end		
	end
	
end

function MAP0:MapEncounter(starObj)

	self.cancel_movement = 1
	self.dest_star = starObj
	
	self.state = STATE_ENCOUNTER
	local x = starObj:GetX()
	local y = starObj:GetY()

	--_G.EncounterMessage(self,"[ENCOUNTER]", x,y)
	--LOG(string.format("big message 1 -  x=%d, y=%d",x,y))
	
	local offset = SCREENS.MapMenu:GetViewOffset()
	x = -offset.x + _G.SCREEN_WIDTH/2
	y = -offset.y + _G.SCREENHEIGHT/2
	
	
	--LOG(string.format("big message 2 -  x=%d, y=%d",x,y))
	--Get Center of Screen in world coords
	_G.EncounterMessage(self,"[ENCOUNTER]", x,y)

	Gamepad.Rumble(PlayerToUser(1), 0.5, 450)
		
	local e = GameEventManager:Construct("MapEncounter")
	PlaySound("snd_alarm")
	GameEventManager:SendDelayed(e,self,GetGameTime()+2000)
	
end



function MAP0:OnEventMapEncounter(event)
	LOG("OnEventSetEncounter()")
	self:OnActionStar(self.dest_star,_G.ALERT_ENCOUNTER)
	
end





function MAP0:OnActionStar(star,alertEncounter)
	LOG("OnActionStar "..star.classIDStr)
	LOG("Curr Star "..self.curr_star.classIDStr)
	SCREENS.MapMenu:ChangeSystemInfo(star,SCREENS.SystemInfoMenu)
	if _G.Hero:HasMovementController() then--if moving --set new dest star
		if self.dest_star ~= star then--Allow double click on destination system
			self.state = _G.STATE_FLIGHT
			if star.hacked then
				PlaySound("snd_shipdepart") --BORT: Ship redirect mid-flight
			end
			LOG("Moving = Cancel Current Movement")
			self.cancel_movement = 1
		end			
	elseif self.curr_star == star and (self.state == _G.STATE_IDLE or self.state ==_G.STATE_ENCOUNTER) then			
		LOG("OpenSystem")
		PlaySound("snd_mapmenuclick")	
		SCREENS.MapMenu:OpenSystem(alertEncounter)
	elseif self.state == _G.STATE_IDLE then
		LOG(string.format("Setpath %s to %s",self.curr_star.classIDStr,star.classIDStr))			
		self:UnHighlightPath(self.path)					
		self.path = GetPath(self.graph, self.curr_star, star, _G.SCREENS.MapMenu:GetPathValidation())
		if type(self.path) ~= "table" then
			LOG("not table "..tostring(self.path))
		elseif #self.path > 0 then
			LOG("#self.path>0")
			_G.Hero.last_gate = self.path[1].classIDStr
			_G.Hero:SetAttribute("curr_loc",_G.Hero.last_gate)				
		
			self:HighlightPath(self.path)
			self.state = _G.STATE_FLIGHT
			GraphMovePath(_G.Hero, self.path, "Smooth")
			
			
			LOG("Set dest_star")
			self.dest_star = star
			if star.hacked then
				PlaySound("snd_shipdepart") --BORT: Ship depart from system
			else
				PlaySound("snd_illegal")
			end
		else
			PlaySound("snd_illegal")				
		end
	end
end

function MAP0:ArriveAtStar(star)
	LOG("ArriveAtStar "..star.classIDStr)
	self.curr_star = star

	SCREENS.MapMenu:UpdateStarPosition(star)
	
	if self.cancel_movement == 1 then
		LOG("Clear graph move")
		self:UnHighlightPath(self.path)
		ClearGraphMove(_G.Hero)
		self.path={}
		if self.state ~= _G.STATE_ENCOUNTER then
			self.state = _G.STATE_IDLE
		end
		self.cancel_movement = 0	
	end
end

function MAP0:ArriveAtEndStar()
	LOG("ArriveAtEndStar() ")
	if self.state ~= _G.STATE_ENCOUNTER then
		self.state = _G.STATE_IDLE		
	end
	if self.cancel_movement == 1 then
		LOG("getPath")
		--self.path = GetPath(self.graph, self.curr_star, self.dest_star, _G.SCREENS.MapMenu:GetPathValidation())
		LOG("HighLightPath")
		self:UnHighlightPath(self.path)
		self.path={}
		--HighlightPath(self.path)
		LOG("GraphMove")
		--GraphMovePath(_G.Hero, self.path, "Smooth")
		self.cancel_movement = 0	
	end
end



function MAP0:OnOverStar(star)
	--BEGIN_STRIP_DS
	local function OnOverStar()
		if not _G.Hero:HasMovementController() then
			self.path = GetPath(self.graph, self.curr_star, star, _G.SCREENS.MapMenu:GetPathValidation())
			self:HighlightPath(self.path)
			--local sprite = star:GetAttribute("sprite")
			if star.hacked then
				PlaySound("snd_butthover") --BORT: Hover over valid System
			end
		end	
		star:Spin()
		_G.GLOBAL_FUNCTIONS.DisplaySystemInfo(star,SCREENS.SystemInfoMenu)
	end
	_G.NotDS(OnOverStar)
	--END_STRIP_DS
end







return ExportClass("MAP0")
