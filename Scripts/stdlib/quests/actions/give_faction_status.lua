-- give_faction_status
--	give_faction_status {faction="x",amount=200,show=true},
local action = import("quests/actions/action")

class "give_faction_status" (action)
function give_faction_status:__init( arg )
	super(arg)
	self.faction = arg.faction
	self.amount = arg.amount
end
function give_faction_status:execute(hero)
	local e = GameEventManager:Construct("GiveFactionStatus")
	e:SetAttribute("faction", self.faction)
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);	
end

return ExportClass("give_faction_status")