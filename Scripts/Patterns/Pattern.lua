-- BattleGround
--  this class defines the basic behaviour of the BattleGround objects
--   

class "Pattern" (GameObject)

Pattern.AttributeDescriptions = AttributeDescriptionList()
Pattern.AttributeDescriptions:AddAttribute('int', 'award', {default=3})
Pattern.AttributeDescriptions:AddAttribute('int', 'bonus', {default=0})
Pattern.AttributeDescriptions:AddAttribute('int', 'multiplier', {default=1})
Pattern.AttributeDescriptions:AddAttribute('string', 'name', {default=""})
Pattern.AttributeDescriptions:AddAttribute('string', 'message', {default=""})
Pattern.AttributeDescriptions:AddAttribute('int', 'extra_turn', {default=0})
Pattern.AttributeDescriptions:AddAttribute('GameObject', 'gem', {})
Pattern.AttributeDescriptions:AddAttribute('int', 'award_delay', {default=700})
-- Pattern.AttributeDescriptions:AddAttributeCollection('GameObject', 'weapons')
-- Pattern.AttributeDescriptions:AddAttributeCollection('GameObject', 'systems')

Pattern.pattern=nil

Pattern.center = 28--Default center for pattern matching
Pattern.min_gems = 1
Pattern.hackGem = "GCPU"
Pattern.hackID = 2

Pattern.board = {}

function Pattern:__init(clid)
    super(clid)
end

function Pattern:GetPattern()

    return self.pattern
end

function Pattern:GetBoard()
    return self.board
end

function Pattern:AwardPlayer(battleGround,grid,player)
    LOG("AWARD PLAYER")
    
    local gem = battleGround:GetGem(grid)
    local msg = self:GetAttribute("name")
    
    local effect = gem:GetAttribute("effect")
    local total = self:GetAttribute("bonus")
    
    self:SetParticle(battleGround,self.pattern,grid,"pattern")
    --will get gemtype from i
    --will award bonus to player
    
    --Award extra turn if necessary
    if self:GetAttribute("extra_turn") == 1 then
        battleGround:AwardExtraTurn()
    end
    
    --Started here
    
    local playerId = player:GetAttribute('player_id')
  
    
    local event
    local dest
    local enemy
    
    if effect == "damage" then 
        playerId = playerId + 1       
        if playerId > battleGround:NumAttributes('Players') then--Wrap Around
            playerId = 1
        end
        enemy = battleGround:GetAttributeAt('Players',playerId)
        if enemy ~= player then
            dest = enemy
        end
        --this breaks the messages
        --msg = msg.." -"..tostring(total)
        event = GameEventManager:Construct("Damage")
    else
        dest = player
        --this breaks the messages.
        --msg = msg.." +"..tostring(total)
        event = GameEventManager:Construct("ReceiveEnergy")
        event:SetAttribute('effect',effect)     
    end
    
    --If pattern has effect -- send effect event to recipient of effect
    if effect ~= "" and total ~= 0 then
        event:SetAttribute('amount',total)
        local nextTime = GetGameTime() + self:GetAttribute("award_delay")
        GameEventManager:SendDelayed( event, dest, nextTime)    
        
        
    
        local path = GameObjectManager:Construct('APTH')
        path:SetAttribute("duration",self:GetAttribute("award_delay"))
        path:SetAttribute("colour",gem:GetAttribute('path'))
    
        local endX,endY = battleGround:WorldToGrid(battleGround.coords[playerId][effect][1], battleGround.coords[playerId][effect][2])
        --local debug = tostring(startX + msgSpawnX)..","..tostring(startY + msgSpawnY)..","..tostring(endX)..","..tostring( endY)
            --assert(false, debug)
            
            
    end
    
    
        

    
    
    --Ended here
    if msg ~= "" then
        _G.BigMessage(battleGround,msg,gem:GetX(),gem:GetY())
    end     
    

end


function Pattern:PreviewPattern(battleGround)
    self:SetParticle(battleGround,self:GetPattern(),self.center,"pattern_preview")  
end

-------------------------------------------------------------------------------
--HackAward - recieved during hacking game
-------------------------------------------------------------------------------
function Pattern:HackAwardPlayer(battleGround,grid,player)
    --Do extra stuff here
    local battleGround = event:GetAttribute("BattleGround")
    battleGround:PatternMatched(ClassIDToString(self:GetClassID()))
    self:OnEventAward(event)
    
end


-------------------------------------------------------------------------------
--HackAward - recieved during hacking game
-------------------------------------------------------------------------------
function Pattern:PsiAwardPlayer(battleGround,grid,player)
    --Do extra stuff here
    local battleGround = event:GetAttribute("BattleGround")
    battleGround:PatternMatched(ClassIDToString(self:GetClassID()))
    self:OnEventAward(event)
    
end

-------------------------------------------------------------------------------
-- MineAward - recieved during Mining game
-------------------------------------------------------------------------------
function Pattern:MineAwardPlayer(battleGround,grid,player)
    
    --Do extra stuff here
    local battleGround = event:GetAttribute("BattleGround")
    battleGround:AwardExtraTime(self:GetAttribute("time_bonus"))
    self:OnEventAward(event)
    
    
end

function Pattern:OnEventAward(event)
    
end


function Pattern:SetParticle(battleGround,patternRoot,i,particle)
    
 	local gem = battleGround:GetGem(i)
    AttachParticles(gem, particle, 0,0)
    if type(patternRoot) == "table" then
    	for d in pairs(patternRoot) do
    		local nextGrid = battleGround.hexAdjacent[i][d] -- get index of adjacent grids       

            if type(patternRoot[d]) == "table" then
                self:SetParticle(battleGround,patternRoot[d],nextGrid, particle)

            else
                gem = battleGround:GetGem(nextGrid)
                if gem then
                    AttachParticles(gem, particle, 0,0)
                end
            end

        end
    end
end

return ExportClass("Pattern")
