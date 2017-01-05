-- Gems
--  base class for all gems

use_safeglobals()






class "Gems" (GameObject)

Gems.AttributeDescriptions = AttributeDescriptionList()
Gems.AttributeDescriptions:AddAttribute('int', 'isGem', {default=1}) 
Gems.AttributeDescriptions:AddAttribute('int', 'matchable', {default=1}) 
Gems.AttributeDescriptions:AddAttribute('int', 'swapable', {default=1}) 
Gems.AttributeDescriptions:AddAttribute('int', 'gem_delay', {default=200}) 

Gems.AttributeDescriptions:AddAttribute('int', 'grid_id', {default=-1}) 

-- Rarity
-- 0 = (never randomly occurs) 
-- 1 = 20%

Gems.AttributeDescriptions:AddAttribute('int', 'rarity', {default=1})
Gems.AttributeDescriptions:AddAttribute('string', 'beam', {default=""})
Gems.AttributeDescriptions:AddAttribute('string', 'particle', {default="WhiteExplosion"})
Gems.AttributeDescriptions:AddAttribute('string', 'font', {default=""})

Gems.AttributeDescriptions:AddAttribute('string', 'sound', {default="snd_shoot"})
Gems.AttributeDescriptions:AddAttribute('string', 'effect', {default= "intel"})
Gems.AttributeDescriptions:AddAttribute('int', 'amount', {default= 0})

Gems.AttributeDescriptions:AddAttribute('int', 'x_source_1', {default=128})
Gems.AttributeDescriptions:AddAttribute('int', 'y_source_1', {default=640})
Gems.AttributeDescriptions:AddAttribute('int', 'x_source_2', {default=896})
Gems.AttributeDescriptions:AddAttribute('int', 'y_source_2', {default=640})


function Gems:__init()
    super("Gems")
    self.GemMatch = {}
	self.id = 0
	self.matched=0
	self.grid_id = -1
end

function Gems:PreDestroy()
	LOG("PreDestroy called for type Gems")
	local world = SCREENS.GameMenu.world
	--BEGIN_STRIP_DS
	local function showParticles()
		if self:GetAttribute("particle")~="" then
			AttachParticles(world, self:GetAttribute('particle'), self:GetX(),self:GetY())		
		end
	end
	_G.NotDS(showParticles)
	--END_STRIP_DS
	
	
	if world then--in case game has ended- with world being destroyed.
		if self.grid_id < 0 then
			--LOG("world:GetGemFromPos")
			self.grid_id = world:GetGemFromPos(self:GetX(),self:GetY())
		end
		world.gems[self.grid_id]=nil
		--LOG("Nil grid_id "..tostring(self.grid_id))
		
		--[[
		local i = self:GetAttribute("grid_id")
		--LOG(string.format("predestroy %d",i))
		world:SetGem(i,nil)
		
		--]]
	end
	--LOG(string.format("Matched->Destroyed->SetToNil %d",i))--Consistency debug
end



-- Event handlers here
return ExportClass("Gems")
