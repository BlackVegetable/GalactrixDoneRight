
local precondition = import("quests/conditions/precondition")

class "has_friend" (precondition)
function has_friend:__init( arg )
	super(arg)
	self.friend = arg.friend 
end
function has_friend:check(hero)
	if hero.HasFriend then
		return hero:HasFriend(self.friend)
	else
		LOG("HERO:HasFriend([friendCode]) Not defined")
		return true
	end
end

return ExportClass("has_friend")