use_safeglobals()


-- declare our menu
class "SystemInfoMenu" (Menu);

function SystemInfoMenu:__init()
	super()
	LOG("__Init() XML")

	self:Initialize("Assets\\Screens\\SolarSystemInfoMenu.xml")
end


function SystemInfoMenu:OnOpen()
	LOG("SystemInfo opened")
	
	_G.GLOBAL_FUNCTIONS.DisplaySystemInfo(self.star,self)	
	
	return Menu.OnOpen(self)
end

function SystemInfoMenu:OnGainFocus()
	LOG("systemInfo:OnGainFocus()")
	if self.menu then
		LOG("call focus on "..tostring(self.menu))
		return SCREENS[self.menu]:OnGainFocus()
	end
	
	return Menu.MESSAGE_HANDLED
end




function SystemInfoMenu:Open(star, menu)

	self.star = star
	self.menu = menu
	
	return Menu.Open(self)
end

function SystemInfoMenu:OnClose()

	self.star = nil
	self.menu = nil
	
	return Menu.OnClose(self)
end


function SystemInfoMenu:Fadeout(star)
	SCREENS.MapMenu.world.fading_system = true
	self.star = star
	self:hide_widget("icon_info")
	self:StartAnimation("fadeout")
end

function SystemInfoMenu:OnAnimFadeout(data)
	if data == 1 then
		_G.GLOBAL_FUNCTIONS.DisplaySystemInfo(self.star,self)
		self:StartAnimation("fadein")
	end
end

function SystemInfoMenu:OnAnimFadein(data)
	if data == 1 then
		SCREENS.MapMenu.world.fading_system = false
	end
end

-- return an instance of SystemInfoMenu
return ExportSingleInstance("SystemInfoMenu")
