-- SPST
--  base class for all SPSTs

use_safeglobals()



local Satellite = import("Satellites/Satellite")


class "SPST" (Satellite)

SPST.AttributeDescriptions = AttributeDescriptionList(Satellite.AttributeDescriptions)
--SPST.AttributeDescriptions:AddAttribute('string', 'name', {default="Unexplored"})
--SPST.AttributeDescriptions:AddAttribute('string', 'type', {default="[SPST_TYPE]"})
--SPST.AttributeDescriptions:AddAttribute('string', 'description', {default="[SPST_DESC]"})
SPST.AttributeDescriptions:AddAttribute('int', 'sat_xpos', {default=1}) 
SPST.AttributeDescriptions:AddAttribute('int', 'sat_ypos', {default=200}) 
SPST.AttributeDescriptions:AddAttribute('string', 'sprite', {default="ZT05"}) 


SPST.rotation_speedx = 0.00
SPST.rotation_speedy = 0.015
SPST.rotation_speedz = 0.00
SPST.gravity = 0 --0,1,..,6
SPST.spriteScale = 1.0
SPST.spriteList = {"ZSI2","ZSI2","ZSI2"}
SPST.models = {"spacestation"}
SPST.modelScale = 1.0

function SPST:__init()
    super("SPST")
	self:InitAttributes()	

end

function SPST:GetPopupMenu()
	self.menuItems = {}
	if #self:GetQuests() > 0 then	
		table.insert(self.menuItems,"[GET_QUESTS]")		
	end	

	table.insert(self.menuItems, "[TRADE_CARGO]")
	table.insert(self.menuItems,"[INVENTORY]")	
	table.insert(self.menuItems,"[CLOSE]")
	
	return self.menuItems
end


return ExportClass("SPST")