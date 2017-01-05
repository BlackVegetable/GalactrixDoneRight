-- ASTD
--  base class for all ASTDs

use_safeglobals()



local Satellite = import("Satellites/Satellite")


class "ASTD" (Satellite)

ASTD.AttributeDescriptions = AttributeDescriptionList(Satellite.AttributeDescriptions)
--ASTD.AttributeDescriptions:AddAttribute('string', 'name', {default="Unexplored"})
--ASTD.AttributeDescriptions:AddAttribute('string', 'type', {default="[ASTD_TYPE]"})
--ASTD.AttributeDescriptions:AddAttribute('string', 'description', {default="[ASTD_DESC]"})
ASTD.AttributeDescriptions:AddAttribute('int', 'sat_xpos', {default=1}) 
ASTD.AttributeDescriptions:AddAttribute('int', 'sat_ypos', {default=200}) 
ASTD.AttributeDescriptions:AddAttribute('string', 'sprite', {default="ZT03"}) 

ASTD.gravity = 0 --0,..,6
ASTD.spriteScale = 1.0
ASTD.rotation_speedx = 0.00
ASTD.rotation_speedy = 0.03
ASTD.rotation_speedz = 0.00


ASTD.miningCost = 0
ASTD.gemList = {["GBLA"]=9,["GCFD"]=3,["GCTX"]=3,["GCMN"]=3}
ASTD.cargo = {	[1]={cargo=_G.CARGO_FOOD,		min=6},
				[2]={cargo=_G.CARGO_TEXTILES,	min=6},
				[3]={cargo=_G.CARGO_MINERALS,	min=6}}

ASTD.spriteList = {"ZSIB","ZSIB","ZSIA"}
ASTD.models = {"aesteroidon","aesteroidoff"}
ASTD.modelScale = 0.6

function ASTD:__init()
    super("ASTD")
	self:InitAttributes()	
	
	self.rotation_speedx = math.random(0,3)/100
	self.rotation_speedy = math.random(0,3)/100
	self.rotation_speedz = math.random(0,3)/100	

end


function ASTD:GetPopupMenu()
	self.menuItems = {}
	
	if #self:GetQuests() > 0 then	
		table.insert(self.menuItems,"[GET_QUESTS]")		
	end
	
	local mineOption = true	
	for i,v in pairs(SCREENS.PopupMenu.questActionList) do
		if v.battleground and v.battleground == "B006"  then
			mineOption = false
		end
	end	
	
	if mineOption and CollectionContainsAttribute(_G.Hero, "crew", "C003") and not CollectionContainsAttribute(_G.Hero, "mined_asteroids", self.classIDStr) then
		table.insert(self.menuItems,"[MINE]")
	end

	table.insert(self.menuItems,"[CLOSE]")	
	return self.menuItems
end



return ExportClass("ASTD")