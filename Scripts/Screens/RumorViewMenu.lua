
use_safeglobals()

class "RumorViewMenu" (Menu);

function RumorViewMenu:__init()
	super()

	self:Initialize("Assets\\Screens\\RumorViewMenu.xml")
end

function RumorViewMenu:OnOpen()
	add_text_file("RumorText.xml")
	self:set_text("str_title", "[RUMOR_TEST]")
	self:set_text("str_heading", "[RUMOR_HEADING]")
	self.selectedRumor = 0
	self.lastTime = GetGameTime()
	
	if IsGamepadActive() then
		 MenuSystem.SetGamepadWidget(self, "list_quests")
	end
	return Menu.MESSAGE_HANDLED
end

function RumorViewMenu:OnClose()
	remove_text_file("RumorText.xml")
	return Menu.MESSAGE_HANDLED
end

function RumorViewMenu:CreateList()
	LOG("CreateList")

	if IsGamepadActive() then
		self:set_listbox_hover("list_quests", false)
	else
		self:set_listbox_hover("list_quests", true)
	end
	self:reset_list("list_quests")
	    
    self.maxListValue = _G.Hero:NumAttributes("unlocked_rumors")
	
    for i,rumorId in IterateCollection(_G.Hero, "unlocked_rumors") do
        self:set_list_option("list_quests", translate_text("["..rumorId.."_TITLE]"))
    end
    
    if _G.Hero:NumAttributes("unlocked_rumors") > 0 then
		self:SetCurrentRumor(1)
		self:set_list_value("list_quests", 1)
    end
end

function RumorViewMenu:OnListbox(id, item)
	if id == self:get_widget_id("list_quests") then
		self:SetCurrentRumor(item+1)
	end
	 
	return Menu.MESSAGE_HANDLED
end

function RumorViewMenu:SetCurrentRumor(n)
	self.selectedRumor = n
	self:set_text("str_rumor", translate_text("[".._G.Hero:GetAttributeAt("unlocked_rumors", self.selectedRumor).."_TEXT]"))
end
	
function RumorViewMenu:OnGainFocus()
	--close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end
	
function RumorViewMenu:OnLoseFocus()
	return Menu.MESSAGE_NOT_HANDLED
end

function RumorViewMenu:OnButton(buttonId, clickX, clickY)

	if (buttonId == 1) then
		-- Cancel
		self:Close();
	end
	
	return Menu.MESSAGE_HANDLED;
end

function RumorViewMenu:OnGamepadDPad(user, dpad, x, y)

	if y ~= 0 then
		local newRumor = self.selectedRumor + y
		if newRumor >= 1 and newRumor <= self.maxListValue then
			PlaySound("snd_mapmenuclick")
			self:SetCurrentRumor(newRumor)
			self:set_list_value("list_quests", newRumor)
		end
	end
	
	return Menu.MESSAGE_HANDLED;
end

function RumorViewMenu:OnTimer(time)
	
	local rumor = self:get_list_value("list_quests")
	if self.selectedRumor ~= rumor then
		self:SetCurrentRumor(rumor)
	end
	return Menu.MESSAGE_HANDLED
end


-- return an instance of RumorViewMenu
return ExportSingleInstance("RumorViewMenu")
