-- current hacking
-- B002
--  Hacking Mini Game  -- make X moves of a type where each gem type to match is pre-specified



use_safeglobals()

-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")

class "B002" (BattleGround)

function B002:__init()
   super("B002")

	self.ui = "HackingUI"
	self.xml = "Assets\\Screens\\HackGameMenu.xml"
	-- Standard Battle Gems List
	self.baseGems={["GTIM"]=2,["GSHB"]=5,["GWEB"]=5,["GCPB"]=5,["GENB"]=5,["GPSB"]=5,["GINB"]=5}
   self:InitGemList()
   self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}

   self.matchEvent = "HackAward"--MineAward for Mine mini game

	self.sequence = { }
	self.time_bonus = 10--bonus for matching time gems

	self.music = {[1]={"music_hack"};
					  [2]={"music_hack"}}--no alt track in key-matching game

  	-- Turn on gem pooling for hacking game
--	local INIT_BATTLEGROUND = import("InitBattleground")
--	INIT_BATTLEGROUND.InitGemPool(self)
--	INIT_BATTLEGROUND = nil
--	purge_garbage()
end

-- Copy our attributes from BattleGround
B002.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B002.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=0})
B002.AttributeDescriptions:AddAttribute('int', 'ui_tick', {default=950})
--B002.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
--B002.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[HACK_VICTORY]"})
--B002.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
--B002.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[HACK_DEFEAT]"})
B002.AttributeDescriptions:AddAttribute('string', 'quit_msg', {default="[QUITPUZZLE]"})

function B002:NewGame()
	LOG("B002 NewGame")
	self.sequence = self:GenerateSequence()
	-- force a UI update (DS does not automatically update regularly)
	_G.SCREENS.GameMenu.update_sequence = true
	--SCREENS.GameMenu:UpdateHackingUI()
	self:ShowNextGem(string.format("img_%s_gem", GEMS[self.sequence[1]].color))
	LOG("Sequence 1 = " .. tostring(self.sequence[1]))
	--SCREENS.GameMenu:set_image("next_gem", string.format("img_%s_gem", GEMS[self.sequence[1]].color))
	--SCREENS.GameMenu:StartAnimation("ShowNextGem")
	PlaySound("snd_hackbegin")

	local tutorial_opened = _G.ShowTutorialFirstTime(8,_G.Hero)
	if tutorial_opened then
		self.pause = true--Pause Timer during Tutorial
	end
end

-- Generates a sequence of gems for the player to match
function B002:GenerateSequence()
	LOG("GenerateSequence")
	local sequence = { }
	local gemList = { }
	for i,v in pairs(self.baseGems) do
		if i ~= "GTIM" then
			LOG("insert "..i)
			table.insert(gemList, i)
		end
	end
	local lastGem, randVal
	randVal = math.random(1, #gemList)
	for i=1,_G.Hero:GetAttribute("seq_length") do
		while lastGem == gemList[randVal] do
			LOG("get new randVal "..tostring(randVal))
			randVal = math.random(1, #gemList)
		end
		lastGem = gemList[randVal]
		table.insert(sequence, lastGem)
	end
	for i,v in pairs(sequence) do
		LOG(tostring(v))
	end

	return sequence
end

function B002:HandleMatches()
	LOG("B002 HandleMatches()")
	local firstMatch = true
	local myContainer = nil
	local theX, theY

	local found = false
	if not self.sequence[_G.Hero:GetAttribute("seq_pos")] then
		return
	end

	local hackID = _G.GEMS[self.sequence[_G.Hero:GetAttribute("seq_pos")]].id

	for i=1, self.matchListIdx do
		local matchIdx = self.matchList[i].matchIdx
		local add = self.dir2add[self.matchList[i].dir]
		for n=1,self.matchList[i].num do
			local thisIdx = self.matchGrid2Grid[matchIdx]
			local gem = self:GetGem(thisIdx)
			local id = gem.id


			if firstMatch then
				firstMatch = false
				myContainer = self:InitDSParticles()

				theX = gem:GetX()
				theY = gem:GetY()
			end
			local myX = gem:GetX()-theX
			local myY = gem:GetY()-theY


			self:AddDSParticle(gem.id,myContainer,myX,myY)

			if id == hackID then
				LOG("Match - show beam")
				PlaySound("snd_gemkey")
				found = true
				gem:SetAttribute("effect","hack")
				--gem:SetAttribute("beam","BM02")
				--break
			end

			matchIdx = matchIdx + add

		end


	end

	_G.GLOBAL_FUNCTIONS["UpdateHackingUI"]()

	if found then
		_G.Hero:SetAttribute("seq_pos", _G.Hero:GetAttribute("seq_pos") + 1)
		if not self.sequence[_G.Hero:GetAttribute("seq_pos")] then
			SCREENS.GameMenu:StartAnimation("SlideGems")
			return
		end
		self:ShowNextGem(string.format("img_%s_gem", GEMS[self.sequence[_G.Hero:GetAttribute("seq_pos")]].color))
		SCREENS.GameMenu:StartAnimation("SlideGems")
	end


	if myContainer then
		self:StartDSParticles(myContainer,theX,theY)
		fxc_start(self, myContainer, theX, theY)
	end


end



function B002:ShowNextGem(icon)
	LOG("ShowNextGem("..icon..")")
	local FX = self.FX
	local container = FX.CreateContainer(1200, 0)
	local elem1     = FX.AddImage(container,icon, 0,0,0.0,0.0, 0.0,1.0, true)
	--local elem2     = FX.AddText(container,"font_small_event","X2 MULTIPLIER", 0,-50, 0.0,0.0, 0.0,1.0, true)

	--FX.AddKey(container,elem1,0,FX.KEY_XY,    0,0, FX.DISCRETE)
	--FX.AddKey(container,elem1,600,FX.KEY_XY,    -100,-88, FX.LINEAR)
	FX.AddKey(container,elem1, 500,FX.KEY_ALPHA, 0.0,  FX.LINEAR)
	FX.AddKey(container,elem1, 500, FX.KEY_SCALE, 0.0,  FX.DISCRETE)--adds slight delay before animation starts

	FX.AddKey(container,elem1, 501, FX.KEY_SCALE, 0.5,  FX.DISCRETE)
	FX.AddKey(container,elem1, 1100,FX.KEY_SCALE, 4.0,  FX.LINEAR)
	FX.AddKey(container,elem1, 501,FX.KEY_ALPHA, 1.0,  FX.DISCRETE)
	FX.AddKey(container,elem1, 1200,FX.KEY_ALPHA, 0.0,  FX.SMOOTH)


	--FX.AddSound(container,250,"snd_nova")
	FX.Start(self, container, self.text_extra_x,self.text_extra_y)
end


--No extra turns in this minigame
function B002:AwardExtraTurn()


end



function B002:OnEventBlackHole(event)
	LOG("OnEventBlackHole")

	collectgarbage()

	_G.BigMessage(self,"[BLACKHOLE]",endX,endY)

	PlaySound("snd_blackhole")

	self.state= STATE_GAME_OVER


	self.locked = true

	self:HandleEndGame(0)


end


function B002:GetEnemy(player)
	LOG("get nil enemy")
	return nil
end



function B002:CheckEndGame()
	local player = self:GetCurrPlayer()
	local seq_pos = player:GetAttribute("seq_pos")
	local seq_length = player:GetAttribute("seq_length")

	if seq_pos > seq_length then
		--PlaySound("music_victory")
		PlaySound("snd_hacksuccess")
		return player:GetAttribute("player_id")
	end

	if self.TimeExpired and self:GetAttribute("counter")<=0 then
		local msg = "[OUTOFTIME]"
		_G.BigMessage(self,msg,self.text_message_x,self.text_message_y)
		return 0
	end
	return false
end


function B002:OnEventGameTimer(event)

	local COUNTER_TICK = 1000 -- this happens to be declared in HexBattleGround.lua at the root level as a local

	local counter = self:GetAttribute("counter")
	if not self.pause and self.state ~= _G.STATE_GAME_OVER then
		counter = counter - 1
	end

	if counter < 0 then
		if not self.TimeExpired then
			local winner = self:CheckEndGame()
			if winner == 1 then--game won
				self:HandleEndGame(winner)
			else
				self.TimeExpired = self.turn_count
				--If cascade not already in motion, show message, end Game - else rely on EndTurn checkEndGame to end game.
				if self.state < _G.STATE_SWAPPING or self.state == _G.STATE_FINDING_MOVE then
					local msg = "[OUTOFTIME]"
					_G.BigMessage(self,msg,self.text_message_x,self.text_message_y)
					self:HandleEndGame(0)
				end
			end
		end

		counter = 0
	end

	_G.GLOBAL_FUNCTIONS.UpdateTimer()

	self:SetAttribute("counter",counter)
	--send event again
	local nextTime = GetGameTime() + COUNTER_TICK
	GameEventManager:SendDelayed( event, self, nextTime )

end




function B002:Nova()
	--self:AwardExtraTime(20)
	--Displays Extra Turn message
    --local msgView = GameObjectManager:Construct('GMSG')
    --self:AddChild(msgView)
    --_G.BigMessage(self,"[NOVA]")
end


function B002:SupaNova(event)

	--self:AwardExtraTime(20)
	--Displays Extra Turn message
    --local msgView = GameObjectManager:Construct('GMSG')
   -- self:AddChild(msgView)
    --_G.BigMessage(self,"[SUPANOVA]")

end
--[[ ENABLED AGAIN LATER
function B002:GetPlayerPrefList(player)
       local prefList = {}
       prefList["other"]=1
       for i,v in pairs(self.baseGems) do
               if GEMS[i].matchable==1 then
                       prefList[GEMS[i].effect]=1
                       if _G.GEMS[i].id == _G.GEMS[self.sequence[_G.Hero:GetAttribute("seq_pos")] ].id then
                               LOG("Set "..GEMS[i].effect.." to 5")
                               prefList[GEMS[i].effect]=5
                       end
               end
       end
       prefList["time"]=5
       return prefList

end
]]

function B002:OnEventAIMove()

end


function B002:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndHackGate")
	e:SetAttribute('result',event:GetAttribute("result"))
	e:SetAttribute('gate',Hero:GetAttribute("curr_loc"))
	LOG("return End Hack Gate Event")
	return e

end

function B002:OpenCombatResults(victory,callback, statHero, factionChange, planList, cargoList)
	statHero:SetAttribute("timer", self:GetAttribute("counter"))
	--SCREENS.CombatResultsMenu:Open(victory, callback, statHero, factionChange, planList, cargoList)
end

-- do nothing when an illegal move is made
function B002:InvalidMove()
	PlaySound("snd_illegal")
end

function B002:OnEventVictoryMenu(event)
	PlaySound("music_victory")
	close_message_menu()
	local winner = event:GetAttribute("winner_id")
	self.state = STATE_GAME_OVER
	local function EndCallback()
		--UnloadAssetGroup("AssetsButtons")
		SCREENS.GameMenu:HideHackingWidgets()
		local e = GameEventManager:Construct("GameEnd")
		e:SetAttribute('result',winner)
		local nextTime = GetGameTime() + self:GetAttribute("game_end_delay")
		GameEventManager:SendDelayed( e, self, nextTime )
		local function transition()
			--GameEventManager:SendDelayed( e, self, nextTime )
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", nil)
	end
	LoadAssetGroup("AssetsButtons")

	-- Hacking Reward (Mod) --

	local reputation = _G.Hero:GetFactionStanding(_G.STARS.AllStars[_G.Hero:GetAttribute("curr_system")].faction)
	LOG(reputation)
	local reward = 20 -- Initialized at 20 for testing purposes
	local location = _G.Hero:GetAttribute("curr_loc")
	LOG(location)
	local keys = _G.GATES[location].keys
	LOG(keys)
	local time = _G.GATES[location].time
	LOG(time)

	if (time / keys) < 5 then -- Hard Gates
		reward = 350
	elseif (time / keys) < 7 then -- Medium Gates
		reward = 250
	elseif (time / keys) > 7 then -- Easy Gates
		reward = 150
	else -- Just Checking
		reward = 4
	end


	if reputation == 1 then -- Criminal
		reward = reward * 0
	elseif reputation == 2 then -- Suspect
		reward = reward * 0.5
	elseif reputation == 3 then -- Neutral
		reward = reward * 1
	elseif reputation == 4 then -- Friendly
		reward = reward * 1.5
	elseif reputation == 5 then -- Ally
		reward = reward * 2
	else
		reward = 11 -- Just checking
	end

	_G.Hero:OnEventGiveGold(nil,reward)



	local Rmsg = string.format("You have successfully hacked the LeapGate.  You have been rewarded %d credits.", reward)

	open_message_menu("[HACK_SUCCESS]", Rmsg, EndCallback)
end

function B002:OnEventLossMenu(event)
	PlaySound("snd_hackfail")
	PlaySound("music_defeat")

	local winner = event:GetAttribute("winner_id")
	self.state = STATE_GAME_OVER
	local function RestartCallback(confirmed)
		--UnloadAssetGroup("AssetsButtons")
		if confirmed then
			local function wait()
				Sound.StopMusic();
				self:RestartBattle()
			end
			SCREENS.CustomLoadingMenu:Open(nil, wait, nil, nil, nil, 500)
		else--No quits game
			SCREENS.GameMenu:HideHackingWidgets()
			local e = GameEventManager:Construct("GameEnd")
			e:SetAttribute('result',winner)
			local nextTime = GetGameTime() + self:GetAttribute("game_end_delay")

			GameEventManager:SendDelayed( e, self, nextTime )
			local function transition()
				--GameEventManager:SendDelayed( e, self, nextTime )
			end
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", nil)
		end
	end

	LoadAssetGroup("AssetsButtons")
	--open_yesno_menu(self:GetAttribute("defeat"),self:GetAttribute("defeat_msg"), RestartCallback, "[NO]" , "[YES]")
	open_yesno_menu("[DEFEAT]", "[HACK_DEFEAT]", RestartCallback,  "[YES]", "[NO]" )
end

return ExportClass("B002")
