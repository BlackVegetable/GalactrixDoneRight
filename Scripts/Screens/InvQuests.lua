
use_safeglobals()

-- declare menu

class "InvQuests" (Menu);

local selectedQuest

function InvQuests:__init()
	super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\InvQuests.xml")
end


function InvQuests:OnOpen()
	LOG("InvQuestsMenu opened");

	self:RefreshList()
	self:OnMouseLeftButton(1, 0, 0, 0)
	
	self.lastTime = GetGameTime()
	if IsGamepadActive() then
		if SCREENS.InventoryFrame.hero:NumAttributes("running_quests") > 0 then
			self.selectedIndex = 1
		end
	end
	
	_G.ShowTutorialFirstTime(18, _G.Hero)
	return Menu.OnOpen(self)
end

function InvQuests:OnGamepadDPad(user, dpad, x, y)
	local numQuests = SCREENS.InventoryFrame.hero:NumAttributes("running_quests")
	if y ~= 0 and self.selectedIndex and numQuests > 1 then
		self.selectedIndex = self.selectedIndex - y
		if self.selectedIndex <= 0 then
			self.selectedIndex = numQuests
		elseif self.selectedIndex > numQuests then
			self.selectedIndex = 1
		end
		self:OnMouseLeftButton(self.selectedIndex, 0, 0, false)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvQuests:OnGamepadJoystick(user, joystick, x_dir, y_dir)
	if self.lastTime < GetGameTime() - 250 then
		if y_dir >= 100 then
			self:OnGamepadDPad(user, 0, 0, 1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		elseif y_dir <= -100 then
			self:OnGamepadDPad(user, 0, 0, -1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvQuests:OnGamepadButton(user, button, value)
	if selectedQuest and (button == _G.BUTTON_X) and (value == 1) and _G.QUESTS[selectedQuest].can_abandon then
		PlaySound("snd_buttclick")
		self:OnButton(20,0,0)
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvQuests:OnMouseLeftButton(id, x, y, up)

	
	local questId
	local questState
	if id <= _G.Hero:NumAttributes("running_quests") then
		questState = _G.Hero:GetAttributeAt("running_quests",id)
		questId = questState:GetQuestID()
	end
	selectedQuest = questId
	
	
	
	if questId then
		for i=1,4 do
			if not up then
				PlaySound("snd_mapmenuclick")
			end
			self:set_font(string.format("str_mission%d", i), "font_info_white")
			self:set_font(string.format("str_mission%d_val", i), "font_info_white")	
		end	
		self:SelectQuest(questState) 

		self:set_font(string.format("str_mission%d", id), "font_info_red")
		self:set_font(string.format("str_mission%d_val", id), "font_info_red")
		
		--BEGIN_STRIP_DS
		WiiOnly(self.set_font, self, string.format("str_mission%d", id), "font_info_blue")
		WiiOnly(self.set_font, self, string.format("str_mission%d_val", id), "font_info_blue")
		--END_STRIP_DS
		
	end

	return Menu.MESSAGE_HANDLED
end

-- displays the information for a quest
function InvQuests:SelectQuest(quest)
	local objectivesList = quest:GetObjectives()
	self:set_text("str_currmission_title", string.format("[%s_TITLE]", selectedQuest))
	self:set_text("str_currmission_desc",  string.format("[%s_DESC]",  selectedQuest))
	if objectivesList[1] and objectivesList[1].log_text then
		self:set_text("str_currmission_action", objectivesList[1].log_text)
		self:activate_widget("str_currmission_action")
	else
		self:hide_widget("str_currmission_action")
	end
	self:activate_widget("icon_mission")
	self:activate_widget("str_currmission_title")
	self:activate_widget("str_currmission_desc")
	if _G.QUESTS[selectedQuest].can_abandon then
		self:activate_widget("butt_abandonquest")
		self:activate_widget("icon_abandonquest")
		self:activate_widget("str_abandonquest")
	else
		self:deactivate_widget("butt_abandonquest")
		self:hide_widget("icon_abandonquest")
		self:hide_widget("str_abandonquest")
	end
end

-- Refresh the list of available quests.
function InvQuests:RefreshList()
	for i=1,4 do
		self:set_text_raw(string.format("str_mission%d_val", i), " -")
		self:set_font(string.format("str_mission%d_val", i), "font_info_white")
		self:set_font(string.format("str_mission%d", i), "font_info_white")
	end
	self:hide_widget("icon_mission")
	self:hide_widget("str_currmission_title")
	self:hide_widget("str_currmission_desc")
	self:hide_widget("str_currmission_reward")
	self:hide_widget("str_currmission_action")
	self:deactivate_widget("butt_abandonquest")		
	self:hide_widget("icon_abandonquest")
	self:hide_widget("str_abandonquest")
	
	local questList = GetRunningQuests(SCREENS.InventoryFrame.hero)
	if questList[1] then
		selectedQuest = questList[1]
		self:SelectQuest(_G.Hero:GetAttributeAt("running_quests",1))
		self:set_font("str_mission1", "font_info_red")
		self:set_font("str_mission1_val", "font_info_red")		
	end
	
	for k,id in ipairs(questList) do
		local title = string.format("[%s_TITLE]", QUESTS[id].id)
		if k <= 4 then
		self:set_text(string.format("str_mission%d_val", k),title)
		else
			break
		end
	end
end

function InvQuests:OnButton(buttonId, clickX, clickY)
	       
   if (buttonId == 20) then
		-- Abandon Quest
		PlaySound("snd_click")
		local function ConfirmAbandon(yes_clicked)
			if yes_clicked then
				if _G.is_open("MapMenu") then
					SCREENS.MapMenu:RemoveQuestMarker(selectedQuest)
					--SCREENS.MapMenu:UpdateUI()
				end					
				AbandonQuest(SCREENS.InventoryFrame.hero, selectedQuest)
				
				if _G.is_open("MapMenu") then
					SCREENS.MapMenu:UpdateUI()
					--SCREENS.MapMenu:UpdateUI()
				end						
							
				self:RefreshList()
			
				_G.Hero:SetToSave()				
			end
		end
		
		open_yesno_menu("[ABANDON]", "[ABANDON_MISSION_QUERY]", ConfirmAbandon, "[YES]", "[NO]" )	
		
		return Menu.MESSAGE_HANDLED
	end
    
    return Menu.MESSAGE_NOT_HANDLED
end

-- return an instance of InvQuests
return ExportSingleInstance("InvQuests")