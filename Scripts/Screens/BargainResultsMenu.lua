
use_safeglobals()

class "BargainResultsMenu" (Menu);


function BargainResultsMenu:__init()
	super()
	
	self:Initialize("Assets\\Screens\\BargainResultsMenu.xml")
	
end


function BargainResultsMenu:Open(numGems,callback)
	self.numGems = numGems
	self.callback = callback
	
	return Menu.Open(self)		
end


function BargainResultsMenu:OnOpen()
	_G.SCREENS.GameMenu:HideHagglingWidgets()
	
	local bonusVal = _G.Hero:GetHaggleTable()[55-self.numGems] or 1
	
	self:set_text("str_matched_val", string.format("%s/55", tostring(self.numGems)))
	self:set_text("str_bonus_val", string.format("%.2f%%", tostring((1-bonusVal)*100)))
	
	
	if self.numGems < 40 then
		self:set_text("str_heading", "[HAGGLE_FAIL]")
	else
		self:set_text("str_heading", "[HAGGLE_SUCCESS]")
	end
	
	return Menu.OnOpen(self)
	
end


function BargainResultsMenu:OnButton(id, x, y)
	
	if id == 2 then
		local function transition()
			SCREENS.GameMenu:ShowHagglingWidgets()
					
			self.callback(true)
			self:Close()		
		end

		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", nil, 500)	
		return Menu.MESSAGE_HANDLED
		
	elseif id == 1 then	
		
		local function transition()
			self.callback(false)
			self:Close()			
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, SCREENS.GameMenu.sourceMenu)	

		return Menu.MESSAGE_HANDLED
	end
	
	return Menu.MESSAGE_NOT_HANDLED
	
end


function BargainResultsMenu:OnClose()
	self.numGems = nil
	self.callback = nil
	
	return Menu.MESSAGE_HANDLED
	
end


return ExportSingleInstance("BargainResultsMenu")
