-- declare menu
class "MiniMapMenu" (Menu);

function MiniMapMenu:__init()
	super()
	
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\MiniMapMenu.xml")
	self.starSystem = nil
end


function MiniMapMenu:OnOpen()

	local function IsPrimaryQuest(id)
		local chapter = string.sub(id,3,3)
		if chapter == "0" or chapter == "1" or chapter == "2" or chapter == "3" or chapter == "4" then
			return true
		end
		return false
	end
		
	-- Set up the star colors
	for s,list in pairs(_G.DATA.StarTable) do
		local faction = _G.STARS.AllStars[s].faction
		local standing = _G.Hero:GetFactionStanding(faction)
		local widget = "icon_"..s
		
		local unknown   = true
		local strbyte	= string.byte
		local codeJ		= strbyte("J")
		for i,j in pairs(list) do
			if strbyte(j)==codeJ then	
				if _G.Hero:IsGateHacked(j) then
					unknown = false
					break
				end			
			end
		end
		
		if unknown then
			self:set_image(widget, "img_mmb_unknown")	
		elseif standing < _G.STANDING_NEUTRAL then
			self:set_image(widget, "img_mmb_enemy")			
		elseif standing > _G.STANDING_NEUTRAL then
			self:set_image(widget, "img_mmb_friend")			
		else
			self:set_image(widget, "img_mmb_neutral")			
		end
	end
	
	-- Set up blocked jumpgate icons
	for s,list in pairs(_G.DATA.JumpGatesTable) do
		local widget = "icon_"..s
		if _G.Hero:IsGateHacked(s) then
			self:set_image(widget, "img_blank")
		else
			self:set_image(widget, "img_mmb_blocked")
		end
	end
	
	-- Set up current position
	local star_id = _G.Hero:GetAttribute("curr_system")
	local fpx = _G.STARS.AllStars[star_id].xpos
	local fpy = 2048 - _G.STARS.AllStars[star_id].ypos
	if fpx == 0 and fpy == 0 then
		self:hide_widget("icon_me")
	else
		self:activate_widget("icon_me")
		fpx = math.ceil( (fpx*448)/2048 + 32 ) - 16
		fpy = math.ceil( (fpy*448)/2048 + 13 ) - 16 - 16
		self:set_widget_position("icon_me",   fpx,  fpy)
	end
	self.starSystem = star_id
	
	
	-- Set up quest destinations
	local valid_destinations = {}
	local numDestinations = 0
	local quest_idloc = GetQuestIdsAndObjectiveLocations(_G.Hero)
	local keys={}
	--creates list of quest locations
	--primary will overwrite secondary
	for s,list in pairs(quest_idloc) do
		if _G.STARS.AllStars[list[2]] then
			if IsPrimaryQuest(list[1])  then
				keys[list[2]]=1
				valid_destinations[list[2]]= list
			elseif not keys[list[2]] then
				keys[list[2]]=2
				valid_destinations[list[2]]= list
			end
		end
	end	
	numDestinations = #valid_destinations
	for i = 1, 8 do
		if i > numDestinations then
			self:hide_widget("icon_point"..tostring(i))--hide any unused widgets
		else
			self:activate_widget("icon_point"..tostring(i))			
		end
	end
	local counter = 0
	for i,v in pairs(valid_destinations) do
		counter = counter + 1
		if counter > 8 then--limit widgets drawn to 8
			break
		end
		local list = v
		local fpx = _G.STARS.AllStars[i].xpos
		local fpy = 2048 - _G.STARS.AllStars[i].ypos
 		fpx = math.ceil( (fpx*448)/2048 + 32 ) - 16
		fpy = math.ceil( (fpy*448)/2048 + 13 ) - 16 - 16

		local ico = "icon_point"..tostring(counter)
		self:set_widget_position(ico, fpx, fpy)
		self:activate_widget(ico)
	end		
	
	for i = counter+1, 8 do
		self:hide_widget("icon_point"..tostring(i))--hide any unused widgets
	end	
	
	
	
	return Menu.OnOpen(self)
end

function MiniMapMenu:OnButton(buttonId, clickX, clickY)
	       
    if (buttonId == 0) then
        -- Done
        self:Close()
    end
    
    return Menu.OnButton(self, buttonId, clickX, clickY)
end

function MiniMapMenu:OnTimer(time)
	local star_id = _G.Hero:GetAttribute("curr_system")
	if self.starSystem ~= star_id then
		self:OnOpen()
	end
	return Menu.MESSAGE_HANDLED
end




-- return an instance of MPJoinMenu
return ExportSingleInstance("MiniMapMenu")