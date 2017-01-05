-- declare our menu
class "CreateHeroMenu" (Menu);

function CreateHeroMenu:__init()
	super()
	LOG("CreateHeroMenu:Init()")
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\CreateHeroMenu.xml")

	self.baseHeroText = "H00"


	self:PlatformVars()
end

function CreateHeroMenu:Open(slot)
	LOG("CreateHeroMenu:Open()")
	self.slot = 1
	if slot then
		LOG("in slot " .. tostring(slot))
		self.slot = slot
	end
	return Menu.Open(self)
end

function CreateHeroMenu:OnOpen()
	LOG("CreateHeroMenu:OnOpen")

	self:DisplayHero()

	--self:unfocus_editor("edit_name")
	self:activate_editor("edit_name")

	_G.DONT_SAVE = false -- if you're in the process of creating a new hero, don't save should be reset

	self.SHIFT = false
	self.CAPSLOCK  = false

	self:activate_editor("edit_name")

	if IsGamepadActive() then
		self:hide_widget("butt_portraitprev")
		self:hide_widget("butt_portraitnext")
	else
		self:hide_widget("icon_gp_l")
		self:hide_widget("icon_gp_r")
	end

	return Menu.OnOpen(self)
end

function CreateHeroMenu:OnAnimOpen(data)
	Graphics.FadeFromBlack()
end


function CreateHeroMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end
	self:activate_editor("edit_name")

	if self.continue and time - self.starttime > 2000 then
		local function continue()
			_G.CallScreenSequencer("CreateHeroMenu", "SinglePlayerMenu")
		end

		_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, continue)
	end

	return Menu.MESSAGE_HANDLED
end






function CreateHeroMenu:OnButton(buttonId, clickX, clickY)
	LOG("CreateHeroMenu:OnButton "..tostring(buttonId))

	if (buttonId == 0) then
		-- Cancel
		--self:Close();
		local saves = _G.GLOBAL_FUNCTIONS.EnumerateSaves(1)  --SaveGameManager.Enumerate()

		local saveNum = #saves

		for k,v in pairs(saves) do
			if (k==1 and v=="Empty 1") or (k==2 and v=="Empty 2") then
				saveNum = saveNum - 1
			end
		end

		if _G.GLOBAL_FUNCTIONS.CheckSaveData() then
			Graphics.FadeToBlack()
			if saveNum > 0 then
				_G.CallScreenSequencer("CreateHeroMenu", "SelectHeroMenu", "CreateHeroMenu")
			else
				_G.CallScreenSequencer("CreateHeroMenu", "MainMenu")
			end
		end

	elseif (buttonId == 1) then
		local newHeroName = self:get_text("edit_name")

		if not _G.ValidName(newHeroName) then
			open_message_menu("[INVALID_NAME]", "[INVALID_HERO_NAME]", nil)

			return Menu.MESSAGE_HANDLED
		end
		-- blank hero
		if _G.Hero then
			_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(_G.Hero)
			_G.Hero = nil
		end
		_G.Hero = _G.GLOBAL_FUNCTIONS.LoadHero.LoadHero(self.baseHeroText..tostring(self.heroSelect))
		_G.Hero:SetAttribute("name",newHeroName)
		_G.Hero:SetToSave()--initial save
		LOG("Created Hero".._G.Hero:GetAttribute("name"))



		AddAvailableQuest(_G.Hero,"Q000")
		AddAvailableQuest(_G.Hero,"Q30a")

		-- For testing, gives the first 12 plans
		--[[
		for i=1, 12 do
			_G.Hero:PushAttribute("plans", string.format("I0%02d", i))
			LOG(string.format("Gave plans I0%02d", i))
		end
		]]

		_G.Hero.slot = self.slot


		self:FirstSaveHero()
		LOG("Created Hero")

	elseif (buttonId == 30) then--prev
		self.heroSelect = self.heroSelect-1
		if self.heroSelect < 1 then
			self.heroSelect = 4
		end
		self:DisplayHero()
		--self:hide_widget("butt_portraitprev")
		--self:activate_widget("butt_portraitnext")
		-- Prev
	elseif (buttonId == 31) then--next
		self.heroSelect = self.heroSelect+1
		if self.heroSelect > 4 then
			self.heroSelect = 1
		end
		--self:hide_widget("butt_portraitnext")
		--self:activate_widget("butt_portraitprev")
		--end
		self:DisplayHero()
		-- Next

	elseif (buttonId == 40) then--prev
		self.heroSelect = 1
		self:DisplayHero()
		--self:hide_widget("butt_portraitprev")
		--self:activate_widget("butt_portraitnext")
		-- Prev
	elseif (buttonId == 41) then--next
		self.heroSelect = 2
		--self:hide_widget("butt_portraitnext")
		--self:activate_widget("butt_portraitprev")
		--end
		self:DisplayHero()
		-- Next

	elseif (buttonId == 11) then
			-- open the keyboard
			self:StartAnimation("open_keypad")
			return Menu.MESSAGE_HANDLED

	elseif (buttonId >= 100 and buttonId < 400) then
		-- alpha buttons
		LOG("Alpha Buttons "..tostring(buttonId))
		local change = self:get_text("edit_name")
		if string.len(change) >= 11 then
			return Menu.MESSAGE_HANDLED
		end
		subtract = 100

		if self.SHIFT then
			subtract = subtract+32
		end

		change = change .. string.format('%c', (buttonId-subtract))


		self:set_text_raw("edit_name", change)

		if self.SHIFT then
			self:DoShift()
		end

		return Menu.MESSAGE_HANDLED

	elseif (buttonId == 1000) then
		-- SPACEBAR
		local change = self:get_text("edit_name")
		if string.len(change) >= 11 then
			return Menu.MESSAGE_HANDLED
		end
		change = change .. " "
		self:set_text_raw("edit_name", change)
		return Menu.MESSAGE_HANDLED

	elseif (buttonId >= 500 and buttonId < 600) then
		-- num buttons
		if(self.SHIFT == false)then
			local change = self:get_text("edit_name")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end
			change = change .. buttonId-500
			self:set_text_raw("edit_name", change)
		else
			local change = self:get_text("edit_name")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end

			if(buttonId == 501)then
				change = change .. "!"
			elseif(buttonId == 502)then
				change = change .. "@"
			elseif(buttonId == 503)then
				change = change .. "#"
			elseif(buttonId == 504)then
				change = change .. "$"
			elseif(buttonId == 505)then
				change = change .. "%"
			elseif(buttonId == 506)then
				change = change .. "^"
			elseif(buttonId == 507)then
				change = change .. "&"
			elseif(buttonId == 508)then
				change = change .. "*"
			elseif(buttonId == 509)then
				change = change .. "("
			elseif(buttonId == 500)then
				change = change .. ")"
			end

			self:set_text_raw("edit_name", change)
			self:DoShift()
		end
		return Menu.MESSAGE_HANDLED

	elseif (buttonId >= 700 and buttonId < 800) then
		-- symbol buttons
		if(self.SHIFT == false)then
			local change = self:get_text("edit_name")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end
			change = change .. string.format('%c', (buttonId-700))
			self:set_text_raw("edit_name", change)
		else
			local change = self:get_text("edit_name")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end

			if(buttonId == 796)then
				change = change .. "~"
			elseif(buttonId == 745)then
				change = change .. "_"
			elseif(buttonId == 761)then
				change = change .. "+"
			elseif(buttonId == 791)then
				change = change .. "{"
			elseif(buttonId == 793)then
				change = change .. "}"
			elseif(buttonId == 792)then
				change = change .. "|"
			elseif(buttonId == 759)then
				change = change .. ":"
			elseif(buttonId == 739)then
				change = change .. "\""
			elseif(buttonId == 744)then
				change = change .. "<"
			elseif(buttonId == 746)then
				change = change .. ">"
			elseif(buttonId == 747)then
				change = change .. "?"
			end

			self:set_text_raw("edit_name", change)
			self:DoShift()
		end
		return Menu.MESSAGE_HANDLED

	end

	-- functionality buttons
	if(buttonId == 801 or buttonId == 1801)then
		--BACKSPACE - delete a letter
		local change = self:get_text("edit_name")
		change = string.sub(change, 1, string.len(change)-1)
		self:set_text_raw("edit_name", change)
		return Menu.MESSAGE_HANDLED
	end

	if(buttonId == 802 or buttonId == 805)then
		--ENTER - close the keypad
		self:StartAnimation("close_keypad")
		return Menu.MESSAGE_HANDLED
	end

	if(buttonId == 803)then
		--SHIFT

		self:DoShift()

		return Menu.MESSAGE_HANDLED
	end

	if(buttonId == 804)then
		--CAPSLOCK
		if(self.SHIFT)then
			self.CAPSLOCK = false
		else
			self.CAPSLOCK = true
		end

		self:DoShift()
		return Menu.MESSAGE_HANDLED
	end

	if(buttonId == 999)then

		self.CAPSLOCK = false
		self.SHIFT = true
		self:DoShift()


		if self.accented then
			self:set_alpha("grp_keypad_accented", 0.0)
			self:deactivate_widget("grp_keypad_accented")
			self:activate_widget("grp_keypad_alpha")
			self:set_alpha("grp_keypad_alpha", 1.0)
			self.accented = false
		else
			self:set_alpha("grp_keypad_alpha", 0.0)
			self:deactivate_widget("grp_keypad_alpha")
			self:activate_widget("grp_keypad_accented")
			self:set_alpha("grp_keypad_accented", 1.0)
			self.accented = true
		end

		return Menu.MESSAGE_HANDLED
	end

	return Menu.MESSAGE_HANDLED
end


function CreateHeroMenu:OnGamepadButton(user, button, value)
	if button == _G.BUTTON_L and value == 1 then
		self:OnButton(30, -1, -1)
		return Menu.MESSAGE_HANDLED
	elseif button == _G.BUTTON_R and value == 1 then
		self:OnButton(31, -1, -1)
		return Menu.MESSAGE_HANDLED
	end

	return Menu.MESSAGE_NOT_HANDLED
end


function CreateHeroMenu:OnEditor(editorId, text)

	LOG("OnEditor() "..tostring(editorId).." "..tostring(text))
	--self:activate_editor("edit_name")

	return Menu.MESSAGE_HANDLED
    --return Menu.OnEditor(self, editorId,text)
end

--[[
function CreateHeroMenu:OnKey(key)
	LOG("OnKey")
	--self:activate_editor("edit_name")

	return Menu.OnKey(self, key)
end
--]]

function CreateHeroMenu:DoShift()
	LOG("DoShift")
	if(self.SHIFT and self.CAPSLOCK == false)then -- turn shift off
		for letter = 1, 26 do
			local change = self:get_text("txt_a_"..letter)
			change = string.lower(change)
			self:set_text_raw("txt_a_"..letter, change)
		end

		local change = self:get_text("txt_n_1")
		change = "1"
		self:set_text_raw("txt_n_1", change)
		change = self:get_text("txt_n_2")
		change = "2"
		self:set_text_raw("txt_n_2", change)
		change = self:get_text("txt_n_3")
		change = "3"
		self:set_text_raw("txt_n_3", change)
		change = self:get_text("txt_n_4")
		change = "4"
		self:set_text_raw("txt_n_4", change)
		change = self:get_text("txt_n_5")
		change = "5"
		self:set_text_raw("txt_n_5", change)
		change = self:get_text("txt_n_6")
		change = "6"
		self:set_text_raw("txt_n_6", change)
		change = self:get_text("txt_n_7")
		change = "7"
		self:set_text_raw("txt_n_7", change)
		change = self:get_text("txt_n_8")
		change = "8"
		self:set_text_raw("txt_n_8", change)
		change = self:get_text("txt_n_9")
		change = "9"
		self:set_text_raw("txt_n_9", change)
		change = self:get_text("txt_n_0")
		change = "0"
		self:set_text_raw("txt_n_0", change)

		local change = self:get_text("txt_s_1")
		change = "`"
		self:set_text_raw("txt_s_1", change)
		change = self:get_text("txt_s_2")
		change = "-"
		self:set_text_raw("txt_s_2", change)
		change = self:get_text("txt_s_3")
		change = "="
		self:set_text_raw("txt_s_3", change)
		change = self:get_text("txt_s_4")
		change = "["
		self:set_text_raw("txt_s_4", change)
		change = self:get_text("txt_s_5")
		change = "]"
		self:set_text_raw("txt_s_5", change)
		change = self:get_text("txt_s_6")
		change = "\\"
		self:set_text_raw("txt_s_6", change)
		change = self:get_text("txt_s_7")
		change = ";"
		self:set_text_raw("txt_s_7", change)
		change = self:get_text("txt_s_8")
		change = "'"
		self:set_text_raw("txt_s_8", change)
		change = self:get_text("txt_s_9")
		change = ","
		self:set_text_raw("txt_s_9", change)
		change = self:get_text("txt_s_10")
		change = "."
		self:set_text_raw("txt_s_10", change)
		change = self:get_text("txt_s_11")
		change = "/"
		self:set_text_raw("txt_s_11", change)

		self.SHIFT = false

	else	--turn shift on
		for letter = 1, 26 do
			change = self:get_text("txt_a_"..letter)
			change = string.upper(change)
			self:set_text_raw("txt_a_"..letter, change)
		end

		local change = self:get_text("txt_n_1")
		change = "!"
		self:set_text_raw("txt_n_1", change)
		change = self:get_text("txt_n_2")
		change = "@"
		self:set_text_raw("txt_n_2", change)
		change = self:get_text("txt_n_3")
		change = "#"
		self:set_text_raw("txt_n_3", change)
		change = self:get_text("txt_n_4")
		change = "$"
		self:set_text_raw("txt_n_4", change)
		change = self:get_text("txt_n_5")
		change = "%"
		self:set_text_raw("txt_n_5", change)
		change = self:get_text("txt_n_6")
		change = "^"
		self:set_text_raw("txt_n_6", change)
		change = self:get_text("txt_n_7")
		change = "&"
		self:set_text_raw("txt_n_7", change)
		change = self:get_text("txt_n_8")
		change = "*"
		self:set_text_raw("txt_n_8", change)
		change = self:get_text("txt_n_9")
		change = "("
		self:set_text_raw("txt_n_9", change)
		change = self:get_text("txt_n_0")
		change = ")"
		self:set_text_raw("txt_n_0", change)

		local change = self:get_text("txt_s_1")
		change = "~"
		self:set_text_raw("txt_s_1", change)
		change = self:get_text("txt_s_2")
		change = "_"
		self:set_text_raw("txt_s_2", change)
		change = self:get_text("txt_s_3")
		change = "+"
		self:set_text_raw("txt_s_3", change)
		change = self:get_text("txt_s_4")
		change = "{"
		self:set_text_raw("txt_s_4", change)
		change = self:get_text("txt_s_5")
		change = "}"
		self:set_text_raw("txt_s_5", change)
		change = self:get_text("txt_s_6")
		change = "|"
		self:set_text_raw("txt_s_6", change)
		change = self:get_text("txt_s_7")
		change = ":"
		self:set_text_raw("txt_s_7", change)
		change = self:get_text("txt_s_8")
		change = "\""
		self:set_text_raw("txt_s_8", change)
		change = self:get_text("txt_s_9")
		change = "<"
		self:set_text_raw("txt_s_9", change)
		change = self:get_text("txt_s_10")
		change = ">"
		self:set_text_raw("txt_s_10", change)
		change = self:get_text("txt_s_11")
		change = "?"
		self:set_text_raw("txt_s_11", change)

		self.SHIFT = true
	end
end

dofile("Assets/Scripts/Screens/CreateHeroMenuPlatform.lua")

-- return an instance of CreateHeroMenu
return ExportSingleInstance("CreateHeroMenu")
