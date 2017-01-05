-------------------------------------------------------------------------------
--
--   InitBattleground.lua
--
--		Code to hand back some initialized tables with generic values
--
-------------------------------------------------------------------------------


--local SP = import("Steve_Profile")
local CRH = import "CoroutineHelpers"

local GRID_CENTER = 28 -- Matches value in HexBattleground.lua
local CHECK_SIDES = 3-- Matches value in HexBattleground.lua
local HEX_GRIDS =55-- Matches value in HexBattleground.lua

local function Init(world)
	world.movement_end_delay = true

	world.moveDir = 4
	world.gemMovements = {{0,10},{9,5},{9,-5},{0,-10},{-9,-5},{-9,5}}
	world.movingGems={}

	-- Standard Battle Gems List
	world.ui = "UI"
	world.baseGems={["GDMG"]=4,["GDM3"]=3,["GDM5"]=1,["GDMX"]=1,["GSHD"]=7,["GWEA"]=7,["GCPU"]=7,["GENG"]=7,["GPSI"]=7,["GINT"]=7}



	world:InitGemList()
	world.patternList={["PMT1"]=1,["PMT3"]=2,["PMT4"]=3,["PMT5"]=4,["PMT6"]=5,["PMT7"]=6,["PMT8"]=7}--,["PLAR"]=8,["PRAR"]=9,["PXWG"]=10,["PHEX"]=11,["PFLC"]=12}

	world.numGrids = 55
	world.numMatchGrids = 71
	world.numMatchGridsToCheck = 69
	world.matchGrid2Grid = {1,2,3,0,0,0,0,
							4,5,6,7,8,9,0,0,
							10,11,12,13,14,15,16,0,
							17,18,19,20,21,22,23,24,0,
							25,26,27,28,29,30,31,0,
							32,33,34,35,36,37,38,39,0,
							40,41,42,43,44,45,46,0,0,
							47,48,49,50,51,52,0,0,0,0,
							53,54,55}
	world.grid2MatchGrid = {}
	for i=1,world.numMatchGrids do
		if world.matchGrid2Grid[i] >0 then
			world.grid2MatchGrid[world.matchGrid2Grid[i]] = i
		end
	end


	world.numMatchColumns = 9
	world.matchColumn = {1,8,16,24,33,41,50,59,69}
	world.matchColumnSize = {2,5,6,7,6,7,6,5,2}
	world.dir2add = {-1,8,9,1,-8,-9}

	world.edgeGrids = {}
	world.edgeGrids[1]={1,4,10,17,25,32,40,47,53}
	world.edgeGrids[2]={17,32,40,47,48,53,54,55,52}
	world.edgeGrids[3]={47,53,54,55,51,52,46,39,24}
	world.edgeGrids[4]={3,9,16,24,31,39,46,52,55}
	world.edgeGrids[5]={4,1,2,3,8,9,16,24,39}
	world.edgeGrids[6]={32,17,10,4,5,1,2,3,9}

	world:InitCoords()
	--InitCoords(world)

	world.matchEvent = "Award"--HackAward for hacking mini game

	world.numClearEvents = 0
	world.clearEvents = {}


	world.turn = {}
	world.turn.matchCount = {0,nil,0,0,0,0,0,0} -- this will count matches matches[4]++ for 4 or a kind.
	--world.turn.patterns = {}
	world.turn.patternCount = {}
	for v,i in pairs(world.patternList) do
		world.turn.patternCount[v]=0 --patternCount["PARR"]=0
	end

	world.turn.chainCount = -1


	world.music = {[1]={"music_ambe01","music_ambe02","music_ambe03","music_ambe04","music_ambe05","music_ambe06","music_ambe07","music_ambe08","music_ambe09","music_ambe10","music_ambe11","music_ambe12","music_ambo05","music_ambo06","music_ambo14","music_ambo15","music_ambo16","music_ambo17","music_ambo18"};
				  [2]={"music_drone1","music_drone2","music_drone3","music_drone4","music_drone5","music_drone6","music_drone7"};
				  [3]={"music_boss0","music_boss4"}}
	if _G.GLOBAL_FUNCTIONS.DemoMode() then
		world.music = {[1]={"music_ambe01","music_ambe02"};
					  [2]={"music_drone1"};
					  [3]={"music_ambe01"}}
	end
	if world:NumAttributes("Players") > 1 and HEROES[world:GetAttributeAt("Players", 2).classIDStr].boss then
		world.music_selection = 3
	else
		world.music_selection = 1
	end

	world.aboutToWin = false
	world.aboutToLose = false

	world.gateHacked = false
	world.hackPattern = nil

	world.fillList = nil
	world.effects = {"damage","shield","engine","weapon","cpu","intel","psi","other"}

	world.xml = "Assets\\Screens\\BattleGameMenu.xml"

	world.gp_grid = GRID_CENTER
	world.gp_dir = 1

	world.inputMsgs = {}
	world.inputMsgs[_G.STATE_USER_INPUT_GEM] = {[0]="[SELECT_GEM]", [1] = "[AI_SELECT_GEM]"}
--	world.inputMsgs[_G.STATE_USER_INPUT_PLAYER] = {[0]="[SELECT_PLAYER]", [1] = "[AI_SELECT_PLAYER]"}

	world.multiplier = 1
	world.gems = {}


	--SETUP MP
	world.mp = nil

	world.host = mp_is_host()
	world.my_id = mp_get_my_id() -- _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_my_id)
	world.host_id = mp_get_host_id() --_G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_host_id)

	world.moveListIdx = 0
	world.find_done = 0

	world.hint_delay = Settings:Read("hint_arrow", 10)
	LOG("world.hint_delay = " .. world.hint_delay)

	world.preProcessLists = false

	world.gem_count = 0 -- test to see if all gems created are destroyed

	world.receivedAdvanceStateMsg = false

	world.turn_delay = 0


	world.drag_threshold = 1000

end

local function InitGemPool(world, poolSize)
	if not poolSize then
		poolSize = 55
	end

	-- gem pool (avoid constructing gems on the fly by preallocating all gems up front)
	-- don't attempt to use this for MP
	world.gemPool = {}
	world.gemAllocCount = 0


	for i=1,poolSize do
		local gem = GameObjectManager:Construct("Gems")
		world.gemPool[gem] = gem
	end

	LOG(string.format("Initialised gem pool with %d gems", poolSize))
end

local function RemoveMatches(world)
end


-- Set up: world.numGems, world.numGemTypes, mapping table between the two
--         world.patternTypes, mapping between n-of-a-kind & patterns
--		   world.matchList = {}, world.matchListIdx
--		   world.board = {}
local function PreProcessLists(world)

	--LOG("BattleGround:PreProcessLists entry")
	-- Set up some lengths
	world.preProcessLists = true
	world.gem2gemType = {}
	world.match2patternType = {}
	world.numGems = 0
	world.gemTagList = {}
	for k,v in pairs(world.baseGems) do
		world.numGems = world.numGems + 1
		world.gemTagList[world.numGems] = k
		--LOG("BattleGround:PreProcessLists Getting gemTagList: "..k)
	end
	world.maxHexes = 71

	--LOG("BattleGround:PreProcessLists world.numGems="..world.numGems)

	-- Figure out the gemtype mapping
	local doneGem = {}
	for i=1,world.numGems do
		doneGem[i] = false--this loop isn't necessary - or should at least be moved to previous loop
	end
	local nextGemTypeIdx = 1
	world.allCanMatch = true
	for i=1,world.numGems do
		if not doneGem[i] then
			local theGem = _G.GEMS[ world.gemTagList[i]]
			if theGem.matchable==0 then
				world.gem2gemType[theGem.id] = 0
				world.allCanMatch = false
				--LOG("BattleGround:PreProcessLists 0 world.gem2gemType["..theGem.id.."]=0")
			else
				world.gem2gemType[ theGem.id ] = nextGemTypeIdx
				--LOG("BattleGround:PreProcessLists a world.gem2gemType["..theGem.id.."]="..nextGemTypeIdx)
				for j=i, world.numGems do
					local thisGem = _G.GEMS[ world.gemTagList[j] ]
					if i ~= j and theGem.GemMatch[thisGem.id] then
						doneGem[j] = true
						world.gem2gemType[thisGem.id] = nextGemTypeIdx
						--LOG("BattleGround:PreProcessLists b world.gem2gemType["..thisGem.id.."]="..nextGemTypeIdx)
					end
				end
				nextGemTypeIdx = nextGemTypeIdx + 1
			end
			doneGem[i] = true
		end
	end
	world.numGemTypes = nextGemTypeIdx
	world.gemType2Gem = {}
	for k,v in pairs(world.gem2gemType) do
		world.gemType2Gem[v] = k
	end

	-- Swappable Gems
 	world.canSwap = {}
	world.allCanSwap = true
	for i=1,world.numGems do
		local theGem = _G.GEMS[ world.gemTagList[i] ]
		if theGem.swapable==0 then
			world.canSwap[world.gem2gemType[ theGem.id ]] = false
			world.allCanSwap = false
		else
			world.canSwap[world.gem2gemType[ theGem.id ]] = true
		end
	end

	-- Figure out pattern-type matching
	for i=1,8 do
		--if (world.patternList["PMT"..tostring(i)]) then
		--	world.match2patternType[i] = world.patternList["PMT"..tostring(i)]
		--else
			world.match2patternType[i] = "PMT"..tostring(i)
		--end
	end

	-- The matchlist only gets cleared once... now
	-- I've set it to 8. Unlikely it will grow any bigger, but it always can if it needs to
	world.matchList = {}   -- idx, num, dir
	world.matchListIdx = 0
	for i=1,8 do
		local myMatch = {}
		myMatch.matchIdx = 0
		myMatch.idx = 0
		myMatch.num = 0
		myMatch.dir = 0
		world.matchList[i] = myMatch
	end


	-- So too with the board
	world.board = {}
	world.doneBoard1 = {}
	world.doneBoard2 = {}
	world.doneBoard3 = {}
	for i=1,world.maxHexes do
		world.board[i] = 0
		world.doneBoard1[i] = false
		world.doneBoard2[i] = false
		world.doneBoard3[i] = false
	end

 	-- The moveList only gets cleared once... now
	-- I've set it to 20. It may grow bigger...
	world.moveList = {}   -- grid1, grid2, weight
	world.moveListIdx = 0
 	for i=1,20 do
 		local myMoveList = {}
		 myMoveList.grid1 = 0
		 myMoveList.grid2 = 0
		 myMoveList.weight = 0
		world.moveList[i] = myMoveList
	end
	world.bestMoveInList = 0
	world.weightList = {10,10,10,15,4,4,27,27,27,27,1,1}--what are 11,12?
	world.randomWeighting = 0
	world.gemCounts = {0,0,0,0,0,0,0,0,0,0,0,0}

	world.doNotDestroy = {}
end




local function InitBattleStats(hero)

	_G.Blog("InitBattleStats()")
	local ship = hero:GetAttribute("curr_ship")
	assert(ship ~= nil)
	hero:SetAttribute("life_max",ship:GetAttribute("hull") + (hero:GetLevel()-1))--derived from level/stats
	hero:SetAttribute("life",hero:GetAttribute("life_max"))
	hero:SetAttribute("shield_max",ship:GetAttribute("shield") + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),4.0)))
	hero:SetAttribute("shield",ship:GetAttribute("shield") + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),3.0)))
	hero:SetAttribute("weapon_max",15 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("gunnery"),2.0)))
	hero:SetAttribute("weapon",5 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("gunnery"),1.0)))
	hero:SetAttribute("engine_max",15 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("engineer"),2.0)))
	hero:SetAttribute("engine",5 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("engineer"),1.0)))
	hero:SetAttribute("cpu_max",15 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("science"),2.0)))
	hero:SetAttribute("cpu",5 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("science"),1.0)))
	hero:SetAttribute("seq_pos",1)
	hero:SetAttribute("cargo_food",0)
	hero:SetAttribute("cargo_textiles",0)
	hero:SetAttribute("cargo_minerals",0)
	hero:SetAttribute("cargo_alloys",0)
	hero:SetAttribute("cargo_tech",0)
	hero:SetAttribute("cargo_luxuries",0)
	hero:SetAttribute("cargo_medicine",0)
	hero:SetAttribute("cargo_gems",0)
	hero:SetAttribute("cargo_gold",0)
	hero:SetAttribute("cargo_contraband",0)
	hero:SetAttribute("mining", _G.GLOBAL_FUNCTIONS.EngineeringMiningBonus(hero:GetCombatStat("engineer")))
	hero.longest_chain = 0
	hero.damage_done = 0
	hero.damage_received = 0
	hero.novas = 0
	hero.supanovas = 0
	hero.matchCount = {0,0,0,0,0,0,0,0, intel = 0, psi = 0}
	hero.matchBonus = {weapon = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("gunnery"),0.2)),
							 engine = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("engineer"),0.2)),
							 cpu =    math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("science"),0.2)),
							 shield = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),0.6)),
							 food = hero:GetAttribute("mining"),
							 textiles = hero:GetAttribute("mining"),
							 minerals = hero:GetAttribute("mining"),
							 alloys = hero:GetAttribute("mining"),
							 tech = hero:GetAttribute("mining"),
							 luxuries = hero:GetAttribute("mining"),
							 medicine = hero:GetAttribute("mining"),
							 gems = hero:GetAttribute("mining"),
							 gold = hero:GetAttribute("mining"),
							 contraband = hero:GetAttribute("mining")
							 }


	local numItems = ship:NumAttributes("battle_items")
	for i=1, numItems do
		LOG ("MEEPO")
		ship:GetAttributeAt("battle_items",i).inactive = 0
	end

	hero:ClearAttributeCollection("Effects")

	local loadout = Hero:GetAttributeAt("ship_list",Hero:GetAttribute("ship_loadout"))
	local curr_ship = hero:GetAttribute("curr_ship")
	local gun = hero:GetAttribute("gunnery")
	local sci = hero:GetAttribute("science")
	local eng = hero:GetAttribute("engineer")
	local pil = hero:GetAttribute("pilot")
	local psi = hero:GetAttribute("psi")
	local RBonus = 0
	local GBonus = 0
	local YBonus = 0
	local SBonus = 0
	local HBonus = 0


	if CollectionContainsAttribute(loadout,"items","I033") then
		RBonus = RBonus + 15 + math.floor(gun / 30)
	end
	if CollectionContainsAttribute(loadout,"items","I037") then
		YBonus = YBonus + 10 + math.floor(eng / 30)
	end
	if CollectionContainsAttribute(loadout,"items","I038") then
		SBonus = SBonus + 10 + math.floor(pil / 30)
	end
	if CollectionContainsAttribute(loadout,"items","I039") then
		SBonus = SBonus + 10 + math.floor(hero:GetLevel() / 8)
	end
	if CollectionContainsAttribute(loadout,"items","I040") then
		RBonus = RBonus + 25 + math.floor(gun / 40)
	end
	if CollectionContainsAttribute(loadout,"items","I041") then
		YBonus = YBonus + 10 + math.floor(eng / 40)
		GBonus = GBonus + 10 + math.floor(eng / 40)
	end
	if CollectionContainsAttribute(loadout,"items","I042") then
		GBonus = GBonus + 15 + math.floor(sci / 40)
	end
	if CollectionContainsAttribute(loadout,"items","I043") then
		SBonus = SBonus + 5 + math.floor(pil / 30)
	end
	if CollectionContainsAttribute(loadout,"items","I045") then
		if psi <= 2500 then
			RBonus = RBonus + 15 + math.floor(psi / 250)
			GBonus = GBonus + 15 + math.floor(psi / 250)
			YBonus = YBonus + 15 + math.floor(psi / 250)
		else
			RBonus = RBonus + 25
			GBonus = GBonus + 25
			YBonus = YBonus + 25
		end
	end
	if CollectionContainsAttribute(loadout,"items","I047") then
		if psi <= 2500 then
			RBonus = RBonus + 20 + math.floor(psi / 250)
			GBonus = GBonus + 20 + math.floor(psi / 250)
		else
			RBonus = RBonus + 30
			GBonus = GBonus + 30
		end
	end
	if CollectionContainsAttribute(loadout,"items","I048") then
		RBonus = RBonus + 10 + math.floor(sci / 20)
		YBonus = YBonus + 10 + math.floor(sci / 20)
	end
	if CollectionContainsAttribute(loadout,"items","I071") then
		RBonus = RBonus + 10 + math.floor(eng / 20)
		GBonus = GBonus + 10 + math.floor(eng / 20)
	end
	if CollectionContainsAttribute(loadout,"items","I073") then
		YBonus = YBonus + 15 + math.floor(eng / 40)
	end
	if CollectionContainsAttribute(loadout,"items","I075") then
		SBonus = SBonus + 20 + math.floor(pil / 30)
	end
	if CollectionContainsAttribute(loadout,"items","I328") then
		HBonus = HBonus + 5
	end
	if CollectionContainsAttribute(loadout,"items","I329") then
		HBonus = HBonus + 15
	end
	if CollectionContainsAttribute(loadout,"items","I330") then
		HBonus = HBonus + 20
	end
	if CollectionContainsAttribute(loadout,"items","I331") then
		if curr_ship:NumAttributes("battle_items") <= 4 then
			HBonus = HBonus + 20 + math.floor(sci / 20)
		end
	end
	if CollectionContainsAttribute(loadout,"items","I332") then
		if curr_ship:NumAttributes("battle_items") <= 4 then
			HBonus = HBonus + 25 + math.floor(eng / 20)
		end
	end



	local oldShield = hero:GetAttribute("shield_max")
	local oldYellow = hero:GetAttribute("engine_max")
	local oldRed = hero:GetAttribute("weapon_max")
	local oldGreen = hero:GetAttribute("cpu_max")
	local oldHull = hero:GetAttribute("life_max")
	local oldCHull = hero:GetAttribute("life")

	hero:SetAttribute("shield_max", oldShield + SBonus)
	hero:SetAttribute("engine_max", oldYellow + YBonus)
	hero:SetAttribute("weapon_max", oldRed + RBonus)
	hero:SetAttribute("cpu_max", oldGreen + GBonus)
	hero:SetAttribute("life_max", oldHull + HBonus)
	hero:SetAttribute("life", oldCHull + HBonus)
	--hero:GetAttribute("curr_ship"):UpdateItems(hero:GetAttributeAt("ship_list", 1))

end


local function InitBattle(world)
    _G.Blog("InitBattle")

    world.lenWeight={[3]=5,[4]=6,[5]=7}

    math.randomseed(GetGameTime())

    world.hexAdjacent, world.hexPts, world.hexBlackHole, world.hexOddRow = world:InitGrid()
    world.gems = {}

    world.gemIndex = {}
    --set up gem Index - maps x,y grid position to grid[index]
    for i=1, HEX_GRIDS do
        if not world.gemIndex[world.hexPts[i][1]] then
            world.gemIndex[world.hexPts[i][1]]={}
        end
        world.gemIndex[world.hexPts[i][1]][world.hexPts[i][2]] = i
    end
    world:InitMatchList()
    world.g1 = nil
    world.g2 = nil
    --world.spawn = {{0,69},{60,35},{60,-34},{0,-69},{-60,-34},{-60,35}}--positions for gems to spawn in each direction.
    world.spawn = {{0,60},{50,25},{50,-24},{0,-60},{-50,-24},{-50,25}}--positions for gems to spawn in each direction.
    world.inverseDir = {4,5,6,1,2,3} --maps the adjacent grid index to to the inverse.

    world.turn = {}
    world.turn_count = 0
	world.turn.turns = 1

    world:ResetTurn()

	world.ds = false


	world.item_skip_end_turn = false
	world.user_input_dest = nil

	world.text_extra_x = 512
	world.text_extra_y = 400
	world.text_message_x = 512
	world.text_message_y = 350

    world.nova_x = 512
	world.nova_y = 384

	world.nova_offset_1 = 70
	world.nova_offset_2 = -60

	world.offset_x = 0
	world.offset_y = 0
	_G.ENEMY_STUNNED = false
	_G.TOTAL_TURNS = 0

end





local function FillGrid(world, fillList, coro_id)

	--SP.SP_Start(4,"FillGrid Entry")

 	--ShowMemUsage("FillGrid 01")
	LOG("Fill Grid()")

	if not world.host then
		LOG("Client Ignores FillGrid")
		return
	end

	math.randomseed(GetGameTime())

	local matchCount = 0


	if not fillList then-- If fill list doesn't exist - randomly generate board with no matches.
		fillList = {}
	   	for i=1, HEX_GRIDS do
	   		fillList[i]=world:GetRandomGemCode()--random gem spawn
			LOG(string.format("%d %s",i,fillList[i]))
	   	end

		--SP.SP_Profile(4,"Placed Initial Gems")


			--SP.SP_Profile(4,"Eliminating Matches")

		 	matchCount = matchCount + 1
		   	--LOG(string.format("FillGrid %d",matchCount))


		   	--foreach grid
		    for i=1, HEX_GRIDS-2 do--MAX 53 Iterations
				local myGrid = i
				local baseGem = _G.GEMS[fillList[myGrid]]
				--LOG(string.format("Grid %d",i))
				if baseGem.matchable ~= 0 then
					local baseType = baseGem.id

					   --check relevant grid directions
				   	for d=2, CHECK_SIDES+1 do-- MAX 3 Iterations
					   	myGrid = i --reset to grid i
					   	local markIt = false
					   	local myMatches = 1
					   	local done = false
						while (not done and (world.hexAdjacent[myGrid][d] ~= -1)) do--MAX 3 Iterations

							--get next grid in direction d
							local myPrevGrid = myGrid
							myGrid = world.hexAdjacent[myGrid][d]

							--if next grid doesn't match basetype
							if not baseGem.GemMatch[GEMS[fillList[myGrid]].id] then
								done = true
							else
								myMatches = myMatches + 1
							   	--if 3 matches in a row
							   	if (myMatches == 3) then
								   	done = true
								   	fillList[myPrevGrid]= world:SpawnUnmatchedGem(fillList,myPrevGrid)

							   	end
							end
						end
				   	end
			   	end
				--assert(coro_id,"no coroutine id")
				--CRH.CheckYield(coro_id) -- YIELD ???
			end

		world:PostProcessFillList(fillList)
	end
   --use fill list to specify gems on board

   --SP.SP_Profile(4,"FillGrid Got List")

   local fill_grid_sequence = { 28,
							   	27,35,36,29,21,20,
							   	19,26,34,42,43,44,37,30,22,14,13,12,
							    11,18,25,33,41,48,49,50,51,45,38,31,23,15,8,7,6,5,
							    4,10,17,32,40,47,53,54,55,52,46,39,24,16,9,3,2,1}


	local gemEvent = GameEventManager:Construct("CreateGems")
	for i=1, HEX_GRIDS do
	--for _,i in pairs(fill_grid_sequence) do
		--local gemEvent = GameEventManager:Construct("CreateGems")
		local gem = nil
		if fillList[i] then
			gemEvent:PushAttribute("gem_code",fillList[i])
		else
			gemEvent:PushAttribute("gem_code","GNIL")
		end
		gemEvent:PushAttribute("grid_id",i)

   		--local endX = world.hexPts[i][1]
   		--local endY = world.hexPts[i][2]
   		local spawnGrid = world.hexBlackHole[i][1]
   		local spawnDir = world.hexBlackHole[spawnGrid][2]
		local spawnX = world.hexPts[spawnGrid][1]
   		local spawnY = world.hexPts[spawnGrid][2]

   		--gem:SetPos(spawnX,spawnY)
   		--Adjust spawn point to outside grid
		spawnX = spawnX + world.spawn[spawnDir][1]
		spawnY = spawnY + world.spawn[spawnDir][2]


		gemEvent:PushAttribute("start_x",spawnX)
		gemEvent:PushAttribute("start_y",spawnY)

		--if math.mod(i,10)==0 then--yield every 10 iterations
			--CRH.CheckYield(coro_id) -- YIELD ???
		--end

		--world:SetBlackHoleMovement(gem,spawnX,spawnY,endX,endY)


		--[[--Multiple create event
		if i==55 then
			gemEvent:SetAttribute("normal_movement",0)--use black hole movement
		else
			gemEvent:SetAttribute("normal_movement",-1)--use black hole movement
		end

		--LOG(string.format("CreateGems Event sent to host %d",world.host_id))
		GameEventManager:Send(gemEvent,world.host_id)

		--]]
	end
	--[[--single create event--]]
	gemEvent:SetAttribute("normal_movement",0)--use black hole movement

   	--LOG(string.format("CreateGems Event sent to host %d",world.host_id))
	GameEventManager:Send(gemEvent,world.host_id)
    --]]

	--SP.SP_Profile(4,"FillGrid Exit")
end




--these are screen coordinates - not world coordinates
local function InitCoords(world)
	world.messageList = {}

    world.coords={}
    world.coords[1] = {}
    world.coords[2] = {}
    world.coords[3] = {}
	world.coords[3]["Effect"] = {510,671}

	world.coords[1]["Effect"] = {230,664}
    world.coords[1]["weapon"]={200,483}
    world.coords[1]["engine"]={195,455}
    world.coords[1]["cpu"]={190,428}
    world.coords[1]["shield"]={240,582}
    world.coords[1]["intel"]={59,406}
    world.coords[1]["psi"]={96,384}
    --world.coords[1]["damage"]={150,638}
    --world.coords[1]["damage"]={240,582}
    --world.coords[1]["ship"]={100,640}
    world.coords[1]["damage"]={156,568}
    world.coords[1]["life"]={156,568}
    world.coords[1]["key"]={890,654}
    world.coords[1]["time"]={512,674}
    world.coords[1]["hack"]={865,579}
    world.coords[1]["cargo_food"]={890,654}
    world.coords[1]["cargo_textiles"]={890,654}
    world.coords[1]["cargo_minerals"]={890,654}
    world.coords[1]["cargo_alloys"]={890,654}
    world.coords[1]["cargo_tech"]={890,654}
    world.coords[1]["cargo_luxuries"]={890,654}
    world.coords[1]["cargo_medicine"]={890,654}
    world.coords[1]["cargo_gems"]={890,654}
    world.coords[1]["cargo_gold"]={890,654}
    world.coords[1]["cargo_contraband"]={890,654}
    world.coords[1]["components_weap"]={890,654}
	 world.coords[1]["components_eng"]={890,654}
	 world.coords[1]["components_cpu"]={890,654}
    world.coords[1]["item"]={}
    world.coords[1]["item"][1]={40,407}--361}
    world.coords[1]["item"][2]={40,448}--320}
    world.coords[1]["item"][3]={40,486}--282}
    world.coords[1]["item"][4]={44,528}--240}
    world.coords[1]["item"][5]={55,567}--201}
    world.coords[1]["item"][6]={66,606}--162}
    world.coords[1]["item"][7]={84,647}--121}
    world.coords[1]["item"][8]={120,687}--81}

	world.coords[2]["Effect"] = {790,664}
    world.coords[2]["weapon"]={820,483}
    world.coords[2]["engine"]={825,455}
    world.coords[2]["cpu"]={830,428}
    world.coords[2]["shield"]={784,582}
    world.coords[2]["intel"]={960,406}
    world.coords[2]["psi"]={930,384}
    --world.coords[2]["damage"]={894,638}
    --world.coords[2]["damage"]={784,582}
    --world.coords[2]["ship"]={930,640}
    world.coords[2]["damage"]={894,568}
    world.coords[2]["life"]={894,568}
    world.coords[2]["key"]={833,596}
    world.coords[2]["time"]={512,674}
    world.coords[2]["cargo_food"]={833,596}
    world.coords[2]["cargo_textiles"]={833,596}
    world.coords[2]["cargo_minerals"]={833,596}
    world.coords[2]["cargo_alloys"]={890,654}
    world.coords[2]["cargo_tech"]={890,654}
    world.coords[2]["cargo_luxuries"]={890,654}
    world.coords[2]["cargo_medicine"]={890,654}
    world.coords[2]["cargo_gems"]={890,654}
    world.coords[2]["cargo_gold"]={890,654}
    world.coords[2]["cargo_contraband"]={890,654}
    world.coords[2]["item"]={}
    world.coords[2]["item"][1]={840,407}
    world.coords[2]["item"][2]={840,448}
    world.coords[2]["item"][3]={832,486}
    world.coords[2]["item"][4]={822,528}
    world.coords[2]["item"][5]={806,567}
    world.coords[2]["item"][6]={790,606}
    world.coords[2]["item"][7]={768,647}
    world.coords[2]["item"][8]={740,687}


	world.beamEffects = {}
	world.beamEffects["life"] 	= "BM12"
	world.beamEffects["damage"] = "BM01"
	--world.beamEffects["ship"] 	= "BM01"
	world.beamEffects["shield"] = "BM02"
	world.beamEffects["intel"] 	= "BM12"
	world.beamEffects["psi"] 	= "BM11"
	world.beamEffects["weapon"] = "BM08"
	world.beamEffects["engine"] = "BM05"
	world.beamEffects["cpu"] 	= "BM04"

	world.effectFont = {}
	world.effectFont["life"] = "font_numbers_white"
	world.effectFont["shield"] = "font_numbers_blue"
	world.effectFont["intel"] = "font_numbers_white"
	world.effectFont["psi"] = "font_numbers_purple"
	world.effectFont["weapon"] = "font_numbers_red"
	world.effectFont["engine"] = "font_numbers_yellow"
	world.effectFont["cpu"] = "font_numbers_green"

end






--local GRID_FUNCS = dofile("Assets/Scripts/BattleGrounds/InitBattlegroundGrid.lua") -- XXXX: if FillGrid is called nowhere else but OnEventGameStart then please remove this and its reference from INIT_BATTLEGROUND
local PLATFORM_FUNCS = dofile("Assets/Scripts/BattleGrounds/InitBattlegroundPlatform.lua")

local INIT_BATTLEGROUND =
{
	Init  = Init,
 	FillGrid = FillGrid,
 	PreProcessLists  = PreProcessLists,
	InitGemPool = InitGemPool,
	InitBattleStats = InitBattleStats,
	OnEventGameStart = PLATFORM_FUNCS.OnEventGameStart,
	InitCoords = InitCoords,
	InitBattle = InitBattle,
}

return INIT_BATTLEGROUND
