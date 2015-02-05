
local precondition = import("quests/conditions/precondition")

class "min_rumor" (precondition)
function min_rumor:__init( arg )
	super(arg)
	self.amount = arg.amount
end
function min_rumor:check(hero)
	if hero.GetRumor then
		if hero:GetRumor() >= self.amount then
		LOG("HeroRumors:")
		LOG(hero:GetRumor())
			return true
		else
			return false
		end
	else
		LOG("HERO:GetRumor() Not defined")
		return true
	end
end

return ExportClass("min_rumor")
