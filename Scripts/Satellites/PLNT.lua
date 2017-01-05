-- PLNT
--  base class for all PLNTs

use_safeglobals()



local Satellite = import("Satellites/Satellite")


class "PLNT" (Satellite)

PLNT.AttributeDescriptions = AttributeDescriptionList(Satellite.AttributeDescriptions)
--PLNT.AttributeDescriptions:AddAttribute('string', 'name', {default="Unexplored"})
--PLNT.AttributeDescriptions:AddAttribute('string', 'type', {default="[PLNT_TYPE]"})
--PLNT.AttributeDescriptions:AddAttribute('string', 'description', {default="[PLNT_DESC]"})
PLNT.AttributeDescriptions:AddAttribute('int', 'sat_xpos', {default=1}) 
PLNT.AttributeDescriptions:AddAttribute('int', 'sat_ypos', {default=200}) 
PLNT.AttributeDescriptions:AddAttribute('string', 'sprite', {default="ZTPL"}) 


PLNT.rotation_speedx = 0.0
PLNT.rotation_speedy = 0.01
PLNT.rotation_speedz = 0.0

PLNT.init_rotationx = 1.7
PLNT.init_rotationy = 0.0
PLNT.init_rotationz = 0--1.57


PLNT.gravity = 0 --0,1,..,6
PLNT.spriteScale = 0.4
PLNT.spriteList = {"ZSI0","ZSI0","ZSI0"}
PLNT.models = {"planet"}
PLNT.modelScale = 2.5

function PLNT:__init(clid)
    super("PLNT")
	self:InitAttributes()	


	self.text_overlay_offset_y = 50	
	
end


function PLNT:GetPopupMenu()
	self.menuItems = {}
	
	
	if #self:GetQuests() > 0 then	
		table.insert(self.menuItems,"[GET_QUESTS]")		
	end	

	table.insert(self.menuItems,"[INVENTORY]")		
	table.insert(self.menuItems,"[CLOSE]")	
	return self.menuItems
end


return ExportClass("PLNT")