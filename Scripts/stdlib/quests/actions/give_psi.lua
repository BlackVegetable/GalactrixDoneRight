-- give_psi
--	give_psi {amount=200},
local action = import("quests/actions/action")

class "give_psi" (action)
function give_psi:__init( arg )
	super(arg)
	self.amount = arg.amount
	self.t = 1
end
function give_psi:execute(hero)
	local e = GameEventManager:Construct("GivePsi")
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("give_psi")
