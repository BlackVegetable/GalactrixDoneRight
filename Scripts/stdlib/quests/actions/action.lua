

-- action commands represent things that can occur at certain times
-- eg when a quest ends and you get experience and an item there will be a command
-- for giving you experience and a command for giving you the item
-- Note that some commands start executing but logically finish at a later time
-- eg the run_convo command starts by opening the conversation menu
-- but doesnt finish until the conversation menu closes
class "action"
function action:__init( arg )
	if arg.show then
		self.show = 1
	else 
		self.show = 0
	end
	
	-- t is used to determine type of action to customize output
	-- EG. if its experience you might display it differently than gold
	self.t = 0
end
function action:execute(hero)
	assert(false)
end
function action:collate(list)
	
end

return ExportClass("action")