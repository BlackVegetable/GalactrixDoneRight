
-- B000
--  our first battleground
--  the first battleground is in n00b space. n00b space is calm. thus has a low spawn rate

use_safeglobals()




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B000" (BattleGround)

function B000:__init()
    super("B000")
end

-- Copy our attributes from BattleGround
B000.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)


--Gets Event to send back to source object containing battle result
function B000:GetReturnEvent(event)

	
	return event
		
	
end


function B000:AdjustFactions()
	--No Faction Standing alterations
end


function B000:AwardPlans(winner)
--No Plans Awarded	
end


function B000:AwardCargo(winner)
--No Cargo Awarded	
end



return ExportClass("B000")
