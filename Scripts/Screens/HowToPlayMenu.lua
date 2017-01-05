use_safeglobals()

-- declare our menu
class "HowToPlayMenu" (Menu);

function HowToPlayMenu:__init()
	super()
	
	self:Initialize("Assets\\Screens\\HowToPlayMenu.xml")
end


function HowToPlayMenu:OnOpen()
	LOG("[HowToPlayMenu] opened")

	self.mode = 1
	self.pageDisplayed = 1
	self.maxPages = 9
	self:set_alpha("grp_2_text", 0.0)
	self:set_text("str_pagenumber", string.format("%d / %d", self.pageDisplayed, self.maxPages))
	return Menu.OnOpen(self)
end

function HowToPlayMenu:OnClose()
	LOG("[HowToPlayMenu] closed")

	return Menu.OnClose(self)
end

function HowToPlayMenu:OnButton(buttonId, clickX, clickY)

	if buttonId == 1 then
		if self.pageDisplayed == 1 then
			self:StartAnimation("text3_fadeout")
		else
			self:StartAnimation("text2_fadeout")
		end
		CallScreenSequencer("HowToPlayMenu", "HelpOptionsMenu")
		return Menu.MESSAGE_HANDLED

	elseif buttonId == 2 then
		self:FlipPage(false)
		return Menu.MESSAGE_HANDLED
		
	elseif buttonId == 3 then
		self:FlipPage(true)
		return Menu.MESSAGE_HANDLED
		
	elseif buttonId == 11 then
		-- Only called on the DS
		self.mode = self.mode + 1
		if self.mode > 3 then
			self.mode = 1
		end
		
		if self.mode == 1 then
			self:set_text("str_c_1_h","[HTP_STORY]")
			self:set_text("str_c_1_1","[HTP_STORY_HELP]")
		elseif self.mode == 2 then
			self:set_text("str_c_1_h","[HTP_BATTLE]")
			self:set_text("str_c_1_1","[HTP_BATTLE_HELP]")
		elseif self.mode == 3 then
			self:set_text("str_c_1_h","[HTP_PUZZLE]")
			self:set_text("str_c_1_1","[HTP_PUZZLE_HELP]")
		end
		
		return Menu.MESSAGE_HANDLED
	end 

	return Menu.MESSAGE_NOT_HANDLED
end

function HowToPlayMenu:OnKey(key)
	
	return Menu.OnKey(self, key)
end

function HowToPlayMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end
--[[
function HowToPlayMenu:OnGamepadDPad(user, dpad, x, y)
	return Menu.MESSAGE_HANDLED
end
]]--

function HowToPlayMenu:FlipPage(forward)
	-- hide existing page
	if self.pageDisplayed == 1 then
		self:StartAnimation("text3_fadeout")
	else
		self:StartAnimation("text2_fadeout")
	end

	--increment/decrement page and update it's contents if necessary
	if forward then
		self.pageDisplayed = self.pageDisplayed + 1
		
		if self.pageDisplayed > self.maxPages then
			self.pageDisplayed = 1
		end
		
		LOG(string.format("New page is %d", self.pageDisplayed))
		if self.pageDisplayed > 1 then
			self:set_text("str_htp_ext_t", translate_text(string.format("[HTP%d_T]", self.pageDisplayed-1)))
			self:set_text("str_htp_ext", translate_text(string.format("[HTP%d]", self.pageDisplayed-1)))
		end
		
	else

		self.pageDisplayed = self.pageDisplayed - 1
		
		if self.pageDisplayed < 1 then
			self.pageDisplayed = self.maxPages
		end
		
		if self.pageDisplayed > 1 then
			self:set_text("str_htp_ext_t", translate_text(string.format("[HTP%d_T]", self.pageDisplayed-1)))
			self:set_text("str_htp_ext", translate_text(string.format("[HTP%d]", self.pageDisplayed-1)))
		end
		
	end
	
	self:set_text("str_pagenumber", string.format("%d / %d", self.pageDisplayed, self.maxPages))

		
	-- show page
	if self.pageDisplayed == 1 then
		self:StartAnimation("text3_fadein")
	else
		self:StartAnimation("text2_fadein")
	end
		
end

-- return an instance of CreateHeroMenu
return ExportSingleInstance("HowToPlayMenu")
