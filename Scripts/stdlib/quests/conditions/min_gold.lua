
local precondition = import("quests/conditions/precondition")

class "min_gold" (precondition)
function min_gold:__init( arg )
	super(arg)
	self.amount = arg.amount 
end
function min_gold:check(hero)
	if hero.GetGold then
		if hero:GetGold() >= self.amount then
			return true
		else
			return false
		end
	else
		LOG("HERO:GetGold() Not defined")
		return true
	end
end

return ExportClass("min_gold")