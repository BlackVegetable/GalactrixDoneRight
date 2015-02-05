-- remove_faction_status
--	remove_faction_status {faction="x",amount=200,show=true},
local action = import("quests/actions/action")

class "remove_faction_status" (action)
function remove_faction_status:__init( arg )
	super(arg)
	self.faction = arg.faction
	self.amount = arg.amount
end
function remove_faction_status:execute(hero)
	local e = GameEventManager:Construct("RemoveFactionStatus")
	e:SetAttribute("faction", self.faction)
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);	
end

return ExportClass("remove_faction_status")