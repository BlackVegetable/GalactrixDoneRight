-- Star
--	this class defines the basic behaviour of the Star objects
--	there is one instance of 

use_safeglobals()



class "Star" (GameObject)

-- BEGIN ATTRIBUTE DESCRIPTIONS
local attribs = AttributeDescriptionList()
Star.AttributeDescriptions = attribs
--attribs:AddAttribute('string',	'name',						{default="[UNKNOWN_STAR]"} )
--attribs:AddAttribute('int',		'tech',						{default=5} )--Range 1-10
--attribs:AddAttribute('int',		'gov',						{default=_G.GOV_DICTATORSHIP} )
--attribs:AddAttribute('int',		'industry',					{default=_G.INDUSTRY_MINING} )
--attribs:AddAttribute('int',		'faction',					{default=_G.FACTION_TRIDENT} )

attribs:AddAttribute('int',		'xpos',						{default=0} )
attribs:AddAttribute('int',		'ypos',						{default=0} )
--attribs:AddAttribute('int',		'sun',						{default=1} )
--attribs:AddAttribute('string',	'sprite',					{default="ZST3"} )
--attribs:AddAttribute('string',	'system_name',				{default="[UNKNOWN_SYSTEM]"} )

--attribs:AddAttribute('string',	'portrait',					{default="img_SystemSun_01"} )
-- attribs:AddAttributeCollection('GameObject', 'orbiters')
attribs:AddAttributeCollection('string', 'jumpgates', {})

Star.system = "Y001"


function Star:__init()
	super("Star")
	--LOG("Star Init()")
	-- we have to init the attributes if we want to set them in the ctor
	self:InitAttributes()
end

--[[
-- private function to add a quest overlay if required
function Star:AddQuestOverlay()
 	local quests = _G.GetAvailableQuestsAtLocation(_G.Hero,self.classIDStr)
	local actions = _G.GetAvailableActions(_G.Hero,self.classIDStr)
	--if actions then use action sprite
 	if #actions > 0 then
		local actionView = GameObjectViewManager:Construct("Sprite","ZQBA")
		self:AddOverlay("actions", actionView, 0, 0)
		actionView:StartAnimation("stand")				
		actionView:SetSortingValue(-16)
	elseif #quests > 0 then
		local questView = GameObjectViewManager:Construct("Sprite","ZQBQ")
		self:AddOverlay("quests", questView, 0, 0)
		questView:StartAnimation("stand")			
		questView:SetSortingValue(-16)
	end
	
	--elseif quests then use quest sprite
end
--]]

function Star:SetSystemView()
	-- SCF: Removed this because we simplified the elements to a single baked-in backdrop
end


function Star:AddText()
	
	local font_type = "font_info_gray"
	
	if self.hacked then
		font_type = "font_info_white"
	end
	
 	local view = GameObjectViewManager:Construct("Text")
    local textView = CastToTextView(view)
    textView:SetString(string.format("[%s_NAME]",self.classIDStr )) 
    textView:SetFont(font_type)
	view:SetSortingValue(-12)			
	self:AddOverlay("star_name", view, 10, 30)

end


function Star:Spin()
	if self.viewanim then
		self.viewanim:StartAnimation("spin")
	end
end

function Star:StopSpin()
	if self.viewanim then
		self.viewanim:StartAnimation("stand")
	end
end

function Star:OnEventLoadHero(event)
	-- Get quantities and costs from saved data
end

function Star:GetFaction()
	--return self:GetAttribute("faction")
	return self.faction
end

function Star:GetGovernment()
	--return self:GetAttribute("gov")
	return self.gov
end	

function Star:GetIndustry()
	--return self:GetAttribute("industry")
	return self.industry
end

function Star:GetTechLevel()
	--return self:GetAttribute("tech")
	return self.tech
end

dofile("Assets/Scripts/Stars/StarPlatform.lua")


return ExportClass("Star")
