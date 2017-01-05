-- BattleGround
--  this class defines the basic behaviour of the BattleGround objects
--


class "Item" (GameObject)



Item.AttributeDescriptions = AttributeDescriptionList()
Item.AttributeDescriptions:AddAttribute('string', 'name', {default=""})
Item.AttributeDescriptions:AddAttribute('string', 'description', {default=""})
Item.AttributeDescriptions:AddAttribute('string', 'icon', {default="img_item_01"})
Item.AttributeDescriptions:AddAttribute('int', 'engine_requirement', {default=5})
Item.AttributeDescriptions:AddAttribute('int', 'weapon_requirement', {default=3})
Item.AttributeDescriptions:AddAttribute('int', 'cpu_requirement', {default=3})
Item.AttributeDescriptions:AddAttribute('int', 'shield_requirement', {default=30})
Item.AttributeDescriptions:AddAttribute('int', 'lvl_requirement', {default=100})
Item.AttributeDescriptions:AddAttribute('int', 'psi_requirement', {default = 0})
Item.AttributeDescriptions:AddAttribute('int', 'cost', {default=1000})
Item.AttributeDescriptions:AddAttribute('int', 'rarity', {default=100})
Item.AttributeDescriptions:AddAttribute('int', 'recharge', {default=0})
Item.AttributeDescriptions:AddAttribute('int', 'status_on_enemy', {default = 0})
Item.AttributeDescriptions:AddAttribute('int', 'passive', {default = 0})


Item.AttributeDescriptions:AddAttribute('string', 'activation_sound', {default="snd_bomb"})
Item.AttributeDescriptions:AddAttribute('string', 'recharged_sound', {default="snd_recharge"})


Item.AttributeDescriptions:AddAttribute('int', 'end_turn', {default=1})--Players turn ends upon casting.
Item.AttributeDescriptions:AddAttribute('int', 'user_input', {default=0})--requires game object to be selected by user.


--Item.AttributeDescriptions:AddAttribute('int', 'power_rating', {default=10})

Item.y_offset = 90--offset for popup menu

function Item:__init(clid)
	super("Item")
	self.inactive = 0
	self.end_turn = true
	--BEGIN_STRIP_DS
	local function platformVars()
		self.message_x = 512
		self.message_y = 500
		self.message_input_y = 200
	end
	_G.NotDS(platformVars)
	--END_STRIP_DS
	local function platformVarsDS()
		self.message_x = 163
		self.message_y = 130
		self.message_input_y = 50
	end
	_G.DSOnly(platformVarsDS)
end



--[[--No longer used
function Item:ShowInfo(battleGround, player, itemIndex)
	LOG("ShowInfo item")
	local x = battleGround.coords[player]["item"][itemIndex][1]
	local y = battleGround.coords[player]["item"][itemIndex][2]

	local endTurnString
	if self:GetAttribute("end_turn") == 1 then
		endTurnString = "[ENDS_TURN]"
	else
		endTurnString = "[NOT_ENDS_TURN]"
	end
	local recharge = translate_text("[NO_RECHARGE]")
	if self:GetAttribute("recharge") > 0 then
		recharge = substitute(translate_text("[RECHARGE_X]"),self:GetAttribute("recharge"))
	end

   _G.GLOBAL_FUNCTIONS.ItemPopup(self.classIDStr, x, y)

end
--]]


function Item:ItemActive(engine,weapon,cpu,enemy,psi)

    local active = true
	if self.inactive ~= 0 then
		return false
	end

	if self:GetAttribute('status_on_enemy') == 1 then
		if enemy:GetAttribute('shield') > 0 then
			active = false
		end
	end

    if engine < self:GetAttribute('engine_requirement') then
        active = false
    end
    if weapon < self:GetAttribute('weapon_requirement') then
        active = false
    end
    if cpu < self:GetAttribute('cpu_requirement') then
        active = false
    end
	if psi < self:GetAttribute('psi_requirement') then
		active = false
	end
	if self:GetAttribute('passive') ~= 0 then
		active = false
	end
	local myHero = 	_G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	-- Using a negative required PSI to Say "Small Ship required"
	if self:GetAttribute('psi_requirement') < 0 then
		if myHero:GetAttribute("curr_ship"):GetAttribute("max_items") >= 6 then
			active = false
		end
	end

    return active
end




function Item:ActivateItem(battleGround,player)
	self.end_turn = true
	close_custompopup_menu()
	LOG("ITEM "..self.classIDStr.." Activated")
	--Display graphic for item activation now!!!!

	LOG("MessageX = " .. tostring(self.message_x))
	_G.BigMessage(battleGround,self:GetAttribute("name"),self.message_x,self.message_y) -- 512,500

	if self:GetAttribute("user_input")~=0 then
		--Display message asking for user input

		--LOG(" set user input dest")
		battleGround.user_input_dest = self
		battleGround.state = self:GetAttribute("user_input")
		--LOG("User Input Dest "..ClassIDToString(battleGround.user_input_dest:GetClassID()))


		--_G.BigMessage(battleGround,battleGround:GetInputMsg(self:GetAttribute("user_input"),player:GetAttribute("ai")),self.message_x,self.message_input_y) -- 512,200
		_G.BigMessage(battleGround, ITEMS[self.classIDStr].input_msg, self.message_x, self.message_input_y)
		if player:GetAttribute("ai")~=0 then
			local e = GameEventManager:Construct("GetAIUserInput")
			e:SetAttribute("player",player)
			e:SetAttribute("BattleGround",battleGround)
			local nextTime = GetGameTime() + battleGround:GetAttribute("ai_delay")
			GameEventManager:SendDelayed(e,self,nextTime)
		else
			_G.SCREENS.GameMenu:CycleUILocation(0)--Cycle to board
		end
	else
		battleGround.state = _G.STATE_ENDING_TURN
		PlaySound(self:GetAttribute("activation_sound"))
		self:Activate(battleGround,player,nil,self:SpendActivationEnergy(player))
		--self:SpendActivationEnergy(player)
		if self.end_turn then
			if self:GetAttribute("end_turn") == 0 then
				battleGround.item_skip_end_turn = true
				_G.LAST_TURN_FREE = true
			end
			self:EndTurn(battleGround,player)
		else
			self:EndItemActivation(battleGround,player)
		end
	end

	--SCREENS[battleGround:GetAttribute("GameMenu")]["Update"..battleGround.ui](SCREENS[battleGround:GetAttribute("GameMenu")])
	_G.GLOBAL_FUNCTIONS[string.format("Update%s",battleGround.ui)]()


end

function Item:SpendActivationEnergy(player)
	--get energy levels before item activation
	local weapon = player:GetAttribute("weapon")
	local engine = player:GetAttribute("engine")
	local cpu	 = player:GetAttribute("cpu")
	local psi   = player:GetAttribute("psi")

	local weapon_cost = self:GetAttribute("weapon_requirement")
	local engine_cost = self:GetAttribute("engine_requirement")
	local cpu_cost 	  = self:GetAttribute("cpu_requirement")
	local psi_cost    = self:GetAttribute("psi_requirement")
	if weapon_cost > 0 then
		local e = GameEventManager:Construct("LoseEnergy")
		e:SetAttribute("effect", "weapon")
		e:SetAttribute("mutate", 0)
		e:SetAttribute("show", 0)
		e:SetAttribute("amount", weapon_cost)
		player:OnEventLoseEnergy(e)
	end
	if engine_cost > 0 then
		e = GameEventManager:Construct("LoseEnergy")
		e:SetAttribute("effect", "engine")
		e:SetAttribute("mutate", 0)
		e:SetAttribute("show", 0)
		e:SetAttribute("amount", engine_cost)
		player:OnEventLoseEnergy(e)
	end
	if cpu_cost > 0 then
		e = GameEventManager:Construct("LoseEnergy")
		e:SetAttribute("effect", "cpu")
		e:SetAttribute("mutate", 0)
		e:SetAttribute("show", 0)
		e:SetAttribute("amount", cpu_cost)
		player:OnEventLoseEnergy(e)
	end
	if psi_cost > 0 then
		e = GameEventManager:Construct("LoseEnergy")
		e:SetAttribute("effect", "psi")
		e:SetAttribute("mutate", 0)
		e:SetAttribute("show", 0)
		e:SetAttribute("amount", psi_cost)
		player:OnEventLoseEnergy(e)
	end

	return weapon,engine,cpu,psi
end

function Item:OnEventGetUserInput(event)
	LOG("User Input Event")
	local battleGround = event:GetAttribute("BattleGround")
	local player = event:GetAttribute("player")
	local obj = event:GetAttribute("obj")
	if battleGround and battleGround.state == _G.ITEMS[self.classIDStr].user_input and obj then
		battleGround:DeselectGem(battleGround.g1)
		battleGround:DeselectGem(battleGround.g2)
		if self:ValidInput(obj) then
			battleGround.state = _G.STATE_ENDING_TURN
			PlaySound(self:GetAttribute("activation_sound"))
			self:Activate(battleGround,player,obj,self:SpendActivationEnergy(player))
			--self:SpendActivationEnergy(player)
			if self.end_turn then
				if self:GetAttribute("end_turn") == 0 then
					battleGround.item_skip_end_turn = true
					_G.LAST_TURN_FREE = true
				end
				self:EndTurn(battleGround,player)
			else
				self:EndItemActivation(battleGround,player)
			end
		else
			_G.BigMessage(battleGround,ITEMS[self.classIDStr].input_msg,self.message_x,self.message_input_y) -- 512,200
		end
	end
	LOG("Done OnEventGetUserInput()")
end

function Item:EndItemActivation(battleGround,player)
	LOG("EndItemActivation")
	local sci = player:GetCombatStat("science")
	local reduction = math.floor(sci / 75)

	if _G.GLOBAL_FUNCTIONS.RandomRounding(sci, 75) == "up" then
		reduction =	math.ceil(sci / 75)
	else
		reduction = math.floor(sci / 75)
	end

	-- Science-based cooldown reduction --
	if self:GetAttribute("recharge") <= 1 then
		self.inactive = self:GetAttribute("recharge")
	elseif self:GetAttribute("recharge") - reduction <= 1 then
		self.inactive = 1
	else
		self.inactive = self:GetAttribute("recharge") - reduction
	end

	--[[
	if self.end_turn and self:GetAttribute("end_turn")==0 and player:GetAttribute("ai") == 1 then
		local e = GameEventManager:Construct("NewTurn")
		e:SetAttribute("BattleGround",battleGround)
		local nextTime = GetGameTime() + battleGround:GetAttribute("ai_delay")
		GameEventManager:SendDelayed( e, player,nextTime)
	end
	]]--

end

function Item:EndTurn(battleGround,player)
	local e = GameEventManager:Construct("EndTurn")
	GameEventManager:SendDelayed( e, battleGround, GetGameTime() + 1250)
	--battleGround:OnEventEndTurn()
	self:EndItemActivation(battleGround,player)
end

-- destroys all columns containing the specified gems
function Item:DestroyColumn(world, gems, award)
	local destroyGems = { }
	for i,v in pairs(gems) do
		local currGem = v
		while currGem ~= -1 do
			table.insert(destroyGems, currGem)
			currGem = world.hexAdjacent[currGem][1]
		end
		currGem = world.hexAdjacent[v][4]
		while currGem ~= -1 do
			table.insert(destroyGems, currGem)
			currGem = world.hexAdjacent[currGem][4]
		end
	end

	self:ClearGems(world, destroyGems, award, true)
end


-- destroys a gem and all the adjacent gems
function Item:ExplodeGem(world, gems, award)
	local adjacentGems = {}
	for i,v in pairs(gems) do
		for j=1,6 do
			if world.hexAdjacent[v][j] ~= -1 then
				table.insert(adjacentGems, world.hexAdjacent[v][j])
			end
		end
	end

	for i,v in pairs(gems) do
		table.insert(adjacentGems, v)
	end

	self:ClearGems(world, adjacentGems, award,true)
end

function Item:GetAdjacentGems(world, gems)

	local adjacentGems = {} -- stores the list of gems to destroy
	local adjacencyTracker = {} -- stores which gems are in the destroy list. used for duplicate checks only
	for i,v in pairs(gems) do
		for j=1,6 do
			if world.hexAdjacent[v][j] ~= -1 and not adjacencyTracker[world.hexAdjacent[v][j]] then
				table.insert(adjacentGems, world.hexAdjacent[v][j])
				adjacencyTracker[world.hexAdjacent[v][j]] = true
			end
		end
	end

	for i,v in pairs(gems) do
		if not adjacencyTracker[v] then--prevent doubling up initial gemlist
			table.insert(adjacentGems, 1, v)--Insert initial gemList at start of list.
		end
	end

	return adjacentGems
end

-- Adds an effect from an item.(player,effectID,obj,duration,itemCode)
function Item:AddEffect(battleGround,player,effectID,obj,duration,itemCode)
--	local enemy = world.GetEnemy(player)
--	if obj == enemy then
--		if enemy:GetAttribute("shield") == 0 then
--			if self:GetAttribute("end_turn") == 0 then
--				battleGround.item_skip_end_turn = true
--			end
--		self.end_turn = false
--		LOG("AddEffect for duration "..tostring(duration))
--		_G.AddEffect(player,effectID,obj,duration,itemCode)
--		end
--	else
--		if self:GetAttribute("end_turn") == 0 then
--			battleGround.item_skip_end_turn = true
--		end
--		self.end_turn = false
--		LOG("AddEffect for duration "..tostring(duration))
--		_G.AddEffect(player,effectID,obj,duration,itemCode)
--	end
	if self:GetAttribute("end_turn") == 0 then
		battleGround.item_skip_end_turn = true
		_G.LAST_TURN_FREE = true
	end

	LOG(effectID)
	if effectID == "[FC05_NAME]" then
		if player:GetAttribute("player_id") == 1 then
			_G.PLAYER_1_COOLANT = 0
		elseif player:GetAttribute("player_id") == 2 then
			_G.PLAYER_2_COOLANT = 0
		end
	end

	self.end_turn = false
	LOG("AddEffect for duration "..tostring(duration))
	_G.AddEffect(player,effectID,obj,duration,itemCode)
end



-- reset the board (similar to Black Hole)
function Item:ResetBoard(battleGround)
	if self:GetAttribute("end_turn") == 0 then
		battleGround.item_skip_end_turn = true
		_G.LAST_TURN_FREE = true
	end
	self.end_turn = false

	local e = GameEventManager:Construct("ClearBoard")
	GameEventManager:Send(e, battleGround)
end

-- returns a list composed of a given number of random gems
-- gemType parameter determines a gem type that should be excluded from the list
function Item:GetRandomGems(numGems, gemType, world)
	local randCounter =1
	local gemList = { }
	local exclusionList = {}
	if gemType then
		if type(gemType)=="table" then
			for i,v in pairs(gemType) do
				exclusionList[v]=true
			end
		else
			exclusionList[gemType]=true
		end
	end
	for i=1, numGems do
		local index
		--index = SCREENS.GameMenu.world:MPRandom(1,55)
		denyIndex = true
		--[[
		if type(gemType) == "table" then
		--]]
			while denyIndex do
				index = SCREENS.GameMenu.world:MPRandom(1,55, randCounter)
				randCounter = randCounter + 1
				denyIndex = false
				if gemList[index] then
					denyIndex = true
				end
				if exclusionList[world:GetGem(index).classIDStr] then
					denyIndex = true
				end
			end
			--[[
		else
			while gemList[index] or world:GetGem(index).classIDStr == gemType do
				index = math.mod(index + SCREENS.GameMenu.world:MPRandom(0,54, randCounter), 55) + 1
				randCounter = randCounter + 1
			end
		end
		--]]
		gemList[index] = true
		--[[
		for i,v in pairs(gemList) do
			LOG("GemList = " .. tostring(i) .. "   " .. tostring(v))
		end
		LOG("-------------------------")
		--]]

	end

	local returnTable = { }
	for i,v in pairs(gemList) do
		table.insert(returnTable, i)
	end
	return returnTable
end

-- changes all gems in the provided list to another type
function Item:TransformGems(world, gemList, particles, newGemType)
	if self:GetAttribute("end_turn") == 0 then
		world.item_skip_end_turn = true
		_G.LAST_TURN_FREE = true
	end

	self.end_turn = false


	if SCREENS.GameMenu.world.host then
		--LOG("Creating SwitchGem event  " .. tostring(newGemType))
		local switchEvent = GameEventManager:Construct("SwitchGems")
		switchEvent:SetAttribute("new_gem_id",newGemType)
		for i,v in ipairs(gemList) do
			switchEvent:PushAttribute("grid_id",v)
		end
		switchEvent:SetAttribute("force_update", 1)
		GameEventManager:Send(switchEvent,world.host_id)
	end
end

function Item:ClearGems(battleGround,gemList,award,noSound,hide_particles)
	if self:GetAttribute("end_turn") == 0 then
		battleGround.item_skip_end_turn = true
	end
	battleGround:ClearGems(gemList,award,noSound,hide_particles)

	self.end_turn = false
end

-------------------------------------------
--Use this funct to Clear Effects From Obj
function Item:ClearEffects(obj)
	if SCREENS.GameMenu.world.host then
		for i=obj:NumAttributes("Effects"),1,-1 do
			local effect = obj:GetAttributeAt("Effects",i)

			-- Heat Ray Coolant Reset Early --
			local myHero = 	_G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
			local myEnemy = _G.SCREENS.GameMenu.world:GetEnemy(myHero)
			local myHero_id = myHero:GetAttribute("player_id")
			local myEnemy_id = myEnemy:GetAttribute("player_id")

			if obj == myHero then
				if myHero_id == 1 then
					_G.PLAYER_1_COOLANT = 9
				elseif myHero_id == 2 then
					_G.PLAYER_2_COOLANT = 9
				end
			elseif obj == myEnemy then
				if myEnemy_id == 1 then
					_G.PLAYER_1_COOLANT = 9
				elseif myEnemy_id == 2 then
					_G.PLAYER_2_COOLANT = 9
				end
			end

			-- Invincibility removing shields --
			if effect:GetAttribute("name") == "[FC13_NAME]" then
				obj:SetAttribute("shield", 0)
			end
			GameObjectManager:Destroy(effect)

		end
	end
end

function Item:IncreaseMaxEnergy(world, player, effect, amt)
	--Was using "font_small_event" - but the font never got fixed
	if type(effect) == "table" then
		for i,v in pairs(effect) do
			local effectMax = string.format("%s_max", v)
			player:SetAttribute(effectMax, player:GetAttribute(effectMax) + amt)
		end
		if amt > 0 then
			_G.ShowMessage(world, "[MAX_ENERGY_INCREASE]", "font_message", self.message_x, self.message_input_y, false)
		elseif amt < 0 then
			_G.ShowMessage(world, "[MAX_ENERGY_DECREASE]", "font_message", self.message_x, self.message_input_y, false)
		end
	else
		local effectTxt = translate_text(string.format("[%s]", string.upper(effect)))
		--LOG(string.format("Increase Max Energy Strings  ->%s<-",effectTxt))
		effectTxt = string.gsub(effectTxt,":","")--strip out Colons
		_G.ShowMessage(world, substitute(translate_text("[MAX_TYPE_INCREASE]"), string.upper(effectTxt)), "font_message", self.message_x, self.message_input_y, false)
		local effectMax = string.format("%s_max", effect)
		player:SetAttribute(effectMax, player:GetAttribute(effectMax) + amt)
	end
end


function Item:DeductEnergy(world, player, effect, amt, hideMsg)
	self:AwardEnergy(world,player,effect,-amt,hideMsg)
end


function Item:AwardEnergy(world, player, effect, amt)
	LOG("AwardEnergy " .. player:GetAttribute("player_id"))

	local e
	if amt > 0 then
		if player:HasAttribute(string.format("%s_max", effect)) then
			amt = math.min(amt, player:GetAttribute(string.format("%s_max", effect)) - player:GetAttribute(effect))
		end
		e = GameEventManager:Construct("ReceiveEnergy")
		e:SetAttribute("amount", amt)
	elseif amt < 0 then--negative amount
		e = GameEventManager:Construct("LoseEnergy")
		e:SetAttribute("amount", math.min(-amt, player:GetAttribute(effect)))

	end

	if e then -- e is not constructed if amt == 0
		e:SetAttribute("effect", effect)
		e:SetAttribute("mutate", 0)
		GameEventManager:Send(e, player)
	end
end

function Item:DamagePlayer(sourcePlayer,destPlayer,amount,direct,particle,sourceObj)
	local world = _G.SCREENS.GameMenu.world
	world:DamagePlayer(sourcePlayer,destPlayer,amount,direct,particle,self.index)
end



--Gets AI user input after delay
function Item:OnEventGetAIUserInput(event)

	--event:SetAttribute("obj",self:GetAIUserInput(event:GetAttribute("BattleGround"),event:GetAttribute("player")))--set obj to new object
	--self:OnEventGetUserInput(event)

	local battleGround =event:GetAttribute("BattleGround")
	e = GameEventManager:Construct("GetUserInput")
	e:SetAttribute("obj",self:GetAIUserInput(battleGround,event:GetAttribute("player")))
	e:SetAttribute("BattleGround",battleGround)
	e:SetAttribute("player",event:GetAttribute("player"))
	GameEventManager:SendDelayed(e,self,GetGameTime()+battleGround:GetAttribute("ai_delay"))


end

function Item:Recharged()
	PlaySound(self:GetAttribute("recharged_sound"))
end

function Item:AddRecharge(amount)
	LOG("Item has had recharge time added")
	self.inactive = self.inactive + amount
	--self:SetAttribute("recharge", self:GetAttribute("recharge") - amount)
end

---PUT ITEM CODE HERE

function Item:Activate(battleGround,player,obj)
	LOG("Item:Activate default")

end

function Item:ShouldAIUseItem(battleGround,player)
	LOG("Item:ShouldAIUseItem default")

	return math.random(0,100)
end


function Item:ValidInput(obj)
	LOG("Item:ValidateInput default")

	return true
end

function Item:GetAIUserInput(battleground,player)
	LOG("Item:GetAIUserInput default")

	return --return user input object
end

return ExportClass("Item")
