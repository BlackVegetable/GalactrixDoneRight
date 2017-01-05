
use_safeglobals()

class "LocationHighlight" (Menu)



function LocationHighlight:__init()
	super()
	self:Initialize("Assets\\Screens\\LocationHighlight.xml")
	LOG("LocationHighlight:__init")
	self.waiting_for_close = false
end

function LocationHighlight:OnOpen()
	LOG("LocationHighlight:OnOpen()")
	
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end

function LocationHighlight:Open(satellite)
	
	self.satellite = satellite
	self:SetCenterPoint(satellite)
	
	return Menu.Open(self)
end


function LocationHighlight:SetCenterPoint(satellite)
	assert(satellite,"No Satellite for Center Point")
	self.waiting_for_close = false
	local offset = 0
	if satellite.satellite_overlay_offset then
		--offset = satellite.satellite_overlay_offset
	end
	self.x = satellite:GetX()-offset
	self.y = satellite:GetY()

	LOG("SET TARGET "..tostring(GetScreenWidth()))
	self:Move(self.x+(GetScreenWidth()-1366)/2, 768-self.y)
	--self:StartAnimation("reset")
	self:StartAnimation("open")
	
	--self:Move(satellite:GetX(), SCREENHEIGHT-satellite:GetY())
end

function LocationHighlight:ResetSatellite()
	self.satellite = nil
end



function LocationHighlight:OnGainFocus()
	--SCREENS.SolarSystemMenu:OnGainFocus()
	if self.satellite then
		--self:MoveToFront()
		SCREENS.SolarSystemMenu.state=_G.STATE_TARGET
	else 
		self:Close()
	end
	return Menu.OnGainFocus(self)
end

function LocationHighlight:OnAnimCloseme(data)
	if self.waiting_for_close == true then
		LOG("CLOSING LOCATIONHIGHLIGHT")
		self:Close()
	end
end

function LocationHighlight:CloseMe()
	self:StartAnimation("closeme")
	self.waiting_for_close = true
end


return ExportSingleInstance("LocationHighlight")