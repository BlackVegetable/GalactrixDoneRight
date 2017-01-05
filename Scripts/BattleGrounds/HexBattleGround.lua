-- BattleGround
--  this class defines the basic behaviour of the BattleGround objects
--

-- SCF: 20080809 I am removing self . matches[] and replacing with self.matchList[] in order to make code more efficient
--               I'm removing the old one to make it easier to spot old bits of code
--				 The new one actually indexes slightly differently, simply listing ALL matches rater than all grids

use_safeglobals()

local FX  = import "FXContainer"
local CRH = import "CoroutineHelpers"

--local SP = import("Steve_Profile")


class "BattleGround" (GameObject)


BattleGround.AttributeDescriptions = AttributeDescriptionList()

BattleGround.AttributeDescriptions:AddAttribute('int', 'movement_check', {default=200})
BattleGround.AttributeDescriptions:AddAttribute('int', 'swap_delay', {default=500})
BattleGround.AttributeDescriptions:AddAttribute('int', 'trail_delay', {default=300})
BattleGround.AttributeDescriptions:AddAttribute('int', 'clear_delay', {default=500})
BattleGround.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=1000})
BattleGround.AttributeDescriptions:AddAttribute('int', 'ui_tick', {default=700})
BattleGround.AttributeDescriptions:AddAttribute('int', 'black_hole_duration', {default=400})
BattleGround.AttributeDescriptions:AddAttribute('int', 'timer', {default=0})--0==no timer(move counter), else timer = limit in seconds
BattleGround.AttributeDescriptions:AddAttribute('int', 'counter', {default=0})--second counter
BattleGround.AttributeDescriptions:AddAttribute('int', 'game_end_delay',{default=800})
BattleGround.AttributeDescriptions:AddAttribute('int', 'preview_delay',{default=3000})


--1 = down, 2 = down/left, 3 = up/left,4 = up, 5 = up/right, 6 = down/right
BattleGround.AttributeDescriptions:AddAttribute('int', 'swap_direction', {default=4})
BattleGround.AttributeDescriptions:AddAttribute('int', 'gravity',{default=0})--0=ZeroG, or fixed gravity 1,2,3,4,5,6


BattleGround.AttributeDescriptions:AddAttribute('int', 'curr_turn',{default=1})



BattleGround.AttributeDescriptions:AddAttributeCollection('GameObject', 'Players',{})
BattleGround.AttributeDescriptions:AddAttributeCollection('GameObject', 'Team1',{})
BattleGround.AttributeDescriptions:AddAttributeCollection('GameObject', 'Team2',{})
BattleGround.AttributeDescriptions:AddAttributeCollection('GameObject', 'GamePatterns',{})

--Effects on BattleGround
BattleGround.AttributeDescriptions:AddAttributeCollection('GameObject', 'Effects',{})



--BattleGround.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
--BattleGround.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[BATTLE_VICTORY]"})
--BattleGround.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
--BattleGround.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[BATTLE_DEFEAT]"})
BattleGround.AttributeDescriptions:AddAttribute('string', 'quit_msg', {default="[QUITBATTLE]"})



local MENU = ""

local SWAP1 = 1
local SWAP2 = 2
local MATCH_WEIGHT = 3

local DANGER_ZONE = 20

local GRID_CENTER = 28 -- Matches value in InitBattleground.lua
local HEX_SIDES = 6
local CHECK_SIDES = 3 -- Matches value in InitBattleground.lua
local HEX_GRIDS =55 -- Matches value in InitBattleground.lua

local COUNTER_TICK = 1000

_G.INIT_BATTLEGROUND = false

function BattleGround:__init(clid)
    super(clid)
	self:InitAttributes()
	LOG("BattleGround:__init()")
			LOG("Dump Watches")

	self.turn_delay = 0 -- dont want this to ever be nil

	--_G.LoadAndExecute("InitBattleground","Init",true,self)
	_G.INIT_BATTLEGROUND = _G.LoadInit(_G.INIT_BATTLEGROUND,"InitBattleground")

	_G.INIT_BATTLEGROUND.Init(self)
	--local INIT_BATTLEGROUND = import("InitBattleground")
	--INIT_BATTLEGROUND.Init(self)
	--INIT_BATTLEGROUND = nil
	--purge_garbage()


	self.state = _G.STATE_INITIALIZING

	self.FX = FX
	self.doNotDestroy={}

	self.messageList = {}

	self.removeEffects = {}

	self.HBG_StartEndState = nil
end

function BattleGround:AdvanceState(newState, delay)

	LOG(string.format("BattleGround:AdvanceState (%s) request advance to %d",tostring(self.my_id),newState))
	if self.host then

		if self.receivedAdvanceStateMsg or not self.mp then
			-- Move on
			LOG(string.format("BattleGround:AdvanceState (%s) sending message",tostring(self.my_id)))
			self.receivedAdvanceStateMsg = false
			local e = GameEventManager:Construct("AdvanceState")
			e:SetAttribute("state", newState)
			e:SetAttribute("delay", delay)
			GameEventManager:Send( e )
		else
			-- Check back later
			LOG(string.format("BattleGround:AdvanceState (%s) check back later",tostring(self.my_id)))
			local e = GameEventManager:Construct("CheckAdvanceState")
			e:SetAttribute("state", newState)
			e:SetAttribute("delay", delay)
			local nextTime = GetGameTime() + 100
			GameEventManager:SendDelayed( e, self, nextTime )

		end

	else
		--LOG(string.format("BattleGround:AdvanceState (%s) remote sending flag",tostring(self.my_id)))
		local e = GameEventManager:Construct("SendAdvanceStateMsg")
		e:SetAttribute("state", newState)
		GameEventManager:Send( e, self.host_id)
	end
end

function BattleGround:OnEventCheckAdvanceState(event)
	LOG(string.format("BattleGround:OnEventCheckAdvanceState (%s)... checking",tostring(self.my_id)))
	self:AdvanceState(event:GetAttribute("state"), event:GetAttribute("delay"))
end

function BattleGround:AllocateGem()
	if self.gemPool then
		local gem = next(self.gemPool)
		if not gem then
			gem = GameObjectManager:Construct("Gems")
			self.gemAllocCount = self.gemAllocCount + 1
			--LOG(" *** WARNING: COULD NOT ALLOCATE GEM OUT OF POOL")
		else
			self.gemPool[gem] = nil
		end
		return gem
	end

	return GameObjectManager:Construct("Gems")
end

function BattleGround:ReleaseGem(g)
	if self.gemPool then
		self.gemPool[g] = g

		-- stop this object from doing things (so that it behaves more "destroyed")
		g:SetView(nil)
		g:ClearParticles()
		g:SetMovementController(nil)

		-- destroying a gem would normally clean up all children
		while g:GetNumChildren() > 0 do
			GameObjectManager:Destroy(g:GetChild(0))
		end
	else
		g:SetView(nil)
		GameObjectManager:Destroy(g)
		g = nil
	end
end

function BattleGround:DestroyObjects()
	LOG("DestroyObjects")

	--self.ui = nil
    --self.baseGems={}



    --self:InitGemList()
    --self.patternList={}

	--self.edgeGrids = {}
    --self:InitCoords()

	--self.matchEvent = nil


    --self.turn = {}
	--self.turn.matchCount = {} -- this will count matches matches[4]++ for 4 or a kind.
	--self.turn.patterns = {}
	--self.turn.patternCount = {}

	--self.turn.chainCount = nil


	--self.music = {}
	--self.music_selection = nil

	--self.aboutToWin = nil
	--self.aboutToLose = nil

	--self.gateHacked = nil
	--self.hackPattern = nil

	--self.fillList = nil
	--self.effects = {}

	--self.xml = nil

	--self.gp_grid = nil
	--self.gp_dir = nil

	--self.inputMsgs = {}

	--self.multiplier = nil

	--self.gems = {}

	--self.HBG_StartEndState = nil

	--self:ClearAttributeCollection("GamePatterns")
	--self:ClearAttributeCollection("Players")

	--[[--Redundant clearing
	if self.gemPool then
		--LOG(string.format(" *** A total of %d extra gems were allocated while playing", self.gemAllocCount))
		for k in pairs(self.gemPool) do
			GameObjectManager:Destroy(k)
		end
		self.gemPool = nil
	end
	--]]

	--[[for pattern,_ in pairs(self.patternList) do

		GameObjectManager:Destroy(self.patternList[pattern])
		self.patternList[pattern] = nil
		--LOG("Destroy pattern " .. pattern)
	end
	--]]
end


--Override this function for any special events for starting new game
function BattleGround:NewGame()
	PlaySound("snd_battleengaged")
end







function BattleGround:PostProcessFillList(fillList)
end

-------------------------------------------------------------------------------
--                            BattleGround:PreProcessLists
--
--                Many lists can be calculated & set up here.
--
-------------------------------------------------------------------------------

-- Set up: self.numGems, self.numGemTypes, mapping table between the two
--         self.patternTypes, mapping between n-of-a-kind & patterns
--		   self.matchList = {}, self.matchListIdx
--		   self.board = {}
function BattleGround:PreProcessLists()

	--_G.LoadAndExecute("InitBattleground","PreProcessLists",true,  self)

	_G.INIT_BATTLEGROUND = _G.LoadInit(_G.INIT_BATTLEGROUND,"InitBattleground")
	--local INIT_BATTLEGROUND = import("InitBattleground")
	_G.INIT_BATTLEGROUND.PreProcessLists(self)

	--no longer any need to nil this
	--_G.INIT_BATTLEGROUND = nil
	--purge_garbage()
end




-------------------------------------------------------------------------------
--                            Find Matches
--
--                creates table self.matchList[].(idx, matchIdx, num, dir)
--						with a size of self.matchListIdx
--
--                  returns true/false if matches found
-------------------------------------------------------------------------------

--function BattleGround:FindMatches()
function BattleGround:FindMatches(coro_id)
	LOG("FindMatches() ")
	if (not self.preProcessLists) then
		self:PreProcessLists()
	end
				CRH.CheckYield(coro_id)  -- YIELD???
	self:InitMatchList()
				CRH.CheckYield(coro_id)  -- YIELD???
	self:InitLocalBoard()
				CRH.CheckYield(coro_id)  -- YIELD???
	local matchesFound = self:GetMatchList()
				CRH.CheckYield(coro_id)  -- YIELD???
	if matchesFound then
		LOG("MatchesFound")
		self:HandleMatches(coro_id)
		self.turn.chainCount = self.turn.chainCount + 1
		--self:Chain(self.turn.chainCount)--match multipliers set before Award match events sent
		--self:FireMatchList()
	end
				CRH.CheckYield(coro_id)  -- YIELD???
	return matchesFound
end

--[[
--Moved to Platform so DS can do things differently for singleplayer
-- Send a CLEAR message to all grids with a match on them
function BattleGround:ClearMatches()
--function BattleGround:ClearMatches(coro_id)

	local curr_player = self:GetAttribute('curr_turn')
	if self.host then
		local clearEvent = GameEventManager:Construct("ClearGems")
		for i=1, self.matchListIdx do

			--if this gem is a match - destroy it.
			local matchIdx = self.matchList[i].matchIdx
			local add = self.dir2add[self.matchList[i].dir]
			for n=1,self.matchList[i].num do
				local thisIdx = self.matchGrid2Grid[matchIdx]
				local gem = self:GetGem(thisIdx)
				if gem then
					clearEvent:PushAttribute("grid_id",thisIdx)
				end
				matchIdx = matchIdx + add

				--CRH.CheckYield(coro_id)

			end

			--CRH.CheckYield(coro_id)

		end

		GameEventManager:Send(clearEvent,self.host_id)

	end

	--CRH.CheckYield(coro_id)

end

--]]


function BattleGround:InitMatchList()
 	self.matchListIdx = 0
end

function BattleGround:InitLocalBoard(coro_id)
	--LOG("BattleGround:InitLocalBoard entry")
	for i=1,self.maxHexes do
		local idx = self.matchGrid2Grid[i]
		if idx == 0 then
			self.board[i] = 0
		else
			--LOG("BattleGround:InitLocalBoard i="..i.."  idx="..idx)
			local baseGem = self:GetGem(idx)
			if baseGem then
				--LOG("BattleGround:InitLocalBoard baseGem.id="..baseGem.id)
				--LOG("BattleGround:InitLocalBoard type="..self.gem2gemType[baseGem.id])
				self.board[i] = self.gem2gemType[baseGem.id]
			else
				--LOG("BattleGround:InitLocalBoard baseGem=nil")
				self.board[i] = 0
			end
			if (self.board[i] == 0) then
				self.doneBoard1[i] = true
				self.doneBoard2[i] = true
				self.doneBoard3[i] = true
			else
				self.doneBoard1[i] = false
				self.doneBoard2[i] = false
				self.doneBoard3[i] = false
			end
		end
		CRH.CheckYield(coro_id)
	end
	self.doNotDestroy = {}
end

function BattleGround:GetMatchList()
	local matchesFound = false

	-- Find any matches on the local board
	for col=1,self.numMatchColumns do
		local startIdx = self.matchColumn[col]
		local size = self.matchColumnSize[col]
		for mgidx = startIdx, startIdx+size do

			local origType = self.board[mgidx]
			if origType and origType > 0 then
				-- Look up-right

				if col <= self.numMatchColumns-2 and not self.doneBoard1[mgidx] then
					if (origType == self.board[mgidx+8] and origType == self.board[mgidx+16]) then
						self.matchListIdx = self.matchListIdx + 1
						if not self.matchList[self.matchListIdx] then
							self.matchList[self.matchListIdx] = {}
						end
						self.matchList[self.matchListIdx].matchIdx = mgidx
						self.matchList[self.matchListIdx].idx = self.matchGrid2Grid[mgidx]
						self.matchList[self.matchListIdx].num = 3
						self.matchList[self.matchListIdx].dir = 2
						self.doneBoard1[mgidx] = true
						self.doneBoard1[mgidx+8] = true
						self.doneBoard1[mgidx+16] = true
						for idx = mgidx+24,mgidx+56,8 do
							if self.board[idx] == origType then
								self.matchList[self.matchListIdx].num = self.matchList[self.matchListIdx].num + 1
								self.doneBoard1[idx] = true
							else
								break
							end
						end
					end
				end

				-- Look down-right
				if col <= self.numMatchColumns-2 and not self.doneBoard2[mgidx] then
					if (origType == self.board[mgidx+9] and origType == self.board[mgidx+18]) then
						self.matchListIdx = self.matchListIdx + 1
						if not self.matchList[self.matchListIdx] then
							self.matchList[self.matchListIdx] = {}
						end
						self.matchList[self.matchListIdx].matchIdx = mgidx
						self.matchList[self.matchListIdx].idx = self.matchGrid2Grid[mgidx]
						self.matchList[self.matchListIdx].num = 3
						self.matchList[self.matchListIdx].dir = 3
						self.doneBoard2[mgidx] = true
						self.doneBoard2[mgidx+9] = true
						self.doneBoard2[mgidx+18] = true
						for idx = mgidx+27,mgidx+63,9 do
							if self.board[idx] == origType then
								self.matchList[self.matchListIdx].num = self.matchList[self.matchListIdx].num + 1
								self.doneBoard2[idx] = true
							else
								break
							end
						end
					end
				end

				-- Look down
				if mgidx <= startIdx+size-2 and not self.doneBoard3[mgidx] then
					if (origType == self.board[mgidx+1] and origType == self.board[mgidx+2]) then
						self.matchListIdx = self.matchListIdx + 1
						if not self.matchList[self.matchListIdx] then
							self.matchList[self.matchListIdx] = {}
						end
						self.matchList[self.matchListIdx].matchIdx = mgidx
						self.matchList[self.matchListIdx].idx = self.matchGrid2Grid[mgidx]
						self.matchList[self.matchListIdx].num = 3
						self.matchList[self.matchListIdx].dir = 4
						self.doneBoard3[mgidx] = true
						self.doneBoard3[mgidx+1] = true
						self.doneBoard3[mgidx+2] = true
						for idx = mgidx+3,mgidx+7,1 do
							if self.board[idx] == origType then
								self.matchList[self.matchListIdx].num = self.matchList[self.matchListIdx].num + 1
								self.doneBoard3[idx] = true
							else
								break
							end
						end
					end
				end
			end

		end
	end

	if self.matchListIdx > 0 then
		matchesFound = true
	end

	return matchesFound
end

function BattleGround:FireMatchList()
	LOG("FireMatchList()")
	--self.turn.chainCount = self.turn.chainCount + 1
	--self:Chain(self.turn.chainCount)--match multipliers set before Award match events sent

	self:Chain(self.turn.chainCount)--match multipliers set before Award match events sent

	local player = self:GetCurrPlayer()

	--Construct Award Event - only once - pass in thru direct call
	local e = GameEventManager:Construct(self.matchEvent)
	e:SetAttribute("player", player)
	local func_name = string.format("OnEvent%s",self.matchEvent)

	for i=1,self.matchListIdx do
		--LOG("BattleGround:FireMatchList   matchList["..i.."] matchIdx="..self.matchList[i].matchIdx.." idx="..self.matchList[i].idx.." dir="..self.matchList[i].dir.." num="..self.matchList[i].num)
		local myGrid = self.matchList[i].matchIdx
		local myAdd = self.dir2add[self.matchList[i].dir]
		for j=1,self.matchList[i].num do
			local myActualGrid = self.matchGrid2Grid[myGrid]
			self:MatchGem(myActualGrid)
			myGrid = myGrid + myAdd
		end

		--LOG("match2pattern = "..tostring(self.match2patternType[self.matchList[i].num]))
		local match = self.patternList[self.match2patternType[self.matchList[i].num]]


		--local e = GameEventManager:Construct(self.matchEvent)
		--e:SetAttribute("player", player)
		e:SetAttribute("index", self.matchGrid2Grid[self.matchList[i].matchIdx])
		e:SetAttribute("direction", self.matchList[i].dir)

		--GameEventManager:Send( e, match )
		match[func_name](match,e)--Changed to straight function call
	end
end




function BattleGround:GetFallDir()
	LOG("GetFallDir()")
	local gravity = self:GetAttribute("gravity")
	local returnGravity = 4
	if gravity == 0 then
		returnGravity = self:GetAttribute("swap_direction")
	else
		returnGravity = gravity
	end
	local numEffects = self:NumAttributes("Effects")
	for i=1,numEffects do
		returnGravity = self:GetAttributeAt("Effects",i):GetGravity(self,returnGravity)
	end
	self:SetAttribute("swap_direction",returnGravity)
	return returnGravity
end


function BattleGround:SetFallDir(swap_dir)
	local gravity = self:GetAttribute("gravity")
	if gravity == 0 then
		self:SetAttribute("swap_direction",swap_dir)
	end
end


-------------------------------------------------------------------------------
--   Spawn chain events for chains of various length,   atm 4,6
-------------------------------------------------------------------------------
function BattleGround:Chain(len)
	--self.multiplier = 1

	--LOG(string.format("chain(%d)",len))
	if len == 4 then

		self:Nova()
	elseif len == 6 then

		self:SupaNova()
	end
end


function BattleGround:Nova()
	local player = self:GetCurrPlayer()
	player.novas = player.novas + 1
	--local otherPlayer

        if self:NumAttributes("Players") >= 2 then
	  LOG("NOVA - set multiplier to 1.5") -- Novas are too strong. <CBM>
	  self.multiplier = 1.5
        else
	  LOG("NOVA - set multiplier to 2")
	  self.multiplier = 2
	end

	local trapped = false
	--if self:NumAttributes("Players") >= 2 then
	--	if player:GetAttribute("player_id") == 1 then
	--		otherPlayer = self:GetAttributeAt("Players", 2)
	--	else
	--		otherPlayer = self:GetAttributeAt("Players", 1)
	--	end
	--else
	--	otherPlayer = player
	--end

	-- Booby-Trap Effect --
	if self:NumAttributes("Players") >= 2 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC02_NAME]" then -- Booby Trap
				trapped = true
				--local TrapEffect = player:GetAttributeAt("Effects", i)
				break
			else
				trapped = false
			end
		end
	end


	for i=1,self:NumAttributes("Players") do
		local pl = self:GetAttributeAt("Players", i)
		--LOG("Evaluating Player " .. i)
		for k=1,pl:NumAttributes("Effects") do
			if pl:GetAttributeAt("Effects", k).classIDStr == "FS02" then
				LOG("Found effect... applying bonus")

				local weapon_increase = pl:GetAttribute("weapon_max") - pl:GetAttribute("weapon")
				local engine_increase = pl:GetAttribute("engine_max") - pl:GetAttribute("engine")
				local cpu_increase = pl:GetAttribute("cpu_max") - pl:GetAttribute("cpu")

				local e = GameEventManager:Construct("ReceiveEnergy")
				e:SetAttribute("effect", "weapon")
				e:SetAttribute("amount", pl:GetAttribute("weapon_max"))
				GameEventManager:Send(e, pl)

				local coords = self.coords[pl:GetAttribute("player_id")]["weapon"]
				_G.ShowMessage(self, string.format("+%i", weapon_increase), "font_numbers_red", coords[1], coords[2], false)

				e = GameEventManager:Construct("ReceiveEnergy")
				e:SetAttribute("effect", "engine")
				e:SetAttribute("amount", pl:GetAttribute("engine_max"))
				GameEventManager:Send(e, pl)

				local coords = self.coords[pl:GetAttribute("player_id")]["engine"]
				_G.ShowMessage(self, string.format("+%i", engine_increase), "font_numbers_yellow", coords[1], coords[2], false)

				e = GameEventManager:Construct("ReceiveEnergy")
				e:SetAttribute("effect", "cpu")
				e:SetAttribute("amount", pl:GetAttribute("cpu_max"))
				GameEventManager:Send(e, pl)

				local coords = self.coords[pl:GetAttribute("player_id")]["cpu"]
				_G.ShowMessage(self, string.format("+%i", cpu_increase), "font_numbers_green", coords[1], coords[2], false)


				break
			end
		end
	end

	if self:NumAttributes("Players") >= 2 then
		if trapped == true then
			local event = GameEventManager:Construct("ReceiveEnergy")
			event:SetAttribute('effect', "life")
			event:SetAttribute('amount', -10)
			GameEventManager:Send(event, player)
			PlaySound("snd_destroy")
		end
	end


	self:NovaMessage()
end

function BattleGround:SupaNova()
	local player = self:GetCurrPlayer()
	player.supanovas = player.supanovas + 1
	local trapped = false
	--local otherPlayer
	--if self:NumAttributes("Players") >= 2 then
	--	if player:GetAttribute("player_id") == 1 then
	--		otherPlayer = self:GetAttributeAt("Players", 2)
	--	else
	--		otherPlayer = self:GetAttributeAt("Players", 1)
	--	end
	--else
	--	otherPlayer = player
	--end

	-- Booby-Trap Effect --
	if self:NumAttributes("Players") >= 2 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC02_NAME]" then -- Booby Trap
				trapped = true
				--local TrapEffect = player:GetAttributeAt("Effects", i)
				break
			else
				trapped = false
			end
		end
	end

	if self:NumAttributes("Players") >= 2 then
	  LOG("SUPANOVA - set multiplier to 1.5") -- Getting an extra turn is reward enough <CBM>
	  self.multiplier = 1.5
        else
	  LOG("SUPANOVA - set multiplier to 3")
	  self.multiplier = 3
	end
	self:AwardExtraTurn(-(self.text_extra_y - (self.nova_y-self.nova_offset_1-10)))
	--self:AwardExtraTurn()

	self:SupaNovaMessage()

	if self:NumAttributes("Players") >= 2 then
		if trapped == true then
			local event = GameEventManager:Construct("ReceiveEnergy")
			event:SetAttribute('effect', "life")
			event:SetAttribute('amount', -20)
			GameEventManager:Send(event, player)
			PlaySound("snd_destroy")
		end
	end

end

function BattleGround:AwardExtraTime(time)

	if time ~= 0 then
		local msg = tostring(time)
		if time > 0 then
			msg = string.format("+%s",msg)
		end
		local counter = self:GetAttribute("counter")
		self:SetAttribute("counter",counter+time)

		--BEGIN_STRIP_DS
		_G.SCREENS.GameMenu:RumblePlayer(self:GetAttribute("curr_turn"), 0.4, 350)
		--END_STRIP_DS

		--Displays Extra Turn message
	    --local msgView = GameObjectManager:Construct('GMSG')
	    --self:AddChild(msgView)
	    _G.BigMessage(self,"[EXTRATIME]",self.text_extra_x,self.text_extra_y + 30)
	    _G.BigMessage(self,msg,self.text_extra_x,self.text_extra_y)

		self.TimeExpired = nil
	end
end


function BattleGround:AwardExtraTurn(offset)
	if not offset then
		offset = 0
	end

	if self.turn.turns < 2 then--max turns at any time is 2.
    	self.turn.turns = self.turn.turns + 1
		_G.SoundFunction("snd_extraturn", 0, 1)
		_G.BigMessage(self,"[EXTRATURN]",self.text_extra_x,self.text_extra_y+offset)
	end
_G.LAST_TURN_FREE = true


end



--[[
--Sets up MatchList data for gems to be removed

--]]
function BattleGround:ClearGems(gemList, award, noSound,hide_particles)
	LOG("ClearGems()")
	self:InitMatchList()
	local player = self:GetCurrPlayer()

	if #gemList > 12 then
		hide_particles = true
	end

	--init effects counters
	local effectCounts = {}
	local effectSounds = {}
	for i,v in pairs(self.baseGems) do
		effectCounts[_G.GEMS[i].effect]=0
		effectSounds[_G.GEMS[i].effect]=_G.GEMS[i].sound
	end

	local e = GameEventManager:Construct(self.matchEvent)
	--e:SetAttribute("BattleGround", self)
	e:SetAttribute("player", player)
	local effect
	local gemID
	for i,v in pairs(gemList) do
		--LOG("gemList ->"..tostring(v))
		local gem = self:GetGem(v)
		gem.grid_id=v
		local gemType = gem.id
		self.matchListIdx = self.matchListIdx + 1
		if not self.matchList[self.matchListIdx] then
			self.matchList[self.matchListIdx] = {}
		end
		self.matchList[self.matchListIdx].idx = v
		self.matchList[self.matchListIdx].matchIdx = self.grid2MatchGrid[v] -- a reverse lookup
		self.matchList[self.matchListIdx].dir = 1
		self.matchList[self.matchListIdx].num = 1

		gemID = gem.classIDStr
		effect = _G.GEMS[gemID].effect
		effectCounts[effect] = effectCounts[effect] + _G.GEMS[gemID].amount
	end


	if award then
		--local match = self.patternList["PMT1"]
		for effect,total in pairs(effectCounts) do
			--LOG(string.format("Award %d -> %s",total,effect))
			if total > 0 then
				local event
				--e:SetAttribute("index", total)
				if not noSound then
					--LOG("Blocked sound")
					--e:SetAttribute("play_sound", 0)
					PlaySound(effectSounds[effect])
				end

				--Send Damage/Energy msg to enemy/hero
				if effect == "damage" then
					local enemy = self:GetEnemy(player)
					event = GameEventManager:Construct("ShipDamage")

					event:SetAttribute('amount',total)
					--event:SetAttribute("BattleGround",battleGround)
					event:SetAttribute("source", player)
					--local nextTime = GetGameTime() --+ self:GetAttribute("award_delay")
					--LOG("Sending GameEvent")
					GameEventManager:Send( event, enemy)
					--LOG("Sent GameEvent")

				elseif not player:HasAttribute(effect) then
					LOG("Unknown effect")
				else
					event = GameEventManager:Construct("ReceiveEnergy")
					event:SetAttribute('effect',effect)
					event:SetAttribute('amount',total)
					--local nextTime = GetGameTime() --+ self:GetAttribute("award_delay")
					--MutateWithCollection(event, player, 'Effects')
					GameEventManager:Send( event, player)
				end


			end
			--match:OnEventAward(e)
		end
	end

	if not hide_particles then
		self:HandleMatches(coro_id)
	end

	self:AdvanceState(_G.STATE_REMOVING,0)--self:GetAttribute("movement_check"))
	--[[
	if self:ClearMatches(nil) then
		self:FireClearMatches()
	end

	--]]
end


function BattleGround:OnEventPreviewPattern()
---empty for standard battle

end

-------------------------------------------------------------------------------
-- destPlayer/sourcePlayer - player objects
-- amount of damage to inflict
-- direct true/false whether to deal to player direct or shield->player
-- particle - the particle to use for the path system
-- sourceObj, optional, will use for source X,Y co-ords if present
-------------------------------------------------------------------------------
function BattleGround:DamagePlayer(sourcePlayer,destPlayer,amount,direct,particle,itemIndex)

	local event
	event = GameEventManager:Construct("ShipDamage")
	if direct then
		event:SetAttribute("direct", 1)
	end
	event:SetAttribute('amount',amount)
	event:SetAttribute("BattleGround",self)
	event:SetAttribute('source',sourcePlayer)

	if sourcePlayer.damage_done then
		sourcePlayer.damage_done = sourcePlayer.damage_done + amount
	end

	GameEventManager:Send( event, destPlayer)


	--Draw Laser from Ship/item to Ship
	if self ~= sourcePlayer then--if bg not dealing this damage for invalid turn
		self:DrainEffect("damage",sourcePlayer:GetAttribute("player_id"),"damage",destPlayer:GetAttribute("player_id"),itemIndex)
	end
end



-------------------------------------------------------------------------------
--    returns list of grid ids for gems that match gemType
-- effect has no effect atm.
-------------------------------------------------------------------------------
function BattleGround:GetGemList(gemType,gemList)
	if not gemList then
		gemList = {}
	end
	local match = GEMS[gemType].id


	for i,v in pairs(self.gems) do
		if v.id== match then
			table.insert(gemList,i)
		end
	end
	return gemList
end



function BattleGround:GetCurrPlayer()
	if self:GetAttribute('curr_turn') <= self:NumAttributes("Players") then
		return self:GetAttributeAt('Players',self:GetAttribute('curr_turn'))
	else
		return nil
	end
end




-----------------------------CheckEndGame-------temp function-----------------------------------------
function BattleGround:CheckEndGame()

    local livePlayers = {}


    local percentage = {}
    for i=1,self:NumAttributes('Players') do

        local player = self:GetAttributeAt('Players',i)
        assert(player,"invalid player at "..tostring(i))
		local life = player:GetAttribute('life')
		local life_max = player:GetAttribute('life_max')
		LOG(string.format("Player %d life = %d",i,life))
        if life > 0 then
        	LOG("Live player")
			percentage[i]=(life/life_max)*100
            table.insert(livePlayers,player)
        else
        	percentage[i] = 0
        end


    end

	if percentage[1] < DANGER_ZONE then
		if percentage[1] > percentage[2] then
			self.aboutToWin = true
		else
			self.aboutToLose = true
		end
    elseif percentage[2] < DANGER_ZONE then
		self.aboutToWin = true
	else
		self.aboutToWin = false
		self.aboutToLose = false
    end


    -- If single player remains
    --to do check single team remains
	LOG(string.format("Check live players %d",#livePlayers))
	local numLivePlayers = #livePlayers
    if numLivePlayers == 1 then
        return livePlayers[1]:GetAttribute("player_id")
    elseif numLivePlayers == 0 then
		return 1
    end

    --player:playerVictory()
    return false
end



-------------------------------------------------------------------------------
--
--                      ValidMove() returns boolean.
--
-------------------------------------------------------------------------------
function BattleGround:ValidMove()
	LOG(string.format("ValidMove start %d",GetGameTime()))

	for i=1,self.moveListIdx do
		if self.moveList[i].grid1 == self.g1 and self.moveList[i].grid2 == self.g2 then
			return true
		elseif self.moveList[i].grid1 == self.g2 and self.moveList[i].grid2 == self.g1 then
			return true
		end
	end
   	LOG("Invalid Move")
    return false
end




function BattleGround:GetFillList()

	return self.fillList
end





-------------------------------------------------------------------------------
--               Reset Turn
--  	Reset turn stats
-------------------------------------------------------------------------------


function BattleGround:ResetTurn()
    LOG("ResetTurn() - chaincount=0")
    self.turn.chainCount = 0 -- counts match/remove/fall/match cycles.
	self.multiplier = 1

end


function BattleGround:EffectsCounter()
	local numEffects = self:NumAttributes("Effects")
	local removeEffects = {}
	for i=1,numEffects do
		local effect = self:GetAttributeAt("Effects",i)
		if effect:GetAttribute("player"):GetAttribute("player_id") == self:GetAttribute("curr_turn") then
			local counter = effect:Counter()
			if counter <= 0 then
				table.insert(removeEffects,effect)
			end
		end
	end

	if mp_is_host() then
		for i,v in pairs(self.removeEffects) do
			--open_message_menu("Destroyed Effect",v.classIDStr)
			GameObjectManager:Destroy(v)
		end
		self.removeEffects = {}
	end


	for i,v in pairs(removeEffects) do
		self:EraseAttribute("Effects",v)
		if mp_is_host() then
			table.insert(self.removeEffects,v)
			--GameObjectManager:Destroy(v)
		end
	end
	removeEffects = nil




end


--noseed - prevents any seeding in this call
--use in controlled circumstances only,
--you should always seed once before using this option. for MP
function BattleGround:MPRandom(a,b,extraSeed)

	if self.mp then
		if not extraSeed then
			extraSeed = 0
		end
		local host_id = tonumber(self.host_id) or 1
		math.randomseed(host_id+self.turn_count+extraSeed)
		math.random(a,b)
	end

	return math.random(a,b)
end





function BattleGround:IsGridAdjacent(g1,g2)

    if (g1<0 or g2<0 or not g1 or not g1) then
        return false
    end

    for i=1, HEX_SIDES do
    	if (self.hexAdjacent[g1][i]==g2) then
            return true
        end
    end
    return false
end

function BattleGround:GetGridDir(g1, g2)

    if (g1<0 or g2<0 and not g1 and not g2) then
        return -1
    end

    for i=1, HEX_SIDES do
        if (self.hexAdjacent[g1][i]==g2) then
            return i
        end
    end
    return -1
end


--BattleGround:MovementStopped()


function BattleGround:EmptyGrids()
    for i=1, HEX_GRIDS do
        if not self:GetGem(i) then
            return true
        end
    end
    return false
end







-------------------------------------------------------------------------------
--
--                      GAME START
--
-------------------------------------------------------------------------------

--------------------------------
-- Sets Up timer if specified -----
--------------------------------------
function BattleGround:InitTimer()
	LOG("InitTimer")

	local counter = self:GetAttribute("timer")
	self:SetAttribute("counter",counter)
	if counter > 0  and not self.timer_set then
		local e = GameEventManager:Construct("GameTimer")
		local nextTime = GetGameTime() + COUNTER_TICK
		GameEventManager:SendDelayed(e, self, nextTime )
		self.timer_set = true
	end
end



function BattleGround:RestartBattle()

	self.HBG_StartEndState = import "HexBattlegroundEndState"
	self.HBG_StartEndState.RestartBattle(self)

	self.gameLost = false
	self.turns_remaining = self.cost

	--no longer any need to nil this
	--self.HBG_StartEndState  = nil -- This is the end of the line for the start/end state
	--purge_garbage()
end

function BattleGround:InitGemList()
	local startmem = collectgarbage("count")
    self.gemList = self.baseGems
	self.gemListTotal = 0
    for i,v in pairs(self.baseGems) do
		self.gemListTotal = self.gemListTotal + v
	end
end

-------------------------------------------------------------------------------
-- BlackHole()
--
-------------------------------------------------------------------------------
function BattleGround:OnEventBlackHole(event)
	LOG("BLack Hole")
	local endX = self.hexPts[GRID_CENTER][1]
	local endY = self.hexPts[GRID_CENTER][2]

	--local msgView = GameObjectManager:Construct('GMSG')
	--self:AddChild(msgView)
	_G.BigMessage(self,"[BLACKHOLE]",endX,endY)

	_G.SoundFunction("snd_blackhole", 0, 1)

	local e = GameEventManager:Construct("ClearBoard")
	GameEventManager:Send(e,self)
end

-------------------------------------------------------------------------------
-- ClearBoard()
-- Clears all the gems from the board
-- ends turn
-- replenishes board - awarding this turns player any match points?
--
-------------------------------------------------------------------------------

function BattleGround:OnEventClearBoard(event)
	LOG("OnEventClearBoard")
	if self:MovementStopped() then
		if event:GetAttribute("void") == 0 then
			LOG("VOID == 0")
			local endX = self.hexPts[GRID_CENTER][1]
			local endY = self.hexPts[GRID_CENTER][2]

			local clearEvent
			if self.host then
				clearEvent = GameEventManager:Construct("ClearGems")
				clearEvent:SetAttribute("black_hole",1)
				--Sets each gem to get sucked into center of board.
				for i=1, HEX_GRIDS do
					local gem = self:GetGem(i)
					if gem then
						--gem:SetAttribute("grid_id",i)
						gem.grid_id = i
						clearEvent:PushAttribute("grid_id",i)
						self:SetBlackHoleMovement(gem,gem:GetX(),gem:GetY(),endX,endY)
					end

				end
				GameEventManager:Send(clearEvent,self.host_id)
			end
		else
			if event:GetAttribute("refresh_board")==1 then
				local e = GameEventManager:Construct("RefreshBoard")
				GameEventManager:Send(e,self)
			end

		end
	else
		--Pass the same event back to itself until movement stopped.
		local nextTime = GetGameTime() + self:GetAttribute("movement_check")
		GameEventManager:SendDelayed( event, self, nextTime )
	end
end

function BattleGround:OnEventRefreshBoard(event)
	local refreshed = true
	self:FillGrid(self:GetFillList(),refreshed)

end

-----------------------------------------
-------------------------------
----------------------
----------- CallBack Functions from end game dialogs
function BattleGround:OnEventVictoryMenu(event)

	self.HBG_StartEndState = import "HexBattlegroundEndState"
	self.HBG_StartEndState.OnEventVictoryMenu(self,event)

end

function BattleGround:OpenCombatResults(victory,callback, statHero, factionChange, planList, cargoList, shipPortrait)

   self.HBG_StartEndState = import "HexBattlegroundEndState"
   self.HBG_StartEndState.OpenCombatResults(self,victory,callback, statHero, factionChange, planList, cargoList, shipPortrait)

end

function BattleGround:OnEventLossMenu(event)

	self.HBG_StartEndState = import "HexBattlegroundEndState"
	self.HBG_StartEndState.OnEventLossMenu(self,event)

end


function BattleGround:HandleEndGame(winner)
	self.HBG_StartEndState = import "HexBattlegroundEndState"
	self.HBG_StartEndState.HandleEndGame(self, winner)
end


function BattleGround:OnEventEndTurn(event)
	LOG("OnEventEndTurn")

	if gcinfo() > 550 then
		LOG("End Turn Emergency Collect")
		--purge_garbage()
	end

	if self.state == _G.STATE_INITIALIZING or self.state == _G.STATE_GAME_OVER then
		return
	end

	self.state = _G.STATE_FINDING_MOVE

	self:DeselectGem(self.g1)
	self:DeselectGem(self.g2)



	local turn = self:GetAttribute('curr_turn')
	local old_player = self:GetAttributeAt("Players",turn)
	old_player:EndTurn(self.turn.chainCount)--For Stat Tracking
	if not self.item_skip_end_turn then -- skips effects counters in fake end turn
		self:EffectsCounter()
		old_player:EffectsCounter()
	end

	local winner = self:CheckEndGame()
	if winner then
		_G.GLOBAL_FUNCTIONS[string.format("Update%s",self.ui)]()--UpdateUI on End of Battle
		self:HandleEndGame(winner)
		return
	end

	self:ResetTurn()

	--If Item has to force end turn to not happen, then this does that.
	if self.item_skip_end_turn then
		LOG("Skip End Turn")
		self.item_skip_end_turn = false
		CRH.Run(function (coro_id) self:CheckMovesAndStartTurn(coro_id, true) end, 1,15, nil	)
		--self:CheckMovesAndStartTurn()
		return
	end

	self:ProcessEndTurn()

    --Check for end turn - alternate current turn
	if self.turn_count > 0 then
	    self.turn.turns = self.turn.turns - 1--decrement curr_players remaining turns


		self.turn_count = self.turn_count + 1
		self.timer_event = nil

        if self.turn.turns <= 0 then--If old_player out of turns - change turns
            --self:set_text_raw("str_turns_"..turn,"")
            turn = turn + 1
            if turn > self:NumAttributes('Players') then
                turn = 1
            end

         	self:SetAttribute('curr_turn',turn)
			--SCREENS.GameMenu:SwitchPanels(turn)
			if _G.XBOXLive and self.mp then  --XBox Live MP game
				local max_timer_value = _G.XBOXLive.GetProperty("game_timer")
				if max_timer_value > 0 then
					local other_side = 2
					if turn == other_side then
						other_side = 1
					end
					SCREENS.GameMenu:hide_widget(string.format("str_counter_%d", other_side))
					SCREENS.GameMenu:activate_widget(string.format("str_counter_%d", turn))
					SCREENS.GameMenu:set_text_raw(string.format("str_counter_%d", turn), tostring(max_timer_value))
				end
			end

			LOG(string.format("End Turn() -- new turn player #%d",turn))
			local player = self:GetAttributeAt("Players",self:GetAttribute('curr_turn'))

			local eraseTimeWarp = false
			for i=1,player:NumAttributes("Effects") do
				local effectId = player:GetAttributeAt("Effects", i).classIDStr
				if effectId == "FT01" and not eraseTimeWarp then
					eraseTimeWarp = true
					i = 1
				end
				if effectId == "FT06" and eraseTimeWarp then
					self:GetAttributeAt("Players", turn):RemoveAttributeAt("Effects", i)
					break
				end
			end

			self.turn.turns = 1

			local old_turn = old_player:GetAttribute("player_id")

			if not _G.Hero or _G.Hero:GetAttribute("player_id") == old_turn then
				_G.SCREENS.GameMenu:TurnEnded()
			end

        end


		local player = self:GetAttributeAt("Players",self:GetAttribute('curr_turn'))


		--(coro_fn,interval,timeslice,callback_fn)
    	CRH.Run(function (coro_id) self:CheckMovesAndStartTurn(coro_id) end, 1,15, nil)
		--self:CheckMovesAndStartTurn()


	else
		LOG("First turn")--This happens after board init-  no player move has actually happened yet.
		_G.TOTAL_TURNS = 0
		--purge_garbage()
		--Sets up static Battle Screen UI elements
		self:NewGame()
		_G.GLOBAL_FUNCTIONS[string.format("Init%s",self.ui)]()
		self:InitTimer()--	init timer when ready for player to start

		self.turn_count = self.turn_count + 1


	--end


		local maxTurn = self:NumAttributes("Players")
		local player1 = self:GetAttributeAt("Players",1)
		local player2
		local phase_second = 0
		local phase_third = 0
		local phase_fourth = 0
		local phase_fifth = 0
		if self:NumAttributes("Players") >= 2 then
			player2 = self:GetAttributeAt("Players",2)
			local p2Intel = player2:GetAttribute("intel")
			local p2level = player2:GetLevel(p2Intel)
			_G.ENEMY_LEVEL = p2level
		end

		if self:NumAttributes("Players") >= 2 then
			player2 = self:GetAttributeAt("Players",2)
			local p1_pilot = player1:GetAttribute("pilot")
			local p2_pilot = player2:GetAttribute("pilot")
			local p1_eng = player1:GetAttribute("engineer")
			local p2_eng = player2:GetAttribute("engineer")
			local p1secondary = (p1_pilot * 3) + (p1_eng * 2)
			local p2secondary = (p2_pilot * 3) + (p2_eng * 2)


			if p1secondary > p2secondary then
				phase_second = 1
			elseif p1secondary < p2secondary then
				phase_second = 2
			else
				phase_second = 0
			end

			local phase_third = 0

			if player1:GetLevel(player1:GetAttribute("intel")) < player2:GetLevel(player2:GetAttribute("intel")) then
				phase_third = 1
			elseif player1:GetLevel(player1:GetAttribute("intel")) > player2:GetLevel(player2:GetAttribute("intel")) then
				phase_third = 2
			else
				phase_third = 0
			end

			local phase_fourth = 0

			if player1:GetAttribute("psi") > player2:GetAttribute("psi") then
				phase_fourth = 1
			elseif player1:GetAttribute("psi") < player2:GetAttribute("psi") then
				phase_fourth = 2
			else
				phase_fourth = 0
			end

			local phase_fifth = 0

			if player1:GetAttribute("intel") < player2:GetAttribute("intel") then
				phase_fifth = 1
			elseif player1:GetAttribute("intel") > player2:GetAttribute("intel") then
				phase_fifth = 2
			else
				phase_fifth = 0
			end
				 --Bola Mines start with a cooldown --
			if _G.TOTAL_TURNS == 0 then
				local numItems = player1:GetAttribute("curr_ship"):NumAttributes("battle_items")
				local numItems2 = player2:GetAttribute("curr_ship"):NumAttributes("battle_items")
				if numItems > 0 then
					for i=1, numItems do
						local suspect = player1:GetAttribute("curr_ship"):GetAttributeAt("battle_items", i)
						if suspect:GetAttribute("name") == "[I157_NAME]" then
							suspect:AddRecharge(5)
						end
					end
				end
				if numItems2 > 0 then
					for i=1, numItems2 do
						local suspect2 = player2:GetAttribute("curr_ship"):GetAttributeAt("battle_items", i)
						if suspect2:GetAttribute("name") == "[I157_NAME]" then
							suspect2:AddRecharge(5)
						end
					end
				end
			end

		end



		--FASTEST SHIP STARTS
		self:SetAttribute("curr_turn",1)
		if maxTurn > 1 then
			player2 = self:GetAttributeAt("Players",2)
			if player1:GetAttribute("curr_ship"):GetAttribute("max_speed") < player2:GetAttribute("curr_ship"):GetAttribute("max_speed") then
				self:SetAttribute("curr_turn",2)
			elseif	player1:GetAttribute("curr_ship"):GetAttribute("max_speed") == player2:GetAttribute("curr_ship"):GetAttribute("max_speed") then
				if phase_second ~= 0 then
					self:SetAttribute("curr_turn",phase_second) -- Check Engineer and Pilot
				elseif phase_third ~= 0 then
					self:SetAttribute("curr_turn",phase_third) -- Check Level
				elseif phase_fourth ~= 0 then
					self:SetAttribute("curr_turn",phase_fourth) -- Check PSI
				elseif phase_fifth ~= 0 then
					self:SetAttribute("curr_turn",phase_fifth) -- Check Intel
				else
					self:SetAttribute("curr_turn",1) -- Ultimately, the host still goes first, but fat chance of that being decided this way. . .
				end
			end
			SCREENS.GameMenu:SwitchPanels(self:GetAttribute("curr_turn"))

			if _G.XBOXLive and self.mp then  --XBox Live MP game
				--SCREENS.GameMenu:hide_widget("str_counter") -- no need to do this here, it's done in InitTimer()
				local max_timer_value = _G.XBOXLive.GetProperty("game_timer")

				local other_side = 2
				if self:GetAttribute("curr_turn") == other_side then
					other_side = 1
				end

				if max_timer_value > 0 then
					SCREENS.GameMenu:hide_widget(string.format("str_counter_%d", other_side))
					SCREENS.GameMenu:activate_widget(string.format("str_counter_%d", self:GetAttribute("curr_turn")))
					SCREENS.GameMenu:set_text_raw(string.format("str_counter_%d", self:GetAttribute("curr_turn")), tostring(max_timer_value))
				else
					SCREENS.GameMenu:hide_widget("str_counter_1")
					SCREENS.GameMenu:hide_widget("str_counter_2")
				end

			end

 		end
		_G.SCREENS.GameMenu:TurnEnded()

    	CRH.Run(function (coro_id) self:CheckMovesAndStartTurn(coro_id) end, 1,15, nil)
		--self:CheckMovesAndStartTurn()

		if self:GetAttribute('curr_turn')== 1 then
			--SCREENS.GameMenu:StartAnimation("player_1_start")
			self:AddToGrid(0, 0)
		else
			--SCREENS.GameMenu:StartAnimation("player_2_start")
			self:AddToGrid(-72, 0)
		end

	end
	--Moved
	--SCREENS.GameMenu:CheckQuitGame()

end

function BattleGround:CheckMovesAndStartTurn(coro_id, item_newturn)

	if not self:GetMoveList(coro_id) then--If no move then
		local e = GameEventManager:Construct("BlackHole")
		GameEventManager:Send( e, self)

	elseif not SCREENS.GameMenu:CheckQuitGame() then
		--self.state = _G.STATE_IDLE

		LOG("send NewTurn")
		local player = self:GetAttributeAt("Players",self:GetAttribute("curr_turn"))
		local e = GameEventManager:Construct("NewTurn")
		e:SetAttribute("BattleGround",self)
		local nextTime = GetGameTime()
		if item_newturn then
			LOG("ItemNewTurn set to 1")
			e:SetAttribute("item_newturn", 1)
		end
		if player:GetAttribute("ai")==1 then
			nextTime = nextTime + self:GetAttribute('ai_delay')--AI delay for opponent only
		end
		if self:NumAttributes("Players") == 2 and not self.mp then
			nextTime = nextTime + self.turn_delay
		end

		GameEventManager:SendDelayed( e, player,nextTime)

		SCREENS.GameMenu:SwitchPanels(self:GetAttribute('curr_turn'))
	end

end

function BattleGround:ProcessEndTurn()
end







--[[
Called when an Invalid move is made
--]]
function BattleGround:InvalidMove()
	_G.BigMessage(self,"[INVALID]")

	_G.SoundFunction("snd_illegal", 0, 1)

	local currPlayer = self:GetCurrPlayer()
	--BEGIN_STRIP_DS
	--Gamepad.Rumble(0, 0.4, 350)
	_G.SCREENS.GameMenu:RumblePlayer(self:GetAttribute("curr_turn"), 0.4, 350)
	--END_STRIP_DS
	self:DamagePlayer(self,currPlayer,5,true,false,self)
end


-------------------------------------------------------------------------------
--
--   Update - Game State
--
-------------------------------------------------------------------------------

function BattleGround:InitStateSwapping()
	self.doneStateSwapping = false
	LOG(string.format("BattleGround:InitStateSwapping (%s) - resetting state 1",tostring(self.my_id)))
end

function BattleGround:UpdateStateSwapping(event, coro_id)
--function BattleGround:UpdateStateSwapping(event)
	LOG("UpdateStateSwapping()")

	-- Init some stuff
	local newState = nil
	local delay = 0

	-- Update code
	if self:MovementStopped() then

		CRH.CheckYield(coro_id)

		--if valid move
		--LOG("BattleGround.UpdateStateSwapping() pre self:ValidMove!")
		if self:ValidMove() then
			--LOG("BattleGround.UpdateStateSwapping() post self:ValidMove!")

			CRH.CheckYield(coro_id)

			self:DeselectGem(self.g1)
			self:DeselectGem(self.g2)

			newState = _G.STATE_SEARCHING      --delay to see matches before they are removed
			delay = self:GetAttribute("swap_delay")

			CRH.CheckYield(coro_id)

			--swapDelayEvent = GameEventManager:Construct("Update")
			--nextTime = GetGameTime() + self:GetAttribute("swap_delay")
		else
			LOG("invalidMove")
			CRH.CheckYield(coro_id)

			--Reverse Swap
			self:PlayerSwapGem(self.g1,self.g2)

			newState = _G.STATE_ILLEGALMOVE
			delay = 0

			self:DeselectGem(self.g1)

			CRH.CheckYield(coro_id)

			self:DeselectGem(self.g2)
			self:InvalidMove()
		end

	end


	CRH.CheckYield(coro_id)

	-- End of update event handling
	if newState then
		--LOG("Update to STATE_SEARCHING")
		--GameEventManager:SendDelayed( swapDelayEvent, self, nextTime )
		self:AdvanceState(newState, delay)
	else
		--LOG("Resend Update "..tostring(self.state))
		event = GameEventManager:Construct("Update")
		local nextTime = GetGameTime() + self:GetAttribute("movement_check")
		GameEventManager:SendDelayed( event, self, nextTime )
	end
end

function BattleGround:InitStateIllegalMove()
	self.doneStateIllegalMove = false
	--LOG(string.format("BattleGround:InitStateIllegalMove (%s) - resetting state 2",tostring(self.my_id)))
end

function BattleGround:UpdateStateIllegalMove(event, coro_id)
--function BattleGround:UpdateStateIllegalMove(event)
	LOG("UpdateIllegalMove()")

	if self.doneStateIllegalMove then
		--LOG(string.format("BattleGround:UpdateStateIllegalMove (%s) - bail out of state 2",tostring(self.my_id)))
		return
	end

	-- Init some stuff
	local isEndTurn = false

	-- We can end the turn when we've finished moving'
	if self:MovementStopped() then
		isEndTurn = true
		self.doneStateIllegalMove = true
	 end

	 CRH.CheckYield(coro_id)

	 -- End of update handling
	 if isEndTurn then
	 	local endTurnEvent = GameEventManager:Construct("EndTurn")
		GameEventManager:Send( endTurnEvent, self)
	 else
		event = GameEventManager:Construct("Update")
		local nextTime = GetGameTime() + self:GetAttribute("movement_check")
		GameEventManager:SendDelayed( event, self, nextTime )
	 end
end

function BattleGround:InitStateSearching()
	self.doneStateSearching = false
	--LOG(string.format("BattleGround:InitStateSearching (%s) - resetting state 3",tostring(self.my_id)))
end

--function BattleGround.UpdateStateSearching(coro_id, self, event)
function BattleGround:UpdateStateSearching(event, coro_id)

	LOG("UpdateStateSearching()")
	local newState = nil
	local isEndTurn = false
	local delay = 0

	if self.doneStateSearching then
		--LOG(string.format("BattleGround:UpdateStateSearching (%s) - bail out of state 3",tostring(self.my_id)))
		return
	end

	if self:MovementStopped() then
		CRH.CheckYield(coro_id)
		if self:FindMatches(coro_id) then
			newState = _G.STATE_REMOVING
			delay = self:GetAttribute("clear_delay")
		else
			isEndTurn = true
		end
		self.doneStateSearching = true
	end
	CRH.CheckYield(coro_id)

	if isEndTurn then
	 	local endTurnEvent = GameEventManager:Construct("EndTurn")
		GameEventManager:Send( endTurnEvent, self)
	elseif newState then
		self:FireMatchList()
		self:AdvanceState(newState,delay)
	else
		local event = GameEventManager:Construct("Update")
		local nextTime = GetGameTime() + self:GetAttribute("movement_check")
		GameEventManager:SendDelayed( event, self, nextTime )
	end



	-----------------------------------------------------------------
	--[[
	LOG("UpdateStateSearching()")
	-- Init some stuff
 	local runUpdate = false
	local cycle_delay =  self:GetAttribute("movement_check")
	local clearDelayEvent = nil
	local findDoneEvent = nil
	local endTurnEvent = nil
	local nextTime = 0
	local matchesFound = false

	local newState = nil

	-- Update code
	if self:MovementStopped() then
		CRH.CheckYield(coro_id)

		if not self.movement_end_delay then
			runUpdate=true
			--cycle_delay = 50--ADJUST DELAY TIME HERE
			self.movement_end_delay = true
			LOG("searching->move delay")
		else
			if self:FindMatches(coro_id) then
			--if self:FindMatches() then

				CRH.CheckYield(coro_id)

				matchesFound = true

				if self.find_done == 0 then
					Blog("UpdateSearching - Set Find Done 1")
					self.find_done = 1
					--send findDone event to opponent
					LOG("searching->got matches, find done = 0")
				elseif self.find_done == 1 then
					Blog("UpdateSearching - Set Find Done 0")
					newState = _G.STATE_REMOVING
					self.find_done = 0

					CRH.CheckYield(coro_id)

					clearDelayEvent = GameEventManager:Construct("Update")
					nextTime = GetGameTime() + self:GetAttribute("clear_delay")
					LOG("searching->got matches, find done = 1")
				end


				findDoneEvent = GameEventManager:Construct("FindDone")
				findDoneEvent:SetAttribute("match_found",1)

			else

				LOG("searching->no matches")

				CRH.CheckYield(coro_id)

				--no more matches found
				if self.find_done == 0 then
					self.find_done = 1
					LOG("searching->no matches, find done = 0")

				--send findDone event
				elseif self.find_done == 1 then

					endTurnEvent = GameEventManager:Construct("EndTurn")
					self.find_done = 0
					LOG("searching->no matches, find done = 1")
				end


				findDoneEvent = GameEventManager:Construct("FindDone")
				findDoneEvent:SetAttribute("match_found",0)

			end
		end


	else
		LOG("searching->moving")
		runUpdate = true
	end


	-- End of update handling
	if matchesFound then
		self:FireMatchList() -- send match events
	end
	if clearDelayEvent then
		--LOG(string.format("sending clear delay evt (%d)", self.state))
		GameEventManager:SendDelayed( clearDelayEvent, self, nextTime )
	end
	if endTurnEvent then
		--LOG(string.format("sending end turn evt (%d)", self.state))
		GameEventManager:Send( endTurnEvent, self )
	end
	if findDoneEvent then
		--LOG(string.format("sending find done evt (%d)", self.state))
		GameEventManager:Send(findDoneEvent,self.opponent_id)
	end
	if runUpdate then
		--LOG(string.format("sending new update evt (%d)", self.state))
		event = GameEventManager:Construct("Update")
		local nextTime = GetGameTime() + cycle_delay
		GameEventManager:SendDelayed( event, self, nextTime )
	end
	--]]
end


function BattleGround:InitStateRemoving()
	self.doneStateRemoving = false
	LOG(string.format("BattleGround:InitStateRemoving (%s) - resetting state 4",tostring(self.my_id)))

end

function BattleGround:UpdateStateRemoving(event, coro_id)
	LOG("UpdateStateRemoving()")

	if self.doneStateRemoving then
		--LOG(string.format("BattleGround:UpdateStateSearching (%s) - bail out of state 3",tostring(self.my_id)))
		return
	end



	-- Init some stuff
	local matchesCleared = false

	-- Update code
	if self:MovementStopped() then
		CRH.CheckYield(coro_id)
		matchesCleared = self:ClearMatches(coro_id)
		CRH.CheckYield(coro_id)
		self:DeselectGem(self.g1)
		self:DeselectGem(self.g2)
		self.doneStateRemoving = true
	end
	CRH.CheckYield(coro_id)

	if gcinfo()>540 then
		--collectgarbage();collectgarbage();
		LOG("Emergency Collect")
		--purge_garbage()
	end



	-- End of update handling
	if matchesCleared then
		self:FireClearMatches()
	elseif self.host then
		event = GameEventManager:Construct("Update")
		local nextTime = GetGameTime() + self:GetAttribute("movement_check")
		GameEventManager:SendDelayed( event, self, nextTime )
	end


end

--function BattleGround:UpdateStateFalling(event)
function BattleGround:InitStateFalling()
	self.doneStateFalling = false
	--LOG(string.format("BattleGround:InitStateFalling (%s) - resetting state 5",tostring(self.my_id)))
end

function BattleGround:UpdateStateFalling(event, coro_id)
	LOG("UpdateStateFalling()")
	-- Update code
	self:FallGems(coro_id)
	-- End of update handling
end

--function BattleGround:UpdateStateReplenishing(event)
function BattleGround:InitStateReplenishing()
		self.doneStateReplenishing = false
		--LOG(string.format("BattleGround:InitStateReplenishing (%s) - resetting state 6",tostring(self.my_id)))
	end
function BattleGround:UpdateStateReplenishing(event, coro_id)
	self:FillVoid(event, coro_id)
end



function BattleGround:OnEventUpdate(event)


	--collectgarbage();collectgarbage();
	LOG(string.format("MemUsage = %s, chain = %s ",tostring(gcinfo()),tostring(self.turn.chainCount)))


	LOG(string.format("Update(%d) %d",self.state,self.my_player_id))

    if self.state == STATE_SWAPPING then
    	--CRH.Run(function (coro_id) self:UpdateStateSwapping(event, coro_id) end ,1,15, nil)
    	self:UpdateStateSwapping(event)

    elseif self.state == STATE_ILLEGALMOVE then
		CRH.Run(function (coro_id) self:UpdateStateIllegalMove(event, coro_id) end ,1,15, nil)
		--self:UpdateStateIllegalMove(event)

     elseif self.state == STATE_SEARCHING then
	 	CRH.Run(function (coro_id) self:UpdateStateSearching(event, coro_id) end, 1,15, nil)
	 	--self:UpdateStateSearching(event)

    elseif self.state == STATE_REMOVING then
		CRH.Run(function (coro_id) self:UpdateStateRemoving(event, coro_id) end ,1,15, nil)
		--self:UpdateStateRemoving(event)

    elseif self.state == STATE_FALLING then
		CRH.Run(function (coro_id) self:UpdateStateFalling(event, coro_id) end, 1,15, nil)
        --self:UpdateStateFalling(event)

    elseif self.state == STATE_REPLENISHING then
		CRH.Run(function (coro_id) self:UpdateStateReplenishing(event, coro_id) end, 1,15, nil)
        --self:UpdateStateReplenishing(event)

    end

end

function BattleGround:HandleMatches(coro_id)

end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
--    USER INPUT
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function BattleGround:OnEventCursorAction(event)
    local obj   = event:GetAttribute("object")
    local x     = event:GetAttribute("x")
    local y     = event:GetAttribute("y")
	local up    = event:GetAttribute("up")
    local turn = self:GetAttribute('curr_turn')
	LOG(string.format("OnEventCursorAction up: %s",tostring(up)))

	--support for gamepad on->up
	if type(up)=="number" then
		if up==1 then
			up = false
		else
			up=true
		end
	end

	local function CloseItemPopup()
		SCREENS.GameMenu:CloseItemText()
	end
	_G.DSOnly(CloseItemPopup)

	if x < -172 or x > 1366 or y < 0 or y > 768 then
		LOG(string.format("Out of bounds x=%d y=%d",x,y))
		return
	end

	local player = self:GetCurrPlayer()

	if not player then
		return
	end

	LOG(string.format("Turn = %d",turn))
	--LOG("self.state = " .. tostring(self.state))
    --if turn = player self.state <= _G.STATE_USER_INPUT_PLAYER and

	local user = 0
	if event:HasAttribute("user") then
		user=event:GetAttribute("user")
	end
	local player_id = self:BGUserToPlayer(user)
	LOG("player_id = "..tostring(player_id))

    if self.state <= _G.STATE_USER_INPUT_PLAYER and turn == player_id and
    	player:GetAttribute("ai") == 0 and obj and self.moveListIdx > 0 then
		--LOG("Triggered turn")

        -- dont process actions if the object is moving
        if (obj:HasMovementController()) then
        	--LOG("obj Moving")
            return
        end

		LOG(string.format("x=%d y=%d",x,y))
		local selected = nil
		if obj:HasAttribute("isGem") then
	        x = obj:GetX()
	        y = obj:GetY()
			selected = self.gemIndex[x][y]
        elseif not self.mouse_down then
        	return
    	end
		if self.cheat then
			if up and selected then
				self.cheat = nil
				LOG("Cheat detected")

				SCREENS.GemSelectMenu:Open(selected,self.baseGems)

			end
			return
		end

		if up and self.mouse_down and self.state == _G.STATE_IDLE then--mouse up/dragging action only calculated for normal move - not item gem selection
			if selected == self.mouse_down then--ignore clicking down and up on single gem
				self.mouse_down = nil
				return
			elseif not self.g1 then
				self.mouse_down = nil
				return
			else
				LOG(string.format("%s %s","selected =",tostring(selected)))
				local adjacent = false
				for i,v in pairs(self.hexAdjacent[self.mouse_down]) do
					if v == selected then
						adjacent=true
						break
					end
				end
				if not adjacent then
					local downGem = self:GetGem(self.mouse_down)
					local downX = downGem:GetX()
					local downY = downGem:GetY()
					x = downX - x
					y = downY - y
					if math.abs(x) > self.drag_threshold or math.abs(y) > self.drag_threshold then
						return
					end
					local angle = math.atan2(y, x)

					local dir_list = {}
					if angle < 0 then
						dir_list = {6,1,2}
					else
						dir_list = {5,4,3}
					end
					angle = math.abs(angle)
					local i = 1
					if angle > 2 then
						i=3
					elseif angle > 1 then
						i=2
					end
					selected = self.hexAdjacent[self.mouse_down][dir_list[i]]
					if selected < 0 then-- -1 == off the board
						selected = self.mouse_down
					end
					--return
				end
				self.mouse_down = nil
			end
		elseif not up and selected then--ie mouse down
			self.mouse_down = selected
		else
			return
		end


		local clickEvent = GameEventManager:Construct("GemSelect")
		clickEvent:SetAttribute("player_id",self.my_player_id)
		clickEvent:SetAttribute("grid_id",selected)
		clickEvent:SetAttribute("behaviour", self.state)
		clickEvent:SetAttribute("turn",self.turn_count)
		GameEventManager:Send(clickEvent)
		--[[
        if self.state == STATE_IDLE then
			local selected = self.gemIndex[x][y]
			local clickEvent = GameEventManager:Construct("GemSelect")
			clickEvent:SetAttribute("player_id",self.my_player_id)
			clickEvent:SetAttribute("grid_id",selected)
			GameEventManager:Send(clickEvent)
            --self:GemClicked(selected,x,y)
        elseif self.state == STATE_USER_INPUT_GEM then
			self:DeselectGem(self.g1)
			self:DeselectGem(self.g2)

			local selected = self.gemIndex[x][y]
			self:SelectGem(selected)

			local e = GameEventManager:Construct("GetUserInput")
			e:SetAttribute("BattleGround",self)
			e:SetAttribute("player",self:GetCurrPlayer())
			e:SetAttribute("obj",obj)
			local nextTime = GetGameTime()
			assert(self.user_input_dest,"user_input_dest = nil")
			GameEventManager:Send( e, self.user_input_dest)

		elseif self.state == STATE_USER_INPUT_PLAYER then--Not currently used.
			self:DeselectGem(self.g1)
			self:DeselectGem(self.g2)

			--local selected = self.gemIndex[x][y]
			--self:SelectGem(selected)

			local e = GameEventManager:Construct("GetUserInput")
			e:SetAttribute("BattleGround",self)
			e:SetAttribute("player",self:GetCurrPlayer())
			e:SetAttribute("obj",obj)
			local nextTime = GetGameTime()
			assert(self.user_input_dest,"user_input_dest = nil")
			GameEventManager:Send( e, self.user_input_dest)
    	end
		--]]
    end

end

-- returns a gem index given an x and y position
function BattleGround:GetGemFromPos(x,y)
	if self.gemIndex[x] then
		return self.gemIndex[x][y]
	else
		return -1
	end
end


function BattleGround:GemClicked(selected)
	local gem = self:GetGem(selected)
	if selected and gem:GetAttribute('swapable')~=0 then
		if not self.g1 or self.g1 == nil  then
			--if no gem selected - select gem

			_G.SoundFunction("snd_click", 0, 1)

			self:SelectGem(selected)
		elseif selected == self.g1 then
			--if double clicking gem - deselect it
			PlaySound("snd_move")
			self:DeselectGem(selected)


		elseif self:IsGridAdjacent(self.g1,selected) then
			--If adjacent Gem - initiate Gem Swap
			PlaySound("snd_move")
			self:SelectGem(selected)
			self:SetFallDir(self:GetGridDir(self.g1,self.g2))
			self:PlayerSwapGem(self.g1,self.g2)

			LOG(string.format("Swap gem1=%d, gem2=%d",self.g1,self.g2))
			self.state = STATE_SWAPPING

			local e = GameEventManager:Construct("Update")
			local nextTime = GetGameTime() + self:GetAttribute("movement_check")
			GameEventManager:SendDelayed( e, self, nextTime )

		else

			_G.SoundFunction("snd_click", 0, 1)

			self:DeselectGem(self.g1)
			self:SelectGem(selected)
		end
	else
		self:DeselectGem(self.g1)
	end

end


function BattleGround:SwapGems()
	self:SetFallDir(self:GetGridDir(self.g1,self.g2))
	self:PlayerSwapGem(self.g1,self.g2)


	LOG(string.format("Swap gem1=%d, gem2=%d",self.g1,self.g2))
	self.state = STATE_SWAPPING

	local e = GameEventManager:Construct("Update")
	local nextTime = GetGameTime() + self:GetAttribute("movement_check")
	GameEventManager:SendDelayed( e, self, nextTime )
end



function BattleGround:GetPlayerPrefList(player)
	return player:GetPrefList(self)
end


-------------------------------------------------------------------------------
--
--   Gets Move List
-- - returns false if zero possible moves found.
-------------------------------------------------------------------------------

function BattleGround:GetMoveList(coro_id)
	LOG(string.format("BattleGround:GetMoveList"))
	if (not self.preProcessLists) then
		self:PreProcessLists()
	end
			CRH.CheckYield(coro_id) -- YIELD ???
	self:InitMoveList()
			CRH.CheckYield(coro_id) -- YIELD ???
	self:InitLocalBoard(coro_id)
			CRH.CheckYield(coro_id) -- YIELD ???
	local movesFound = self:GetAllMoves(coro_id)
			CRH.CheckYield(coro_id) -- YIELD ???
	if (movesFound) then
		 self:SortAllMoves()
		 	CRH.CheckYield(coro_id) -- YIELD ???
	end
	self:GetGemCounts()
			CRH.CheckYield(coro_id) -- YIELD ???
	return movesFound
end

function BattleGround:InitMoveList()
	self.moveListIdx = 0
end

function BattleGround:GetAllMoves(coro_id)
	-- Find any matches on the local board
	local movesFound = false

	if self.allCanSwap and self.allCanMatch then

		-- Slightly more efficient version for use in main battle game
		for col=1,self.numMatchColumns do
			local startIdx = self.matchColumn[col]
			local size = self.matchColumnSize[col]
			for mgidx = startIdx, startIdx+size do

				local origType = self.board[mgidx]
				if origType and origType > 0 and self.canSwap[origType] then

					local up_right   = self.board[mgidx+8]
					local down_right = self.board[mgidx+9]
					local down       = self.board[mgidx+1]

					if (up_right and up_right > 0) then
						self:TestMoves(mgidx,mgidx+8)
					end
					if (down_right and down_right > 0) then
						self:TestMoves(mgidx,mgidx+9)
					end
					if (down and down > 0) then
						self:TestMoves(mgidx,mgidx+1)
					end
				end

			end
			CRH.CheckYield(coro_id) -- YIELD ???
		end

	else

		-- Slightly LESS efficient version for use in mini games
		-- Why cant we use the one above?
		-- This one needs to handle non-matchable gems
		for col=1,self.numMatchColumns do
			local startIdx = self.matchColumn[col]
			local size = self.matchColumnSize[col]
			--LOG(tostring(startIdx).." to "..tostring(startIdx+ size).." do")
			for mgidx = startIdx, startIdx+size do
				local origType = self.board[mgidx]
				if origType and self.canSwap[origType] then

					local up_right   = self.board[mgidx+8]
					local down_right = self.board[mgidx+9]
					local down       = self.board[mgidx+1]
					local g2g_up_right   = self.matchGrid2Grid[mgidx+8]
					local g2g_down_right = self.matchGrid2Grid[mgidx+9]
					local g2g_down       = self.matchGrid2Grid[mgidx+1]

					if (up_right and self.canSwap[up_right] and g2g_up_right and g2g_up_right>0) then
						--LOG("--"..mgidx..", +8 "..tostring(mgidx+8))
						self:TestMoves(mgidx,mgidx+8)
					end
					if (down_right and self.canSwap[down_right] and g2g_down_right and g2g_down_right>0) then
						--LOG("--"..mgidx..", +9 "..tostring(mgidx+8))
						self:TestMoves(mgidx,mgidx+9)
					end
					if (down and self.canSwap[down] and g2g_down and g2g_down>0) then
						--LOG("--"..mgidx..", +1 "..tostring(mgidx+8))
						self:TestMoves(mgidx,mgidx+1)
					end
				end

			end
			CRH.CheckYield(coro_id) -- YIELD ???
		end
	end

	if self.moveListIdx > 0 then
		LOG(string.format("BattleGround:GetAllMoves WE HAVE A MOVE!!!!!"))
		movesFound = true
	end
	return movesFound
end

function BattleGround:TestMoves(mgrid1,mgrid2)
	-- Swap
	local temp = self.board[mgrid1]
	self.board[mgrid1] = self.board[mgrid2]
	self.board[mgrid2] = temp

	local weight1 = self:TestMatches(mgrid1)
	local weight2 = self:TestMatches(mgrid2)
	--LOG(string.format("   BattleGround:TestMoves weights=%d,%d",weight1,weight2))

	if weight1 + weight2 > 0 then
		self.moveListIdx = self.moveListIdx + 1
		if not self.moveList[self.moveListIdx] then
			self.moveList[self.moveListIdx] = {}
		end
		self.moveList[self.moveListIdx].grid1 = self.matchGrid2Grid[mgrid1]
		self.moveList[self.moveListIdx].grid2 = self.matchGrid2Grid[mgrid2]
		self.moveList[self.moveListIdx].weight = weight1 + weight2 + math.random(0,self.randomWeighting)
		--LOG(string.format("   BattleGround:TestMoves added as %d",self.moveListIdx))
	end

 	-- Swap Back
	temp = self.board[mgrid1]
	self.board[mgrid1] = self.board[mgrid2]
	self.board[mgrid2] = temp
end

function BattleGround:TestMatches(theGrid)
	local weight = 0
	local myGrid
	local origType = self.board[theGrid]
	--LOG(string.format("   BattleGround:TestMatches grid=%d",theGrid))

	if origType == 0 then
		return 0
	end

	for dir=1,3 do
		local add = self.dir2add[dir]
		if origType == self.board[theGrid+add] or origType == self.board[theGrid-add] then
			local count = 1
			myGrid = theGrid-add
			while self.board[myGrid] == origType do
				count = count + 1
				myGrid = myGrid-add
			end
			myGrid = theGrid+add
			while self.board[myGrid] == origType do
				count = count + 1
				myGrid = myGrid+add
			end

			-- match-3+ ?
			if count >= 3 then
				--LOG(string.format("   BattleGround:TestMatches dir=%d count=%d",dir,count))
				local myWeight = self.weightList[self.gemType2Gem[origType]]
				if (not myWeight) then
					myWeight = 1
				end
				weight = weight+count*myWeight
				if count > 3 then
					local
					weight = weight + (count-3)*(count-3)*myWeight
					--if count > 4 then
					--	weight = weight + 500
					--end
				end
			end
		end
	end

	return weight
end

function BattleGround:SortAllMoves()
	self.bestMoveInList = 0
	local bestWeight = -1
	for i=1, self.moveListIdx do
		if self.moveList[i].weight > bestWeight then
			bestWeight = self.moveList[i].weight
			self.bestMoveInList = i
		end
	end
end

function BattleGround:GetGemCounts()
	for i=1,self.numGems do
		self.gemCounts[i] = 0
	end
end




-------------------------------------------------------------------------------
--
--		Initiates Ai Move
--		Selects gem1 + gem2, sets state to SWAPPING, then sends Update event
--
-------------------------------------------------------------------------------
function BattleGround:OnEventAIMove(event)

    if self.state == _G.STATE_IDLE then

		LOG("IDLE == OnEventAIMove")

	    --local enemyPrefs={["GDMG"]=5,["GSHD"]=2,["GINT"]=1,["GENG"]=3,["GWEA"]=4,["GPSI"]=1,["GCPU"]=2,}





	    --Randomly determine swap direction of AI move.
	    local swap1 = event:GetAttribute("swap1")
	    local swap2 = event:GetAttribute("swap2")


	    self:SelectGem(swap1)
	    self:SelectGem(swap2)
	    self:SetFallDir(self:GetGridDir(self.g1,self.g2))

		LOG(string.format("AI Swap gem1=%d, gem2=%d",self.g1,self.g2))
	    self:PlayerSwapGem(self.g1,self.g2)

	    self.state = STATE_SWAPPING

	    local e = GameEventManager:Construct("Update")
	    local nextTime = GetGameTime() + self:GetAttribute("movement_check")
	    GameEventManager:SendDelayed( e, self, nextTime )

    else
        --assert(false,"aimove state="..tostring(self.state))
    end

end


function BattleGround:SetNewGem(newGemType)

    self:ReleaseGem(self.newGem)
    self:SpawnGem(self.gemGrid,newGemType)


end





function BattleGround:SelectGem(i)
	LOG("SelectGem")
    self:HighlightGem(i)
    if not self.g1 then
        self.g1 = i
    else
        self.g2 = i
    end
end

function BattleGround:DeselectGem(i)
    self:UnHighlightGem(i)
    if self.g1 == i then
        self.g1 = nil
    elseif self.g2 == i then
        self.g2 = nil
    end
end

function BattleGround:UnHighlightGem(i)
    local gem = self:GetGem(i)
    if gem then
        local view = gem:GetView()
        view:StartAnimation("stand")

		gem:RemoveOverlay("Select")
    end
end

function BattleGround:MatchGem(i)
    local gem = self:GetGem(i)
    if gem then
        local view = gem:GetView()
        view:StartAnimation("match")
		--gem:SetAttribute("grid_id",i)
		gem.grid_id = i
		gem.matched = 1
    end
end


-------------------------------------------------------------------------------
--                 SPAWN  GEM
--			of type gemID(if present)
--                 for grid i
--
--				returns gem object
-------------------------------------------------------------------------------
function BattleGround:GetRandomGemCode()

	local index = math.random(self.gemListTotal)
	local newGem

	for gem, chance in pairs(self.gemList) do
		index = index - chance
		if index <= 0 then
			newGem = gem
			break
		end
	end

	if not newGem then
		error("Random gem selection failed")
	end

 	if newGem == "GUST" then
		 local player = self:GetCurrPlayer()
		player.biohazardSpawns = player.biohazardSpawns + 1
	end

    -- end temp testing
    -- Add to board representation
    return newGem
end



-------------------------------------------------------------------------------
--                 SPAWN  GEM
--			of type gemID(if present)
--                 for grid i
--
--				returns gem object
-------------------------------------------------------------------------------
function BattleGround:SpawnGem(i,gemID)

	local newGem = ""
	if gemID then
		newGem=gemID
	else
    	--Choose random Gem
    	newGem = self:GetRandomGemCode()
	end

	local player = self:GetCurrPlayer()
 	if newGem == "GUST" then
		player.biohazardSpawns = player.biohazardSpawns + 1
	end

 	--LOG(string.format("Construct Gem %s @ grid %d",newGem,i))

 	local gem = _G.LoadGem(newGem, self:AllocateGem());
	self.gem_count = self.gem_count + 1
    -- self:

 	--Get Grid Position for gridspace i
    gem:SetPos( self.hexPts[i][1],self.hexPts[i][2])
    self:SetGem(i, gem)

    -- add the ship to the world
    self:AddChild(gem)
    -- end temp testing
    -- Add to board representation
    return gem
end




-------------------------------------------------------------------------------
--                 SPAWN UNMATCHED GEM
--                 for grid i
--
--          Spawns a gem that doesn't match any gems around it.
--
-------------------------------------------------------------------------------
function BattleGround:SpawnUnmatchedGem(fillList,i)
	--LOG("SpawnUnmatchedGem at "..tostring(i))
	local gemList = {}
    local gemType = nil
	local shortList = {}

    --for each adjacent gem to gridspace i
    for d=1, HEX_SIDES do
        --checks within grid bounds
        if self.hexAdjacent[i][d] ~= -1 then
            --sets classId index to true.

            gemType = fillList[self.hexAdjacent[i][d]]
            local MatchList = GEMS[gemType].GemMatch--get list of all gems that can match with edge gem
            for gemID,gemType in pairs(MatchList) do
				--add the list of gem matches to overall gemlist
				--LOG("gemList "..tostring(gemType).." set to true.")
                gemList[gemType] = true
            end
        end

    end

	--Put valid baseGems into shortList
    for g,v in pairs(self.baseGems) do
    	if v > 0 and ( not gemList[g] or _G.GEMS[g].matchable==0) then
    		--LOG("Insert "..tostring(g).." into shortList")
    		table.insert(shortList,g)
    	end
    end
    local newGem = math.random(1,#shortList)
	--LOG("return newGem "..tostring(shortList[newGem]))



    -- end temp testing
    -- Add to board representation
    return shortList[newGem]
end


function BattleGround:WorldToGrid(x,y)
    -- NOTE:    game object positions are the position their origin is at
    --          the sprites are all 64x64
    return x,y
end



function BattleGround:GetGem(i)
	local gem = self.gems[i]
    return gem
end

function BattleGround:SetGem(i,gem)
    self.gems[i] = gem
end



function BattleGround:PlayerSwapGem(g1,g2)
	local curr_gem = self:GetGem(self.gp_grid)
	curr_gem:RemoveOverlay("gp_select")
	if SCREENS.GameMenu.stick_force and SCREENS.GameMenu.stick_force.x then
		SCREENS.GameMenu.stick_force.x = 0
		SCREENS.GameMenu.stick_force.y = 0
	end

	self:SwapGem(g1,g2)
end



function BattleGround:SwapGem(i1,i2)

    local g1 = self:GetGem(i1)
    local g2 = self:GetGem(i2)

    self:SetGem(i2, g1)
    self:SetGem(i1, g2)
    --g1 from
	local x1,y1,x2,y2

	if g1 then
    	x1 = g1:GetX()
    	y1 = g1:GetY()
	else
    	x1 = self.hexPts[i1][1]
    	y1 = self.hexPts[i1][2]
	end

	--g2 from
   if g2 then
	   x2 = g2:GetX()
	   y2 = g2:GetY()
   else
	   x2 = self.hexPts[i2][1]
	   y2 = self.hexPts[i2][2]
   end


    --g1 to
    --local x2 = self.hexPts[i2][1]
    --local y2 = self.hexPts[i2][2]
	if g1 then
    	self:SetGemMovement(g1,x1,y1,x2,y2)
	end
	if g2 then
    	self:SetGemMovement(g2,x2,y2,x1,y1)
	end


    --g2 to
    --x2 = self.hexPts[i1][1]
    --y2 = self.hexPts[i1][2]




end



function BattleGround:SetBlackHoleMovement(gem,x1,y1,x2,y2)
    if gem then
        local m = MovementManager:Construct("Linear")
        m:SetAttribute("Duration", self:GetAttribute("black_hole_duration"))    -- 200 world units (pixels) per second^2
        m:SetAttribute("StartX", x1)
        m:SetAttribute("StartY", y1)
        m:SetAttribute("EndX", x2)
        m:SetAttribute("EndY", y2)
        gem:SetMovementController(m)
    end
end



function BattleGround:GetEnemy(player)
	local playerID = player:GetAttribute("player_id")
	playerID = playerID + 1
	if playerID > self:NumAttributes('Players') then--Wrap Around
		playerID = 1
	end
	local enemy = self:GetAttributeAt('Players',playerID)
	return enemy
end





function BattleGround:InitHeroBattleStats(hero)

	--_G.LoadAndExecute("InitBattleground","InitBattleStats",false,  hero)

	_G.INIT_BATTLEGROUND = _G.LoadInit(_G.INIT_BATTLEGROUND,"InitBattleground")
	--local INIT_BATTLEGROUND = import("InitBattleground")
	_G.INIT_BATTLEGROUND.InitBattleStats(hero)
	--INIT_BATTLEGROUND = nil
	--purge_garbage()





end




-------------------------------------------------------------------------------
-- Decrements counter attribute -- resends GameTimer event
-------------------------------------------------------------------------------
function BattleGround:OnEventGameTimer(event)

	local counter = self:GetAttribute("counter")
	if not self.pause and self.state ~= _G.STATE_GAME_OVER and self.turn_count > 0 then
		counter = counter - 1
	end

	if counter < 0 then

		if self:GetAttribute("curr_turn") == self.my_player_id  then
			LOG("times up, send TimerRunOut event")
			local e = GameEventManager:Construct("TimerRunOut")
			e:SetAttribute("turn_count",self.turn_count)--bg.turncount to match this time out message
			GameEventManager:Send(e,self.my_id)
			self.timer_event = true
		end

		counter = 0
	end

	_G.GLOBAL_FUNCTIONS.UpdateTimer()


	self:SetAttribute("counter",counter)

	local curr_turn = self:GetAttribute("curr_turn")
	local other_side = 2
	if curr_turn == other_side then
		other_side = 1
	end

	local menu = _G.SCREENS.GameMenu
	menu:hide_widget(string.format("str_counter_%d", other_side))
	menu:activate_widget(string.format("str_counter_%d", curr_turn))
	menu:set_text_raw(string.format("str_counter_%d", curr_turn),tostring(counter))

	--send event again
	local nextTime = GetGameTime() + COUNTER_TICK
	GameEventManager:SendDelayed( event, self, nextTime )

end


function BattleGround:GetMusic()
	local music
	local boss
	if self:NumAttributes("Players") > 1 then
		local player2 = self:GetAttributeAt("Players", 2)
		local idStr = player2.classIDStr
		if idStr ~= "Hero" and HEROES[player2.classIDStr].boss then
			boss = true
		end
		local enemyTrack = _G.SHIPS[player2:GetAttribute("curr_ship").classIDStr].sound
		LOG("enemyTrack "..tostring(enemyTrack))
		if self.turn_count <= 1 and enemyTrack then
			LOG("play enemy track")
			return enemyTrack
		end
	end

	if self.aboutToWin then
		music = "music_about_to_win"
	elseif self.aboutToLose then
		music = "music_about_to_lose"
	elseif (not self.mp) and boss then
		if self.music_selection == 1 then
			self.music_selection = 3
		else
			self.music_selection = 1
		end
		local music_num = self:MPRandom(1,#self.music[self.music_selection])
		return self.music[self.music_selection][music_num]
	else
		local music_num = self:MPRandom(1,#self.music[self.music_selection])
		music = self.music[self.music_selection][music_num]

		if self.music_selection == 1 then
			self.music_selection = 2
		else
			self.music_selection = 1
		end
	end
	LOG("Set Music "..music)
	return music
end



function BattleGround:DoNotDestroy(posIdx)
 	for k,v in pairs(self.doNotDestroy) do
 		--LOG(string.format("BattleGround:SwitchGems check doNotDestroy list %d",v))
		if v == posIdx then
			return true
		end
	end
	return false
end

--Gets Event to send back to source object containing battle result
function BattleGround:GetReturnEvent(event)

	return event
end


function BattleGround:AdjustFactions(statHero, loser)
	self.HBG_StartEndState = import "HexBattlegroundEndState"
	return self.HBG_StartEndState.AdjustFactions(self, statHero, loser)
end




function BattleGround:AwardCargo(winner)
	self.HBG_StartEndState = import "HexBattlegroundEndState"
	return self.HBG_StartEndState.AwardCargo(self, winner)
end



function BattleGround:AwardPlans(winner)
	self.HBG_StartEndState = import "HexBattlegroundEndState"
	return self.HBG_StartEndState.AwardPlans(self, winner)
end

-------------------------------------------------------------------------------
-- Destroys all game objects, calls menu endGame function
-------------------------------------------------------------------------------
function BattleGround:OnEventGameEnd(event)

	self.HBG_StartEndState = import "HexBattlegroundEndState"
	self.HBG_StartEndState.OnEventGameEnd(self, event)

	--No longer any need to nil this
	--self.HBG_StartEndState = nil
	--purge_garbage()
end

function BattleGround:OnEventGameStart(event)

	--SP.SP_Start(2,"BattleGround:OnEventGameStart Entry")
	_G.INIT_BATTLEGROUND = _G.LoadInit(_G.INIT_BATTLEGROUND,"InitBattleground")
	_G.INIT_BATTLEGROUND.OnEventGameStart(self,event)
end


function BattleGround:OnEventStartMPBattle(event)
	LOG("OnEventStartMPBattle")
end


function BattleGround:SwitchGems(grid, gemID, disableMatch)
	LOG(string.format("Switching Gems: %d   %s   %s", grid,gemID,tostring(disableMatch)))
	local e = GameEventManager:Construct("SwitchGems")
	e:SetAttribute("force_update", 0)
	e:SetAttribute("new_gem_id", gemID)
	e:PushAttribute("grid_id", grid)
	GameEventManager:Send(e, self)
	if not disableMatch then
		--LOG(string.format("BattleGround:SwitchGems do not destroy %d",grid))
		table.insert(self.doNotDestroy, grid)
		-- SCF... Why would we want to disable matches??? Just curious. We'll need to find another way to do this now...
		--self.matches[grid] = {}
	end
end


function BattleGround:OnEventHintArrow(event)
	LOG("OnEventHintArrow")
	local hintTurn = event:GetAttribute("turn")

	if self.turn_count == hintTurn and self.state == _G.STATE_IDLE then
		if self.g1 then

			local delay = self.hint_delay * 1000

			GameEventManager:SendDelayed(event, self, GetGameTime()+ delay)-- self.hint_delay*1000)
			return
		end
		self:ClearHintArrow()

		--if no best move - no hint
		if self.bestMoveInList == 0 then
			return
		end
		local hintGrid = self.moveList[self.bestMoveInList].grid1
		local hintGem = self:GetGem(hintGrid)

		if not hintGem then
			return
		end

		local FX = self.FX
		local container = FX.CreateContainer(600, 0)

		local hint_image = "img_hint"
		if self.ui == "RumorUI" then
			hint_image = "img_hint_rumor"
		end
		local elem1     = FX.AddImage(container,hint_image, 0,0,0.0,0.0, 0.0,1.0, true)

		--FX.AddKey(container,elem1,0,FX.KEY_XY,    0,0, FX.DISCRETE)
		--FX.AddKey(container,elem1,600,FX.KEY_XY,    -96,-96, FX.LINEAR)
		FX.AddKey(container,elem1, 0, FX.KEY_SCALE, 0.5,  FX.DISCRETE)
		FX.AddKey(container,elem1, 600,FX.KEY_SCALE, 2.0,  FX.LINEAR)
		FX.AddKey(container,elem1, 0,FX.KEY_ALPHA, 1.0,  FX.DISCRETE)
		FX.AddKey(container,elem1, 600,FX.KEY_ALPHA, 0.0,  FX.LINEAR)


		local elem2     = FX.AddImage(container,hint_image, 0,0,0.0,0.0, 0.0,1.0, true)

		--FX.AddKey(container,elem2,0,FX.KEY_XY,    0,0, FX.DISCRETE)
		--FX.AddKey(container,elem2,100,FX.KEY_XY,    0,0, FX.LINEAR)
		--FX.AddKey(container,elem2,600,FX.KEY_XY,    -96,-96, FX.LINEAR)
		FX.AddKey(container,elem2, 0, FX.KEY_SCALE, 0.5,  FX.DISCRETE)
		FX.AddKey(container,elem2, 100, FX.KEY_SCALE, 0.5,  FX.LINEAR)
		FX.AddKey(container,elem2, 600,FX.KEY_SCALE, 2.0,  FX.LINEAR)
		FX.AddKey(container,elem2, 0,FX.KEY_ALPHA, 1.0,  FX.DISCRETE)
		FX.AddKey(container,elem2, 600,FX.KEY_ALPHA, 0.0,  FX.SMOOTH)


		--FX.AddSound(container,250,"snd_nova")
		FX.Start(self, container, hintGem:GetX(),hintGem:GetY())

		--event = GameEventManager:Construct("HintArrow")
		--event:SetAttribute("turn",self.turn_count)
		local delay = self.hint_delay * 1000
		LOG("delay = "..tostring(delay))
		GameEventManager:SendDelayed(event, self, GetGameTime()+ delay)-- self.hint_delay*1000)
	end

end

function BattleGround:DestroyGem(posIdx, forceParticles)
	--LOG(string.format("DestroyGem %d",posIdx))

	local gem = self.gems[posIdx]


	if not gem then
		return
	end
	gem.grid_id = posIdx
	gem:SetView(nil)
	GameObjectManager:Destroy(gem)
	gem = nil
	--self:ReleaseGem(gem)

	self.gem_count = self.gem_count - 1
	self.gems[posIdx] = nil--set this grid position to be empty
end

-- forces there to be a specific number of a specified gem type on the board
--adapted to use min and max values -- if no max is entered - will use same as min
function BattleGround:SetNumGems(fillList, gemType, targetMin,targetMax)
	if not targetMax then
		targetMax = targetMin
	end
	local numGems = 0
	local gemPos = { }
	local uncheckedGems = { }
	for i=1,HEX_GRIDS do
		table.insert(uncheckedGems, i)
	end

	local function count_gems()
		numGems = 0
		for i=1,HEX_GRIDS do
			if fillList[i] == gemType then
				numGems = numGems + 1
				gemPos[numGems] = i
			end
		end
	end

	count_gems()

	-- add gems as necessary, checking to prevent matches being added.
	while numGems < targetMin do
		local setGem = true
		local tpos = math.random(1,#uncheckedGems) -- table position
		local npos = uncheckedGems[tpos]           -- grid position
		table.remove(uncheckedGems, tpos)
		for d=1,HEX_SIDES do
			local adj = self.hexAdjacent[npos][d]
			if adj ~= -1 and fillList[adj] == gemType then
				-- run additional checking
				local newAdj = self.hexAdjacent[adj][d]
				if newAdj ~= -1 and fillList[newAdj] == gemType then
					setGem = false
					break
				else
					newAdj = self.hexAdjacent[npos][self.inverseDir[d]]
					if newAdj ~= -1 and fillList[newAdj] == gemType then
						setGem = false
						break
					end
				end
			end
		end

		if setGem then
			fillList[npos] = gemType
		end
		count_gems()
	end

	-- remove gems as necessary. new matches must not be created
	while numGems > targetMax do
		LOG("NumGems Exceeds Max !!! => " .. tostring(numGems))
		local tpos = math.random(1,#gemPos)
		local gem = gemPos[tpos]
		local gem_types = { }

		table.remove(gemPos, tpos)

		local illegal_gems = { }
		for d=1,HEX_SIDES do
			LOG("Processing illegal gems")
			local adj = self.hexAdjacent[gem][d]
			if fillList[adj] == fillList[self.hexAdjacent[adj][d]] then
				-- prevent change to gem type filList[adj]
				table.insert(illegal_gems, fillList[adj])
			elseif fillList[adj] == fillList[self.hexAdjacent[gem][self.inverseDir[d]]] then
				-- prevent change to gem type filList[adj]
				table.insert(illegal_gems, fillList[adj])
			end
		end

		for i,v in pairs(self.baseGems) do
		LOG("Getting base gems")
			if i ~= gemType and v ~= 0 then
				local save_gem = true
				for j,k in pairs(illegal_gems) do
					if k == i then
						save_gem = false
					end
				end
				if save_gem then
					table.insert(gem_types, i)
				end
			end
		end

		if #gem_types > 1 then
			fillList[gem] = gem_types[math.random(1, #gem_types)]
		elseif #gem_types == 1 then
			fillList[gem] = gem_types[1]
		end
		LOG(string.format("grid %d, set to %s",gem,fillList[gem]))
		count_gems()
	end
end

-- SCF: Removed it - was only using it on the DS, but not any longer
--[[
function BattleGround:MoveGems()

	LOG("Before "..#self.movingGems)
	local moveGemX = self.gemMovements[self.moveDir][1]
	local moveGemY = self.gemMovements[self.moveDir][2]

	local remove = {}
	for i,v in pairs(self.movingGems) do

		local gem = self:GetGem(i)
		local destX = v[1]
		local destY = v[2]
		if gem then
			local currX = gem:GetX()+ moveGemX
			local currY = gem:GetY()+ moveGemY
			gem:SetPos(currX,currY)
			LOG(string.format("CHECK ABS X %d<%d",math.abs(destX - currX),math.abs(moveGemX)))
			LOG(string.format("CHECK ABS Y %d<%d",math.abs(destY - currY),math.abs(moveGemY)))
			if math.abs(destX - currX)<= math.abs(moveGemX) and math.abs(destY - currY)<= math.abs(moveGemY) then
				LOG(string.format("ABS Break %d",i))
				gem:SetPos(destX,destY)
				table.insert(remove,i)
			end
		end

	end

	for i,v in pairs(remove) do
		LOG(string.format("Remove %d",v))
		self.movingGems[v] = nil
	end



end
--]]


function _G.Blog(txt)
	LOG(string.format("%s  - %s %s",tostring(_G.SCREENS.GameMenu.world.my_player_id),tostring(txt),tostring(_G.SCREENS.GameMenu.world.turn_count)))
end


function BattleGround:DebugChangeGem()
		self.user_input_dest = self
		_G.BigMessage(self,"[SELECT_GEM]",512,200)
		self.cheat = true
end



function BattleGround:InitCoords()

	_G.INIT_BATTLEGROUND = _G.LoadInit(_G.INIT_BATTLEGROUND,"InitBattleground")
	_G.INIT_BATTLEGROUND.InitCoords(self)

end


function BattleGround:InitBattle()

	_G.INIT_BATTLEGROUND = _G.LoadInit(_G.INIT_BATTLEGROUND,"InitBattleground")
	_G.INIT_BATTLEGROUND.InitBattle(self)

end

function BattleGround:OnEventCursorEntered(event)

	--BEGIN_STRIP_DS
	local function highlight()
		local object = event:GetAttribute("object")

		if self.lastSelected then
			self.lastSelected:BeUnSelected()
		end

		if object:HasAttribute("isGem") then
			self.lastSelected = object
			object:BeSelected()
		end
	end

	WiiOnly(highlight)
	--END_STRIP_DS
end


function BattleGround:BGUserToPlayer(user)
	if self.mp then
		if UserToPlayer(user)==1 then
			return _G.Hero:GetAttribute("player_id")
		else
			return 0
		end
	else
		return UserToPlayer(user)
	end
end



--itemIndex1/2 - optional - specifies index to draw beam from/to item Coords
function BattleGround:DrainEffect(sourceEffect,sourcePlayer,destEffect,destPlayer,itemIndex1,itemIndex2)
	--BEGIN_STRIP_DS
   local function processBeams()
   	if _G.BEAMS_ON then
   		local beam = self.beamEffects[destEffect] or "BM02"

		if destPlayer == 3 then--battleground
			destEffect = "Effect" -- gives coords for effect circle above board.
		end

		local startx,starty,endx,endy
   		if itemIndex1 then
			startx,starty = self:WorldToScreen(self.coords[sourcePlayer]["item"][itemIndex1][1],768-self.coords[sourcePlayer]["item"][itemIndex1][2])
   		else
   			startx,starty = self:WorldToScreen(self.coords[sourcePlayer][sourceEffect][1],self.coords[sourcePlayer][sourceEffect][2])
		end
		if itemIndex2 then
			endx, endy = self:WorldToScreen(self.coords[destPlayer]["item"][itemIndex2][1],self.coords[destPlayer]["item"][itemIndex2][2])
   		else
   			endx, endy = self:WorldToScreen(self.coords[destPlayer][destEffect][1],self.coords[destPlayer][destEffect][2])
   		end
		--LOG(string.format("DrainEffect %s %s %s",beam,sourceEffect,destEffect))
   		_G.BEAMS[beam]:CreateBeam(self,startx,starty,endx,endy)
   	end
   end

   _G.NotDS(processBeams)
	--END_STRIP_DS
end


--BEGIN_STRIP_DS
function BattleGround:OnEventEndSpecialEffect(event)
	LOG("OnEventEndSpecialEffect")
	local id = event:GetAttribute("effect_num")
	self.messageList[id] = nil

end
--END_STRIP_DS





dofile("Assets/Scripts/BattleGrounds/BattleGroundPlatform.lua")


return ExportClass("BattleGround")
