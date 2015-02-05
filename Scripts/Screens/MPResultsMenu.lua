use_safeglobals()


-- declare our menu
class "MPResultsMenu" (Menu);

dofile("Assets/Scripts/Screens/MPResultsMenuPlatform.lua")

function MPResultsMenu:__init()
	super()
	
	self:LoadGraphics()
   
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\MPResultsMenu.xml")
end

function MPResultsMenu:DisableRematch()
	self.rematch = false
	self:hide_widget("butt_rematch")
	self:hide_widget("check_rematch")
	self:activate_widget("butt_return")
end

local function end_callback(result)
	LOG("MPResultsMenu: end callback")
end


function MPResultsMenu:OnOpen()
	LOG("MPResultsMenu opened");
	
	self.clicked = false
	self.rematch = false
	
	local str = string.gsub(translate_text("[LIFE_REMAINING]"),":","")
	self:set_text_raw("str_life_text",str)
	str = string.gsub(translate_text("[DAMAGE_DONE]"),":","")
	self:set_text_raw("str_damage_done_text",str)
	str = string.gsub(translate_text("[LONGEST_CHAIN]"),":","")
	self:set_text_raw("str_chain_text",str)
	str = string.gsub(translate_text("[PSI_GAINED]"),":","")
	self:set_text_raw("str_psi_text",str)
	str = string.gsub(translate_text("[INTEL_GAINED]"),":","")
	self:set_text_raw("str_intel_text",str)
	str = string.gsub(translate_text("[FOUROFAKINDS_]"),":","")
	self:set_text_raw("str_fourofakinds_text",str)
	str = string.gsub(translate_text("[FIVEOFAKINDS_]"),":","")
	self:set_text_raw("str_fiveofakinds_text",str)
	str = string.gsub(translate_text("[NOVAS_]"),":","")
	self:set_text_raw("str_novas_text",str)
	str = string.gsub(translate_text("[SUPANOVAS_]"),":","")
	self:set_text_raw("str_supanovas_text",str)
	
	

	self:activate_widget("butt_return")	
	self:hide_widget("str_retry")
	self:hide_widget("butt_rematch")	
	self:set_widget_value("check_rematch",0)		
	self:hide_widget("check_rematch")	
	
	if mp_is_host() then
		self:deactivate_widget("butt_rematch")
	else
		self:activate_widget("check_rematch")		
	end
	
	if self.victory then
		LOG("victory yes "..tostring(self.victory))
		self:Victory()
	else
		LOG("victory no "..tostring(self.victory))
		self:Defeat()
	end	
	
	
	local world = SCREENS.GameMenu.world
	if world then
		for i=1, world:NumAttributes("Players") do	
			local player = world:GetAttributeAt("Players",i)
			self:SetStats(player)
		end
	elseif self.stats then
		for k,v in pairs(self.stats) do
			self:SetStats(v, k)
		end
	end
	
	--[[ SUBMIT STATS ]]
	if _G.XBOXLive then
		self:activate_widget("icon_gpy")
		self:activate_widget("str_gpy")	
					
		if _G.XBOXLive.GetProperty("game_type") == NetworkGameType.RANKED then
			self:DisableRematch()--No rematch in Ranked - return to Type/Setup?Menu
			local my_xuid = mp_get_my_id()
			local opponent_xuid = _G.XBOXLive.GetProperty("opponent_xuid")
			
			if my_xuid ~= nil and opponent_xuid ~= nil then
				
				if self.victory then
					-- handle awarding of xbox live match achievements
					local function stats_callback(t)
						if (t == nil) or (t and #t == 0) then
							return
						end
						
						table.pretty_print(t)
						
						if t[1].rating then
							if t[1].rating == 1 then
								AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_MP_1)
							elseif t[1].rating == 49 then
								AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_MP_2)
							end
						else
							LOG("Error - no victories found")
						end
					end
				
					GetStatsPlayer(stats_callback, 1, _G.XLAST.STATS_VIEW_LB_BATTLES_RANKED, { _G.XLAST.STATS_COLUMN_LB_BATTLES_RANKED_BATTLES } )
				
				
					_G.XBOXLive.SubmitStats({ { ['xuid']=my_xuid, ['score']=1, ['team']=1 }, { ['xuid']=opponent_xuid, ['score']=0, ['team']=2 } })
				else
					_G.XBOXLive.SubmitStats({ { ['xuid']=my_xuid, ['score']=0, ['team']=1 }, { ['xuid']=opponent_xuid, ['score']=1, ['team']=2 } })
				end
			end
			--FlushStats()
		end
	end
	
	--if self.victory then
	if world then
		LOG("mp_end_game()")
		mp_end_game(end_callback)
	end
	

	if _G.XBOXLive and _G.XBOXLive.GetProperty("game_type") == NetworkGameType.RANKED then
		if world then
			world.host = false
		end
		--if _G.XBOXLive.GetProperty("hosting") then
			LOG("cleanup all network bla bla")
			mp_cleanup_network_objects()
		--end
		LOG("PropertyGotten 'hosting'="..tostring(_G.XBOXLive.GetProperty("hosting")))
		mp_leave_game(_G.DoNothing)
	end
	--end
	return Menu.OnOpen(self)
end

--[[
function MPResultsMenu:SyncHeroStats(statHero)
	LOG("SyncHeroStats ".._G.Hero.classIDStr)
	LOG("Saved")
	_G.Hero:SetAttribute("stat_points",statHero:GetAttribute("stat_points"))
	_G.Hero:SetAttribute("intel",statHero:GetAttribute("intel"))
	_G.Hero:SetAttribute("psi",statHero:GetAttribute("psi"))
end
--]]


--[[

function MPResultsMenu:LevelUpStatHero()
	local world = SCREENS.GameMenu.world
	
	if not world then
		return
	end
	
	local player = world:GetAttributeAt("Players",_G.Hero:GetAttribute("player_id"))

	player:SetAttribute("gunnery",_G.Hero:GetAttribute("gunnery"))
	player:SetAttribute("engineer",_G.Hero:GetAttribute("engineer"))
	player:SetAttribute("science",_G.Hero:GetAttribute("science"))
	player:SetAttribute("pilot",_G.Hero:GetAttribute("pilot"))
	
	_G.Hero:SetToSave()
	
	
end
--]]

function MPResultsMenu:SetStats(statHero, index)	
	
	local stats, player_id
	if type(statHero) == "table" then
		stats  = statHero
		player_id = index
	elseif statHero then -- passed a Hero object
		stats = { }
		stats.intel  = statHero.matchCount.intel
		stats.psi    = statHero.matchCount.psi
		stats.life   = statHero:GetAttribute("life")
		stats.chain  = statHero.longest_chain
		stats.damage = statHero.damage_done
		stats.four   = statHero.matchCount[4]
		stats.five   = statHero.matchCount[5]
		stats.six    = statHero.matchCount[6]
		stats.seven  = statHero.matchCount[7]
		stats.novas  = statHero.novas
		stats.snovas = statHero.supanovas
		stats.name   = statHero:GetAttribute("name")
		stats.ship   = statHero:GetAttribute("curr_ship"):GetAttribute("portrait")
		player_id    = statHero:GetAttribute("player_id")
	else -- no hero
		return
	end
	
	--self:set_text_raw("str_psi_"..tostring(player_id),tostring(statHero:GetAttribute('psi')))
	self:set_text_raw(string.format("str_psi_%d",           player_id), tostring(stats.psi))
	self:set_text_raw(string.format("str_intel_%d",         player_id), tostring(stats.intel))
	self:set_text_raw(string.format("str_life_%d",          player_id), tostring(stats.life))
	self:set_text_raw(string.format("str_chain_%d",         player_id), tostring(stats.chain))
	self:set_text_raw(string.format("str_damage_done_%d",   player_id), tostring(stats.damage))
	self:set_text_raw(string.format("str_fourofakinds_%d",  player_id), tostring(stats.four))
	self:set_text_raw(string.format("str_fiveofakinds_%d",  player_id), tostring(stats.five))
	self:set_text_raw(string.format("str_sixofakinds_%d",   player_id), tostring(stats.six))
	self:set_text_raw(string.format("str_sevenofakinds_%d", player_id), tostring(stats.seven))
	self:set_text_raw(string.format("str_novas_%d",         player_id), tostring(stats.novas))
	self:set_text_raw(string.format("str_supanovas_%d",     player_id), tostring(stats.snovas))


	local nameWidget = string.format("str_name_%d",player_id)
	local myWidth = self:get_widget_w(nameWidget)
	local myName = translate_text(stats.name)
	--if myWidth <= 100 then
	--	myName = fit_text_to("font_info_gray", myName , myWidth)
	--end
	self:set_text_raw(string.format("str_name_%d", player_id), myName)
	self:set_image(string.format("icon_ship_%d", player_id),stats.ship)
	
	if _G.Hero and _G.XBOXLive then
		local name
		if _G.Hero:GetAttribute("player_id") == player_id then
			name = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResultParams(mp_get_player_name_from_ID, mp_get_my_id())
		else
			name = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResultParams(mp_get_player_name_from_ID, _G.XBOXLive.GetProperty("opponent_xuid"))
		end
		self:set_text_raw(string.format("str_gamertag_%d", player_id), name)
	end
	
	--[[
	local cargoText = ""
	local iterator = 1
	if self.cargo then
		for i,v in pairs(self.cargo) do
			if v ~= 0 then
				cargoText = cargoText .. translate_text(_G.DATA.Cargo[iterator].name) .. ": " .. tostring(math.floor(v)) .. " \n "
			end
			iterator = iterator + 1
		end
	end
	
	self:set_text_raw("str_cargo_val", cargoText)
	--]]
	
	
	
end

function MPResultsMenu:OnButton(buttonId, clickX, clickY)

	local is_host = mp_is_host()
	if not self.clicked then
		if buttonId == 1 then-- butt_return--Back To MultiplayerGameSetup	
			LOG("ButtReturn Clicked")
			self.clicked = true	
			local updateEvent = GameEventManager:Construct("UpdateMPResults")
			updateEvent:SetAttribute("quit",1)
			--LOG(string.format("Send UpdateMPResults to opponent %d",SCREENS.GameMenu.opponent_id))
			local myID = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_my_id)
			local num_players = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_num_connected_players)
			

			local opponentID
			if num_players == 2 then	
				if not is_host then
					opponentID = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_host_id)
				else
					
					opponentID = _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(2)
					
					-- What happens here if num_players ~= 2 ???
					LOG("GameMenu opponent_id 2 ="..tostring(opponentID))
				end
				
				LOG("GameMenu opponent_id ="..tostring(opponentID))
				GameEventManager:Send(updateEvent,opponentID)
			end
			local result = 0
			if self.victory then
				result = 1
			end
			self:EndGame(result)
			self:Close()
		elseif buttonId == 2 and is_host then--butt_rematch - RestartBattle
			local updateEvent = GameEventManager:Construct("UpdateMPResults")
			updateEvent:SetAttribute("rematch",1)
			updateEvent:SetSendToSelf(true)	
			GameEventManager:Send(updateEvent)
			self:deactivate_widget("butt_return")
		elseif buttonId == 0 and not is_host then --check_rematch - Toggle accept quick rematch
			if self:get_widget_value("check_rematch") == 0 then
				self:activate_widget("butt_return")
				local updateEvent = GameEventManager:Construct("UpdateMPResults")
				updateEvent:SetAttribute("rematch_ready",0)
				GameEventManager:Send(updateEvent,_G.SCREENS.GameMenu.host_id)
				self.rematch = false
			else
				self:deactivate_widget("butt_return")
				local updateEvent = GameEventManager:Construct("UpdateMPResults")
				updateEvent:SetAttribute("rematch_ready",1)
				GameEventManager:Send(updateEvent,_G.SCREENS.GameMenu.host_id)
				self.rematch = true
			end			
		end
	end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end


function MPResultsMenu:EndGame(result)

	if _G.SCREENS.GameMenu.world and _G.SCREENS.GameMenu.world.host then
		LOG("HOST GAME END EVENT SENDING")
		local e = GameEventManager:Construct("GameEnd")
		e:SetAttribute('result',result)
		--GameEventManager:Send( e, _G.SCREENS.GameMenu.world)
		_G.SCREENS.GameMenu.world:OnEventGameEnd(e)
	else
		LOG("GLOBAL END_GAME")
		_G.GLOBAL_FUNCTIONS["EndGame"](_G.SCREENS.GameMenu.returnEvent)	
	end	
	
end



function MPResultsMenu:OnClose()
	Sound.StopMusic();
	self.callback = nil
	self.levelUp = nil
	
	return Menu.OnClose(self)
end


-- return an instance of MPResultsMenu
return ExportSingleInstance("MPResultsMenu")
