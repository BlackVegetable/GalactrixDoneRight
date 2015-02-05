
-- B003
--  Gain Psi-power/ Pattern Matching mini game Mini-game

use_safeglobals()




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B003" (BattleGround)



local HEX_GRIDS =55


function B003:__init()
    super("B003")
	self.xml = "Assets\\Screens\\MineGameMenu.xml"
	-- Standard Battle Gems List
   self.baseGems={["GNIL"]=1}
   
   self:InitGemList()
   self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}--standard match patterns only 
   --self:InitBattle()
   
   
   self.matchEvent = "PsiAward"--HackAward for hacking mini game
   
  
  
   self.gateHacked = false
end


-- Copy our attributes from BattleGround
B003.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B003.AttributeDescriptions:AddAttribute('int', 'swap_delay', {default=100})
B003.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
B003.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[PSI_VICTORY]"})
B003.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
B003.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[PSI_DEFEAT]"})


--No extra turns in this minigame
function B003:AwardExtraTurn()
	
	
end


--- All moves Valid here.
function B003:ValidMove()
	return true
end



function B003:GetEnemy(player)
	LOG("get nil enemy")
	return nil
end





function B003:MatchPatterns()
	local pattern = self.hackPattern
	
  	assert(pattern,"No pattern to match")
    
	local matches = self:GetPatternMatches()
	

	   	
	local i = pattern.center
	local hackGem = pattern.hackID
    local baseType = matches[i]["matched"]--gem class Id
	LOG("basetype "..baseType)
	
    local baseGem = self:GetGem(i)
    if baseType == hackGem then   
    	if self:MatchGemPattern(pattern:GetPattern(),i,matches,baseGem) then
    		pattern:AwardPlayer(self,i,self:GetCurrPlayer())		
			LOG("Pattern match found @"..tostring(i))				
			self.gateHacked = true	
        end
    end
	

end



function B003:OnEventPreviewPattern(event)
	LOG("Preview pattern event")
	if self.state ~= STATE_GAME_OVER then
		assert(self.hackPattern,"No pattern")
		self.hackPattern:PreviewPattern(self)
		self.hackPattern:PreviewPattern(self)
	
		if event then
			local nextTime = GetGameTime() + self:GetAttribute("preview_delay")
			GameEventManager:SendDelayed( event, self, nextTime )
		else
			LOG("No event")
		end
	else
			LOG("game Over")
	end
end


function B003:CheckEndGame()
	if self.gateHacked then--Player has succeeded
		return self:GetCurrPlayer():GetAttribute("player_id")
	elseif #self:GetGemList(self.hackPattern.hackGem) < self.hackPattern.min_gems then
		return 0
	end
	
end
--[[
function B003:OnEventCursorAction(event)
    local obj  = event:GetAttribute("object")
    local x    = event:GetAttribute("x")
    local y    = event:GetAttribute("y")
	local up    = event:GetAttribute("up")
    local turn = self:GetAttribute('curr_turn')

    
	LOG("CursorAction  up:"..tostring(up))

    --if turn = player
    if turn == 1 and obj and self.moveList then
        x = obj:GetX()
        y = obj:GetY()

        -- dont process actions if the object is moving
        if (obj:HasMovementController()) or not obj:HasAttribute("isGem") then
            return
        end

        if self.state == STATE_IDLE then
            self:GemClicked(obj,x,y)
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
    end
end
]]--


function B003:GetMoveList(coro_id)
	self.moveList={}
	return true
end


function B003:Nova(event)
end


function B003:SupaNova(event)	
end


function B003:OnEventAIMove()	
end

function B003:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndHackGate")
	e:SetAttribute('result',event:GetAttribute("result"))
	e:SetAttribute('gate',Hero:GetAttribute("curr_loc"))
	LOG("return End Hack Gate Event")
	return e		
	
end

--function B003:OnEventUpdateUI(event)
    
    
    --SCREENS.GameMenu:UpdateUI()
    

    --local e = GameEventManager:Construct("UpdateUI")
    --local nextTime = GetGameTime() + self:GetAttribute("ui_tick")
    --GameEventManager:SendDelayed( e, self, nextTime )

--end



return ExportClass("B003")
