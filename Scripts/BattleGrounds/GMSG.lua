-- GMSG
--  base class for all GMSGs

use_safeglobals()






class "GMSG" (GameObject)

GMSG.AttributeDescriptions = AttributeDescriptionList()
--GMSG.AttributeDescriptions:AddAttribute('int', 'message_duration', {default=1500}) 
--GMSG.AttributeDescriptions:AddAttribute('string', 'message', {default=""}) 
--GMSG.AttributeDescriptions:AddAttribute('string', 'message_val', {default=""}) 



function GMSG:__init()
    super("GMSG")

	self.xpos = 265
	self.ypos = 280
	
	
	self.textView = nil
	
	self.duration = 2500
end


function GMSG:EncounterMessage(msg,x,y)

    --LOG("ShowMessage() "..msg)
    --self:SetAttribute("message",msg)
    local view = GameObjectViewManager:Construct("Text")
    self.textView = CastToTextView(view)
    --assert(view,"view "..msg.."not created")
	
    
    self.textView:SetString(msg)
    self.textView:SetFont("font_message")
    
    
	local acc = 30
	
	self.xpos = x
	self.ypos = y
    
    self:SetPos(x,y)
    self:SetView(view)
    
    view:StartAnimation("stand")
    if float then
	    local m = MovementManager:Construct("Gravity")
	    m:SetAttribute("Accel", acc)        -- 50 world units (pixels) per second^2
	    m:SetAttribute("StartX", x)
	    m:SetAttribute("StartY", y)
	    m:SetAttribute("EndX", x)
	    m:SetAttribute("EndY", y+192)
	    self:SetMovementController(m)
    end
    
    --Place in front of all gems
    view:SetSortingValue(-1)
    
    --continuous_scale(self,0.8,2.0,GetGameTime(),self:GetAttribute('message_duration')-300)
    continuous_blend(view,1.0,0.0,GetGameTime()+400,self.duration)	
	

    local e = GameEventManager:Construct("EndMessage")
    local nextTime = GetGameTime() + self.duration
    GameEventManager:SendDelayed( e, self, nextTime )	
	
end


--[[
function GMSG:DamageMessage(msg,x,y)

	self:ShowMessage(msg,"font_info_red",x,y,false)

end

function GMSG:ShieldMessage(msg,x,y)

	self:ShowMessage(msg,"font_info_blue",x,y,false)

end



function GMSG:BigMessage(msg,x,y)
	self:ShowMessage(msg,"font_heading",x,y,true)

end



function GMSG:SmallMessage(msg,x,y)
	self:ShowMessage(msg,"font_info_white",x,y,true)

end

--]]

function GMSG:ShowMessage(msg,font,x,y,float,acc)
	
	--[[
    --LOG("ShowMessage() "..msg)
    --self:SetAttribute("message",msg)
    local view = GameObjectViewManager:Construct("Text")
    self.textView = CastToTextView(view)
    --assert(view,"view "..msg.."not created")
	
    
    self.textView:SetString(msg)
    self.textView:SetFont(font)
    
    
	
	if not acc then
		acc = 30
	end
	
	self.xpos = x
	self.ypos = y
    
    self:SetPos(x,y)
    self:SetView(view)
    
    view:StartAnimation("stand")
    if float then
	    local m = MovementManager:Construct("Gravity")
	    m:SetAttribute("Accel", acc)        -- 50 world units (pixels) per second^2
	    m:SetAttribute("StartX", x)
	    m:SetAttribute("StartY", y)
	    m:SetAttribute("EndX", x)
	    m:SetAttribute("EndY", y+192)
	    self:SetMovementController(m)
    end
    
    --Place in front of all gems
    view:SetSortingValue(-1)
    
    --continuous_scale(self,0.8,2.0,GetGameTime(),self:GetAttribute('message_duration')-300)
    continuous_blend(view,1.0,0.0,GetGameTime()+400,self.duration)
    
	
	--]]
	
	
	
	--************************************

	local baseObj = self:GetParent()
	local FX = baseObj.FX
	
	
	if not x then
		x = 512
	end
	if not y then
		y = 384
	end
	
	if not acc then
		acc = 30
	end	
	

	local container = FX.CreateContainer(1700, x)
	local elem1     = FX.AddText(container,font,msg, 0,0, 0.0,0.0, 0.0,1.0, true)
	
	
	--FX.AddKey(container,elem1,1500,FX.KEY_XY,    0,70, FX.SMOOTH)
	FX.AddKey(container,elem1,500, FX.KEY_SCALE, 1.0,  FX.BOUNCE)
	FX.AddKey(container,elem1,1000,FX.KEY_SCALE, 1.0,  FX.DISCRETE)
	FX.AddKey(container,elem1,1400,FX.KEY_SCALE, 3.0,  FX.PUNCH_OUT)
	FX.AddKey(container,elem1,1000,FX.KEY_ALPHA, 1.0,  FX.DISCRETE)
	FX.AddKey(container,elem1,1400,FX.KEY_ALPHA, 0.0,  FX.LINEAR)
	
	
	FX.Start(baseObj, container, x,y)
	
	
	self.container = container
	self.element = elem1
	--*****************************************************8	


	
	
    
    local e = GameEventManager:Construct("EndMessage")
    local nextTime = GetGameTime() + self.duration
    GameEventManager:SendDelayed( e, self, nextTime )

end


function GMSG:UpdateMessage(msg)
	--self.textView:SetString(msg)
	local world = self:GetParent()
	local FX = world.FX
	LOG("FX.ChangeText "..msg)
	FX.ChangeText(self.container,self.element,msg)
	
    --continuous_blend(view,1.0,0.0,GetGameTime()+400,self.extend)
	--self.extend = 500	
end


--Just Cleans up event
--cleaning up after container in HexBattleGround
function GMSG:OnEventEndMessage(event)
	LOG("Destroy Message Obj ->  "..tostring(self.val))
	--[[
    
    --Setup GMSG Destruction
	if self.val then
		self:GetParent().messageList[self.xpos]=nil
	end
	--self.textView = nil
	--]]
	self.container = nil
	self.element = nil
    GameObjectManager:Destroy(self)

end

-- Event handlers here

return ExportClass("GMSG")



















--[[
class "GMSG" (GameObject)

GMSG.AttributeDescriptions = AttributeDescriptionList() 
GMSG.AttributeDescriptions:AddAttribute('int', 'message_duration', {default=2100}) 
GMSG.AttributeDescriptions:AddAttribute('string', 'message', {default=""})

function GMSG:__init()
    super("GMSG")
	
	self.xpos = 265
	self.ypos = 280
end



function GMSG:DamageMessage(msg,x,y)

	self:ShowMessage(msg,"font_info_red",x,y,false)

end

function GMSG:ShieldMessage(msg,x,y)

	self:ShowMessage(msg,"font_info_blue",x,y,false)

end



function GMSG:BigMessage(msg,x,y)

	self:ShowMessage(msg,"font_message",x,y,true)

end



function GMSG:SmallMessage(msg,x,y)
	self:ShowMessage(msg,"font_numbers_white",x,y,true)

end

function GMSG:ShowMessage(msg,font,x,y,float)
    LOG("ShowMessage() "..msg)
    self:SetAttribute("message",msg)
    local view = GameObjectViewManager:Construct("Text")
    local textView = CastToTextView(view)
    assert(view,"view "..msg.."not created")
    
    textView:SetString(msg)
    textView:SetFont(font)
    
    if not x then --no x,y co-ords   -- use center
    	x = self.xpos
        y = self.ypos
    end
    
    self:SetPos(x,y)
    self:SetView(view)
    
    view:StartAnimation("stand")
    if float then
	    local m = MovementManager:Construct("Gravity")
	    m:SetAttribute("Accel", 30)        -- 50 world units (pixels) per second^2
	    m:SetAttribute("StartX", x)
	    m:SetAttribute("StartY", y)
	    m:SetAttribute("EndX", x)
	    m:SetAttribute("EndY", y+120)
	    self:SetMovementController(m)
    end
    
    --Place in front of all gems
    view:SetSortingValue(-1)
    
    --continuous_scale(self,0.8,2.0,GetGameTime(),self:GetAttribute('message_duration')-300)
    continuous_blend(view,1.0,0.0,GetGameTime(),self:GetAttribute('message_duration')-300)
    
    
    local e = GameEventManager:Construct("EndMessage")
    local nextTime = GetGameTime() + self:GetAttribute('message_duration')
    GameEventManager:SendDelayed( e, self, nextTime )    

end


function GMSG:OnEventEndMessage(event)

    LOG("Destroy Message Obj - "..self:GetAttribute("message"))
    
    --Setup GMSGPlatform Destruction
    GameObjectManager:Destroy(self)    

end
-- Event handlers here

return ExportClass("GMSG")


--]]