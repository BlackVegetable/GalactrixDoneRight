
class "BargainIntroMenu" (Menu)

function BargainIntroMenu:__init()
	super()
	self:Initialize("Assets\\Screens\\BargainIntroMenu.xml")
end

function BargainIntroMenu:OnOpen()
	LOG("BargainIntroMenu OnOpen()")	
	
	return Menu.OnOpen(self)
end

function BargainIntroMenu:Open(callback)
	self.callback = callback
	return Menu.Open(self)
end

function BargainIntroMenu:OnButton(id, x, y)
	if id == 99 then
		self:Close()
		self.callback(false)
	elseif id == 1 then
		self:Close()
		self.callback(true)
	
		--_G.GLOBAL_FUNCTIONS.Backdrop.Open()		
		--_G.CallScreenSequencer(sourceMenu, "GameMenu", sourceMenu, player1, "B010", event)
	end

	return Menu.MESSAGE_HANDLED
end

return ExportSingleInstance("BargainIntroMenu")