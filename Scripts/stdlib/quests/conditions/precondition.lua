-- precondition commands represent things that can occur at certain times
-- eg when a quest ends and you get experience and an item there will be a command
-- for giving you experience and a command for giving you the item
-- Note that some commands start executing but logically finish at a later time
-- eg the run_convo command starts by opening the conversation menu
-- but doesnt finish until the conversation menu closes
class "precondition"

function precondition:__init( arg )
	self.text = arg.text
end

function precondition:check(hero)
	assert(false)
end

function precondition:collate(list)
	
end

return ExportClass("precondition")