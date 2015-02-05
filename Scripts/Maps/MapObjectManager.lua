
require "Assets/Scripts/JumpGates/Gate"
require "Assets/Scripts/Stars/Star"

function InitMapObjects()
	
	_G.JumpGateList = {}
	
	_G.StarList = {}
end


function LoadStar(starID,dataTable)	
	local star = GameObjectManager:Construct("Star")
	--[[
	star:SetAttribute("tech",     dataTable.tech)
	star:SetAttribute("gov",      dataTable.gov)
	star:SetAttribute("faction",  dataTable.faction)
	star:SetAttribute("industry", dataTable.industry)
	--]]
	star.tech = dataTable.tech
	star.gov = dataTable.gov
	star.faction = dataTable.faction
	star.industry = dataTable.industry
	--star.xpos = dataTable.xpos
	--star.ypos = dataTable.ypos
	star:SetAttribute("xpos",     dataTable.xpos)
	star:SetAttribute("ypos",     dataTable.ypos)
	
	star.classIDStr = starID
	return star
end

function LoadGate(gateID,dataTable)		
	local gate = GameObjectManager:Construct("Gate")
	gate:SetAttribute("sat_xpos",dataTable.sat_xpos)
	gate:SetAttribute("sat_ypos",dataTable.sat_ypos)
	gate.sat_xpos = dataTable.sat_xpos
	gate.sat_ypos = dataTable.sat_ypos
	gate.time = dataTable.time
	gate.keys = dataTable.keys
	
	gate.classIDStr = gateID
	
	return gate
	
end
