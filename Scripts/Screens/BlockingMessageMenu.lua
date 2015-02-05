-------------------------------------------------------------------------------
--
-- BlockingMessageMenu
--	Just like the MessageMenu, only also uses an icon 
--
-------------------------------------------------------------------------------

use_safeglobals()

-------------------------------------------------------------------------------
-- BlockingMessageMenu Class
-------------------------------------------------------------------------------

class "BlockingMessageMenu" (Menu);

-------------------------------------------------------------------------------
--
function BlockingMessageMenu:__init()
	super()
	--LOG("[BLOCKINGMESSAGEMENU] __initialised")
	
	self:Initialize("Assets/Screens/BlockingMessageMenu.xml")
	self:Parse()
end

-------------------------------------------------------------------------------
--
function BlockingMessageMenu:__finalize()
	--LOG("__collected [BLOCKINGMESSAGEMENU]")
end



-------------------------------------------------------------------------------
--
function BlockingMessageMenu:OnOpen()
	--LOG("[BLOCKINGMESSAGEMENU] opened");
	if self.title then
		--LOG("TITLE:" .. title)
		assert(self)
		self:set_text("str_title",	self.title)
	end
	if self.message then
		--LOG("MESSAGE:" .. message)
		self:set_text("str_message",	self.message)
	end
	self:MoveToFront()
			
	return Menu.OnOpen(self)
end

function BlockingMessageMenu:ShowMessage(title, message)
	--LOG("[BLOCKINGMESSAGEMENU] opened");
	if title then
		--LOG("TITLE:" .. title)
		assert(self)
		self:set_text("str_title",	title)
	end
	if message then
		--LOG("MESSAGE:" .. message)
		self:set_text("str_message",	message)
	end
			
end

-------------------------------------------------------------------------------
--
function BlockingMessageMenu:OnClose()
	--LOG("[BLOCKINGMESSAGEMENU] closed");
	if self.close_callback then
		self.close_callback()
	end
	
	self.openTime = nil
	self.close_callback = nil
	self.open_callback = nil
	self.closeMe = nil
	self.halt = nil
	SCREENS.BlockingMessageMenu = nil
	
	if self.ds then
		enable_sleep_mode()
	end
	
	SCREENS.BlockingMessageMenu = nil
	
	return Menu.OnClose(self)
end

-------------------------------------------------------------------------------
--
function BlockingMessageMenu:OverrideCallback(callback)
	self.close_callback = callback
end

-------------------------------------------------------------------------------
-- Display()
function BlockingMessageMenu:Open(title, message, open_func, close_func, halt)
	LOG("BlockingMessageMenu Display")
	self.title = title
	self.message = message
	self.open_callback = open_func
	self.close_callback = close_func
	self.halt = halt
	
	return Menu.Open(self)
end

-------------------------------------------------------------------------------
-- CloseASAP
function BlockingMessageMenu:CloseASAP(ds)
	self.closeMe = true
	
	if ds then
		self.ds = true
	end
end

-------------------------------------------------------------------------------
-- 
function BlockingMessageMenu:OnAnimOpen()
	self:MoveToFront()
	self.openTime = GetSystemTime()
	Graphics.FadeFromBlack()
	
	if self.open_callback then
		self.open_callback()
	end	
	
end

function BlockingMessageMenu:OnTimer(time)	
	if self.openTime then
		if self.closeMe and (self.openTime < GetSystemTime() - 2000)then
			LOG("BlockingMessageMenu Close")			
			self.closeMe = nil		
			self:Close()
		end
		
		if GetSystemTime() - self.openTime > 50 and self.halt then
			LOG("halt")
			_G.OS_HALT()
		end
	end
	self:MoveToFront()

	return Menu.OnTimer(self, time)
end



return ExportSingleInstance("BlockingMessageMenu")