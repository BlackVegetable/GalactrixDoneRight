
-- B101
--  Multiplayer BattleGround PC only
--  the first battleground is in n00b space. n00b space is calm. thus has a low spawn rate

use_safeglobals()




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B101" (BattleGround)

function B101:__init()
    super("B101")
end

-- Copy our attributes from BattleGround
B101.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
--B101.AttributeDescriptions:AddAttribute('int', 'timer', {default=30})



--This is here in case it's destroyed by client disconnecting.
function B101:PreDestroy()
	LOG("Multiplayer BattleGround B101:PreDestroy() "..tostring(self.my_player_id).." "..tostring(self.my_id))
	if _G.SCREENS then
		_G.SCREENS.GameMenu.world = nil	
	end

end

function B101:ProcessEndTurn()
	if self:GetAttribute("timer") > 0 then
		self:InitTimer()
	end
end

--Gets Event to send back to source object containing battle result
function B101:GetReturnEvent(event,mp_event)

	LOG("Construct EndBattle")
	if mp_event then
		local e = GameEventManager:Construct("EndMPBattle")
		LOG("EndBattle Constructed")
		e:SetAttribute("result",event:GetAttribute("result"))
		LOG("Set result "..tostring(event:GetAttribute("result")))
		local enemy = self:GetAttributeAt("Players",2).classIDStr
		LOG("Enemy "..enemy)
		e:SetAttribute("enemy",enemy)
		return e
	end
		
end








return ExportClass("B101")
