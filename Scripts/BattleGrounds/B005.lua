
-- B005
--   Mini Game -- get rid of all CPU gems on the board

import "safeglobals"




-- import our base class
local BattleGround = import("BattleGrounds/HexBattleGround")


class "B005" (BattleGround)

function B005:__init()
    super("B005")
	
	self.ui = "MiningUI"
	self.xml = "Assets\\Screens\\MineGameMenu.xml"
	-- Standard Battle Gems List
	self.baseGems={["GKEY"]=2,["GSHD"]=5,["GWEA"]=5,["GCPU"]=5,["GENG"]=5,["GPSI"]=5,["GINT"]=5}
   
   
   
   	self:InitGemList()
   	self.patternList={["PMT3"]=1,["PMT4"]=2,["PMT5"]=3,["PMT6"]=4,["PMT7"]=5,["PMT8"]=6,["PLAR"]=7,["PRAR"]=8,["PXWG"]=9,["PHEX"]=10}    
   	--self:InitBattle()

   	self.matchEvent = "MineAward"--MineAward for Mine mini game	
end

-- Copy our attributes from BattleGround
B005.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)
B005.AttributeDescriptions:AddAttribute('int', 'ai_delay', {default=0})
B005.AttributeDescriptions:AddAttribute('string', 'victory',{default="[VICTORY]"})
B005.AttributeDescriptions:AddAttribute('string', 'victory_msg',{default="[MINE_VICTORY]"})
B005.AttributeDescriptions:AddAttribute('string', 'defeat',{default="[DEFEAT]"})
B005.AttributeDescriptions:AddAttribute('string', 'defeat_msg',{default="[MINE_DEFEAT]"})



--No extra turns in this minigame
function B005:AwardExtraTurn()
	
	
end



function B005:OnEventBlackHole(event)
	
	
end

function B005:GetEnemy(player)
	LOG("get nil enemy")
	return nil
end



function B005:CheckEndGame()
	local numGems = #self:GetGemList("GCPU")
	if numGems == 0 then
		return self:GetCurrPlayer():GetAttribute("player_id")
	elseif numGems > 0 and numGems < 3 then
		return 0
	end
	
	return false
end


function B005:Nova(event)
	--[[
	self:AwardExtraTime(60)
	--Displays Extra Turn message
    local msgView = GameObjectManager:Construct('GMSG')
    self:AddChild(msgView)
    _G.BigMessage(self,"[NOVA]",250,200)	
	]]--
end


function B005:SupaNova(event)
	--[[
	self:AwardExtraTime(120)	
	--Displays Extra Turn message
    local msgView = GameObjectManager:Construct('GMSG')
    self:AddChild(msgView)
    _G.BigMessage(self,"[SUPANOVA]",250,200)	
	]]--
end

function B005:OnEventUpdateUI(event)
    
	
	--No UI To update in this game ATM - maybe timer only
    
	--SCREENS.GameMenu:UpdateMiningUI()
    

    --local e = GameEventManager:Construct("UpdateUI")
    --local nextTime = GetGameTime() + self:GetAttribute("ui_tick")
    --GameEventManager:SendDelayed( e, self, nextTime )

end



function B005:OnEventAIMove()
	
end


return ExportClass("B005")
