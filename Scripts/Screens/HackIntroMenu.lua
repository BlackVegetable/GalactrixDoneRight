
use_safeglobals()

class "HackIntroMenu" (Menu)

function HackIntroMenu:__init()
	super()
	self:Initialize("Assets\\Screens\\HackIntroMenu.xml")
end

function HackIntroMenu:OnOpen()
	LOG("HackIntroMenu OnOpen()")
	
	self:set_text("str_instruct", "[HACK_INSTRUCT]")
	self:set_text_raw("str_gems", string.format("%s %d", translate_text("[GEMS_]"), self.keys))
	self:set_text_raw("str_time", substitute(translate_text("[TIME_]"), self.time))
	
	local secsPerGem = self.time / self.keys
	if secsPerGem < 5 then
		self:set_text("str_diff", "[HARD]")
	elseif secsPerGem < 7 then
		self:set_text("str_diff", "[MEDIUM]")
	else
		self:set_text("str_diff", "[EASY]")
	end
	
	return Menu.MESSAGE_HANDLED
end

function HackIntroMenu:Open(callback,keys,time)
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	
	self.keys = keys
	self.time = time
	self.callback = callback
	
	return Menu.Open(self)
end

function HackIntroMenu:OnClose()
	self.keys = nil
	self.time = nil
	self.callback = nil
	
	return Menu.MESSAGE_HANDLED
end

function HackIntroMenu:OnButton(id, x, y, up)
	if id == 41 then
		local function transition()
			self.callback(false)
			self:Close()
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, nil, "HackIntroMenu")
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "HackIntroMenu")
	elseif id == 42 then
		local function transition()
			self.callback(true)
			self:Close()
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, "GameMenu", "SolarSystemMenu")
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", "SolarSystemMenu")
	end
	
	
	return Menu.MESSAGE_HANDLED
end

return ExportSingleInstance("HackIntroMenu")
