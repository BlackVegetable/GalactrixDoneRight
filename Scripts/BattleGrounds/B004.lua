-- B004
--  Encounter Battle
--  the first battleground is in n00b space. n00b space is calm. thus has a low spawn rate

use_safeglobals()




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B004" (BattleGround)

function B004:__init()
    super("B004")
	 self.classIDStr = "B004"
end

-- Copy our attributes from BattleGround
B004.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)


function B004:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndEncounter")
	local result = event:GetAttribute("result")
	if result ~= 1 then
		_G.Hero:SetAttribute("curr_loc","")
	end
	e:SetAttribute('result',result)
	e:SetAttribute('encounter',Hero:GetAttribute("curr_loc"))
	e:SetAttribute('enemy',self:GetAttributeAt("Players",2).classIDStr)
	LOG("return End Encounter Event")
	return e		
	
end


return ExportClass("B004")
