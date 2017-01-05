
-- B009
--  OLD Pattern Matching Hacking Mini-game

import "safeglobals"




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")

class "B009" (BattleGround)

local HEX_GRIDS =55

local STATE_SET_PATTERN_GRID = 99



function B009:__init()
    super("B009")
    
    -- Standard Battle Gems List
   self.baseGems={["GNIL"]=1}
   
   
   
   self:InitGemList()
   self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6}--standard match patterns only 
   --self:InitBattle()
 
     
   --self.hackPattern = object
   self.patternGrids = {28}
   self.gemGrid = 28
   self.newGem = nil
  
  	-- Turn on gem pooling for hacking game
	--local INIT_BATTLEGROUND = import("InitBattleground")
	--INIT_BATTLEGROUND.InitGemPool(self)
	--INIT_BATTLEGROUND = nil
	--purge_garbage()
end


-- Copy our attributes from BattleGround
B009.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B009.AttributeDescriptions:AddAttribute('int', 'swap_delay', {default=100})
B009.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
B009.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[HACK_VICTORY]"})
B009.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
B009.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[HACK_DEFEAT]"})
B009.AttributeDescriptions:AddAttribute('string', 'GameMenu',{default="EditPuzzleMenu"})


--No extra turns in this minigame
function B009:AwardExtraTurn()
    
    
end


--- All moves Valid here.
function B009:ValidMove()
    return true 
end



function B009:GetEnemy(player)
    LOG("get nil enemy")
    return nil
end





function B009:MatchPatterns()
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



function B009:OnEventPreviewPattern(event)
    LOG("Preview pattern event")
    if self.state ~= STATE_GAME_OVER then
        assert(self.hackPattern,"No pattern")
		if self.hackPattern.pattern then
	        self.hackPattern:PreviewPattern(self)
	        self.hackPattern:PreviewPattern(self)
		end
    
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


function B009:CheckEndGame()
    
    --if self.gateHacked then--Player has succeeded
    --    return self:GetCurrPlayer()
    --elseif #self:GetGemList(self.hackPattern.hackGem) < self.hackPattern.min_gems then
    --    return 0
    --end
    
end


function B009:GetMoveList(coro_id)
    return true
end


function B009:Nova(event)
end


function B009:SupaNova(event)    
end


function B009:OnEventAIMove()   
end

function B009:GetReturnEvent(event)
    --local e = GameEventManager:Construct("EndHackGate")
    --e:SetAttribute('result',event:GetAttribute("result"))
    --e:SetAttribute('gate',Hero:GetAttribute("curr_loc"))
    --LOG("return End Hack Gate Event")
    return event        
    
end

function B009:OnEventCursorEntered(event)
    local obj = event:GetAttribute("object")

    local x = obj:GetX()
    local y = obj:GetY()

    -- dont process actions if the object is moving
    if (obj:HasMovementController()) or not obj:HasAttribute("isGem") then
        return
    end


   
	self.gemGrid = self.gemIndex[x][y]
		
end


function B009:OnEventCursorAction(event)
	LOG("OnEventCursorAction")
    local obj = event:GetAttribute("object")
    local up = event:GetAttribute("up")
    
    local x = obj:GetX()
    local y = obj:GetY()

    -- dont process actions if the object is moving
    if (obj:HasMovementController()) or not obj:HasAttribute("isGem") then
        return
    end


    local selected = self.gemIndex[x][y]
    
    
    
    self.gemGrid = selected
    self.newGem = obj
    
    
    if self.state == STATE_IDLE then
    
        SCREENS.GemSelectMenu:Open()
		
      
        
    end
	

end


function B009:OnRightClickGrid()
	LOG("OnRightClickGrid")
	self.hackPattern.pattern = self:AddNewPatternGrid(self.patternGrids,self.hackPattern.pattern,self.hackPattern.center,self.gemGrid)

	self.patternGrids={}
	LOG("patternText = "..self:OutputPattern(self.patternGrids,self.hackPattern.pattern,self.hackPattern.center))	
	
	local i = 0
	for j,v in pairs(self.patternGrids) do
		i = i+1
	end
	self.hackPattern.min_gems = i	

	self.patternGrids={}
	LOG("patternText = "..self:OutputPattern(self.patternGrids,self.hackPattern.pattern,self.hackPattern.center))	
	
end


function B009:OutputPattern(list,pattern,centerGrid)
	local patternText = ""
	local comma = ""
	list[centerGrid]=true
	
	if type(pattern)=="table" then
		patternText="{"
		for i,v in pairs(pattern) do
			patternText=string.format("%s[%s]=%s%s", patternText, i, self:OutputPattern(list,pattern[i],self.hexAdjacent[centerGrid][i]), comma)
			comma = ","
		end
		patternText=patternText.."}"
	else
		patternText="true"
	end
		
	return patternText
end



function B009:AddNewPatternGrid(list,pattern,centerGrid,newGrid)
    local gemAction = false
    LOG("addnewpatternGrid")
	
    if type(pattern) == "table" then
        if pattern == {} then
            return nil
        end
		--Check around the grid in each direction
        for i=1,6 do
            local checkGrid = self.hexAdjacent[centerGrid][i]
            if checkGrid == newGrid then
                
                if not list[newGrid] then
                    gemAction=true
                    list[newGrid]=true
                    pattern[i]=true
					break
                else
                    gemAction=true
                    list[newGrid]=nil
                    pattern[i]=nil
					break
                end
            end
        end
		if not gemAction then
	        for i=1,6 do
	            if pattern[i] then
	                local checkGrid = self.hexAdjacent[centerGrid][i]
	                pattern[i]=self:AddNewPatternGrid(list,pattern[i],checkGrid,newGrid)
	            end
	        end
		end
        return pattern
    else
        for i=1,6 do
            local checkGrid = self.hexAdjacent[centerGrid][i]
            if checkGrid == newGrid then
                if not list[newGrid] then  
                    list[newGrid]=true
                    return {[i]=true}
                else
                    list[newGrid]=nil
                    return nil
                end
            end
        end
    end
    return true
end

function B009:SetNewGem(newGemType)

	self:ReleaseGem(self.newGem)
    self:SpawnGem(self.gemGrid,newGemType)
    
    
    local board = {}
	local boardString = "board = {"
    for i=1,HEX_GRIDS do
        board[i]=self:GetGem(i).classIDStr
		if board[i] ~= "GNIL" then--This is automatically filled in
        	boardString = string.format("%s[%d]='%s',\n", boardString, i, board[i])
		end
    end
	boardString = boardString.."}"
	LOG(boardString)
	
    self.hackPattern.board = board
end




return ExportClass("B009")
