-- BattleGround
--  this class defines the basic behaviour of the BattleGround objects
--  

class "Ship" (GameObject)

Ship.AttributeDescriptions = AttributeDescriptionList()
Ship.AttributeDescriptions:AddAttribute('string', 'model', {default=""})
Ship.AttributeDescriptions:AddAttribute('string', 'portrait', {default=""})

Ship.AttributeDescriptions:AddAttribute('string', '3d_model', {default=""})

Ship.AttributeDescriptions:AddAttribute('int', 'cost', {default=1000})

Ship.AttributeDescriptions:AddAttribute('int', 'shield', {default=20})
Ship.AttributeDescriptions:AddAttribute('int', 'hull', {default=80})
Ship.AttributeDescriptions:AddAttribute('int', 'weapons_rating', {default=4})
Ship.AttributeDescriptions:AddAttribute('int', 'engine_rating', {default=4})
Ship.AttributeDescriptions:AddAttribute('int', 'cpu_rating', {default=4})
Ship.AttributeDescriptions:AddAttribute('int', 'cargo_capacity', {default=25})
Ship.AttributeDescriptions:AddAttribute('int', 'max_items', {default=8})--No more than 8
Ship.AttributeDescriptions:AddAttribute('int', 'power_rating', {default=100})

Ship.AttributeDescriptions:AddAttributeCollection('GameObject', 'battle_items',{})--max num = 8 - used for battles

Ship.AttributeDescriptions:AddAttribute('int',     'turn_speed',                     {default=150} )
Ship.AttributeDescriptions:AddAttribute('int',     'max_speed',                     {default=100} )
Ship.AttributeDescriptions:AddAttribute('int',     'acceleration',                     {default=100} )
Ship.AttributeDescriptions:AddAttribute('int',     'decceleration',                     {default=100} )
Ship.AttributeDescriptions:AddAttribute('int',     'engines',                     {default=2} )
-- Ship.AttributeDescriptions:AddAttributeCollection('GameObject', 'weapons')
-- Ship.AttributeDescriptions:AddAttributeCollection('GameObject', 'systems')

function Ship:__init()
   super("Ship")
   self:InitAttributes()   
	
   self.rand = math.random(1,1000)
   LOG("Ship:__init "..tostring(self.rand))
   --self:InitItems()
   self.particle_offset = 0

end

function Ship:PreDestroy()
	LOG("PreDestroy() ship --"..tostring(self.rand))
	
end


function Ship:GetSystemView(sprite)
	
	local view
	local model = self:GetAttribute("3d_model")
	view = self:Get3DView(model)

	if view then
		CastToModel3DView(view):SetPosition(self.pilot:GetX(), self.pilot:GetY(), -100*self.pilot.sorting_value)--z position does nothing why?
	else
		if not sprite or string.len(sprite)~= 1 then
			sprite = "N"
		end
		sprite = string.format("ZS%s%d",sprite,self:GetAttribute("engines"))
		--LOG("Construct sprite view "..sprite)
		view = GameObjectViewManager:Construct("Sprite",sprite)
		
		view:StartAnimation("stand")
		view:SetMaxRotation(math.pi/12)
		view:SetSortingValue(-20)
	end
	LOG("SortingValue")
	LOG("Before "..tostring(view:GetSortingValue()))
	--view:SetSortingValue(-self.pilot.sorting_value)
	LOG("After "..tostring(view:GetSortingValue()))
	view:SetAutoDir(true)	
	
	return view
end

--No longer necessary, but we keep it around out of sympathy
function Ship:GetStarMapView(sprite)
	return self:GetSystemView(sprite) 	
end	

function Ship:ClearBattleItems()
	local numItems = self:NumAttributes("battle_items")
	for j=1,numItems do
		local item = self:GetAttributeAt("battle_items",1)
		self:EraseAttribute("battle_items",item)
		_G.GLOBAL_FUNCTIONS.ClearItem(item)
	end	
end

-- updates this ship's items for battle from an item loadout object
function Ship:BattleItemsFromLoadout(Loadout, player)
   -- erase what is currently in the battle items list
	self:ClearBattleItems()
	--local weaponMax = self:GetAttribute("weapons_rating")
	local ship = player:GetAttributeAt("ship_list", player:GetAttribute("ship_loadout")):GetAttribute("ship")
	local weaponMax = SHIPS[ship].weapons_rating
	--LOG("Ship rating = " .. tostring(self:GetAttribute("weapons_rating")) .. "    Player rating = " .. tostring(player:GetAttribute("weapon_max")))
	--local engineMax = self:GetAttribute("engine_rating")
	local engineMax = SHIPS[ship].engine_rating
	--local cpuMax = self:GetAttribute("cpu_rating")
	local cpuMax = SHIPS[ship].cpu_rating
	local maxEquip = self:GetAttribute("max_items")
	local weapon = 0
	local engine = 0
	local cpu = 0
	
	-- update the battle items list with the loadout contents
	local maxAttribs = Loadout:NumAttributes("items")
	for i=1,maxAttribs do
		local itemID = Loadout:GetAttributeAt("items",i)
		--LOG("battle item "..itemID)
		if i <= maxEquip and 
				weapon+_G.ITEMS[itemID].weapon_requirement <= weaponMax and
				engine+_G.ITEMS[itemID].engine_requirement <= engineMax and
				cpu+_G.ITEMS[itemID].cpu_requirement <= cpuMax then
				
			weapon = weapon + _G.ITEMS[itemID].weapon_requirement
			engine = engine + _G.ITEMS[itemID].engine_requirement
			cpu = cpu + _G.ITEMS[itemID].cpu_requirement
			local item = _G.GLOBAL_FUNCTIONS.LoadItem(itemID)
			self:PushAttribute("battle_items",item)
			item.index = i
			LOG("Added to battle items: " .. itemID)		
		end		
	end
end



function Ship:Get3DView(model)
	local view = nil
	--BEGIN_STRIP_DS
	local function Get3DView()
		if model ~= "" then
			LOG("Construct Model3DView "..model)
			view = GameObjectViewManager:Construct("Model3DView",model)
			LOG("Set start position of model")
			--CastToModel3DView(view):SetPosition(self:GetX() - 1366/2,self:GetY() - 768/2,0.0)--this doesn't currently work, ships have no position
			LOG("Set scale of model")
			CastToModel3DView(view):SetScale(self.model_scale)
			--CastToModel3DView(view):SetScale(0.5)
			--CastToModel3DView(view):SetScale(2.0)
		end
		return view
	end
	view = _G.NotDS(Get3DView)
	--END_STRIP_DS
	return view
end


--[[
function _G.GetShipClass(id)
	if SHIPS[id].max_items < 3 then
		return "[FIGHTER]"
	elseif SHIPS[id].max_items == 3 then
		return "[SHUTTLE]"
	elseif SHIPS[id].max_items == 4 then
		return "[FRIGATE]"
	elseif SHIPS[id].max_items == 5 then
		return "[LIGHT_CRUISER]"
	elseif SHIPS[id].max_items == 6 then
		return "[HEAVY_CRUISER]"
	elseif SHIPS[id].max_items == 7 then
		return "[DREADNAUGHT]"
	elseif SHIPS[id].max_items == 8 then
		return "[CAPITAL]"
	end
end
]]--
--[[
function Ship:GetClass()
	if self:GetAttribute("max_items") < 3 then
		return "[FIGHTER]"
	elseif self:GetAttribute("max_items") == 3 then
		return "[SHUTTLE]"
	elseif self:GetAttribute("max_items") == 4 then
		return "[FRIGATE]"
	elseif self:GetAttribute("max_items") == 5 then
		return "[LIGHT_CRUISER]"
	elseif self:GetAttribute("max_items") == 6 then
		return "[HEAVY_CRUISER]"
	elseif self:GetAttribute("max_items") == 7 then
		return "[DREADNAUGHT]"
	elseif self:GetAttribute("max_items") >= 8 then
		return "[CAPITAL]"
	end
end
]]--
return ExportClass("Ship")