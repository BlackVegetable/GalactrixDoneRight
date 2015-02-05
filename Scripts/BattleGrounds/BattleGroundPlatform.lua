local FX = import "FXContainer"
local FX_AddKey = FX.AddKey
local FX_CreateContainer = FX.CreateContainer
local FX_AddText 	= FX.AddText
local FX_KEY_X   	= FX.KEY_X
local FX_KEY_Y 		= FX.KEY_Y
local FX_KEY_XY 	= FX.KEY_XY
local FX_KEY_SCALE 	= FX.KEY_SCALE
local FX_KEY_HSCALE = FX.KEY_HSCALE
local FX_KEY_VSCALE = FX.KEY_VSCALE
local FX_KEY_ROT 	= FX.KEY_ROT
local FX_KEY_ALPHA 	= FX.KEY_ALPHA
local FX_KEY_VIS 	= FX.KEY_VIS
local FX_KEY_ALL 	= FX.KEY_ALL
local FX_DISCRETE   = FX.DISCRETE
local FX_LINEAR 	= FX.LINEAR
local FX_BOUNCE 	= FX.BOUNCE
local FX_SMOOTH 	= FX.SMOOTH
local FX_PUNCH_IN 	= FX.PUNCH_IN
local FX_PUNCH_OUT	= FX.PUNCH_OUT
local FX_AddRumble 	= FX.AddRumble

local CRH = import "CoroutineHelpers"

local MENU = ""

local SWAP1 = 1
local SWAP2 = 2
local MATCH_WEIGHT = 3




local GRID_CENTER = 28
local HEX_SIDES = 6
local CHECK_SIDES = 3
local HEX_GRIDS =55



--[[ --Unused Globals
local GRID_WIDTH = 8
local HEX_GRIDS_MAX = 55


local HEX_GEM_WIDTH = 76
local HEX_GEM_HEIGHT = 67
local HEX_GEM_COLORS = 7

local SWAP_TIME = 400
local REMOVE_TIME = 200
local FALL_TIME = 300
local REPLENISH_TIME = 800

local SCREEN_HEIGHT = 768
]]--
--[[
function BattleGround:InitBattle()
    _G.Blog("BattleGroundPlatform Inititated")

    self.lenWeight={[3]=5,[4]=6,[5]=7}

    math.randomseed(GetGameTime())

    self.hexAdjacent, self.hexPts, self.hexBlackHole, self.hexOddRow = self:InitGrid()
    self.gems = {}

    self.gemIndex = {}
    --set up gem Index - maps x,y grid position to grid[index]
    for i=1, HEX_GRIDS do
        if not self.gemIndex[self.hexPts[i][1] ] then
            self.gemIndex[self.hexPts[i][1] ]={}
        end
        self.gemIndex[self.hexPts[i][1] ][self.hexPts[i][2] ] = i
    end
    self:InitMatchList()
    self.g1 = nil
    self.g2 = nil
    --self.spawn = {{0,69},{60,35},{60,-34},{0,-69},{-60,-34},{-60,35}}--positions for gems to spawn in each direction.
    self.spawn = {{0,60},{50,25},{50,-24},{0,-60},{-50,-24},{-50,25}}--positions for gems to spawn in each direction.
    self.inverseDir = {4,5,6,1,2,3} --maps the adjacent grid index to to the inverse.

    self.turn = {}
    self.turn_count = 0
	self.turn.turns = 1
   
    self:ResetTurn()
	
	self.ds = false


	self.item_skip_end_turn = false	
	self.user_input_dest = nil
	
	self.text_extra_x = 512
	self.text_extra_y = 400
	self.text_message_x = 512
	self.text_message_y = 350
	
    self.nova_x = 512
	self.nova_y = 384
	
	self.nova_offset_1 = 70
	self.nova_offset_2 = -60
	
	self.offset_x = 0
	self.offset_y = 0
end
--]]

--[[

--these are screen coordinates - not world coordinates
function BattleGround:InitCoords()

    self.coords={}
    self.coords[1] = {}
    self.coords[2] = {}
    
    self.coords[1]["weapon"]={200,483}
    self.coords[1]["engine"]={195,455}
    self.coords[1]["cpu"]={190,428}
    self.coords[1]["shield"]={240,582}
    self.coords[1]["intel"]={59,406}
    self.coords[1]["psi"]={96,384}
    --self.coords[1]["damage"]={150,638}
    --self.coords[1]["damage"]={240,582}
    self.coords[1]["damage"]={156,568}
    self.coords[1]["life"]={156,568}
    self.coords[1]["key"]={890,654}
    self.coords[1]["time"]={512,674}
    self.coords[1]["hack"]={865,579}
    self.coords[1]["cargo_food"]={890,654}
    self.coords[1]["cargo_textiles"]={890,654}
    self.coords[1]["cargo_minerals"]={890,654}
    self.coords[1]["cargo_alloys"]={890,654}
    self.coords[1]["cargo_tech"]={890,654}
    self.coords[1]["cargo_luxuries"]={890,654}
    self.coords[1]["cargo_medicine"]={890,654}
    self.coords[1]["cargo_gems"]={890,654}
    self.coords[1]["cargo_gold"]={890,654}
    self.coords[1]["cargo_contraband"]={890,654}
    self.coords[1]["components_weap"]={890,654}
	 self.coords[1]["components_eng"]={890,654}
	 self.coords[1]["components_cpu"]={890,654}
    self.coords[1]["item"]={}
    self.coords[1]["item"][1]={40,407}--361}
    self.coords[1]["item"][2]={40,448}--320}
    self.coords[1]["item"][3]={40,486}--282}
    self.coords[1]["item"][4]={44,528}--240}
    self.coords[1]["item"][5]={55,567}--201}
    self.coords[1]["item"][6]={66,606}--162}
    self.coords[1]["item"][7]={84,647}--121}
    self.coords[1]["item"][8]={120,687}--81}
    
    self.coords[2]["weapon"]={820,483}
    self.coords[2]["engine"]={825,455}
    self.coords[2]["cpu"]={830,428}
    self.coords[2]["shield"]={784,582}
    self.coords[2]["intel"]={960,406}
    self.coords[2]["psi"]={930,384}
    --self.coords[2]["damage"]={894,638}
    --self.coords[2]["damage"]={784,582}
    self.coords[2]["damage"]={894,568}
    self.coords[2]["life"]={894,568}
    self.coords[2]["key"]={833,596}
    self.coords[2]["time"]={512,674}
    self.coords[2]["cargo_food"]={833,596}
    self.coords[2]["cargo_textiles"]={833,596}
    self.coords[2]["cargo_minerals"]={833,596}
    self.coords[2]["cargo_alloys"]={890,654}
    self.coords[2]["cargo_tech"]={890,654}
    self.coords[2]["cargo_luxuries"]={890,654}
    self.coords[2]["cargo_medicine"]={890,654}
    self.coords[2]["cargo_gems"]={890,654}
    self.coords[2]["cargo_gold"]={890,654}
    self.coords[2]["cargo_contraband"]={890,654}
    self.coords[2]["item"]={}
    self.coords[2]["item"][1]={840,407}
    self.coords[2]["item"][2]={840,448}
    self.coords[2]["item"][3]={832,486}
    self.coords[2]["item"][4]={822,528}
    self.coords[2]["item"][5]={806,567}
    self.coords[2]["item"][6]={790,606}
    self.coords[2]["item"][7]={768,647}
    self.coords[2]["item"][8]={740,687}

end

--]]



-------------------------------------------------------------------------------
--
--   Inits hexXXXX array - pt in Grid Coordinates
--
-------------------------------------------------------------------------------
function BattleGround:InitGrid()
	
	INIT_GRID = import("InitGridPlatform")
	local adj = INIT_GRID.InitAdjacent()
	local pts = INIT_GRID.InitPoints()
	local bh = INIT_GRID.InitBlackHole()
	local odd = INIT_GRID.InitOddRow()
	INIT_GRID = nil
	
	return adj,pts,bh,odd
	
end



--Fills grid with no matches, used at start of battle only(maybe black hole)
--Assumes and requires minimum 6 gem types on board or at least 1 gemType that cannot be matched
--
-- fillList(optional) = table {[1]="GDMG",[2]..[HEX_GRIDS]="GCPU"}
function BattleGround:FillGrid(fillList,restarted)

	INIT_BATTLEGROUND = _G.LoadInit(INIT_BATTLEGROUND,"InitBattleground")
	--_G.LoadAndExecute("InitBattleground","FillGrid",false,  self,fillList)	
	--local INIT_BATTLEGROUND = import("InitBattleground")
	
	INIT_BATTLEGROUND.FillGrid(self,fillList)
	--CRH.Run(function (coro_id) INIT_BATTLEGROUND.FillGrid(self,fillList, coro_id) end, 1,15, nil	)	
	
	--INIT_BATTLEGROUND = nil
	--purge_garbage()
end



function BattleGround:SetGemMovement(gem,x1,y1,x2,y2)
    if gem then
        local m = MovementManager:Construct("Gravity")
        m:SetAttribute("Accel", 1200)    -- 200 world units (pixels) per second^2
        m:SetAttribute("StartX", x1)
        m:SetAttribute("StartY", y1)
        m:SetAttribute("EndX", x2)
        m:SetAttribute("EndY", y2)
        gem:SetMovementController(m)
    end
end



function BattleGround:SetEndGemMovement(gem,x1,y1,x2,y2)
	--PC Does nothing
	--[[
    if gem then
        local m = MovementManager:Construct("Linear")
        m:SetAttribute("Duration", 1000)    -- 200 world units (pixels) per second^2
        m:SetAttribute("StartX", x1)
        m:SetAttribute("StartY", y1)
        m:SetAttribute("EndX", x2)
        m:SetAttribute("EndY", y2)
        gem:SetMovementController(m)
    end	
	
	--]]	
end

-------------------------------------------------------------------------------
--
--  Spawns the gems outside grid, set animations to fall into place
--
-------------------------------------------------------------------------------
function BattleGround:FillVoid(e, coro_id)

	if not self.host then
		return
	end
	local fillDir = self:GetAttribute("swap_direction")
    --used for detecting edge grid - no longer used.
	local checkDir = self.inverseDir[fillDir]   --- 
	local gemEvent = GameEventManager:Construct("CreateGems")
	
    for k,i in pairs(self.edgeGrids[checkDir]) do
    	--if    empty grid    and     an edge grid(with respect to fall direction)
        if not self:GetGem(i) then
            local x1 = self.hexPts[i][1] + self.spawn[checkDir][1]
            local y1 = self.hexPts[i][2] + self.spawn[checkDir][2]
            --local gem = self:SpawnGem(i)
			local gemID = self:GetRandomGemCode()
			gemEvent:PushAttribute("gem_code",gemID)
			gemEvent:PushAttribute("start_x",x1)
			gemEvent:PushAttribute("start_y",y1)
			--gem:SetPos(x1,y1)--Set Start Position off screen
			--gem:GetView():SetAlpha(0.0)
			local nextGrid = i
		
			--Loop to set the animation for the next gem			
			while self.hexAdjacent[nextGrid][fillDir] ~=-1 do
				if self:GetGem(self.hexAdjacent[nextGrid][fillDir]) then
					break--stops when it finds a solid gem in the fillDirection
				end
				nextGrid = self.hexAdjacent[nextGrid][fillDir]
			end
			--local x2 = self.hexPts[nextGrid][1]
			--local y2 = self.hexPts[nextGrid][2]

			gemEvent:PushAttribute("grid_id",nextGrid)	
        end
	

		CRH.CheckYield(coro_id) -- YIELD ???

    end

	-- End of update - events
	GameEventManager:Send(gemEvent,self.host_id)	
	
end




-------------------------------------------------------------------------------
--
--  Sets the animations for each gem to fall into place.
--
-------------------------------------------------------------------------------


--function BattleGround:FallGems()
function BattleGround:FallGems(coro_id)

    local falling = false
    local fallDir = self:GetFallDir()
    local checkDir = self.inverseDir[fallDir]
	

	
    for i,v in pairs(self.edgeGrids[fallDir]) do
            local baseGrid = v
            local checkGrid = self.hexAdjacent[baseGrid][fallDir]
            local empty = false
            --check no empty grids between this and edge
            while self:GetGem(baseGrid) do
                if self.hexAdjacent[baseGrid][checkDir] == -1 then
                    empty = true
					break
                end
                baseGrid = self.hexAdjacent[baseGrid][checkDir]
            end
			
			CRH.CheckYield(coro_id) -- YIELD ???

            --baseGrid = bottom most empty grid on this fallDir line
            if not empty then

                local gemList = {}
                local gemCount = 1
                local fillList = {}
                local fillCount = 1
                --insert first grid to be filled
                fillList[fillCount] = baseGrid
                fillCount = fillCount + 1
                checkGrid = self.hexAdjacent[baseGrid][checkDir]

                -- check grid in checkDirection until hit edge of board
                while  checkGrid ~= -1 do

                    fillList[fillCount] = checkGrid
                    fillCount = fillCount + 1
                    --if find grid to fall
                    if self:GetGem(checkGrid) then
                        falling = true
                        gemList[gemCount] = checkGrid
                        gemCount = gemCount + 1
                    end

                    checkGrid = self.hexAdjacent[checkGrid][checkDir]

                end
				
				CRH.CheckYield(coro_id) -- YIELD ???

                for j=1, gemCount-1 do
                	
                     self:SwapGem(gemList[j],fillList[j])
					 
                end

            end
        


			CRH.CheckYield(coro_id) -- YIELD ???


    end


	-- End of update event sending
	self:AdvanceState(STATE_REPLENISHING, self:GetAttribute("movement_check"))
	--[[ 
    self.state = STATE_REPLENISHING
    local e = GameEventManager:Construct("Update")
    local nextTime = GetGameTime()
    if falling then
        nextTime = nextTime + self:GetAttribute("movement_check")
    end
    GameEventManager:SendDelayed( e, self, nextTime )
	--]]
	
	--_G.Blog("End "..tostring(GetGameTime()))
    return 0
end



-- Send a CLEAR message to all grids with a match on them
--PC SAME FOR SINGLE & MP
--function BattleGround:ClearMatches()
function BattleGround:ClearMatches(coro_id)
	_G.Blog("ClearMatches()")

	local sendEvents = false
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
				
				CRH.CheckYield(coro_id)
				
			end	
			
			CRH.CheckYield(coro_id)
			
		end
		
		self.numClearEvents = self.numClearEvents + 1
		self.clearEvents[self.numClearEvents] = clearEvent
		sendEvents = true
		--GameEventManager:Send(clearEvent,self.host_id)
	
	end 	

	CRH.CheckYield(coro_id)
	return sendEvents
	
end




function BattleGround:InitDSParticles()
end

function BattleGround:AddDSParticle(gemID,myContainer,myX,myY)
end

function BattleGround:StartDSParticles(myContainer,theX,theY)
end



	
function BattleGround:FireClearMatches()
	for i=1,self.numClearEvents do
		GameEventManager:Send(self.clearEvents[i],self.host_id)
		self.clearEvents[i] = nil
	end
	self.numClearEvents = 0
end


function BattleGround:MovementStopped()

    for i=1, HEX_GRIDS do
    	assert(self,"no self")
    	local gem = self:GetGem(i)
    	if gem then
        	if self:GetGem(i):HasMovementController() then
        		return false
        	end			
		end
        
    end
    return true
end

function BattleGround:WorldToScreen(x,y)
	return x+ _G.SCREENS.GameMenu.left_edge,768-y
end

function BattleGround:ScreenToWorld(x,y)
	return x - _G.SCREENS.GameMenu.left_edge,768-y
end

function BattleGround:AddToGrid(x, y)
	self.offset_x = x
	self.offset_y = y
end

	
function BattleGround:SupaNovaMessage()
	
		local container = FX_CreateContainer(1700, 0)
		local elem1     = FX_AddText(container,"font_big_event",translate_text("[SUPANOVA]"), 0,50, 0.0,0.0, 0.0,1.0, true)
		local elem2     = FX_AddText(container,"font_small_event",translate_text("[SUPANOVA_EFFECT]"), 0,-50, 0.0,0.0, 0.0,1.0, true)
		
		FX_AddKey(container,elem1,1500,FX_KEY_XY,    0,self.nova_offset_1, FX_SMOOTH)
		FX_AddKey(container,elem1,500, FX_KEY_SCALE, 1.0,  FX_BOUNCE)
		FX_AddKey(container,elem1,1000,FX_KEY_SCALE, 1.0,  FX_DISCRETE)
		FX_AddKey(container,elem1,1400,FX_KEY_SCALE, 3.0,  FX_PUNCH_OUT)
		FX_AddKey(container,elem1,1000,FX_KEY_ALPHA, 1.0,  FX_DISCRETE)
		FX_AddKey(container,elem1,1400,FX_KEY_ALPHA, 0.0,  FX_LINEAR)
		
		FX_AddKey(container,elem2,1500, FX_KEY_XY,   0,self.nova_offset_2, FX_SMOOTH)
		FX_AddKey(container,elem2,700, FX_KEY_SCALE, 1.0, FX_BOUNCE)
		FX_AddKey(container,elem2,1200,FX_KEY_SCALE, 1.0, FX_DISCRETE)
		FX_AddKey(container,elem2,1400,FX_KEY_SCALE, 3.0, FX_PUNCH_OUT)
		FX_AddKey(container,elem2,1000,FX_KEY_ALPHA, 1.0, FX_DISCRETE)
		FX_AddKey(container,elem2,1400,FX_KEY_ALPHA, 0.0, FX_LINEAR)
		
		--BEGIN_STRIP_DS
		--FX_AddRumble(container,0,0,0.4,500)
		--FX_AddRumble(container,550,0,0.5,450)
		--FX_AddRumble(container,1000,0,0.6,400)
		--FX_AddRumble(container,1400,0,0.7,300)
		_G.SCREENS.GameMenu:RumblePlayer(self:GetAttribute("curr_turn"), 0.6, 750)		
		--END_STRIP_DS			
		
		FX.AddSound(container,250,"snd_supernova")
		FX.AddParticles(container,elem1,0,"BlueExplosion",   0,0)
		FX.AddParticles(container,elem1,0,"BlueExplosion", 100,0)
		FX.AddParticles(container,elem1,0,"BlueExplosion",-100,0)
		FX.Start(self, container, self.nova_x,self.nova_y)				
	end
	
	
	
function BattleGround:NovaMessage()
		local container = FX_CreateContainer(1700, 0)
		local elem1     = FX_AddText(container,"font_big_event",translate_text("[NOVA]"), 0,50, 0.0,0.0, 0.0,1.0, true)
		local elem2     = FX_AddText(container,"font_small_event",translate_text("[NOVA_EFFECT]"), 0,-50, 0.0,0.0, 0.0,1.0, true)
		
		FX_AddKey(container,elem1,1500,FX_KEY_XY,    0,self.nova_offset_1, FX_SMOOTH)
		FX_AddKey(container,elem1,500, FX_KEY_SCALE, 1.0,  FX_BOUNCE)
		FX_AddKey(container,elem1,1000,FX_KEY_SCALE, 1.0,  FX_DISCRETE)
		FX_AddKey(container,elem1,1400,FX_KEY_SCALE, 3.0,  FX_PUNCH_OUT)
		FX_AddKey(container,elem1,1000,FX_KEY_ALPHA, 1.0,  FX_DISCRETE)
		FX_AddKey(container,elem1,1400,FX_KEY_ALPHA, 0.0,  FX_LINEAR)
		
		FX_AddKey(container,elem2,1500, FX_KEY_XY,   0,self.nova_offset_2, FX_SMOOTH)
		FX_AddKey(container,elem2,700, FX_KEY_SCALE, 1.0, FX_BOUNCE)
		FX_AddKey(container,elem2,1200,FX_KEY_SCALE, 1.0, FX_DISCRETE)
		FX_AddKey(container,elem2,1400,FX_KEY_SCALE, 3.0, FX_PUNCH_OUT)
		FX_AddKey(container,elem2,1000,FX_KEY_ALPHA, 1.0, FX_DISCRETE)
		FX_AddKey(container,elem2,1400,FX_KEY_ALPHA, 0.0, FX_LINEAR)
		
		--BEGIN_STRIP_DS
		--FX_AddRumble(container,0,0,0.2,500)
		--FX_AddRumble(container,550,0,0.3,450)
		--FX_AddRumble(container,1000,0,0.5,700)
		_G.SCREENS.GameMenu:RumblePlayer(self:GetAttribute("curr_turn"), 0.5, 450)	
		--END_STRIP_DS			
		
		FX.AddSound(container,250,"snd_nova")
		FX.AddParticles(container,elem1,0,"BlueExplosion",   0,0)
		FX.AddParticles(container,elem1,0,"BlueExplosion", 100,0)
		FX.AddParticles(container,elem1,0,"BlueExplosion",-100,0)
		FX.Start(self, container, self.nova_x,self.nova_y)		
end

function BattleGround:ClearHintArrow()
	if self.hint_arrow then
		self.FX:Stop(self.hint_arrow)
		self.hint_arrow = nil
	end	
end

function BattleGround:HighlightGem(i)
    local gem = self:GetGem(i)
    if gem then
        local view = gem:GetView()
        view:StartAnimation("highlight")
		
		local view = GameObjectViewManager:Construct("Sprite","ZGSL")
		view:StartAnimation("stand")
		gem:AddOverlay("Select", view, 0, 0)
    end
end
