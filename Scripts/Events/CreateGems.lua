-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "CreateGems" (GameEvent)

CreateGems.AttributeDescriptions = AttributeDescriptionList()
CreateGems.AttributeDescriptions:AddAttribute('int', 'broadcast', {default=0,serialize= 1})
CreateGems.AttributeDescriptions:AddAttributeCollection('GameObject', 'gems', {serialize= 1})
CreateGems.AttributeDescriptions:AddAttributeCollection('string', 'gem_code', {serialize= 1})
CreateGems.AttributeDescriptions:AddAttributeCollection('int', 'grid_id', {serialize= 1})
CreateGems.AttributeDescriptions:AddAttributeCollection('int', 'start_x', {serialize= 1})
CreateGems.AttributeDescriptions:AddAttributeCollection('int', 'start_y', {serialize= 1})
CreateGems.AttributeDescriptions:AddAttribute('int', 'normal_movement', {default=1,serialize= 1})


function CreateGems:__init()
	super("CreateGems")
	LOG("CreateGems Init()")
	self:SetSendToSelf(false)
end

function CreateGems:do_OnReceive()
	LOG("CreateGems OnReceive")

	local world = _G.SCREENS.GameMenu.world
	if not world then
		return
	end	
	if self:GetAttribute("broadcast") == 0 then	
		self:SetSendToSelf(true)		
		for i=1,self:NumAttributes("gem_code") do
			self:PushAttribute("gems",GameObjectManager:Construct("Gems"))
		end
		self:SetAttribute("broadcast",1)
		GameEventManager:Send(self)
	else
		--purge_garbage()
		
		for i=1, self:NumAttributes('gems') do
		--create the star (this will assert if we arent the host)
			if _G.is_open("CustomLoadingMenu") then
				SCREENS.CustomLoadingMenu:Close()		
			end	
		
			local gem = self:GetAttributeAt("gems",i)
			local gemCode = self:GetAttributeAt("gem_code",i)
			gem = _G.LoadGem(gemCode,gem)		
			local grid_id = self:GetAttributeAt("grid_id",i)
			world:SetGem(grid_id,gem)
			world:AddChild(gem)
			gem:SetPos(self:GetAttributeAt("start_x",i),self:GetAttributeAt("start_y",i))

			local startX = self:GetAttributeAt("start_x",i)
			local startY = self:GetAttributeAt("start_y",i)
			local endX = world.hexPts[grid_id][1]
			local endY = world.hexPts[grid_id][2]
			
			if self:GetAttribute("normal_movement")==1 then		
				gem:GetView():SetAlpha(0.0)
				continuous_blend(gem:GetView(),0.0,1.0,GetGameTime(),400)				
				world:SetGemMovement(gem,startX,startY,endX,endY)				
			else		
				world:SetBlackHoleMovement(gem,startX,startY,endX,endY)						
			end
			
			--Can Setup animation with dest from hexgrid[gridId] array
			
			--create a new event to notify everyone of the new object thats been created		
		end

		if self:GetAttribute("normal_movement")==1 then
			LOG(tostring(world.my_player_id).." CreateGems Event -- create Update Event")
			if world:EmptyGrids() then
				world:AdvanceState(_G.STATE_REPLENISHING, world:GetAttribute("trail_delay"))
				--world.state = _G.STATE_REPLENISHING
			else
				world:AdvanceState(_G.STATE_SEARCHING, world:GetAttribute("trail_delay"))
				--world.state = _G.STATE_SEARCHING
			end
			--[[ 
			local e = GameEventManager:Construct("Update")
			local nextTime = GetGameTime() + world:GetAttribute("trail_delay")
			GameEventManager:SendDelayed( e, world, nextTime )	
			--]]	
		elseif self:GetAttribute("normal_movement")==0 then
			LOG(tostring(world.my_player_id).." CreateGems Event -- create End Turn Event")
			world.state = _G.STATE_FINDING_MOVE--From STATE_INITIALIZING
			local e = GameEventManager:Construct("EndTurn")
			local nextTime = GetGameTime() + world:GetAttribute('ai_delay')
			GameEventManager:SendDelayed( e, world, nextTime)
			
			   
		end	
	end

end

return ExportClass("CreateGems")