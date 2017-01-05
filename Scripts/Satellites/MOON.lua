-- MOON
--  base class for all MOONs

import "safeglobals"



local Satellite = import("Satellites/Satellite")


class "MOON" (Satellite)

MOON.AttributeDescriptions = AttributeDescriptionList(Satellite.AttributeDescriptions)
--MOON.AttributeDescriptions:AddAttribute('string', 'name', {default="Unexplored"})
--MOON.AttributeDescriptions:AddAttribute('string', 'type', {default="[MOON_TYPE]"})
--MOON.AttributeDescriptions:AddAttribute('string', 'description', {default="[MOON_DESC]"})
MOON.AttributeDescriptions:AddAttribute('int', 'sat_xpos', {default=1}) 
MOON.AttributeDescriptions:AddAttribute('int', 'sat_ypos', {default=200}) 
MOON.AttributeDescriptions:AddAttribute('string', 'sprite', {default="ZTMN"}) 
MOON.AttributeDescriptions:AddAttribute('string', 'rumor', {default=""})
MOON.AttributeDescriptions:AddAttribute('int',    'moves', {default=1})
MOON.AttributeDescriptions:AddAttribute('int',    'intel', {default=1})

MOON.AttributeDescriptions:AddAttribute('string',		'psi_pattern',			{default="PTR1"} )

MOON.rotation_speedx = 0.00
MOON.rotation_speedy = 0.015
MOON.rotation_speedz = 0.00



MOON.gravity = 0 --0,1,..,6
MOON.spriteScale = 1.0
MOON.spriteList = {"ZSI4","ZSI4","ZSI4"}
MOON.models = {"moon"}
MOON.modelScale = 1.5

function MOON:__init()
    super("MOON")
	self:InitAttributes()

end

function MOON:GetPopupMenu()
	self.menuItems = {}

	if #self:GetQuests() > 0 then	
		table.insert(self.menuItems,"[GET_QUESTS]")		
	end		
	
	local rumorID = self:GetAttribute("rumor")
	
	if CollectionContainsAttribute(_G.Hero, "crew", "C006") and rumorID ~= "" and (not _G.Hero:IsRumorUnlocked(rumorID)) then
		table.insert(self.menuItems,"[RUMOR_TEST]")
	end	
	
	table.insert(self.menuItems,"[CLOSE]")
	
	return self.menuItems
end


return ExportClass("MOON")