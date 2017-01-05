-- mining
-- B006

use_safeglobals()




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B006" (BattleGround)

function B006:__init()
    super("B006")
end

-- Copy our attributes from BattleGround
B006.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
--B006.AttributeDescriptions:AddAttribute('string',"no_credits_msg",{default="You have insufficient Cr to continue mining this Asteroid"})
B006.AttributeDescriptions:AddAttribute('string', 'quit_msg', {default="[QUITPUZZLE]"})
B006.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=0})





function B006:__init()
    super("B006")
	
	self.ui = "MiningUI"
	self.xml = "Assets\\Screens\\MineGameMenu.xml"
	-- Standard Battle Gems List
	self.baseGems={["GBLX"]=9,["GCFD"]=3,["GCTX"]=3,["GCMN"]=3}
   
   
   
   	self:InitGemList()
   	self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}    
   	--self:InitBattle()
   
   	self.matchEvent = "MineAward"--MineAward for Mine mini game	
	
	self.cargo = {}
	self.locked = false
	self.miningCost = 0
	
end


function B006:NewGame()
	local player = self:GetCurrPlayer()
	
	for i,v in pairs(self.cargo) do
		player:SetAttribute(_G.DATA.Cargo[v.cargo].effect.."_max",v.min)
		self.cargo[i].achieved = false
	end
	
	player:SpendCredits(self.miningCost)
 
	
	_G.ShowTutorialFirstTime(7,_G.Hero)	
end


function B006:SetMiningInfo(player,gemList,cost,cargo)
	
	self.baseGems = gemList
	self:InitGemList()
	for i,v in pairs(cargo) do
		player:SetAttribute(_G.DATA.Cargo[v.cargo].effect.."_max",v.min)
		cargo[i].achieved = false
	end
	self.cargo = cargo	
	self.miningCost = cost
end





function B006:OnEventBlackHole(event)
	LOG("OnEventBlackHole")
	
	collectgarbage()
	--local msgView = GameObjectManager:Construct('GMSG')
	--self:AddChild(msgView)
	_G.BigMessage(self,"[BLACKHOLE]",endX,endY)
	
	PlaySound("snd_blackhole")
	
	self.state= STATE_GAME_OVER
	
	
	self.locked = true
	
	self:HandleEndGame(0)
	
	--self:OnEventEndTurn(event)
end



function B006:CheckEndGame()
	local victory = true
	local player = self:GetCurrPlayer()
	for i,v in pairs(self.cargo) do
		if player:GetAttribute(_G.DATA.Cargo[v.cargo].effect) < v.min then
			victory = false
		end
	end
	
	if victory then
		return player:GetAttribute("player_id")
	elseif self.locked then
		return 0
	end
	
	return false
end



function B006:OnEventLossMenu(event)
	--PlaySound("music_defeat")
	PlaySound("snd_miningfail")
	local winner = event:GetAttribute("winner_id")	
	
	local function transition()
		self.state = STATE_GAME_OVER 	
		local player = self:GetCurrPlayer()
		
		local dropped = self:AwardCargo(winner)
		
		local function RestartCallback(confirmed)
			LOG("confirm Restart? "..tostring(confirmed))
			if confirmed then
				Sound.StopMusic();
				self:RestartBattle()
			else--No quits game		
				local e = GameEventManager:Construct("GameEnd")
				local nextTime = GetGameTime() + self:GetAttribute("game_end_delay")
				GameEventManager:SendDelayed( e, self, nextTime )		
			end
		end
		LoadAssetGroup("AssetsButtons")
		
		--CallScreenSequencer("MiningResultsMenu", "MiningResultsMenu", false,RestartCallback, self.cargo, dropped, self.miningCost)	
		SCREENS.MiningResultsMenu:Open(false,RestartCallback, self.cargo, dropped, self.miningCost)
	end
	transition()
end

function B006:OnEventVictoryMenu(event)
	PlaySound("music_victory")
	PlaySound("snd_miningsuccess")
	local winner = event:GetAttribute("winner_id")	
	
	local function transition()
		self.state = STATE_GAME_OVER 	
				
		local function VictoryCallback()			
			local e = GameEventManager:Construct("GameEnd")
			e:SetAttribute('result',winner)	
			local nextTime = GetGameTime() + (self:GetAttribute("game_end_delay"))
			GameEventManager:SendDelayed( e, self, nextTime )			
		end
		
		local dropped = self:AwardCargo(winner)
		
		LoadAssetGroup("AssetsButtons")
		
		--CallScreenSequencer("MiningResultsMenu", "MiningResultsMenu", true,VictoryCallback, self.cargo, dropped, self.miningCost)	
		SCREENS.MiningResultsMenu:Open(true,VictoryCallback, self.cargo, dropped, self.miningCost)
	end
	transition()
end

function B006:AwardCargo(winner)
	local multiplier = 4
	if winner ~= 1 then
		multiplier = 1
		winner = 1
	end
	
	local winner = self:GetAttributeAt("Players", winner)
	local cargoList = {0,0,0,0,0,0,0,0,0,0}
	
	for i=1, _G.NUM_CARGOES do 
		local amount = winner:GetAttribute(_G.DATA.Cargo[i].effect) * multiplier
		if amount > 0 then
			cargoList[i] = amount
		end		
	end
	

	local dropped = winner:AddCargo(cargoList)
	for i,v in pairs(cargoList) do		
		winner:SetAttribute(_G.DATA.Cargo[i].effect,v-dropped[i])	
	end
	
	return dropped
end

--No ai move
function B006:OnEventAIMove()
	
end

--No enemy
function B006:GetEnemy(player)
	LOG("get nil enemy")
	return nil
end

--No extra turns in this minigame
function B006:AwardExtraTurn()
	
	
end

--[[ WILL BE USED LATER
function B006:GetPlayerPrefList(player)
       local prefList = {}
       prefList["other"]=3
       for i,v in pairs(self.baseGems) do
               if GEMS[i].matchable==1 then
                       prefList[GEMS[i].effect]=4
               end
       end
       for i,v in pairs(self.cargo) do
               if player:GetAttribute(_G.DATA.Cargo[v.cargo].effect) < v.min then
                       prefList[_G.DATA.Cargo[v.cargo].effect]=6
               else
                       prefList[_G.DATA.Cargo[v.cargo].effect]=3
               end
       end
       return prefList
end
]]

--Gets Event to send back to source object containing battle result
function B006:GetReturnEvent(event)

	LOG("Construct EndMine")
	
	local e = GameEventManager:Construct("EndMine")
	LOG("EndMine Constructed")
	e:SetAttribute("result",event:GetAttribute("result"))
	e:SetAttribute('asteroid',Hero:GetAttribute("curr_loc"))
	LOG("Set result "..tostring(event:GetAttribute("result")))
	
	return e
		
	
end

-- do nothing when an illegal move is made
function B006:InvalidMove()
	PlaySound("snd_illegal")
end


return ExportClass("B006")
