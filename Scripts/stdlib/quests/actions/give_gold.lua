
local action = import("quests/actions/action")

-- give_gold
--	give_gold {amount=200},
class "give_gold" (action)
function give_gold:__init( arg )
	super(arg)
	self.amount = arg.amount
	
	self.t = 2
end
function give_gold:execute(hero)
	local e = GameEventManager:Construct("GiveGold")
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("give_gold")