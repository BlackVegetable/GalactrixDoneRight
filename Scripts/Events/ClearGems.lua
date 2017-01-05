-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "ClearGems" (GameEvent)

ClearGems.AttributeDescriptions = AttributeDescriptionList()
ClearGems.AttributeDescriptions:AddAttribute('int', 'broadcast', {default=0,serialize= 1})
ClearGems.AttributeDescriptions:AddAttributeCollection('int', 'grid_id', {serialize= 1})
ClearGems.AttributeDescriptions:AddAttributeCollection('int', 'end_x', {serialize= 1})
ClearGems.AttributeDescriptions:AddAttributeCollection('int', 'end_y', {serialize= 1})
ClearGems.AttributeDescriptions:AddAttribute('int', 'award', {default=1,serialize= 1})
ClearGems.AttributeDescriptions:AddAttribute('int', 'black_hole', {default=0,serialize= 1})


function ClearGems:__init()
	super("ClearGems")
	LOG("ClearGems:init()")
end

function ClearGems:do_OnReceive()
	
	local world = _G.SCREENS.GameMenu.world
	if not world then--if there's no world then that's bad and we should do nothing.
		return
	end
	if self:GetAttribute("broadcast") == 0 then
		LOG("ClearGems OnReceive - DestroyGems "..tostring(world.host))
	
		self:SetSendToSelf(true)		
		for i=1,self:NumAttributes("grid_id") do
			local gemIdx = self:GetAttributeAt("grid_id",i)
			--local gem = world:GetGem(gemIdx)
			if not world:DoNotDestroy(gemIdx) then
				--LOG("ClearGems OnReceive - destroy me!")
				--gem:SetAttribute("grid_id",gemIdx)
				world:DestroyGem(gemIdx)
			end
		end
		self:SetAttribute("broadcast",1)
		GameEventManager:Send(self)--Send to everyone to handle the rest
	else		
	
		world.doNotDestroy = {}
		world.find_done = 0
		LOG("ClearGems OnReceive "..tostring(world.host))
		--if self:NumAttributes("grid_id")==0 then--no matches cleared
			--local e = GameEventManager:Construct("EndTurn")
			----local nextTime = GetGameTime()
			--GameEventManager:Send( e, world)
		--else			
			--for i=1, self:NumAttributes('grid_id') do
				--create the star (this will assert if we arent the host)
				--local grid_id = self:GetAttributeAt("grid_id",i)
	
				--world:SetGem(grid_id,nil)
			--end

			collectgarbage()
			
			if self:GetAttribute("black_hole")==0 then--Not black hole 
			
				world:AdvanceState(_G.STATE_FALLING,0)
				--[[
		        world.state = _G.STATE_FALLING
		
		        --Create an End Swap Event for clearing Matches - to refill the grid
		        local e = GameEventManager:Construct("Update")
		        local nextTime = GetGameTime()
		
		        GameEventManager:Send( e, world )--, nextTime )
				
				--]]
			else
				local event = GameEventManager:Construct("ClearBoard")
				event:SetAttribute("void",1)
				local nextTime = GetGameTime() + world:GetAttribute("black_hole_duration")
				GameEventManager:SendDelayed( event, world, nextTime )				
			end	
		--end	
	end

end

return ExportClass("ClearGems")
