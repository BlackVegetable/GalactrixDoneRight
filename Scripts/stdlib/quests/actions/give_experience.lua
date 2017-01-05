-- give_experience
--	give_experience {amount=200},
local action = import("quests/actions/action")

class "give_experience" (action)
function give_experience:__init( arg )
	super(arg)
	self.amount = arg.amount
	self.t = 1
end
function give_experience:execute(hero)
	local e = GameEventManager:Construct("GiveExperience")
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);	
end

return ExportClass("give_experience")