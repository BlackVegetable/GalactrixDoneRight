-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "SwitchGems" (GameEvent)

SwitchGems.AttributeDescriptions = AttributeDescriptionList()
--SwitchGems.AttributeDescriptions:AddAttribute('GameObject', 'item', {serialize= 1})
SwitchGems.AttributeDescriptions:AddAttribute('int', 'broadcast', {default=0, serialize=1})
SwitchGems.AttributeDescriptions:AddAttribute('string', 'new_gem_id', {default="",serialize= 1})
SwitchGems.AttributeDescriptions:AddAttributeCollection('int', 'grid_id', {serialize= 1})
SwitchGems.AttributeDescriptions:AddAttributeCollection('GameObject', 'new_gems', {serialize=1})
SwitchGems.AttributeDescriptions:AddAttribute('int', 'force_update', {default=1, serialize=1})
SwitchGems.AttributeDescriptions:AddAttribute('int', 'cheat', {default=0, serialize=1})



function SwitchGems:__init()
	super("SwitchGems")
	self:SetSendToSelf(false)
end

function SwitchGems:do_OnReceive()

	local world = _G.SCREENS.GameMenu.world

	local gemID = self:GetAttribute("new_gem_id")
	LOG("SwitchGems OnReceive")
	if self:GetAttribute("broadcast")==0 then--Delete Gems - Construct New Gems
		for i=1,self:NumAttributes("grid_id") do
			--local gem = world:GetGem(self:GetAttributeAt("grid_id",i))
			--LOG("Destroy gem at "..tostring(self:GetAttributeAt("grid_id",i)))
			world:DestroyGem(self:GetAttributeAt("grid_id",i))
			self:PushAttribute("new_gems",GameObjectManager:Construct("Gems"))
		end
	
		self:SetAttribute("broadcast",1)
		self:SetSendToSelf(true)
		GameEventManager:Send(self)
	else--Set newly constructed gems in place.
		for i=1,self:NumAttributes("new_gems") do
			local gem = self:GetAttributeAt("new_gems",i)
			gem = _G.LoadGem(gemID,gem)
			local grid_id = self:GetAttributeAt("grid_id",i)
			--LOG("Construct "..gemID.." at "..tostring(grid_id).." "..gem:GetAttribute("particle"))
			world:SetGem(grid_id,gem)
			world:AddChild(gem)
			gem:SetPos(world.hexPts[grid_id][1],world.hexPts[grid_id][2])
		end
		
		if self:GetAttribute("cheat")==1 then
			world.item_skip_end_turn = true
		end
		if self:GetAttribute("force_update") == 1 then
			world:AdvanceState(_G.STATE_SEARCHING, 0)
			--world.state = _G.STATE_SEARCHING
			--local e = GameEventManager:Construct("Update")
			--GameEventManager:Send(e,world)
		end
		collectgarbage();
	end

end

return ExportClass("SwitchGems")
