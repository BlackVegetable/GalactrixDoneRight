----------------------------------------------------------------------
-- GetQuestsMenu
-- A dialog from which the user can create and name a new pet
----------------------------------------------------------------------

use_safeglobals()

class "GetQuestsMenu" (Menu);

--local NeoCharacterManager = import "NeoCharacterManager"

local firstUpdate
local petCode
local editorString

local src
local menuList


----------------------------------------------------------------------
-- __init()
--
-- Loads the xml spec for the screen, which causes widgets to be 
-- added and animations to be parsed and added.
----------------------------------------------------------------------
function GetQuestsMenu:__init()

	super()

	self:Initialize("Assets\\Screens\\GetQuestsMenu.xml")
   
end


----------------------------------------------------------------------
-- OnOpen()
--
-- Just run an update for now
----------------------------------------------------------------------
function GetQuestsMenu:OnOpen()
	
	LOG("GetQuestsMenu:OnOpen")
	
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	
	self:CreateList(self.satellite)
	
	if not IsGamepadActive() then
		self:hide_widget("grp_gp")
	end
	
	return Menu.OnOpen(self)

end

function GetQuestsMenu:Open(satellite)
	
	LOG("GetQuestsMenu:Open()")
	
	assert(satellite, "Open no satellite")
	
	self.satellite = satellite
	
	
	return Menu.Open(self)

end


local function IsPrimaryQuest(id)
	local chapter = string.sub(id,3,3)
	if chapter == "0" or chapter == "1" or chapter == "2" or chapter == "3" or chapter == "4" then
		return true
	end
	return false
end


--[[
function GetQuestsMenu:OnListbox(id, item)
	
	return Menu.MESSAGE_HANDLED
end
--]]

----------------------------------------------------------------------
-- CreateList()
--
----------------------------------------------------------------------
function GetQuestsMenu:CreateList(site)
	LOG("GetQuestsMenu:CreateList")

	
	self.site = site
	if IsGamepadActive() then
		self:set_listbox_hover("list_quests", false)
	else
		self:set_listbox_hover("list_quests", true)
	end
	self:reset_list("list_quests")
		
	--self.questActionList = GetAvailableQuestsAtLocation( _G.Hero, site.classIDStr )
	self.questActionList = site:GetQuestsActions(true)--true gets available quests only --false/nil gets actions also
	
	LOG("GetAvailableQuestsAt "..site.classIDStr)
	local availableQuests = {}
	local primaryQuests = {}
	local sideQuests = {}
	self.disabledQuests = {}
	self.questList = {}
	for k,v in pairs(self.questActionList) do

		if not QUESTS[v]:MeetsPreconditions(_G.Hero) then
			self.disabledQuests[v]=true
		elseif IsPrimaryQuest(v) then
			table.insert(primaryQuests,v)
		else
			table.insert(sideQuests,v)
		end
	end
	
	
	for k,v in pairs(primaryQuests) do
		table.insert(self.questList,v)
		self:set_list_option("list_quests","[" .. v .. "_TITLE]")		
	end
	
	for k,v in pairs(sideQuests) do
		table.insert(self.questList,v)
		self:set_list_option("list_quests","[" .. v .. "_TITLE]")
	end
	
	for v,_ in pairs(self.disabledQuests) do
		table.insert(self.questList,v)
		self:set_list_option("list_quests",translate_text("[" .. v .. "_TITLE]")..translate_text("[UNAVAILABLE]"))	
		self:set_list_option_disabled("list_quests",translate_text("[" .. v .. "_TITLE]")..translate_text("[UNAVAILABLE]"))		
	end			
	
	
	

	

end





function GetQuestsMenu:OnGamepadDPad(user, dpad, x, y)
	
	if y ~= 0 then
		local curr_selection = self:get_list_value("list_quests")
		LOG("curr_selection "..tostring(curr_selection))
		if y == 1 then--Up
			curr_selection = curr_selection -1
			if curr_selection < 1 then
				curr_selection = self:get_list_option_count("list_quests")
			end
		elseif y==-1 then
			curr_selection = curr_selection + 1
			if curr_selection > self:get_list_option_count("list_quests") then
				curr_selection = 1
			end	
		end
		
	
		LOG("curr_selection "..tostring(curr_selection))
		self:set_list_value("list_quests",curr_selection)
	end
	
	return Menu.MESSAGE_HANDLED
end





function GetQuestsMenu:SelectQuest()
	local questNum = self:get_list_value("list_quests")
	if self.questList[questNum] ~= nil and not self.disabledQuests[self.questList[questNum]] then
		LOG("STARTING QUEST, index: " .. tostring(questNum) .. " result: " .. self.questList[questNum])
		SCREENS.QuestStartMenu:Open()
		SCREENS.QuestStartMenu:SetSource(self)	
		SCREENS.QuestStartMenu:SetQuest(self.questList[questNum])

		return Menu.MESSAGE_HANDLED
	end	
	
end



function GetQuestsMenu:OnGamepadButton(user, button, val)
	LOG("OnGamePadButton")
	if val == 0 and button == _G.BUTTON_B then
		-- close popup
		_G.CallScreenSequencer("GetQuestsMenu", "SolarSystemMenu")
	elseif val == 0 and button == _G.BUTTON_A then
		LOG("Gamepad button A pressed")
		self:SelectQuest()
	end
	
	return Menu.MESSAGE_HANDLED
end

----------------------------------------------------------------------
-- OnListbox()
--
----------------------------------------------------------------------
function GetQuestsMenu:OnListbox(id, item)

	--item = item + 1
	--LOG("OnListBox "..tostring(item))
	PlaySound("snd_mapmenuclick")

	local itemValue = self:get_list_option("list_quests")
	if id == self:get_widget_id("list_quests") then
		self:SelectQuest()
	end

	return Menu.MESSAGE_HANDLED
end


----------------------------------------------------------------------
-- OnButton()
--
-- Handles button presses and opens the appropriate screen
-- Param: buttonID - id of the button pressed
-- Param: clickX - X coord in pixels of mouse at time of click
-- Param: clickY - Y coord in pixels of mouse at time of click
-- Returns: itself
----------------------------------------------------------------------
function GetQuestsMenu:OnButton(buttonId, clickX, clickY)

	if (buttonId == -1) then
		-- Cancel
		SCREENS.QuestStartMenu:Close()
		--self:Close();
		_G.CallScreenSequencer("GetQuestsMenu", "SolarSystemMenu")		

	elseif (buttonId == 0) then
		self:SelectQuest()

	end
	
	--return Menu.OnButton(self, buttonId, clickX, clickY)
	return Menu.MESSAGE_HANDLED;
end


function GetQuestsMenu:OnClose()
	
	return Menu.OnClose(self)
end


----------------------------------------------------------------------
-- OnKey()
--
----------------------------------------------------------------------
function GetQuestsMenu:OnKey(key)
	return Menu.OnKey(self, key)
end


-- return an instance of GetQuestsMenu
return ExportSingleInstance("GetQuestsMenu")
