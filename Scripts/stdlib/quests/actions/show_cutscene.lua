
local action = import("quests/actions/action")


-- show_location
--	show_cutscene {message="CS1"},
class "show_cutscene" (action)
function show_cutscene:__init( arg )
	super(arg)
	self.cutscene = arg.cutscene
end
function show_cutscene:execute(hero)
	local e = GameEventManager:Construct("ShowCutscene")
	e:SetAttribute("cutscene", self.cutscene)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("show_cutscene")