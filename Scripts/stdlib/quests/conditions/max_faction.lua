
local precondition = import("quests/conditions/precondition")

class "max_faction" (precondition)
function max_faction:__init( arg )
	super(arg)
	self.faction = arg.faction
	self.amount = arg.amount
end
function max_faction:check(hero)
	if hero.GetFactionStanding then
		if hero:GetFactionStanding(self.faction) <= self.amount then
			return true
		else
			return false
		end
	else
		LOG("HERO:GetFaction([FactionCode]) Not defined")
		return true
	end
end

return ExportClass("max_faction")
