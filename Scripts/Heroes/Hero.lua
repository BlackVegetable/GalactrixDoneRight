-- Hero - Battle-Hero

use_safeglobals()


class "Hero" (GameObject)

local playerTurnCounter = 0;

_G.TOTAL_TURNS = 0;
-- BEGIN ATTRIBUTE DESCRIPTIONS
local attribs = AttributeDescriptionList()
Hero.AttributeDescriptions = attribs

_G.LoadAndExecute("HeroStateInit","SetupAttributes",true,attribs)
--local HSI = import "HeroStateInit"
--HSI.SetupAttributes(attribs)
--HSI = nil
--purge_garbage()


local MAX_ENCOUNTER_DESTS = 3
local PI = math.pi

function Hero:__init()
	super("Hero")

	_G.LoadAndExecute("HeroStateInit","Initialize",false,self)

end


function Hero:PreDestroy()
	LOG(string.format("%s:PreDestroy()",tostring(self.classIDStr)))
	if _G.is_open("MultiplayerGameSetup") then
		local player_id = self:GetAttribute("player_id")
		if self == _G.SCREENS.MultiplayerGameSetup.players[player_id] then
			_G.SCREENS.MultiplayerGameSetup.players[player_id]=nil
		end
	end

	if _G.is_open("MPLobby") then
		local player_id = self:GetAttribute("player_id")
		if self == _G.SCREENS.MPLobby.players[player_id] then
			_G.SCREENS.MPLobby.players[player_id]=nil
		end
	end
end


function Hero:SetSystemNeutral()
	self.neutral = self:GetCurrSystem()
end

function Hero:ResetEncounters()
	self.num_encounters = -1
	self.neutral = nil
end

function Hero:GetCurrSystem()
	return self:GetAttribute("curr_system")
end

function Hero:GetCurrLoc()
	return self:GetAttribute("curr_loc")
end

function Hero:SetPlayerTurnCounter(n)
	playerTurnCounter = n
end

function Hero:GetLevel(intelAmt)
	local intel = intelAmt or self:GetAttribute("intel")
	local lvl = 1
	while intel >= (20 + (lvl * 10)) do
		intel = intel - (20 + (lvl*10))
		lvl = lvl + 1
	end

	return math.min(50, lvl)

--[[ incorrect level determination code?
	if (math.ceil(intel/50) == intel/50) then
		return ((intel/50) + 1)
	end
	return math.ceil(self:GetAttribute("intel")/50)
]]--
	--[[ old level determination code
	local stats = 1
	stats = stats + self:GetAttribute("gunnery")
	stats = stats + self:GetAttribute("engineer")
	stats = stats + self:GetAttribute("science")
	stats = stats + self:GetAttribute("pilot")
	return math.floor(stats / 5)
]]--
end

function Hero:GetCombatStat(stat)
	local val = self:GetAttribute(stat) + self.statBonus[stat]
	for i=1,self:NumAttributes("Effects") do
		if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS01_NAME]" then
			val = math.floor(val / 2)
		end
		if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC16_NAME]" then
			val = math.floor(val * 0.8)
		end
		if stat == "gunnery" then
			if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC05_NAME]" then
				if self:GetAttribute("player_id") == 1 then
					val = math.ceil(val * (0.1 + _G.PLAYER_1_COOLANT * 0.1))
				elseif self:GetAttribute("player_id") == 2 then
					val = math.ceil(val * (0.1 + _G.PLAYER_2_COOLANT * 0.1))
				end
			end
		end
		if stat == "engineer" then
			if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC06_NAME]" then
				val = math.floor(val * 0.35)
			end
		end
		if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC07_NAME]" then
			if stat == "science" then
				if self:GetAttribute("curr_ship"):GetAttribute("max_items") == 3 then
					val = math.ceil(val * 0.7)
				elseif self:GetAttribute("curr_ship"):GetAttribute("max_items") == 4 then
					val = math.ceil(val * 0.6)
				else
					val = math.ceil(val * 0.5)
				end
			elseif stat == "pilot" then
				if self:GetAttribute("curr_ship"):GetAttribute("max_items") == 3 then
					val = math.floor(val * 1.8)
				elseif self:GetAttribute("curr_ship"):GetAttribute("max_items") == 4 then
					val = math.floor(val * 1.65)
				else
					val = math.floor(val * 1.5)
				end
			end
		end
	end

	if val > 245 then
		val = 245
	end

	return val
end

function Hero:AddCombatStat(stat, bonus)
	if stat then
		self.statBonus[stat] = self.statBonus[stat] + bonus
		self.matchBonus = { 	weapon = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(self:GetCombatStat("gunnery"),0.2)),
								engine = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(self:GetCombatStat("engineer"),0.2)),
								cpu =    math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(self:GetCombatStat("science"),0.2)),
								shield = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(self:GetCombatStat("pilot"),0.6))
								}
	end
end

function Hero:ResetCombatStats()
	self.statBonus = { gunnery = 0, engineer = 0, science = 0, pilot = 0, cargo = 0 }
end

--Adds average of the total difference in stats to self. Also updates intel to reflect level.
function Hero:LevelToHero(hero)
	local minLevel = HEROES[self.classIDStr].min_level
	local heroLevel = hero:GetLevel()

	if not minLevel then
		minLevel = 1
	end

--	if heroLevel - minLevel < 0 then
--		return minLevel -- hero is below the AI's min level
--	end

	local endLevel = math.max(heroLevel, minLevel)
	local lvl = 1
	local intel = 0
	while lvl < endLevel + math.random(-2, 2) do
		lvl = lvl + 1
		intel = intel + (20 + (lvl * 10))
	end
	local lvlMultiplier = math.max(math.floor((heroLevel-minLevel)/2), 0)

	self:SetAttribute("intel", intel + math.random(0, 30))

	if HEROES[self.classIDStr].boss then
		-- don't scale up bosses
		self:SetAttribute("gunnery",  HEROES[self.classIDStr].base_gunnery)
		self:SetAttribute("engineer", HEROES[self.classIDStr].base_engineer)
		self:SetAttribute("science",  HEROES[self.classIDStr].base_science)
		self:SetAttribute("pilot",    HEROES[self.classIDStr].base_pilot)

	else
		self:SetAttribute("gunnery",  HEROES[self.classIDStr].base_gunnery  + (lvlMultiplier * HEROES[self.classIDStr].gain_gunnery))
		self:SetAttribute("engineer", HEROES[self.classIDStr].base_engineer + (lvlMultiplier * HEROES[self.classIDStr].gain_engineer))
		self:SetAttribute("science",  HEROES[self.classIDStr].base_science  + (lvlMultiplier * HEROES[self.classIDStr].gain_science))
		self:SetAttribute("pilot",    HEROES[self.classIDStr].base_pilot    + (lvlMultiplier * HEROES[self.classIDStr].gain_pilot))
	end

end

function Hero:UpdateLevel(gunnery,engineer,science,pilot)
	gunnery = gunnery or 0
	engineer = engineer or 0
	science = science or 0
	pilot = pilot or 0
	self:SetAttribute("gunnery",self:GetAttribute("gunnery")+gunnery)
	self:SetAttribute("engineer",self:GetAttribute("engineer")+engineer)
	self:SetAttribute("science",self:GetAttribute("science")+science)
	self:SetAttribute("pilot",self:GetAttribute("pilot")+pilot)
end




function Hero:GetGravity()
	local gravity = 0
	local loc = self:GetCurrLoc()
	loc = self:GetAttribute("curr_loc_obj")
	if loc then
		if loc.gravity then
			LOG("gravity set")
			gravity = loc.gravity
		end
	end


	return gravity
end

function Hero:GetFactionData(faction)
	if CollectionContainsAttribute(_G.Hero, "encountered_factions", faction) then
		return faction
	else
		return _G.FACTION_UNKNOWN
	end
end

function Hero:GetFactionStanding(faction)

	if (faction == 0) then
		return _G.STANDING_NEUTRAL
	end
	local standing = self:GetAttributeAt("faction_standings",faction)

	if standing <= -50 then
		standing = _G.STANDING_CRIMINAL
	elseif standing <= -10 then -- > -49
		standing = _G.STANDING_SUSPECT
	elseif standing <= 10 then-- > -10
		standing = _G.STANDING_NEUTRAL
	elseif standing < 50 then -- > 50
		standing = _G.STANDING_FRIENDLY
	else
		standing = _G.STANDING_ALLIED
	end
	return standing
end



function Hero:OnArriveAtEndNode()
	_G.LoadAndExecute("HeroStateMaps","OnArriveAtEndNode",nil,self)
end



function Hero:OnEventMovementFinished(event)
	--_G.LoadAndExecute("HeroStateMaps","OnEventMovementFinished",true,  self,event)
	if self:GetAttribute("in_system")==1 then
		return
	end
	LOG("OnEventMovementFinished")

	if self.path_state and type(self.path_state.path)== "table" then
		LOG("path_state pass")
		self.path_state.curr_node = self.path_state.dest_node
		self.path_state.dest_node = nil
		local world = SCREENS.MapMenu:GetWorld()

		if #self.path_state.path == 0 then
			LOG("end_node")
			local end_node = self.path_state.curr_node
			self.path_state = {path={};} -- clean up

			self:OnArriveAtNode(end_node)
			self:OnArriveAtEndNode(end_node)

		else
			LOG("GetLastGate Used. curr_node "..tostring(self.path_state.curr_node.classIDStr))
			--GET LAST GATE FROM PATH BEFORE UPDATING IT

			self:OnArriveAtNode(self.path_state.curr_node)
			--!!!This is necessary -- do not touch
			if #self.path_state.path ~= 0 then
				LOG("1="..tostring(self.path_state.path[1].classIDStr))
				self.last_gate = self.path_state.path[1].classIDStr
				self:SetAttribute("curr_loc",self.last_gate)
				LOG("2="..tostring(self.path_state.path[2].classIDStr))


				LOG("GraphMoveSeg")
				GraphMoveSeg(self)
				PlaySound("snd_shipdepart")
			end
		end
	end
end





function Hero:OnArriveAtNode(node)
	_G.LoadAndExecute("HeroStateMaps","OnArriveAtNode",nil,  self,node)
end

function Hero:GetLastGate()
	return _G.LoadAndExecute("HeroStateMaps","GetLastGate",nil,  self)
end


-- GameObject::Serialize, Deserialize, Fixup functions
function Hero:Serialize(savegame)
	return GameObject.Serialize(self, savegame)
end


function Hero:Deserialize(savegame)
	return GameObject.Deserialize(self, savegame)
end




--hero has arrived at an enemy in Solar System map
function Hero:HeroArrived()
	_G.LoadAndExecute("HeroStateMaps","HeroArrived",nil,  self)
end



function Hero:IsGateHacked(jgID)

	if CollectionContainsAttribute(self,'hacked_gates',jgID) then
	    return true
	end

	return false
end

function Hero:IsRumorUnlocked(rumorId)
	return CollectionContainsAttribute(self, 'unlocked_rumors', rumorId)
end

-------------------------------------------------------------------------------
--     Action Completion Events sent to hero
-------------------------------------------------------------------------------
function Hero:OnEventEndBattle(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndBattle",true,  self,event)
end



-------------------------------------------------------------------------------
--     Action Completion Events sent to hero
-------------------------------------------------------------------------------
function Hero:OnEventEndMPBattle(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndMPBattle",true,  self,event)
end



-------------------------------------------------------------------------------
--- Called after Hack Gate Mini Game
-------------------------------------------------------------------------------
function Hero:OnEventEndHackGate(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndHackGate",true,  self,event)
end


function Hero:OnEventEndEncounter(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndEncounter",true,  self,event)
end

function Hero:OnEventEndMine(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndMine",true,  self,event)
end

function Hero:OnEventEndCraft(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndCraft",true,  self,event)
end

function Hero:OnEventEndRumor(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndRumor",true,  self,event)
end


-- bargain == haggle
function Hero:OnEventEndBargain(event)
	_G.LoadAndExecute("HeroStateEndGame","OnEventEndBargain",true,  self,event)
end

function Hero:GetHaggleTable()
	return { [0]  = 0.70,
	         [1]  = 0.72,
				[2]  = 0.74,
				[3]  = 0.76,
				[4]  = 0.78,
				[5]  = 0.80,
				[6]  = 0.82,
				[7]  = 0.84,
				[8]  = 0.86,
				[9]  = 0.88,
				[10] = 0.90,
				[11] = 0.92,
				[12] = 0.94,
				[13] = 0.96,
				[14] = 0.98,
				[15] = 0.99 }
end

function Hero:AwardPlan(planID, successFactor)
	return _G.LoadAndExecute("HeroStateInventory","AwardPlan",true,  self,planID,successFactor)
end

function Hero:AddCargo(cargo_in,amount,show)
	return _G.LoadAndExecute("HeroStateInventory","AddCargo",true,  self,cargo_in,amount,show)
end

function Hero:AddCargoBatch(itemTable)
	return _G.LoadAndExecute("HeroStateInventory", "AddCargoBatch", true, self, itemTable)
end


function Hero:RemoveCargo(cargoID,amount)
	return _G.LoadAndExecute("HeroStateInventory","RemoveCargo",true,  self,cargoID,amount)
end


function Hero:SpendCredits(amount)
	local credits = self:GetAttribute("credits")

	credits = credits - amount

	if credits < 0 then
		credits = 0
	end

	self:SetAttribute("credits",credits)

	return credits

end


function Hero:GetCurrLoadout()
	return self:GetAttributeAt("ship_list",self:GetAttribute("ship_loadout"))
end


--Inserts Hero/Enemies default items into ships loadout
function Hero:InitShip(shipType)
	return _G.LoadAndExecute("HeroStateInit","InitShip",false,  self,shipType)
end

-------------------------------------------------------------------------------
--Calculates stat maximum and start values for a battle
-------------------------------------------------------------------------------
function Hero:InitBattleStats()
	_G.LoadAndExecute("HeroStateInit","InitBattleStats",true,  self)
end

function Hero:GetItemAt(i)
	local curr_ship = self:GetAttribute("curr_ship")
	local numItems = curr_ship:NumAttributes('battle_items')
	local item = nil

	if i <= numItems then
		item = curr_ship:GetAttributeAt('battle_items',i)
	end

	return item
end

function Hero:UpdateMatchStats(length)
	self.matchCount[length] = self.matchCount[length] + 1
end

function Hero:OnEventUpdateUI(event)

end


function Hero:OnEventUnhackGate(event)
	LOG("Hero:UnhackGate")
	local menuOpen = _G.is_open("SolarSystemMenu")
	local loading = _G.is_open("CustomLoadingMenu")--resend delayed if loading
	local instant = event:GetAttribute("instant") == 1

	if not loading and (instant or (menuOpen and SCREENS.SolarSystemMenu.state <= _G.STATE_TARGET) or not menuOpen) then
		local gateID = event:GetAttribute("gateID")
		if gateID then
			_G.Hero:EraseAttribute("hacked_gates", gateID)
		end
		local gate
		if _G.JumpGateList then
			gate = _G.JumpGateList[gateID]
		end
		if gate then
			if gate:GetAttribute("hacked")==0 then
				--nothing to do
				return
			end
			gate:SetAttribute("hacked", 0)
		end
		if menuOpen and gate then
			LOG("SetSystemView()")
			_G.EncounterMessage(SCREENS.SolarSystemMenu:GetWorld(),"[GATE_OFFLINE]",gate:GetX(),gate:GetY())
			gate:SetSystemView(self:GetCurrSystem())
			--SCREENS.SolarSystemMenu:RefreshGateSprites()
		end
		if _G.is_open("MapMenu") and gate then
			_G.EncounterMessage(SCREENS.MapMenu:GetWorld(),"[GATE_OFFLINE]",gate:GetX(),gate:GetY())
			--SCREENS.MapMenu:GetWorld():InitNodeJumpGate(gate)
			gate:InitNode(SCREENS.MapMenu:GetWorld().graph)
		end

	else
		GameEventManager:SendDelayed(event,self,GetGameTime()+math.random(2000,10000))
	end


end




function Hero:SetStarMapView(sprite,map)
	_G.LoadAndExecute("HeroStateMaps","SetStarMapView",false,  self,sprite,map)
end



function Hero:SetSystemView(sprite)
	_G.LoadAndExecute("HeroStateMaps","SetSystemView",false,  self,sprite)
end





function Hero:OnEventReceiveEnergy(event)
	if event:GetAttribute("mutate") == 1 then
		LOG(string.format("Mutate x %d",self:NumAttributes("Effects")))
		MutateWithCollection(event, self, 'Effects')
	else
		for i=1, self:NumAttributes("Effects") do
			if self:GetAttributeAt("Effects", i).classIDStr == "FE03" and event:GetAttribute("effect") == "shield" then
				PlaySound("snd_shieldsdown")
				event:SetAttribute("amount", 0)
			end
		end
		LOG("Didn't mutate")
	end

	local world = _G.SCREENS.GameMenu.world
	local player_id = self:GetAttribute("player_id")
    local effect = event:GetAttribute("effect")
    local energy = self:GetAttribute(effect)
    local amount = event:GetAttribute("amount")

    energy = energy + amount
	 if self.matchCount[effect] then
	     self.matchCount[effect] = self.matchCount[effect] + amount
    end

	local strMax = string.format("%s_max",effect)
    if self:HasAttribute(strMax) then
        local energyMax = self:GetAttribute(strMax)
        if energy >= energyMax then
            energy = energyMax
			if world.cargo then
				for i,v in pairs(world.cargo) do
					if _G.DATA.Cargo[v.cargo].effect == effect and not v.achieved then
						world.cargo[i].achieved = true
						local complete = string.gsub(effect, "cargo_", "snd_cc")
						--LOG(string.format("play cargo complete sound %s",complete))
						PlaySound(complete)
					end
				end
			end
        end

		--LOG(string.format("%s -> $d",effect,energy))
		self:SetAttribute(effect,energy)

		self:UpdateEffectGraphics(effect,player_id,energy,energyMax)
		--[[
		--********************************************
		_G.SCREENS.GameMenu:set_text_raw(string.format("str_%s_%d",effect,player_id),tostring(energy))
		if effect ~= "shield" then
			_G.SCREENS.GameMenu:set_progress(string.format("progbar_%s_%d",effect,player_id),(energy/energyMax)*100)
		---***************************8
		--]]
	else
    	self:SetAttribute(effect,energy)
		_G.SCREENS.GameMenu:set_text_raw(string.format("str_%s_%d",effect,player_id),tostring(energy))
    end

	if world.coords[player_id][effect] then--wont display for anything that doesn't have coordinates
		local font = world.effectFont[effect] or "font_numbers_white"
		local coords = world.coords[player_id][effect]
		if world.cargo then
			--Can we map to the proper widget coords? - may for crafting also?
			return
		end
		_G.ShowMessage(world,amount,font,coords[1]-world.offset_x,coords[2],true)
	end

end


function Hero:OnEventLoseEnergy(event)
	LOG(string.format("Mutate x %d",self:NumAttributes("Effects")))
	if event:GetAttribute("mutate")==1 then
		MutateWithCollection(event, self, "Effects")
	end

	local effect = event:GetAttribute("effect")
	local energy = self:GetAttribute(effect)
	local amount = event:GetAttribute("amount")
	local world = SCREENS.GameMenu.world

	energy = energy - amount

	if energy < 0 then
		amount = amount - energy
		energy = 0
	end

    LOG(string.format("%s -> %d",effect,energy))
	self:SetAttribute(effect, energy)
	local player_id = self:GetAttribute("player_id")
	_G.SCREENS.GameMenu:set_text_raw(string.format("str_%s_%d",effect,player_id),tostring(energy))
	local strMax = string.format("%s_max",effect)
	if self:HasAttribute(strMax) then
		if effect ~= "shield" then
			local energyMax = self:GetAttribute(strMax)
			local bar_height = lerp(energy,0,energyMax,0,39)
			_G.SCREENS.GameMenu:set_widget_size(string.format("icon_bar_%s_%d",effect,player_id),14,bar_height)

			_G.SCREENS.GameMenu:set_widget_position(string.format("icon_bar_%s_%d",effect,player_id),_G.SCREENS.GameMenu:get_widget_x(string.format("icon_bar_%s_%d",effect,player_id)),189-bar_height)
		else
			self:UpdatePlayerShield(player_id,energy,self:GetAttribute(strMax))
		end
	end
	local font = world.effectFont[effect] or "font_numbers_white"
	local coords = world.coords[player_id][effect]
	if event:GetAttribute("show")==1 then
		_G.ShowMessage(world,-amount,font,coords[1]-world.offset_x,coords[2],true)
	end
end

--Hero receiving damage direct to ship
function Hero:OnEventDirectDamage(event)
	--MutateWithCollection(event, self, "Effects")
	local damage = event:GetAttribute("amount")
	--local battleGround = event:GetAttribute("BattleGround")
	local battleGround = SCREENS.GameMenu.world

    local life = self:GetAttribute('life')
	local ship = self:GetAttribute("curr_ship")
	local playerID = self:GetAttribute("player_id")

    if damage > 0 then
	    local newLife = life - damage
		if not battleGround.ds then
			AttachParticles(battleGround,"BlackExplosion", battleGround.coords[playerID]["life"][1],battleGround.coords[playerID]["life"][2]+20)
		end
		local msg = string.format("-%d",damage)
		msg = -damage

		self.damage_received = self.damage_received + damage

	    _G.DamageMessage(battleGround,msg,battleGround.coords[playerID]["life"][1]-battleGround.offset_x,battleGround.coords[playerID]["life"][2])--Displays "+3","+4","-10" over match

	    if newLife < 0 then
	        newLife = 0
	    end
	    self:SetAttribute('life',newLife)
		_G.SCREENS.GameMenu:set_text_raw(string.format("str_life_%d",playerID),tostring(newLife))


		local energyMax = self:GetAttribute('life_max')
		local energy = newLife
		local bar_height = lerp(energy,0,energyMax,0,39)
		_G.SCREENS.GameMenu:set_widget_size(string.format("icon_bar_life_%d",playerID),14,bar_height)

		_G.SCREENS.GameMenu:set_widget_position(string.format("icon_bar_life_%d",playerID),_G.SCREENS.GameMenu:get_widget_x(string.format("icon_bar_life_%d",playerID)),189-bar_height)
    end

end

--Hero receiving damage to shield first then direct^^ to ship
function Hero:OnEventShipDamage(event)
	local source = event:GetAttribute("source")

	-- remove cloaking effect from the player who dealt the damage
	local removeEffect = nil
	for i=1,source:NumAttributes("Effects") do
		if source:GetAttributeAt("Effects", i).classIDStr == "FD02" then
			removeEffect = i
		end
	end
	if removeEffect then
		source:RemoveAttributeAt("Effects", removeEffect)
	end
	MutateWithCollection(event, self, "Effects")

	local amount = event:GetAttribute("amount")

	if self:GetAttribute("ai") ~= 0 then
		local shield = self:GetAttribute("shield")
		local shieldMax = self:GetAttribute("shield_max")
		local life = self:GetAttribute("life") + shield
		local lifeMax = self:GetAttribute("life_max")
		local dmg = amount

		if (life > 0) and ((life - dmg) <= 0) then

			_G.SoundFunction("snd_ehulld", 0, 1)

		elseif (((life-shield) / lifeMax) > 0.25) and (((life - dmg) / lifeMax) < 0.25) then

			_G.SoundFunction("snd_ehullc", 0, 1)

		elseif event:GetAttribute("direct") == 0 then
			if (shield > 0) and ((shield - dmg) <= 0) then

				_G.SoundFunction("snd_eshieldsd", 0, 1)

			elseif ((shield / shieldMax) > 0.25) and (((shield - dmg) / shieldMax) < 0.25) then

				_G.SoundFunction("snd_eshieldsc", 0, 1)
			end
		end

	end

	if self:GetAttribute("ai") ~= 1 then
		local shield = self:GetAttribute("shield")
		local shieldMax = self:GetAttribute("shield_max")
		local life = self:GetAttribute("life") + shield
		local lifeMax = self:GetAttribute("life_max")
		local dmg = amount

		if (life > 0) and ((life - dmg) <= 0) then
			PlaySound("snd_hulld")
		elseif ((life / lifeMax) > 0.25) and (((life - dmg) / lifeMax) < 0.25) then
			PlaySound("snd_alarm")
			PlaySound("snd_hullc")
		elseif event:GetAttribute("direct") == 0 then
			if (shield > 0) and ((shield - dmg) <= 0) then
				PlaySound("snd_alarm")
				PlaySound("snd_shieldsd")
			elseif ((shield / shieldMax) > 0.25) and (((shield - dmg) / shieldMax) < 0.25) then
				PlaySound("snd_alarm")
				PlaySound("snd_shieldsc")
			end
		end

	end


	if event:GetAttribute("direct") == 1 then
		local evt = GameEventManager:Construct("DirectDamage")
		evt:SetAttribute('source',source)
		evt:SetAttribute("amount",amount)
		self:OnEventDirectDamage(evt)--Deal direct damage.

		-- Optimal/Advanced Targeting Removal (Direct) --
		if self:NumAttributes("Effects") >= 1 then
			for i=1,self:NumAttributes("Effects") do
				if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC08_NAME]" then
					local effect = self:GetAttributeAt("Effects",i)
					GameObjectManager:Destroy(effect)
					break
				end
			end
		end

		if self:NumAttributes("Effects") >= 1 then
			for i=1,self:NumAttributes("Effects") do
				if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC09_NAME]" then
					local effect = self:GetAttributeAt("Effects",i)
					GameObjectManager:Destroy(effect)
					break
				end
			end
		end
	else

		local e = GameEventManager:Construct("DamageDealt")
		e:SetAttribute("amount", amount)
		GameEventManager:Send(e, source)

		self:ReceiveDamage(amount)
	end
end

function Hero:ReceiveDamage(amount)
    local shield = self:GetAttribute('shield')
    local life = self:GetAttribute('life')
	--local pilot = self:GetCombatStat('pilot')
	local battleGround = SCREENS.GameMenu.world
	--if shield > 0 then
	--		amount = math.ceil(amount * _G.GLOBAL_FUNCTIONS.ShieldIntegrity(pilot))
	--	end
	local damage = 0
	local newShield = shield - amount
	if newShield < 0 then
		damage = newShield
		amount = amount + damage--amount applied to shield minus the damage that will follow on.
	end
	self.damage_received = self.damage_received + amount--add damage applied to shield only
	--Other damage will be tabulated in OnEventDirectDamage

	--BEGIN_STRIP_DS
	local function ripple()
		LOG("Ripple Effect!")
		local damage_amount = amount-damage

		local player_id = self:GetAttribute("player_id")
		local world = _G.SCREENS.GameMenu.world
		local FX = world.FX
		local effect = FX.CreateContainer(2500, player_id, "", 50)

		local amount_ratio = math.sqrt(damage_amount)/5

		local min_radius = 0.1
		local min_finish_time = 800

		local vanish_time = math.floor(math.max(amount_ratio * 1700,min_finish_time))

		local ring_width = amount_ratio*0.05--amount/60--0.5
		local max_radius = damage_amount/30 --0.5

		LOG(string.format("EffectDebug damage_amount=%d, ring_width=%s, max_radius=%s, vanish_time = %s",damage_amount,tostring(ring_width),tostring(max_radius),tostring(vanish_time)))

		local ring = FX.AddRingDistortion(effect, 0, 0, 10.0, 250.0, 250.0, 0.0, ring_width, 3.0)
		--FX.AddSpecificKey(effect, ring, 500, FX.KEY_SCALE, 20, FX.PUNCH_OUT)
		--FX.AddSpecificKey(effect, ring, 1800, FX.KEY_SCALE, 400, FX.PUNCH_OUT)

		--FX.AddSpecificKey(effect, ring, 1800, FX.KEY_SCALE, 20, FX.PUNCH_OUT)
		FX.AddSpecificKey(effect, ring, vanish_time+100, FX.KEY_DISTORT_RING_RADIUS, max_radius, FX.LINEAR)
		--FX.AddSpecificKey(effect, ring, 2000, FX.KEY_DISTORT_RING_WIDTH, 0.1, FX.LINEAR)
		--FX.AddSpecificKey(effect, ring, 2000, FX.KEY_SCALE, 0.0, FX.SMOOTH)
		FX.AddSpecificKey(effect, ring, vanish_time-200, FX.KEY_DISTORT_STRENGTH, 0.2, FX.PUNCH_OUT)
		FX.AddSpecificKey(effect, ring, vanish_time, FX.KEY_DISTORT_STRENGTH, 0.0, FX.LINEAR)
		FX.Start(world,effect,world.coords[player_id]["damage"][1],world.coords[player_id]["damage"][2])
		--DISTORT_RING_RADIUS
	end
	ripple()
	--END_STRIP_DS



	-- If shield going to take damage
	if shield > 0 and amount > 0 then

		local ship = self:GetAttribute("curr_ship")
		--AttachParticles(ship,"ShieldDamage"..tostring(self:GetAttribute("gui_id")), 0,0)

		local msg = string.format("-%d",amount)
		msg = -amount

		_G.ShieldMessage(battleGround,msg,ship:GetX()-battleGround.offset_x,ship:GetY())
	end

	--if damage to be applied direct to ship
  if damage < 0 then

    	newShield = 0
		local event = GameEventManager:Construct("DirectDamage")
		--event:SetAttribute("BattleGround",battleGround)
		event:SetAttribute('source',self)
		event:SetAttribute("amount",-damage)
		self:OnEventDirectDamage(event)--Deal direct damage.

		-- Optimal Targeting Effect Removal --
		if self:NumAttributes("Effects") >= 1 then
			for i=1,self:NumAttributes("Effects") do
				if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC08_NAME]" then
					local effect = self:GetAttributeAt("Effects",i)
					GameObjectManager:Destroy(effect)
					break
				end
			end
		end

		if self:NumAttributes("Effects") >= 1 then
			for i=1,self:NumAttributes("Effects") do
				if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC09_NAME]" then
					local effect = self:GetAttributeAt("Effects",i)
					GameObjectManager:Destroy(effect)
					break
				end
			end
		end

  end
  self:SetAttribute('shield',newShield)
	if newShield ~= shield then
		self:UpdatePlayerShield(self:GetAttribute("player_id"),newShield,self:GetAttribute('shield_max'))
	end
end

function Hero:UpdateEffectGraphics(effect,player_id,energy,energyMax)

	_G.SCREENS.GameMenu:set_text_raw(string.format("str_%s_%d",effect,player_id),tostring(energy))
	if effect ~= "shield" then
		_G.SCREENS.GameMenu:set_progress(string.format("progbar_%s_%d",effect,player_id),(energy/energyMax)*100)

		local bar_height = lerp(energy,0,energyMax,0,39)
		_G.SCREENS.GameMenu:set_widget_size(string.format("icon_bar_%s_%d",effect,player_id),14,bar_height)

		_G.SCREENS.GameMenu:set_widget_position(string.format("icon_bar_%s_%d",effect,player_id),_G.SCREENS.GameMenu:get_widget_x(string.format("icon_bar_%s_%d",effect,player_id)),189-bar_height)
	else
		self:UpdatePlayerShield(player_id,energy,energyMax)
	end

end


function Hero:OnEventDamageDealt(event)
	self.damage_done = self.damage_done + event:GetAttribute("amount")
end


function Hero:EndTurn(chain)
	--LOG(string.format("end turn %d",self:GetAttribute("player_id")))
	if chain > self.longest_chain then
		self.longest_chain = chain
		if chain > self:GetAttribute("longest_chain") then
			self:SetAttribute("longest_chain", chain)
		end
	end
end

--This is where the AI analyzes the movelist/gemCounts to determine whether it should use item.
function Hero:OnEventNewTurn(event)
	local SWAP1 = 1
	local SWAP2 = 2
	local MATCH_WEIGHT = 3

	local myHero = _G.SCREENS.GameMenu.world:GetAttributeAt("Players", _G.SCREENS.GameMenu.world:GetAttribute("curr_turn"))
	local myengineer = myHero:GetCombatStat('engineer')
	local life = myHero:GetAttribute('life')
	local life_max = myHero:GetAttribute('life_max')
	local event1

	local battleGround = _G.SCREENS.GameMenu.world

	if myHero:NumAttributes("Effects") > 0 then
		for i=1, myHero:NumAttributes("Effects") do
			if myHero:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC15_NAME]" then -- Aggression Drone
				if myHero:GetAttribute("shield") >= 3 then
					event1 = GameEventManager:Construct("ReceiveEnergy")
					event1:SetAttribute('effect', "shield")
					event1:SetAttribute('amount', -3)
					GameEventManager:Send(event1, myHero)
				elseif myHero:GetAttribute("shield") >= 1 then
					event1 = GameEventManager:Construct("ReceiveEnergy")
					event1:SetAttribute('effect', "shield")
					event1:SetAttribute('amount', -myHero:GetAttribute("shield"))
					GameEventManager:Send(event1, myHero)
				end
				if myHero:GetAttribute("life") >= 4 then
					event1 = GameEventManager:Construct("ReceiveEnergy")
					event1:SetAttribute('effect', "life")
					event1:SetAttribute('amount', -3)
					GameEventManager:Send(event1, myHero)
					PlaySound("snd_probe")
				elseif myHero:GetAttribute("life") >= 2 then
					event1 = GameEventManager:Construct("ReceiveEnergy")
					event1:SetAttribute('effect', "life")
					event1:SetAttribute('amount', -(myHero:GetAttribute("life") - 1))
					GameEventManager:Send(event1, myHero)
					PlaySound("snd_probe")
				end
			end
			if myHero:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC16_NAME]" then -- Havoc Drone
				if myHero:GetAttribute("shield") >= 1 then
					event = GameEventManager:Construct("ReceiveEnergy")
					event:SetAttribute('effect', "shield")
					event:SetAttribute('amount', -1)
					GameEventManager:Send(event, myHero)
				end
				if myHero:GetAttribute("life") >= 2 then
					event = GameEventManager:Construct("ReceiveEnergy")
					event:SetAttribute('effect', "life")
					event:SetAttribute('amount', -1)
					GameEventManager:Send(event, myHero)
					PlaySound("snd_probe")
				end
			end
		end
	end

	-- This is where Hull Repair/Turn is determined.
	local repair
	if _G.GLOBAL_FUNCTIONS.RandomRounding(myengineer, 25) == "up" then
		repair = math.ceil(myengineer / 25)
	else
		repair = math.floor(myengineer / 25)
	end

	if myengineer >= 245 then
		repair = 10
	end

	-- Battle Fatigue
	if _G.SCREENS.GameMenu.world:NumAttributes("Players") >= 2	then
		if _G.LAST_TURN_FREE == false then
			_G.TOTAL_TURNS = _G.TOTAL_TURNS + 1

			if _G.TOTAL_TURNS == 51 then
				_G.BigMessage(SCREENS.GameMenu.world,"Battle Weariness",512,500)
			elseif _G.TOTAL_TURNS == 101 then
				_G.BigMessage(SCREENS.GameMenu.world,"Battle Fatigue",512,500)
			elseif _G.TOTAL_TURNS == 175 then
				_G.BigMessage(SCREENS.GameMenu.world,"Battle Exhaustion",512,500)
			end

			if _G.TOTAL_TURNS <= 50 then
				repair = repair
			elseif _G.TOTAL_TURNS <= 100 then
				repair = math.floor(repair * 0.75)
			elseif _G.TOTAL_TURNS <= 174 then
				repair = math.floor(repair * 0.5)
			else
				repair = 0
			end

			-- Reverse Engineering Droid Effect --
			if _G.ALLY_STUNNED == false then
				for i=1,myHero:NumAttributes("Effects") do
					if myHero:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC03_NAME]" then
						if repair > 0 then
							repair = -repair
							if repair < -7 then
								repair = -7  -- Setting a cap at -7 hull/turn
							end
							break
						end
					end
				end
			end

			-- Angst Machine: Combat Stress Effect --
			local bg = SCREENS.GameMenu.world
			if bg:NumAttributes("Effects") >= 1 then
				for i=1,bg:NumAttributes("Effects") do
					if bg:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC04_NAME]" then
						repair = 0
						break
					end
				end
			end

			if repair ~= 0 then
				if life < life_max then
					local event = GameEventManager:Construct("ReceiveEnergy")
					event:SetAttribute('effect', "life")
					event:SetAttribute('amount', repair)
					if repair < 0 then
						PlaySound("snd_probe")
					end
					GameEventManager:Send(event, myHero)

					-- Discovery of R.E. Probe Chance --
					if repair < 0 then
						if math.random() <= 0.1 then
							for i=1,myHero:NumAttributes("Effects") do
								if myHero:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC03_NAME]" then
									local REeffect = myHero:GetAttributeAt("Effects",i)
									GameObjectManager:Destroy(REeffect)
									_G.BigMessage(SCREENS.GameMenu.world,"R.E. Probe Discovered",512,500)
									PlaySound("snd_degauss")
									break
								end
							end
						end
					end
				end
			end
		end
	end

	-- Determines when players are stunned by TimeWarp effects
	_G.ALLY_STUNNED = false

	if _G.SCREENS.GameMenu.world:NumAttributes("Players") >= 2 then
		local myEnemy = _G.SCREENS.GameMenu.world:GetEnemy(myHero)
		if myEnemy:NumAttributes("Effects") == 0 then
			_G.ENEMY_STUNNED = false
		end
		if myHero:NumAttributes("Effects") == 0 then
			_G.ALLY_STUNNED = false
		end
		for i=1,myEnemy:NumAttributes("Effects") do
			if myEnemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT06_NAME]" then
				_G.ENEMY_STUNNED = true
				break
			else
				_G.ENEMY_STUNNED = false
			end
		end
		for i=1,myHero:NumAttributes("Effects") do
			if myHero:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT06_NAME]" then
				_G.ALLY_STUNNED = true
				break
			else
				_G.ALLY_STUNNED = false
			end
		end

		-- Engine Leak Effect --
		for i=1,myHero:NumAttributes("Effects") do
			if myHero:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC06_NAME]" then
				if myHero:GetAttribute("engine") >= 7 then
					if math.random() <= 0.2 then
						local leakedEnergy = myHero:GetAttribute("engine")
						local event = GameEventManager:Construct("ReceiveEnergy")
						event:SetAttribute('effect', "engine")
						event:SetAttribute('amount', -leakedEnergy)
						GameEventManager:Send(event, myHero)
						PlaySound("snd_drone")
						_G.BigMessage(SCREENS.GameMenu.world,"Engine Leak",512,500)
					end
				end
			end
		end
	end


-- Check for stunned players, the old method didn't work --
	if myHero:GetAttribute("player_id") == 1 then
		if _G.ALLY_STUNNED == true then
			_G.PLAYER_1_STUN = true
			_G.PLAYER_2_STUN = false
		elseif _G.ENEMY_STUNNED == true then
			_G.PLAYER_2_STUN = true
			_G.PLAYER_1_STUN = false
		end
	elseif myHero:GetAttribute("player_id") == 2 then
		if _G.ALLY_STUNNED == true then
			_G.PLAYER_2_STUN = true
			_G.PLAYER_1_STUN = false
		elseif _G.ENEMY_STUNNED == true then
			_G.PLAYER_1_STUN = true
			_G.PLAYER_2_STUN = false
		end
	end
	if _G.ALLY_STUNNED == false then
		if _G.ENEMY_STUNNED == false then
			_G.PLAYER_1_STUN = false
			_G.PLAYER_2_STUN = false
		end
	end


	--decrement Item Recharge Counter
	--IF Not hidden new turn after using item that does&doesn't end this players turn
	-- Won't allow cooldown while anyone is stunned, or during bonus turns.
	if event:GetAttribute("item_newturn") == 0 then
		if _G.LAST_TURN_FREE == false then
			if _G.ENEMY_STUNNED == false then
				if _G.ALLY_STUNNED == false then
					self:ItemRechargeCounter()
				end
			end
		end
		LOG("Mutate Effects with New Turn")
		MutateWithCollection(event, self, 'Effects')
	end
	_G.LAST_TURN_FREE = false

	if self.missTurn then
		self.missTurn = nil
		return
	end


	--local battleGround = event:GetAttribute("BattleGround")
	local battleGround = SCREENS.GameMenu.world
	local ship = self:GetAttribute("curr_ship")

	--Allow Player to select Gems
	--PUT Here to prevent players moving between the time the turn attribute is changed,
	--and the TimeWarp Effects EndTurn event is received and processed
	if not battleGround or not battleGround.state then
		return
	end
	battleGround.state = _G.STATE_IDLE
	--_G.GLOBAL_FUNCTIONS[string.format("Update%s",battleGround.ui)]()

	LOG(string.format("%d new turn %d,  my_player_id= %d",self:GetAttribute("player_id"),self:GetAttribute("ai"),battleGround.my_player_id))


	--LOG(string.format("%s new turn %d,  my_player_id= %d",self:GetAttribute("name"),self:GetAttribute("player_id"),battleGround.my_player_id))
	--LOG(string.format("curr turn %d",battleGround:GetAttribute("curr_turn")))
	if self:GetAttribute("ai") == 0 and battleGround and (battleGround.my_player_id==battleGround:GetAttribute("curr_turn") or not _G.Hero) then
		_G.XBoxOnly(SCREENS.GameMenu.CycleUILocation, SCREENS.GameMenu, 0)
		if battleGround.hint_delay > 0 then
			local event = GameEventManager:Construct("HintArrow")
			event:SetAttribute("turn",battleGround.turn_count)
			--LOG(string.format("SetAttribute turn =%d",battleGround.turn_count))
			GameEventManager:SendDelayed(event,battleGround,GetGameTime() + battleGround.hint_delay*1000)
		end

		SCREENS.GameMenu:SetGamepadIcon(battleGround.gp_grid)

		local bgID = ClassIDToString(battleGround:GetClassID())
		LOG("bgID == "..bgID)
		if not _G.Hero then
			--no tutorials player 2 local mp
			return
		end

		if bgID == "B001" or bgID == "B000" or bgID == "B004" then
			LOG(" TRUE ")
			local tutorial_opened = false
			--Tutorial stuff
			playerTurnCounter = playerTurnCounter + 1
			if (playerTurnCounter == 1) then
				tutorial_opened = _G.ShowTutorialFirstTime(3,_G.Hero)
				if(tutorial_opened == false) then
					--on second battle
					tutorial_opened = _G.ShowTutorialFirstTime(10,_G.Hero)
				end
			elseif (playerTurnCounter == 2) then
				tutorial_opened = _G.ShowTutorialFirstTime(20,_G.Hero)
			elseif (playerTurnCounter == 3) then
				tutorial_opened = _G.ShowTutorialFirstTime(4,_G.Hero)
			elseif (playerTurnCounter == 4) then
				tutorial_opened = _G.ShowTutorialFirstTime(5,_G.Hero)
			elseif (playerTurnCounter == 5) then
				tutorial_opened = _G.ShowTutorialFirstTime(6,_G.Hero)
			end
			if is_yesno_menu_open() then
				move_yesno_menu_to_front()
			end
		end

	end
	if self:GetAttribute("ai") == 1 and battleGround then

		local bestMove = self:GetAIMove(battleGround)
		local weight = 0
		if bestMove then
			weight = bestMove[MATCH_WEIGHT]
			--_G.print_table(bestMove)
		else
			bestMove = {21,28}
		end

		local activeItems = {}--stores items
		local useItems = {}--stores the weights associated with those items.
		for i=1, ship:NumAttributes("battle_items") do
			local item = ship:GetAttributeAt("battle_items",i)
			if item:ItemActive(self:GetAttribute("engine"),self:GetAttribute("weapon"),self:GetAttribute("cpu"), _G.SCREENS.GameMenu.world:GetEnemy(myHero), self:GetAttribute("psi")) then
				table.insert(activeItems,item)
				local result = item:ShouldAIUseItem(battleGround, self)
	--			if item:GetAttribute("status_on_enemy") == true then
	--				if myEnemy:GetAttribute('shield') > 0 then
	--					result = 1
	--				end
	--			end

				if result then
					table.insert(useItems,result)
				else
					LOG("Warning - item use returned nil")
					table.insert(useItems, math.random(1,100))
				end
				LOG(string.format("ActiveItem %s",item.classIDStr))
			end
		end

		local useItem = false
		local itemMax = 0

		--Get Largest Weight from active items
		for i,v in pairs(useItems) do
			if v > itemMax  then
				itemMax = v
				useItem = i
			end
		end

		--if activeItems[useItem]:GetAttribute("status_on_enemy") == true then
		--	if myEnemy:GetAttribute('shield') > 0 then
		--		itemMax = 0
		--		useItem = false
		--	end
		--end

		if useItem then
			if activeItems[useItem]:GetAttribute("end_turn") == 0 then
				itemMax = itemMax + 24
			end
			if itemMax <= weight then
				useItem = false
			end
		end

		if useItem then
			LOG(string.format("AI ACTIVATE ITEM %s",activeItems[useItem].classIDStr))
			self:ActivateItem(battleGround,activeItems[useItem])
		else
			LOG("Spawn AI Move Event")
			local swap1 = 0
			local swap2 = 0
			if math.random(1,10) < 5 then
				swap1 = bestMove[1]
				swap2 = bestMove[2]
			else
				swap1 = bestMove[2]
				swap2 = bestMove[1]
			end

			local e = GameEventManager:Construct("AIMove")
			e:SetAttribute("swap1",swap1)
			e:SetAttribute("swap2",swap2)
			--local nextTime = GetGameTime()
			GameEventManager:Send( e, battleGround)
		end
	end


	_G.GLOBAL_FUNCTIONS[string.format("Update%s",battleGround.ui)]()

end





function Hero:ItemRechargeCounter()

	local ship = self:GetAttribute("curr_ship")
	local numItems = ship:NumAttributes("battle_items")

	for i=1,numItems do
		local item = ship:GetAttributeAt("battle_items",i)
		if item.inactive > 0 then
			item.inactive = item.inactive -1
			if item.inactive == 0 then
				item:Recharged()
			end
		end

	end

end

function Hero:EffectsCounter()
	local numEffects = self:NumAttributes("Effects")
	local removeEffects = {}
	for i=1,numEffects do
		local effect = self:GetAttributeAt("Effects",i)
		--if effect:GetAttribute("player"):GetAttribute("player_id") == self:GetAttribute("curr_turn") then
		local counter = effect:Counter()
		if counter <= 0 then
			table.insert(removeEffects,effect)
		end
	end

	local world = SCREENS.GameMenu.world
	for i,v in pairs(removeEffects) do
		self:EraseAttribute("Effects",v)--remove Heroes ref to effect - give to battleground
		if world.host then
			table.insert(world.removeEffects,v)
			--GameObjectManager:Destroy(v)
		end
	end
	removeEffects = nil

	self:AddCombatStat("gunnery", 0) -- ensure match bonuses are updated if Confusion effect is erased
end



--This function subtracts item activation cost from hero
--then activates item
function Hero:ActivateItem(battleGround,item)

	local player_id = self:GetAttribute("player_id")
	local player = battleGround:GetAttributeAt("Players",player_id)

	local item_id = 0
	for i=1,8 do
		local ship_item = player:GetItemAt(i)
		if ship_item and item.classIDStr == ship_item.classIDStr then
			item_id = i
			break
		end
	end

 	LOG(string.format("Item #%d (%s) activated for player #%d (Hero:ActivateItem)",item_id,item.classIDStr,player_id))

	battleGround.state = _G.STATE_ENDING_TURN -- SCF: trying to stop items being double-cast in a turn. Is this state right?

	local itemEvent = GameEventManager:Construct("ActivateItem")
	itemEvent:SetAttribute("player_id",player_id)
	--itemEvent:SetAttribute("item",item)
	itemEvent:SetAttribute("item_id",item_id)
	GameEventManager:Send(itemEvent)

end




function Hero:GetPrefList(battleGround)
    --this will eventually be gotten from BaseHero object

	local enemy = battleGround:GetEnemy(self)
    --init preference lists
  local prefList = {}

  prefList["damage"]=7
  prefList["shield"]=5
  prefList["engine"]=4
  prefList["cpu"]=4
  prefList["weapon"]=4
  prefList["psi"]=2
  prefList["intel"]=2
	prefList["other"]=1
	local engine_adjust = 0
	local weapon_adjust = 0
	local cpu_adjust = 0
	local shield_adjust = 0
  
	local engine_req = 0
	local cpu_req = 0
	local weapon_req = 0

	--Total Hero's Energy Requirements
	local ship = self:GetAttribute("curr_ship")
	for i=1, ship:NumAttributes("battle_items") do
		local item = ship:GetAttributeAt("battle_items",i)
		engine_req = engine_req + item:GetAttribute("engine_requirement")
		weapon_req = weapon_req + item:GetAttribute("weapon_requirement")
		cpu_req = cpu_req + item:GetAttribute("cpu_requirement")
	end

	local enemy_engine_req = 0
	local enemy_weapon_req = 0
	local enemy_cpu_req = 0
	if enemy then
		--Get Enemy Ship items energy reqs
		ship = battleGround:GetEnemy(self):GetAttribute("curr_ship")
		for i=1, ship:NumAttributes("battle_items") do
			local item = ship:GetAttributeAt("battle_items",i)
			enemy_engine_req = engine_req + item:GetAttribute("engine_requirement")
			enemy_weapon_req = weapon_req + item:GetAttribute("weapon_requirement")
			enemy_cpu_req = cpu_req + item:GetAttribute("cpu_requirement")
		end
	end


	local life = self:GetAttribute("life")

	--SET SHIELD ADJUST
	shield_adjust = math.floor((1 - self:GetAttribute("shield")/self:GetAttribute("shield_max"))* 3) - 1
	--LOG(string.format("Shield Adjust = %d",shield_adjust))
	if enemy and shield_adjust <= 0 then
		shield_adjust = shield_adjust + math.floor((1 - enemy:GetAttribute("shield")/enemy:GetAttribute("shield_max"))* 2) - 1
		--LOG(string.format("Shield Adjust = %d",shield_adjust))
	end

	if self:NumAttributes("Effects") > 0 then
		for i=1,self:NumAttributes("Effects") do
			if self:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				shield_adjust = -15
			end
		end
	end

	--SET ENGINE ADJUST
	if engine_req > 0 then
		engine_adjust = math.floor((1 - self:GetAttribute("engine")/ engine_req )* 3) - 1
	end
	--LOG(string.format("engine Adjust = %d",engine_adjust))
	if enemy and engine_adjust <= 0 and enemy_engine_req > 0 then
		engine_adjust = engine_adjust + math.floor((1 - enemy:GetAttribute("engine")/enemy_engine_req)* 2) - 1
		--LOG(string.format("engine Adjust = %d",engine_adjust))
	end

	--SET WEAPON ADJUST
	if weapon_req > 0 then
		weapon_adjust = math.floor((1 - self:GetAttribute("weapon")/ weapon_req )* 3) - 1
	end
	--LOG(string.format("weapon Adjust = %d",weapon_adjust))
	if enemy and weapon_adjust <= 0 and enemy_weapon_req > 0 then
		weapon_adjust = weapon_adjust + math.floor((1 - enemy:GetAttribute("weapon")/enemy_weapon_req)* 2) - 1
		--LOG(string.format("weapon Adjust = %d",weapon_adjust))
	end

	--SET CPU ADJUST
	if cpu_req > 0 then
		cpu_adjust = math.floor((1 - self:GetAttribute("cpu")/ cpu_req )* 3) - 1
	end
	LOG(string.format("cpu Adjust = %d",cpu_adjust))
	if enemy and cpu_adjust <= 0 and enemy_cpu_req > 0 then
		cpu_adjust = cpu_adjust + math.floor((1 - enemy:GetAttribute("cpu")/enemy_cpu_req)* 2) - 1
		LOG(string.format("cpu Adjust = %d",cpu_adjust))
	end

	prefList["shield"]= prefList["shield"] + shield_adjust
    prefList["engine"]= prefList["engine"] + engine_adjust
    prefList["cpu"]	  = prefList["cpu"]    + cpu_adjust
    prefList["weapon"]= prefList["weapon"] + weapon_adjust

    return prefList
end

function Hero:GetAIMove(battleGround)
	local theMove = {21,28,0}
	if battleGround.bestMoveInList > 0 then
		if (math.random(1,100) < 50) then
			theMove[1] = battleGround.moveList[battleGround.bestMoveInList].grid1
 			theMove[2] = battleGround.moveList[battleGround.bestMoveInList].grid2
		else
			theMove[1] = battleGround.moveList[battleGround.bestMoveInList].grid2
 			theMove[2] = battleGround.moveList[battleGround.bestMoveInList].grid1
		end
		theMove[3] = battleGround.moveList[battleGround.bestMoveInList].weight
	end
	return theMove
end


function Hero:AddItem(newItemID,show)
	_G.LoadAndExecute("HeroStateInventory","AddItem",true,  self,newItemID,show)
end

function Hero:RemoveItem(itemID,show)
	_G.LoadAndExecute("HeroStateInventory","RemoveItem",true,  self,itemID,show)
end

function Hero:AddShip(shipID,show)
	_G.LoadAndExecute("HeroStateInventory","AddShip",true,  self,shipID,show)
end


function Hero:AddPlan(planID,show)
	_G.LoadAndExecute("HeroStateInventory","AddPlan",true,  self,planID,show)
end



function Hero:SetToSave(quest_battle)
	LOG("SetToSave()")
	if quest_battle then
		LOG("SetQuestBattle True")
		self.quest_battle = true
	end
	self.auto_save = true
end


----------------------------------------------------------------------
--
-- QUEST RELATED FUNCTIONS
--
----------------------------------------------------------------------

-- EVENT HANDLERS


function Hero:OnEventSaveObjective(event)
	LOG("OnEventSaveObjective "..event:GetAttribute("objective"))
	self:SetToSave(true)
end



function Hero:OpenQuestRewards(callback)
	if not _G.is_open("QuestRewardsMenu") then
		Graphics.FadeToBlack()
		local event = GameEventManager:Construct("FadeFromBlack")
		local nextTime = GetGameTime() + 1300
		GameEventManager:SendDelayed( event, _G.Hero, nextTime )
		SCREENS.QuestRewardsMenu:Open()
	end
	SCREENS.QuestRewardsMenu:AddCallback(callback)
end

function Hero:OnEventQuestComplete(event)
	LOG("OnEventQuestComplete() ")
	local questID = event:GetAttribute("quest_id")
	self:OpenQuestRewards()
	SCREENS.QuestRewardsMenu:SetQuestComplete()
	SCREENS.QuestRewardsMenu:SetQuest(questID)
	--avoid saving on loading SolarSystemMenu if quest_battle was last objective in quest
	self.quest_battle = nil
	self:SetToSave()
	--if self ~= _G.Hero then
		--open_message_menu("not the hero","WTF")
	--end
end

function Hero:OnEventUpdateQuestUI(event)
	LOG("UpdateQuestUI")
	LOG("UpdateQuestUI " .. gcinfo())
	if _G.is_open("SolarSystemMenu") then
		SCREENS.SolarSystemMenu:UpdateUI()
	end

	LOG("UpdateQuestUI " .. gcinfo())

end

--Any code to respond to Non-Lua menus - generated by quest system
function Hero:QuestPopup()
	if _G.is_open("SolarSystemMenu") then
		SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	end
end

function Hero:OnEventShowCutscene(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventShowCutscene",true,  self,event)
end


function Hero:OnEventShowMessage(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventShowMessage",true,  self,event)
end



function Hero:OnEventGiveResource(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventGiveResource",true,  self,event)
	end

function Hero:OnEventRemoveResource(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventRemoveResource",true,  self,event)
end

function Hero:OnEventGiveItem(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventGiveItem",true,  self,event)
end



function Hero:OnEventRemoveItem(event,itemID)
	_G.LoadAndExecute("HeroStateQuest","OnEventRemoveItem",true,  self,event)
end



function Hero:OnEventGiveFriend(event)

	_G.LoadAndExecute("HeroStateQuest","OnEventGiveFriend",true,  self,event)
end

function Hero:OnEventRemoveFriend(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventRemoveFriend",true,  self,event)

end



function Hero:OnEventGiveExperience(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventGiveExperience",true,  self,event)
end

function Hero:OnEventGivePsi(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventGivePsi",true,  self,event)
end

function Hero:OnEventGiveGold(event,amount)
	_G.LoadAndExecute("HeroStateQuest","OnEventGiveGold",true,  self,event,amount)
end

function Hero:OnEventHideLocation(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventHideLocation",true,  self,event)
end


function Hero:OnEventShowLocation(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventShowLocation",true,  self,event)
end


function Hero:OnEventGiveFactionStatus(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventGiveFactionStatus",true,  self,event)
end

function Hero:OnEventRemoveFactionStatus(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventRemoveFactionStatus",true,  self,event)
end


--Start Quest Battle
function Hero:OnEventStartBattle(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventStartBattle",true,  self,event)
end

function Hero:OnEventSetEncounter(event)
	_G.LoadAndExecute("HeroStateQuest","OnEventSetEncounter",true,  self,event)
end

--PRECONDITION FUNCTIONS

function Hero:HasFriend(crewID)
	return _G.LoadAndExecute("HeroStateQuest","HasFriend",true,  self,crewID)
end


function Hero:HasItem(itemID)
	return _G.LoadAndExecute("HeroStateQuest","HasItem",true,  self,itemID)
end

function Hero:HasItemEquip(itemID)
	return _G.LoadAndExecute("HeroStateQuest","HasItemEquip",true,  self,itemID)
end


function Hero:GetResource(resourceID)
	return _G.LoadAndExecute("HeroStateQuest","GetResource",true,  self,resourceID)
end

function Hero:GetRumor()
	return self:NumAttributes("unlocked_rumors")
end

function Hero:GetGold()
	return self:GetAttribute("credits")
end

MakeQuestable(Hero)
MakeTutorialised(Hero)

dofile("Assets/Scripts/Heroes/HeroPlatform.lua")

return ExportClass("Hero")
