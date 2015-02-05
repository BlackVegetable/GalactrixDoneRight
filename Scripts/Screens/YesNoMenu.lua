use_safeglobals()

-- declare our menu
class "YesNoMenu" (Menu);

function YesNoMenu:__init()
	super()
	
	self:Initialize("Assets\\Screens\\YesNoMenu.xml")
end



function YesNoMenu:Open(heading,message,callback,option1,option2)
	self.heading = heading
	self.message = message
	self.callback = callback
	self.option1 = option1
	self.option2 = option2

	self.response = false	
	
	return Menu.Open(self)
end


function YesNoMenu:OnOpen()
	LOG("[YesNoMenu] opened")
	self:set_text("str_heading",self.heading)
	self:set_text("str_message",self.message)
	self:set_text("butt_no",self.option1)
	self:set_text("butt_yes",self.option2)
	
	return Menu.OnOpen(self)
end

function YesNoMenu:OnClose()
	LOG("[YesNoMenu] closed")

	return Menu.OnClose(self)
end

function YesNoMenu:CloseMenu(callback)
	if callback then
		self.callback(self.response)
	end
	self:Close()
end
	
function YesNoMenu:OnButton(buttonId, clickX, clickY)
	if buttonId == 0 then--yes
		self.response = true
		self:CloseMenu(true)
		return Menu.MESSAGE_HANDLED
	elseif buttonId == 1 then--no
		self.response = false
		self:CloseMenu(true)
		return Menu.MESSAGE_HANDLED
	end 
	
	
	return Menu.MESSAGE_NOT_HANDLED
end


function YesNoMenu:OnKey(key)
	
	return Menu.OnKey(self, key)
end



return ExportSingleInstance("YesNoMenu")
