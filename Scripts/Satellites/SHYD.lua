-- SHYD
--  base class for all SHYDs

use_safeglobals()



local Satellite = import("Satellites/Satellite")


class "SHYD" (Satellite)

SHYD.AttributeDescriptions = AttributeDescriptionList(Satellite.AttributeDescriptions)
--SHYD.AttributeDescriptions:AddAttribute('string', 'name', {default="Unexplored"})
--SHYD.AttributeDescriptions:AddAttribute('string', 'type', {default="[SHYD_TYPE]"})
--SHYD.AttributeDescriptions:AddAttribute('string', 'description', {default="[SHYD_DESC]"})
SHYD.AttributeDescriptions:AddAttribute('int', 'sat_xpos', {default=1}) 
SHYD.AttributeDescriptions:AddAttribute('int', 'sat_ypos', {default=200}) 
SHYD.AttributeDescriptions:AddAttribute('string', 'sprite', {default="ZT05"}) 

SHYD.AttributeDescriptions:AddAttribute('int', 'shop_type', {default=0}) 

SHYD.rotation_speedx = 0.00
SHYD.rotation_speedy = 0.015
SHYD.rotation_speedz = 0.00
SHYD.gravity = 0 --0,1,..,6
SHYD.spriteScale = 1.0
SHYD.spriteList = {"ZSI8","ZSI8","ZSI8"}
SHYD.models = {"shipyard"}
SHYD.modelScale = 0.5

function SHYD:__init(clid)
    super("SHYD")
	self:InitAttributes()	
	
end

function SHYD:GetPopupMenu()
	self.menuItems = {}
	
	
	
	if #self:GetQuests() > 0 then	
		table.insert(self.menuItems,"[GET_QUESTS]")		
	end
	local craftOption = true	
	for i,v in pairs(SCREENS.PopupMenu.questActionList) do
		if v.battleground and v.battleground == "B010"  then
			craftOption = false
		end
	end
	
	local sphere_plans = _G.CollectionContainsAttribute(_G.Hero,"plans","SSGS")
	
	
	
	if craftOption and (CollectionContainsAttribute(_G.Hero, "crew", "C000") or CollectionContainsAttribute(_G.Hero, "crew", "C001") or sphere_plans) then
		table.insert(self.menuItems,"[CRAFT_ITEM]")
	end
	
	table.insert(self.menuItems,"[SHOP]")	

	table.insert(self.menuItems,"[CLOSE]")	
	return self.menuItems
end


return ExportClass("SHYD")