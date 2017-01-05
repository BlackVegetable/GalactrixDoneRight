
-- B000
--  our first battleground
--  the first battleground is in n00b space. n00b space is calm. thus has a low spawn rate

use_safeglobals()




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B001" (BattleGround)

function B001:__init()
    super("B001")
end

-- Copy our attributes from BattleGround
B001.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)


--Gets Event to send back to source object containing battle result
function B001:GetReturnEvent(event)

	LOG("Construct EndBattle")
	
	local e = GameEventManager:Construct("EndBattle")
	LOG("EndBattle Constructed")
	e:SetAttribute("result",event:GetAttribute("result"))
	LOG("Set result "..tostring(event:GetAttribute("result")))
	local enemy = self:GetAttributeAt("Players",2).classIDStr
	LOG("Enemy "..enemy)
	e:SetAttribute("enemy",enemy)
	return e
		
	
end




return ExportClass("B001")
