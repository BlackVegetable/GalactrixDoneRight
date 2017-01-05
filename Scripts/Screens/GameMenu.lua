class "GameMenu" (cGameMenu)

local FX = import("FXContainer")
local CRH = import "CoroutineHelpers"

--local SP = import("Steve_Profile")

function GameMenu:__init()
	super()
	LOG("Init Game Menu")

	self.popup_id = 0
	
    self.energyList = {"weapon","engine","cpu"}
    -- set the worlds view object (this screen doesnt use a world view object)
    -- world:SetView( GameObjectViewManager:Construct("Sprite",'MapView') )

	self.bg_effect = 1
	self.pone_effect = 1
	self.ptwo_effect = 1
	
	self.effect_alpha = 100
	
	self.effect_counters = {[1]=1,[2]=1,["bg"]=1}
	
	self.effect_counter = 1
	

	self.time_delta = 0
	

	self.show_items = 0
end


function GameMenu:Open(sourceMenu,sourceObject,battleGround,event,questID,objectiveID,gemList,cost,cargo,itemID,rumorID,rumorCost,rumorReward)
	
	--SP.SP_Profile(1,"Opening GameMenu")
	
	self.sourceMenu = sourceMenu  
	self.sourceObject = sourceObject

	self.active_items={{},{}}	

	self:PlatformVars()
	self.uiInited = false
	self.waiting_to_quit = false
	--SP.SP_Profile(1,"Set up Platform Vars")

	self.world =  nil
	if type(battleGround)=="string" then
		--purge_garbage()
		self.world = GameObjectManager:Construct(battleGround)
	else--MP battleGround already constructed by host
		self.world = battleGround
	end

	--SP.SP_Profile(1,"Constructed Battleground")
	
	--ShowMemUsage("GameMenu Open 02")
	self:Initialize(self.world.xml)
   self:SetWorld(self.world)			

   --SP.SP_Profile(1,"Set up World")
   
	self.questID = questID
	self.objectiveID = objectiveID	
	
	if gemList and cost and cargo then
		self.world:SetMiningInfo(sourceObject,gemList,cost,cargo)
	end
	
	if itemID then
		LOG("GameMenu itemID "..tostring(itemID))
		self.world:SetCraftingInfo(sourceObject, itemID, cost)
	end
	
	if rumorID then
		self.world:SetRumorInfo(sourceObject, rumorID, rumorCost, rumorReward)
	end
	
	if IsGamepadActive() then
		self.ui_loc = 1 -- on the board
	end
	
	LOG(string.format("onopen memory at %d",gcinfo()))

	--SP.SP_Profile(1,"About to send gamestart event")
	
	if event then
		GameEventManager:Send(event,self.world)
	end

	self.last_time = GetGameTime()
	--SP.SP_Profile(1,"Gamestart event sent")
	

	_G.Hero:SetPlayerTurnCounter(0)	

	return Menu.Open(self)
end



function GameMenu:OnKey(key, user)
	LOG("GameMenu OnKey")
	close_custompopup_menu()	
    if key == self.exit_key then
    	
    	if self.world.state ~= _G.STATE_GAME_OVER then
	    	function QuitConfirm(confirmed)
	
	    		if (confirmed) then
	    			
	    			self.waiting_to_quit = true
					
					if self.world.state >= STATE_IDLE and self.world.state <= _G.STATE_USER_INPUT_PLAYER then
						self:CheckQuitGame()
	    			end
	    			  						
					--[[
					LOG("STATE_GAME_OVER")
					self.world.state = STATE_GAME_OVER
				
					local event = GameEventManager:Construct("GameEnd")
					local nextTime = GetGameTime() + self.world:GetAttribute("game_end_delay")
					GameEventManager:SendDelayed( event, self.world, nextTime )
					--]]
				end
	    	end
			LoadAssetGroup("AssetsButtons")		
			--open_yesno_menu("[QUIT]", self.world:GetAttribute("quit_msg"), QuitConfirm, "[YES]", "[NO]" )
			_G.GLOBAL_FUNCTIONS.Pause.Open("GameMenu","[QUIT]", self.world:GetAttribute("quit_msg"), QuitConfirm, "[YES]", "[NO]" )
    	end
		
        return Menu.MESSAGE_HANDLED
			
	elseif _G.DEBUGS_ON and key == self.victory_key  then
		--LOG("Create keyEndBattle event")
		local keyEndEvent = GameEventManager:Construct("KeyEndBattle")
		keyEndEvent:SetAttribute("result",self.world.my_player_id)
		--LOG("send event")
		GameEventManager:Send(keyEndEvent)						
			
		--self.world:HandleEndGame(1)

	elseif _G.DEBUGS_ON and key == self.lose_key then	
		local keyEndEvent = GameEventManager:Construct("KeyEndBattle")
		local opponent_player_id = 1
		if self.world:NumAttributes("Players")==2 then
			opponent_player_id = 2
		else
			opponent_player_id = 0
		end		
		keyEndEvent:SetAttribute("result",opponent_player_id)
		GameEventManager:Send(keyEndEvent)
		--self.world:HandleEndGame(0)
	elseif _G.DEBUGS_ON and key == self.gemcheat_key  then
		self.world:DebugChangeGem()
	end

    return Menu.MESSAGE_NOT_HANDLED
end

function GameMenu:CheckQuitGame()
	local world = self.world
	if self.waiting_to_quit then
		self.waiting_to_quit = nil
		local host_player_id = _G.Hero:GetAttribute("player_id")
		if mp_is_host() then
			if host_player_id == 1 then
				host_player_id = 2
			else
				host_player_id = 1
			end
		end		
		local function QuitBattle()
		--dump_loaded_texts()
		--dump_loaded_assetgroups()
		--MemLeak.end_cpp_analysis()
			local keyEndEvent = GameEventManager:Construct("KeyEndBattle")
			keyEndEvent:SetAttribute("result",-1)
			keyEndEvent:SetAttribute("sender",_G.Hero:GetAttribute("player_id"))
			keyEndEvent:SetAttribute("host",host_player_id)
			GameEventManager:Send(keyEndEvent)    				
		end
		
		local statHero = self.world:GetAttributeAt("Players",1)
		
		local oldLevel = statHero:GetLevel(statHero:GetAttribute("intel") - statHero.matchCount.intel)
		local newLevel = statHero:GetLevel()
		
		if _G.GLOBAL_FUNCTIONS.DemoMode() and newLevel > 5 then
			newLevel = oldLevel
		end		
		
		if not world.mp and  statHero:GetAttribute("ai") ~= 1 and oldLevel < newLevel then
			statHero:SetAttribute("stat_points", statHero:GetAttribute("stat_points") + (5*(newLevel-oldLevel)))
			SCREENS.GameMenu:HideWidgets()
			SCREENS.LevelUpMenu:Open(QuitBattle)
			self.levelUp = true
		else
			if statHero:GetAttribute("intel") > 13300 then
				statHero:SetAttribute("intel", 13300)
			end
			QuitBattle()
		end
		
		return true
	else
		return false
	end		
end

-------------------------------------------------------------------------------------------------------
--
--   				GameMenu:CacheIds()
--
-------------------------------------------------------------------------------------------------------
local icon_player_turn_1 = 2001
local icon_player_turn_2 = 2002
local icon_turnlight_1 = 2003
local icon_turnlight_2 = 2004
	
local butt_item = 0 -- Player #1... items 1-8
	
local icon_item_weapon = 2000 -- Player #n... items 1-8
local icon_item_engine = 2020 -- Player #n... items 1-8
local icon_item_cpu    = 2040 -- Player #n... items 1-8
local icon_item        = 2060 -- Player #n... items 1-8
local progress_recharge= 2080 -- Player #n... items 1-8
local str_item_recharge= 2100 -- Player #n... items 1-8
local icon_item_back   = 2120 -- Player #n... items 1-8 
local str_item_weapon  = 2140 -- Player #n... items 1-8
local str_item_engine  = 2160 -- Player #n... items 1-8
local str_item_cpu     = 2180 -- Player #n... items 1-8
local icon_item_energy     = 2200 -- Player #n... items 1-8
	
function GameMenu:CacheIds()
	
	self:set_widget_id("player_turn_1",icon_player_turn_1)
 	self:set_widget_id("player_turn_2",icon_player_turn_2)
 	self:set_widget_id("icon_turnlight_1",icon_turnlight_1)
	self:set_widget_id("icon_turnlight_2",icon_turnlight_2)
	
	for p=1,2 do
		for i=1,8 do
			local offset = 10*p+i
			self:set_widget_id( string.format("item_%d_weapon_%d",i,p), icon_item_weapon+offset)
			self:set_widget_id( string.format("item_%d_engine_%d",i,p), icon_item_engine+offset)
			self:set_widget_id( string.format("item_%d_cpu_%d",i,p),    icon_item_cpu+offset)
			self:set_widget_id( string.format("item_%d_weapon_%d_req",i,p), str_item_weapon+offset)
			self:set_widget_id( string.format("item_%d_engine_%d_req",i,p), str_item_engine+offset)
			self:set_widget_id( string.format("item_%d_cpu_%d_req",i,p), str_item_cpu+offset)
			self:set_widget_id( string.format("item_%d_icon_%d",i,p),    icon_item+offset)
			self:set_widget_id( string.format("progbar_%d_recharge_%d",i,p), progress_recharge+offset)
			self:set_widget_id( string.format("item_%d_recharge_%d",i,p), str_item_recharge+offset)
			self:set_widget_id( string.format("item_back_%d_%d",i,p), icon_item_back+offset)
			self:set_widget_id( string.format("item_%d_energy_%d",i,p), icon_item_energy+offset)
		end
	end
	
end
-------------------------------------------------------------------------------------------------------



function GameMenu:TurnEnded()
	--Does nothing on PC
end


function GameMenu:RumblePlayer()
	--Does nothing on PC
end


function GameMenu:OnOpen()
 	LOG("Open Game MENU")
	
	--self:CacheIds()

	add_text_file("EffectText.xml")	
	--add_text_file("ItemText.xml")
	add_text_file("CrewText.xml")
	
	
	if _G.is_open("SinglePlayerMenu") then
		SCREENS.SinglePlayerMenu.stopMusic = true
	end		
    Sound.StopMusic();
 
   self:InitWirelessStatus()

	return cGameMenu.OnOpen(self)
end

function GameMenu:OnClose()
	LOG("GameMenu:OnClose")
	close_custompopup_menu()--kill all info popups
	
	_G.GLOBAL_FUNCTIONS.Pause.Close(false, false)
	--close_yesno_menu(false,false)
	
	if _G.is_open("TutorialMenu") then
		SCREENS.TutorialMenu:Close()
	end
	
	--BEGIN_STRIP_DS
	local function WiiGamepadOff()
		SetIsGamepadActive(false)	
	end
	WiiOnly(WiiGamepadOff)
	--END_STRIP_DS	
	
	return cGameMenu.OnClose(self)
end

function GameMenu:Finalize()
	FX.StopAll()
	--FX.Close()
	CRH.KillAll()
	
	--SCREENS.YesNoMenu:CloseMenu()
	if _G.is_open("TutorialMenu") then
		SCREENS.TutorialMenu:Close()
	end
	
	
	if self.world then
		
		--self.world:GetAttributeAt('Players',playerID)
	
		self.world:ClearAttributeCollection("Players")	
		
		--LOG(string.format("Gems left over %d", self.world.gem_count))	
		local num_children = self.world:GetNumChildren()
		--ShowMemUsage(string.format("Before GameMenu world destroyed num_children: %d",num_children))
		if self.world.host then
			self.world:DestroyObjects()
			self:SetWorld(nil)		
			GameObjectManager:Destroy(self.world)
		end
		
		self.world = nil
	end
	LOG("World Destroyed")
	ClearAutoLoadTables()
	_G.INIT_BATTLEGROUND = nil
	purge_garbage()

end

function GameMenu:OnAnimShowNextGem()
	LOG("OnAnimShowNextGem()")
	
	self.update_sequence = true
	
	return Menu.MESSAGE_HANDLED
end


function GameMenu:OnAnimSlideGems()
	LOG("OnAnimSlideGems()")
	
	self.update_sequence = true
	
	return Menu.MESSAGE_HANDLED
end

function GameMenu:OnAnimMadeMove()
	local gemTable = {  }
	gemTable[0] = "red"
	gemTable[1] = "green"
	gemTable[2] = "purple"
	gemTable[3] = "blue"
	gemTable[4] = "yellow"
	gemTable[5] = "red"
--[[
	table.insert(gemTable, "red")
	table.insert(gemTable, "green")
	table.insert(gemTable, "purple")
	table.insert(gemTable, "blue")
	table.insert(gemTable, "yellow")
	table.insert(gemTable, "red")
]]--
	if not self.gemCycle then
		self.gemCycle = 4
	else
		self.gemCycle = self.gemCycle - 1
		if self.gemCycle < 0 then
			self.gemCycle = 5
		end
	end
	
	for i=1,6 do
		local i_val = i
		while i_val + self.gemCycle >= 7 do
			i_val = i_val - 6
		end
		LOG("I_Val = " .. tostring(i_val))
		self:set_image(string.format("icon_gem%d", i), string.format("img_rumor_%s", gemTable[math.mod(i+self.gemCycle,6)]))
	end
	return Menu.MESSAGE_HANDLED
end

function GameMenu:UpdateEffects(obj,counter,tag)
	
	
	local num_effects = obj:NumAttributes("Effects")
		
	if num_effects > 0 then
		counter = counter + 1
		if counter > num_effects then
			counter = 1
		end

		self:set_image(string.format("icon_%s",tag),obj:GetAttributeAt("Effects",counter):GetAttribute("icon"))
		self:set_text_raw(string.format("str_%s",tag), tostring(obj:GetAttributeAt("Effects",counter):GetAttribute("counter")))
		self:activate_widget(string.format("pad_%s",tag))
	else
		self:set_image(string.format("icon_%s",tag),"")
		self:set_text_raw(string.format("str_%s",tag),"")	
		self:hide_widget(string.format("pad_%s",tag))
	end

	--self:set_alpha("str_"..tag,self.effect_alpha)
	
	return counter
end

function GameMenu:OnGainFocus()
	LOG("OnGainFocus - pause = false")
	if self.world then
		self.world.pause = false
	end
	return cGameMenu.OnGainFocus(self)
end

function GameMenu:OnAnimOpen(data)

	Graphics.FadeFromBlack()

	return Menu.MESSAGE_HANDLED	
end

dofile("Assets/Scripts/Screens/GameMenuPlatform.lua")

return ExportSingleInstance("GameMenu")
