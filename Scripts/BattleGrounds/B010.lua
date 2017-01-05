-- Crafting mini-game (match components, avoid unstable gems)
-- B010

import "safeglobals"

local BattleGround = import("BattleGrounds/HexBattleGround")

class "B010" (BattleGround)


function B010:__init()
	super("B010")
	
	self.ui = "CraftingUI"
	self.xml = "Assets\\Screens\\MineGameMenu.xml"
	
	-- Get specialised gems for this game
	self.baseGems={["GWCB"]=2,["GECB"]=2, ["GCCB"]=2, ["GCNL"]=3,["GUST"]=0,["GCPC"]=0,["GENC"]=0,["GWEC"]=0}
	self:InitGemList()
	
	self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}
	
	
	self.matchEvent="CraftAward"
	
	self.music = {[1]={"music_mine"};
					  [2]={"music_mine"}}
	
	self.lastSwap = {}
end

B010.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B010.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=0})
B010.AttributeDescriptions:AddAttribute('string', 'quit_msg', {default="[QUITPUZZLE]"})
B010.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
B010.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[CRAFT_VICTORY]"})
B010.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
B010.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[CRAFT_DEFEAT]"})

-- extra turns are never awarded (no opponent)
function B010:AwardExtraTurn()
end

function B010:NewGame()
	LOG("NewGame()")
	_G.Hero.biohazardMatches = 0
	_G.Hero.biohazardSpawns = 0
	_G.Hero:SetAttribute("components_weap", 0)
	_G.Hero:SetAttribute("components_cpu", 0)
	_G.Hero:SetAttribute("components_eng", 0)
	self.baseGems={["GWCB"]=2,["GECB"]=2, ["GCCB"]=2, ["GCNL"]=0,["GUST"]=1,["GCPC"]=0,["GENC"]=0,["GWEC"]=0}
	self:InitGemList()
	
	_G.ShowTutorialFirstTime(26, _G.Hero)
end

function B010:SetCraftingInfo(player, item, cost)
	self.item = item
	local is_ship = string.char(string.byte(item)) == "S"
	local weap,eng,cpu = _G.GLOBAL_FUNCTIONS.Plans.GetCraftingReqs(item,is_ship)
	
	
	player:SetAttribute("components_weap_max", weap)
	player:SetAttribute("components_eng_max",  eng)
	player:SetAttribute("components_cpu_max",  cpu)
	
	player:SetAttribute("components_weap", 0)
	player:SetAttribute("components_eng",  0)
	player:SetAttribute("components_cpu",  0)
end

function B010:OnEventBlackHole(event)
	--local msgView = GameObjectManager:Construct('GMSG')
	--self:AddChild(msgView)
	PlaySound("snd_blackhole")
	
	_G.BigMessage(self,"[FAILED_CRAFTING]")
	
	self.state = STATE_GAME_OVER
	self.locked = true
	
	--local e = GameEventManager:Construct("EndTurn")
	--GameEventManager:SendDelayed(e, self, GetGameTime() + 1000)
	self:HandleEndGame(0)
end

function B010:CheckEndGame()
	local victory = true
	
	-- 	victory = true
	-- end
	
	if _G.Hero:GetAttribute("components_weap") < _G.Hero:GetAttribute("components_weap_max") then
		victory = false
	end
	if _G.Hero:GetAttribute("components_eng") < _G.Hero:GetAttribute("components_eng_max") then
		victory = false
	end
	if _G.Hero:GetAttribute("components_cpu") < _G.Hero:GetAttribute("components_cpu_max") then
		victory = false
	end	
	
	if victory then
		return 1
	elseif self.locked then
		return 0
	end
	
	return false
end

-- AI does not move (or exist) in crafting game
function B010:OnEventAIMove()
end

-- Enemy does not exist
function B010:GetEnemy(player)
	LOG("Get nil enemy")
	return nil
end

function B010:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndCraft")
	e:SetAttribute("result", event:GetAttribute("result"))
	e:SetAttribute("itemID", self.item)
	LOG("Return EndCraft event")
	return e
end

function B010:OnEventLossMenu()
	LOG("Construct EndBattle")
	PlaySound("music_defeat")
	PlaySound("snd_craftfail")
	self.baseGems={["GWCB"]=2,["GECB"]=2, ["GCCB"]=2, ["GCNL"]=3,["GUST"]=0,["GCPC"]=0,["GENC"]=0,["GWEC"]=0}
	local function RestartCallback(confirmed)
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
	SCREENS.CraftingResultsMenu:Open(false, RestartCallback, self.item)
	--SetFadeToBlack(true, 300)
	--CallScreenSequencer("CraftingResultsMenu", "CraftingResultsMenu", false, RestartCallback, self.item)		
end

function B010:OnEventVictoryMenu(event)
	--Pay crafting Cost to craft this item	
	PlaySound("music_victory")
	PlaySound("snd_craftcomplete")	
	local winner = event:GetAttribute("winner_id")
	self.state = STATE_GAME_OVER 	
	self.baseGems={["GWCB"]=2,["GECB"]=2, ["GCCB"]=2, ["GCNL"]=3,["GUST"]=0,["GCPC"]=0,["GENC"]=0,["GWEC"]=0}
	local function VictoryCallback()		
		local e = GameEventManager:Construct("GameEnd")
		e:SetAttribute('result',winner)	
		local nextTime = GetGameTime() + (self:GetAttribute("game_end_delay"))
		GameEventManager:SendDelayed( e, self, nextTime )			
	end
	LoadAssetGroup("AssetsButtons")
	SCREENS.CraftingResultsMenu:Open(true, VictoryCallback, self.item)
end

function B010:Nova(event)
end

function B010:SupaNova(event)
end

function B010:ValidMove()
	local valid = false
	local baseGrid=-1
   
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
function B010:InvalidMove()
	PlaySound("snd_illegal")
end

function B010:PostProcessFillList(fillList)
	self:SetNumGems(fillList, "GCNL", 14,18)
end

return ExportClass("B010")