
local action = import("quests/actions/action")

-- give_item
--	when executed sends the GiveItem event to the hero
--	it is assumed that the hero will be able to process this event
class "give_item" (action)
function give_item:__init( arg )
	super(arg)
	self.item = arg.item
	self.t = 3
end
function give_item:execute(hero)
	-- send event to hero
	local e = GameEventManager:Construct("GiveItem")
	e:SetAttribute("item", self.item)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("give_item")