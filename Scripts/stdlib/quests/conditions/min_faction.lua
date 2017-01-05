
local precondition = import("quests/conditions/precondition")


class "min_faction" (precondition)
function min_faction:__init( arg )
	super(arg)
	self.faction = arg.faction
	self.amount = arg.amount
end
function min_faction:check(hero)
	if hero.GetFactionStanding then
		if hero:GetFactionStanding(self.faction) >= self.amount then
			return true
		else
			return false
		end
	else
		LOG("HERO:GetFaction([FactionCode]) Not defined")
		return true
	end
end

return ExportClass("min_faction")
