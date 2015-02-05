
use_safeglobals()

-- declare menu

class "InvCrew" (Menu);

function InvCrew:__init()
	super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\InvCrew.xml")
end


function InvCrew:OnOpen()
	LOG("InvCrewMenu opened");

	self.lastTime = GetGameTime()
	for i=1,6 do
		self:set_text("str_crew"..i, "")
		self:set_image("img_crew"..i, "")
	end

	self:hide_widget("img_frame_selected")
	self:hide_widget("img_crew_selected_bg")	
	
	self:set_text_raw("str_crew_selected_name", "")
	self:set_image("img_crew_selected", "")
	local numCrew = math.min(SCREENS.InventoryFrame.hero:NumAttributes("crew"), 6)
	for i=1,numCrew do
	   local crewID = SCREENS.InventoryFrame.hero:GetAttributeAt("crew", i)
		self:set_text(string.format("str_crew%d",i), CREW[crewID].name)
		self:set_image(string.format("img_crew%d",i), CREW[crewID].portrait)
	end
	
	if IsGamepadActive() then
		if SCREENS.InventoryFrame.hero:NumAttributes("crew") == 0 then
			self:hide_widget("grp_gp")
		else
			self:activate_widget("icon_gp_cursor")
			self.selectedIndex = 1
			self:set_widget_position("icon_gp_cursor", 195, 194)
		end
	else
		self:hide_widget("grp_gp")
	end
	
	_G.ShowTutorialFirstTime(16, _G.Hero)
	
	return Menu.MESSAGE_HANDLED
end

function InvCrew:MouseOverCrew(id, x, y)
	 if id <= SCREENS.InventoryFrame.hero:NumAttributes("crew") then
	 	PlaySound("snd_mapmenuclick")
		local crew = SCREENS.InventoryFrame.hero:GetAttributeAt("crew", id)
		
		local x_offset = 195 + ((id-1) * 224)
		if id > 3 then
			x_offset = x_offset - 672
		end
		local y_offset = math.floor((id-1)/3) * 224 + 172
		local strings = { race = translate_text("[RACE]") .. ": " .. translate_text(CREW[crew].race),
						  gender = translate_text("[GENDER]") .. ": " .. translate_text(CREW[crew].gender),
								age = translate_text("[AGE]") .. ": " .. translate_text(CREW[crew].age),
								desc = translate_text(CREW[crew].description) }
		self:ShowCrew(crew,strings,x_offset+x,y_offset+y)
	end
end

function InvCrew:OnGamepadDPad(user, dpad, x, y)
	if not self.selectedIndex then
		return Menu.MESSAGE_HANDLED
	end
	
	local increment = 0
	if x == 0 and y == 0 then
		return Menu.MESSAGE_NOT_HANDLED
	end
	
	if x ~= 0 then
		increment = increment + x
	end
	if y ~= 0 then
		increment = increment - (y*3)
	end
	
	if self.selectedIndex + increment > 0 and self.selectedIndex + increment <= SCREENS.InventoryFrame.hero:NumAttributes("crew") then
		self.selectedIndex = self.selectedIndex + increment
		LOG(string.format("X =  %d  Y = %d", 195 + (224 * math.mod(self.selectedIndex - 1, 3)), 194 + (224*math.floor((self.selectedIndex-1)/3))))
		self:set_widget_position("icon_gp_cursor", 195 + (224 * math.mod(self.selectedIndex - 1, 3)), 194 + (224*math.floor((self.selectedIndex-1)/3)))
		if self.showInfo then
			close_custompopup_menu()
			self:MouseOverCrew(self.selectedIndex, 0, 0)
		end
		PlaySound("snd_mapmenuclick")
		return Menu.MESSAGE_HANDLED
	end
	
	return Menu.MESSAGE_NOT_HANDLED
end

function InvCrew:OnGamepadJoystick(user, joystick, x_dir, y_dir)
	if self.lastTime < GetGameTime() - 250 then
		local x = 0
		local y = 0

		if x_dir >= 100 then
			x = 1
		elseif x_dir <= -100 then
			x = -1
		end
		
		if y_dir >= 100 then
			y = 1
		elseif y_dir <= -100 then
			y = -1
		end
		
		if x ~= 0 or y ~= 0 then
			self:OnGamepadDPad(user, 0, x, y)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvCrew:OnGamepadButton(user, button, value)
	if not self.selectedIndex then
		return Menu.MESSAGE_NOT_HANDLED
	end
	
	if value == 0 and button == _G.BUTTON_Y then
		PlaySound("snd_buttclick")
		self.showInfo = not self.showInfo
		if self.showInfo then
			self:MouseOverCrew(self.selectedIndex, 0, 0)
		else
			close_custompopup_menu()
		end
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

dofile("Assets/Scripts/Screens/InvCrewPlatform.lua")


-- return an instance of InvCrew
return ExportSingleInstance("InvCrew")
