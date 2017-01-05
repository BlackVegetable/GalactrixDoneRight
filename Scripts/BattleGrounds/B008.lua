-- Haggling minigame (remove as many gems as possible)
-- B008

import "safeglobals"

local BattleGround = import("BattleGrounds/HexBattleGround")

class "B008" (BattleGround)


function B008:__init()
	super("B008")
	
	self.ui  = "BargainUI"
	self.xml = "Assets\\Screens\\BargainGameMenu.xml"
	
	-- Get specialised gems for this game
	self.baseGems={ ["GHG1"]=2, ["GHG2"]=2, ["GHG3"]=2, ["GHG4"]=2, ["GHG5"]=2, ["GHNL"]=0 }
	self:InitGemList()
	
	self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}
	
	
	
	self.matchEvent="BargainAward"
	
	self.music = {[1]={"music_mine"};
					  [2]={"music_mine"}}
	
	self.lastSwap = {}
end

B008.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B008.AttributeDescriptions:AddAttribute('string', 'quit_msg', {default="[QUITPUZZLE]"})
B008.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=0})
--B008.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
--B008.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[BARGAIN_VICTORY]"})
--B008.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
--B008.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[BARGAIN_DEFEAT]"})

-- extra turns are never awarded (no opponent)
function B008:AwardExtraTurn()
end

function B008:NewGame()
	self.baseGems={ ["GHG1"]=0, ["GHG2"]=0, ["GHG3"]=0, ["GHG4"]=0, ["GHG5"]=0, ["GHNL"]=2 }
	self:InitGemList()
	self.nil_gems = 0
	
	_G.ShowTutorialFirstTime(25, _G.Hero)
end

function B008:OnEventBlackHole(event)
	--local msgView = GameObjectManager:Construct('GMSG')
	--self:AddChild(msgView)
	
	self.state = STATE_GAME_OVER
	self.locked = true
	self.nil_gems = #self:GetGemList("GHNL")
		
	--local e = GameEventManager:Construct("EndTurn")
	--GameEventManager:SendDelayed(e, self, GetGameTime() + 1000)
	if self.nil_gems >= 40 then
		self:HandleEndGame(1)
	else
		self:HandleEndGame(0)
	end
end

function B008:CheckEndGame()
	--self.nil_gems = #self:GetGemList("GHNL")
	
	--[[
	if self.locked then
		if self.nil_gems > 40 then
			--return self:GetCurrPlayer():GetAttribute("player_id")
			return 0
		else
			return 0
		end
	end
	]]--
	return false
end

-- AI does not move (or exist) in crafting game
function B008:OnEventAIMove()
end

-- Enemy does not exist
function B008:GetEnemy(player)
	LOG("Get nil enemy")
	return nil
end

function B008:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndBargain")
	e:SetAttribute("result", event:GetAttribute("result"))
	e:SetAttribute("location",_G.Hero:GetAttribute("curr_loc"))
	if self.nil_gems then
		e:SetAttribute("nil_gems", self.nil_gems)
	end
	LOG("Return EndBargain event")
	return e
end

function B008:OnEventVictoryMenu(event)
	self:OnEventLossMenu(event)
end

function B008:OnEventLossMenu(event)

	LOG("Construct EndBattle " .. tostring(self.nil_gems))
	local winner = event:GetAttribute("winner_id")
	local function transition()
		if self.nil_gems < 40 then
			PlaySound("music_defeat")
		else
			PlaySound("music_victory")
		end
		self.baseGems={ ["GHG1"]=2, ["GHG2"]=2, ["GHG3"]=2, ["GHG4"]=2, ["GHG5"]=2, ["GHNL"]=0 }
		
		local function RestartCallback(confirmed)
			if confirmed then
				Sound.StopMusic();
				self:RestartBattle()
			else
				local e = GameEventManager:Construct("GameEnd")
				e:SetAttribute('result',winner)
				local nextTime = GetGameTime() + self:GetAttribute("game_end_delay")
				GameEventManager:SendDelayed(e, self, nextTime)
			end
		end
		LoadAssetGroup("AssetsButtons")		
		SCREENS.BargainResultsMenu:Open(self.nil_gems, RestartCallback)
	end
	--SetFadeToBlack(true, 300)
	--CallScreenSequencer("BargainResultsMenu", "BargainResultsMenu", self.nil_gems, RestartCallback)
	transition()
end


function B008:Nova(event)
end

function B008:SupaNova(event)
end

function B008:ValidMove()

	LOG(tostring(self.g1) .. " = self.g1")
	self.lastSwap = {[1]=self.g1, [2]=self.g2}
	
	for i=1,self.moveListIdx do
		if self.moveList[i].grid1 == self.g1 and self.moveList[i].grid2 == self.g2 then
			return true
		elseif self.moveList[i].grid1 == self.g2 and self.moveList[i].grid2 == self.g1 then
			return true
		end		
	end
	return false
end

-- do nothing when an illegal move is made
function B008:InvalidMove()
	PlaySound("snd_illegal")
end


local HEX_SIDES = 6 
local CHECK_SIDES = 3 -- Matches value in InitBattleground.lua
-------------------------------------------------------------------------------
--                 SPAWN UNMATCHED GEM
--                 for grid i
--
--          Spawns a gem that doesn't match any gems around it.
--
--  WARNING!!!: Requires that there be at least 6 Gem Types OR at least 1 
--         AVAILABLE(value > 0) UNMATCHABLE gem type in .baseGems 
--
-------------------------------------------------------------------------------
function B008:SpawnUnmatchedGem(fillList,i)
	LOG("SpawnUnmatchedGem at "..tostring(i))	
	local gemList = {}
    local gemType = nil
	local shortList = {}
	local centerType = fillList[i]
    
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
    	if v > 0 then
    		if ( not gemList[g] or _G.GEMS[g].matchable==0) then
	    		--LOG("Insert "..tostring(g).." into shortList")
	    		table.insert(shortList,g)
    		end
    	end
    end
	
	local newGem
	if #shortList > 0 then
		newGem = shortList[math.random(1,#shortList)]
		LOG("return shortList newGem "..tostring(newGem))	
		return newGem
	else--return random up-right,down-right,oown adjacent gem type
		local adjacentList = {}
		local MatchList = GEMS[centerType].GemMatch
		for d=2, CHECK_SIDES+1 do
			local adjacentType = fillList[self.hexAdjacent[i][d]]
			if not MatchList[_G.GEMS[adjacentType].id] then
				table.insert(adjacentList,adjacentType)
			end
		end
		newGem = adjacentList[math.random(1,#adjacentList)]
		LOG("return adjacentList newGem "..tostring(newGem))	
		return newGem
    end
    
  
    
end



return ExportClass("B008")