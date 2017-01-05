-- GemSelect 
--When Players change Hero to use in MP
--This is sent to server to replicate outward.

use_safeglobals()






class "GemSelect" (GameEvent)

GemSelect.AttributeDescriptions = AttributeDescriptionList()


--GemSelect.AttributeDescriptions:AddAttribute('string', 'mp_id', {default=1,serialize= 1})
GemSelect.AttributeDescriptions:AddAttribute('int', 'player_id', {default=1,serialize= 1})
GemSelect.AttributeDescriptions:AddAttribute('int', 'grid_id', {default=1,serialize= 1})
GemSelect.AttributeDescriptions:AddAttribute('int', 'behaviour', {default=_G.STATE_IDLE, serialize=1})
GemSelect.AttributeDescriptions:AddAttribute('int', 'turn', {default=1,serialize= 1})



function GemSelect:__init()
    super("GemSelect")
    LOG("GemSelect Init()")
	self:SetSendToSelf(true)
end



function GemSelect:do_OnReceive()
	LOG("GemSelect OnReceive()")
	--and add an entry to the log
	local world = SCREENS.GameMenu.world
	if not world then
		return
	end
	
	if self:GetAttribute("behaviour") == world.state then
		if self:GetAttribute("behaviour") == _G.STATE_IDLE then	
			--self:GemClicked(selected,x,y)
			LOG("Received GemSelect event")
			world:GemClicked(self:GetAttribute("grid_id"))
		elseif self:GetAttribute("behaviour") == _G.STATE_USER_INPUT_GEM then
			--CHECK THIS CODE
			LOG("Received GemSelect event for player inputting gem")
		
			world:DeselectGem(world.g1)
			world:DeselectGem(world.g2)
		   
			local selected = self:GetAttribute("grid_id")
			world:SelectGem(selected)		
	   
			local e = GameEventManager:Construct("GetUserInput")
			e:SetAttribute("BattleGround",world)
			e:SetAttribute("player",world:GetCurrPlayer())
			local obj = world:GetGem(selected)
			e:SetAttribute("obj",obj)
			--local nextTime = GetGameTime()
			--assert(world.user_input_dest,"user_input_dest = nil")
			--LOG("User Input = " .. tostring(world.user_input_dest.classIDStr))
			--GameEventManager:Send( e, world.user_input_dest)			
			world.user_input_dest:OnEventGetUserInput(e)
			
		elseif self:GetAttribute("behaviour") == _G.STATE_USER_INPUT_PLAYER then--Not currently used.
			LOG("Received GemSelect event for player inputting player")
			world:DeselectGem(world.g1)
			world:DeselectGem(world.g2)
	   
	   
			local e = GameEventManager:Construct("GetUserInput")
			e:SetAttribute("BattleGround",world)
			e:SetAttribute("player",world:GetCurrPlayer())
			local obj = world:GetAttributeAt("Players",selected)
			e:SetAttribute("obj",obj)
			--local nextTime = GetGameTime()
			--assert(world.user_input_dest,"user_input_dest = nil")
			--GameEventManager:Send( e, world.user_input_dest)
			world.user_input_dest:OnEventGetUserInput(e)
		end
	elseif world.turn_count <= self:GetAttribute("turn") then--LOG("Incorrect state - resend GemSelect ")
			self:SetSendToSelf(false)
			GameEventManager:SendDelayed(self,world,GetGameTime()+200)		   
	end
end



return ExportClass("GemSelect")
