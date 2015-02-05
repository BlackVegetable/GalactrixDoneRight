-------------------------------------------------------------------------------
--
--	TutorialMenu
--	
--
-------------------------------------------------------------------------------

use_safeglobals()

local string_format = string.format

-- name of stdlib file and conviently substring for individual tutorial lua files and xml files
local TUT_FILE_NAME = "Tutorials/Tutorial"  

import(TUT_FILE_NAME)

-------------------------------------------------------------------------------
--	TutorialMenu Class
-------------------------------------------------------------------------------

class "TutorialMenu" (Menu);

-------------------------------------------------------------------------------
-- __init()
function TutorialMenu:__init()
	super()
	--LOG("[TUTORIAL_MENU] initialised")
	LoadAssetGroup("AssetsTutorial")
	self:Initialize("Assets/Screens/TutorialMenu.xml")
	self:Parse()
end

-------------------------------------------------------------------------------
-- __finalize()
--function TutorialMenu:__finalize()
--	LOG("[TUTORIAL_MENU] collected, IsOpen:" .. tostring(self:IsOpen()))
--end

-------------------------------------------------------------------------------
-- OpenTarget(tutorialNumber, object)
--	tutorialNumber is the number of the tutorial you want to open
--	object is the GameObject the tutorial system uses to manage tutorials
function TutorialMenu:OpenTarget(tutorialNumber, object, callback)
	assert(tutorialNumber)
	LoadAssetGroup("AssetsTutorial")
	self.tutorialNumber = tutorialNumber
	self.object = object
	self.callback = callback
	self.step = 1
 	
	self:Open()
	
	
		
	-- setup the checkbox widget
	if self.object then
		if self.object:GetAttribute("show_tutorials") == 2 then
			self:set_widget_value("check_show", 1)
		else
			self:set_widget_value("check_show", 0)
		end
	else
		if SHOW_TUTORIALS == 1 then
			self:set_widget_value("check_show", 0)
		else
			self:set_widget_value("check_show", 1)
		end
	end

	-- load the tutorial data
	self.info = import(string_format("%s_%s", TUT_FILE_NAME, tutorialNumber))

	self:StepDisplay()
end

-------------------------------------------------------------------------------
-- OnButton(buttonID, clickX, clickY)
function TutorialMenu:StepDisplay()
	self:set_text("str_tut_num",	translate_text("[TUTORIAL:]") .. " " .. 
									self.step .. " / " .. 
									#self.info)
	open_custompopup_menu(self.info[self.step].format, self.info[self.step].data, self.info[self.step].x, self.info[self.step].y, self.info[self.step].facing, self.info[self.step].minWidth)
end

-------------------------------------------------------------------------------
-- OnButton(buttonID, clickX, clickY)
function TutorialMenu:OnButton(buttonID, clickX, clickY, up)
	if (buttonID == 10) then -- done
		close_custompopup_menu()
		CloseTutorialMenu(self.callback)
	elseif (buttonID == 5) then -- show all checkbox, toggle showing tutorials
		if self.object then
			if (self.object:GetAttribute("show_tutorials") == 1) then
				SetShowingTutorials(self.object, 2)
			elseif (self.object:GetAttribute("show_tutorials") == 2) then
				SetShowingTutorials(self.object, 1)
			end
		else
			if (_G.SHOW_TUTORIALS == 1) then
				_G.SHOW_TUTORIALS = 2
			elseif (_G.SHOW_TUTORIALS == 2) or (_G.SHOW_TUTORIALS == 0) then
				_G.SHOW_TUTORIALS = 1
			end
		end
	else	-- Unhandled message
		self:OnMouseLeftButton(1, 0, 0, true) -- close menu
		return Menu.MESSAGE_NOT_HANDLED
	end
	
	return Menu.MESSAGE_HANDLED
end

-------------------------------------------------------------------------------
-- OnButton(buttonID, clickX, clickY)
--	Captures clicks on the pad and cycles the popup display.
function TutorialMenu:OnMouseLeftButton(id, x, y, up)
	if  GetGameTime() - 2000 < self.time then
		return Menu.MESSAGE_HANDLED
	end
	
	if id == 1 and up then
		if self.step == #self.info then
			close_custompopup_menu()
			CloseTutorialMenu(self.callback)
		else
			self.step = self.step + 1
			self:StepDisplay()
		end
	end
	return Menu.MESSAGE_HANDLED
end

-------------------------------------------------------------------------------
-- OnGamepadButton(user_id, button_id, value)
--	Captures gamepad button presses and cycles the popup display.
function TutorialMenu:OnGamepadButton(user_id, button_id, value)
	if  GetGameTime() - 2000 < self.time then
		return Menu.MESSAGE_HANDLED
	end
	
	if value == 0 and button_id == _G.BUTTON_A then
		if self.step == #self.info then
			close_custompopup_menu()
			CloseTutorialMenu(self.callback)
		else
			self.step = self.step + 1
			self:StepDisplay()
		end
	elseif value == 1 and button_id == _G.BUTTON_X then
		if (self:get_widget_value("check_show") == 0) then
			self:set_widget_value("check_show", 1)
		else
			self:set_widget_value("check_show", 0)
		end
		self:OnButton(5)
	end
	return Menu.MESSAGE_HANDLED
end

-------------------------------------------------------------------------------
-- OnKey()
--	Does nothing but capture keypresses.
function TutorialMenu:OnKey()
	
	return Menu.MESSAGE_HANDLED
end

-------------------------------------------------------------------------------
-- OnOpen()
--	Load the text file
function TutorialMenu:OnOpen()
	--LOG("[TUTORIAL_MENU] opened")
	self.time = GetGameTime()
	add_text_file(string_format("%s_%s.xml", TUT_FILE_NAME, self.tutorialNumber))
	
			
	return Menu.OnOpen(self)
end


function TutorialMenu:OnAnimOpen()
	LOG("TutorialMenu:OnAnimOpen")
	if _G.is_open("PauseMenu") then
		SCREENS.PauseMenu:MoveToFront()
	end
end	


	


-------------------------------------------------------------------------------
-- OnClose()
--	Clear the pointers and unload the tutorial text file
function TutorialMenu:OnClose()
	--LOG("[TUTORIAL_MENU] Closed")
	
	remove_text_file(string_format("%s_%s.xml", TUT_FILE_NAME, self.tutorialNumber))

	self.tutorialNumber = nil
	self.object = nil
	self.callback = nil
	self.step = nil
	self.time = nil
	_G.SHOWING_TUTORIAL = false
	
	UnloadAssetGroup("AssetsTutorial")
	
	if _G.Hero and _G.Hero.SetToSave then
		_G.Hero:SetToSave()
	end
	
--	SCREENS.TutorialMenu = nil
	return Menu.OnClose(self)
end

return ExportSingleInstance("TutorialMenu")
