-- Rumor minigame (avoid matching certain types for as long as possible!)
-- B011

import "safeglobals"

local BattleGround = import("BattleGrounds/HexBattleGround")

class "B011" (BattleGround)


local HEX_GRIDS =55 -- Matches value in InitBattleground.lua

function B011:__init()
	super("B011")

	self.ui = "RumorUI"
	self.xml = "Assets\\Screens\\RumorGameMenu.xml"

	_G.Hero.biohazardSpawns = 0
	_G.Hero.biohazardMatches = 0

	-- Get specialised gems for this game
	self.baseGems={["GRG1"]=5, ["GRG2"]=5, ["GRG3"]=5, ["GRG4"]=5, ["GRG5"]=5, ["GVRS"]=1}
	self:InitGemList()

	self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}


	self.matchEvent="RumorAward"

	self.music = {[1]={"music_hack"};
					  [2]={"music_hack"}}

	self.lastSwap = {}
	self.gameLost = false  -- set to true when ForceGameLoss is called (when a match of biohazards is detected
end

B011.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B011.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=0})
B011.AttributeDescriptions:AddAttribute('string', 'quit_msg', {default="[QUITPUZZLE]"})
--B011.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
--B011.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[CRAFT_VICTORY]"})
--B011.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
--B011.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[CRAFT_DEFEAT]"})

-- extra turns are never awarded (no opponent)
function B011:AwardExtraTurn()
end

function B011:NewGame()
	LOG("NewGame()")
	_G.Hero.biohazardSpawns = 0
	_G.Hero.biohazardMatches = 0
	_G.Hero:SetAttribute("components_weap", 0)
	_G.Hero:SetAttribute("components_cpu", 0)
	_G.Hero:SetAttribute("components_eng", 0)
	--self.cost = RUMORS[self.rumorID].cost

	SCREENS.GameMenu:StartAnimation("StartGame")



	_G.ShowTutorialFirstTime(23,_G.Hero)

	--self.baseGems["GVRS"]=(7-(self.cost/10))
	--self:InitGemList()
	self.gameLost = false
	self.turns_remaining = self.cost

end

function B011:ForceGameLoss()
	LOG("Rumor game has been lost")
	self.gameLost = true
end

function B011:SetRumorInfo(player, rumor, cost, reward)
   	self.rumorID = rumor
	self.cost = cost
	self.reward = reward
	self.turns_remaining = self.cost

	if self.reward == 25 then
		self.reward = 15
	elseif self.reward == 50 then
		self.reward = 30
	elseif self.reward == 100 then
		self.reward = 60
	elseif self.reward == 250 then
		self.reward = 100
	elseif self.reward == 500 then
		self.reward = 180
	elseif self.reward == 1000 then
		self.reward = 200
	end


	--self.baseGems={["GRG1"]=6, ["GRG2"]=6, ["GRG3"]=6, ["GRG4"]=6, ["GRG5"]=6, ["GVRS"]=(7-(cost/10))}
	--self:InitGemList()
end


function B011:OnEventBlackHole(event)
	_G.BigMessage(self,"[FAILED_RUMORS]")

	self.state = STATE_GAME_OVER
	self.locked = true

	self:HandleEndGame(0)
end

function B011:CheckEndGame()
	if self.gameLost then
		PlaySound("snd_rumorfail")
		SCREENS.GameMenu:StartAnimation("LostGame")
		return 0
	elseif self.turns_remaining <= 0 then
		PlaySound("snd_rumorsuccess")
		return 1
		--[[
	elseif self.turn_count >= self.cost then
		PlaySound("snd_rumorsuccess")
		return 1
		--]]
	end

	return false
end

-- AI does not move (or exist) in crafting game
function B011:OnEventAIMove()
end

-- Enemy does not exist
function B011:GetEnemy(player)
	LOG("Get nil enemy")
	return nil
end

function B011:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndRumor")
	e:SetAttribute("result", event:GetAttribute("result"))
	e:SetAttribute("rumor", self.rumorID)
    e:SetAttribute("reward", self.reward)
	LOG("Return EndRumor event")
	return e
end

function B011:OnEventVictoryMenu(event)
	local winner = event:GetAttribute("winner_id")
	PlaySound("music_victory")

	self.state = STATE_GAME_OVER

	local function VictoryCallback()
		UnloadAssetGroup("AssetsButtons")
		local e = GameEventManager:Construct("GameEnd")
		e:SetAttribute('result',winner)
		local nextTime = GetGameTime() + (self:GetAttribute("game_end_delay"))
		GameEventManager:SendDelayed(e, self, nextTime )
	end

	LoadAssetGroup("AssetsButtons")
	SCREENS.RumorResultsMenu:Open(true, VictoryCallback, self.rumorID, self.reward)
end

function B011:OnEventLossMenu()
	LOG("Construct EndBattle")
	PlaySound("music_defeat")
	local function RestartCallback(confirmed)
		UnloadAssetGroup("AssetsButtons")
		if confirmed then
			Sound.StopMusic();
			self:RestartBattle()
		else
			local e = GameEventManager:Construct("GameEnd")
			e:SetAttribute('result',0)
			local nextTime = GetGameTime() + self:GetAttribute("game_end_delay")
			GameEventManager:SendDelayed(e, self, nextTime)
		end
	end

	LoadAssetGroup("AssetsButtons")
	SCREENS.RumorResultsMenu:Open(false, RestartCallback, self.rumorID, self.reward)
end


function B011:Nova(event)
end

function B011:SupaNova(event)
end


-------------------------------------------------------------------------------
--
--                      ValidMove() returns boolean.
--
-------------------------------------------------------------------------------
function B011:ValidMove()
	LOG(string.format("ValidMove start %d",GetGameTime()))
    local valid = false
	for i=1,self.moveListIdx do
		if self.moveList[i].grid1 == self.g1 and self.moveList[i].grid2 == self.g2 then
			valid = true
		elseif self.moveList[i].grid1 == self.g2 and self.moveList[i].grid2 == self.g1 then
			valid =  true
		end
	end
	if valid then
		--increment counter
		self.turns_remaining = self.turns_remaining - 1
	end

    return valid
end


--[[
function B011:HandleMatches()
	SCREENS.GameMenu:StartAnimation("MadeMove")
end
--]]

-- adjust the turn count down to prevent this move being counted
function B011:InvalidMove()
	PlaySound("snd_illegal")
	--self.turn_count = self.turn_count - 1
end

function B011:ProcessEndTurn()
	--if math.mod(self.turn_count, 3) == 0 and self.turn_count ~= 0 then
	if math.mod(self.turns_remaining, 3) == 0 and self.turns_remaining ~= self.cost then
		_G.BigMessage(self, substitute(translate_text("[TURNS_REMAINING]"), self.turns_remaining))
	end
end

-- This is the chance to remove any nuke gems that we don't want'
function B011:PostProcessFillList(fillList)
	-- Force only a specified number of virus gems from the number of turns we need to make (or self.cost)
	self:SetNumGems(fillList, "GVRS", math.floor( 1 + (35-self.cost)/5 ))
end

return ExportClass("B011")
