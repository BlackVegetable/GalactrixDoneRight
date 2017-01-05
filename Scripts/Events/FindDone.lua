-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "FindDone" (GameEvent)

FindDone.AttributeDescriptions = AttributeDescriptionList()
FindDone.AttributeDescriptions:AddAttribute('int', 'match_found', {default=0,serialize= 1})
FindDone.AttributeDescriptions:AddAttribute('int', 'done', {default=0,serialize= 1})


function FindDone:__init()
	super("FindDone")
	self:SetSendToSelf(false)
end

function FindDone:do_OnReceive()
	local world = _G.SCREENS.GameMenu.world
	
	LOG(string.format("FindDone:do_OnRecieve() turn %d, chain %d,  player %d",tostring(world.turn_count),tostring(world.turn.chainCount),tostring(world.my_player_id)))
	
	local found = self:GetAttribute("match_found")
	--if world.state == _G.STATE_SEARCHING then
		if world.find_done == 0 then
			LOG("FindDone: set find_done = 1")
			world.find_done = 1	
			LOG("FindDone:Set find_done->1 for "..tostring(world.my_player_id))		
		elseif world.find_done == 1 then
			--world.find_done = 2
			if found ==1 then
				LOG("FindDone:Set STATE_REMOVING "..tostring(world.my_player_id))
				world.state = _G.STATE_REMOVING
				local e = GameEventManager:Construct("Update")
				local nextTime = GetGameTime() + world:GetAttribute("clear_delay")
				GameEventManager:SendDelayed( e, world, nextTime )	
				LOG("FindDone: set find_done = 0")
				world.find_done = 0
			else
				LOG("FindDone:Send End Turn "..tostring(world.my_player_id))
				local e = GameEventManager:Construct("EndTurn")			
				GameEventManager:Send( e, world)	
				LOG("FindDone: set find_done = 0")		
				world.find_done = 0
			end		
		end
	--end
	
	
end

return ExportClass("FindDone")
