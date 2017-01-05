use_safeglobals()

require "Assets/Scripts/Screens/MultiplayerGameSetup"

-- declare our menu
class "MultiplayerMenu" (Menu);

dofile("Assets/Scripts/Screens/MultiplayerMenuPlatform.lua")

local function InitMPResult(result)
	
	--check we initted the multiplayer system correctly
	if (result ~= 0) then
	
		open_message_menu("[FAILED_INIT_MULTIPLAYER]", "[FAILED_INIT_MULTIPLAYER_MSG]")
		
		--return to the main menu
		self:Close()
		SCREENS.MainMenu:Open()
	end
end


function MultiplayerMenu:__init()
	super()
	
	_G.SCREENS.MultiplayerGameSetup:IsOpen()

	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\MultiplayerMenu.xml")
	
end

local function ResetButton()

	SCREENS.MultiplayerMenu.button_clicked = nil	
	
end



function MultiplayerMenu:Open(ip_address)
	if not ip_address then
		ip_address = "255.255.255.255"
	end
	self.ip_address = ip_address
	
	LOG("")
   
	mp_init(InitMPResult, MPMessage)
	

	self.numHosts = 0
	self.findinggames = false
	self.hosts = {}	
	self:activate_widget("butt_create")
	
	local function do_nothing()
	end

	mp_stop_finding_games(do_nothing)	
	
	return Menu.Open(self)
end


--we found a game. This callback takes  the name of the game, the max and current number of players and the host's address
local function FoundGame(name, maxplayers, numplayers, hostaddress)

	--add the new server to the list
	SCREENS.MultiplayerMenu:set_list_option("list_games", name)
	
	--store the address
	SCREENS.MultiplayerMenu.numHosts = SCREENS.MultiplayerMenu.numHosts + 1

	table.insert(SCREENS.MultiplayerMenu.hosts,{host_address=hostaddress,host_name=name})
	--and increment the number of hosts
	
end


-- Game was successfully created
local function CreateResult(ret)
	LOG("CreateResult")
	--close the current menu and open the game menu
	if _G.GLOBAL_FUNCTIONS.CheckSaveData() then

		if (ret == 0) then
			_G.CallScreenSequencer("MultiplayerMenu","MultiplayerGameSetup")
		
			--mp_debug_delay(500,1000)			
		else
			_G.HideWirelessIcons()
			open_message_menu("[FAILED]", "[HOSTING_FAILED]")--Hosting failed! Check another instance of the game is not running.
			ResetButton()
		end
	else
		--self:hide_widget("icon_wireless_strength")	
		_G.HideWirelessIcons()
		local function DoNothing()
		end
		mp_leave_game(DoNothing)
	end	
end


-- the result of the find call
local function FindResult(ret)

	if (ret ~= 0) then
		open_message_menu("[FIND_FAILED]", "[NO_GAMES_FOUND]")
		ResetButton()
		_G.SCREENS.MultiplayerMenu:StopFinding()
	end
end


-- the result of the find call
local function JoinResult(ret)

	if _G.GLOBAL_FUNCTIONS.CheckSaveData() then


		--close the current menu and open the game menu
		LOG("JoinResult = "..tostring(ret))
		if (ret == 0) then			
			_G.CallScreenSequencer("MultiplayerMenu","MultiplayerGameSetup")
		
			--mp_debug_delay(1000,1500)			
			return
		elseif ret == -3 then
			open_message_menu("[JOIN_FAILED]", "[MP_GAME_FULL]")
			_G.SCREENS.MultiplayerMenu.joining = nil
			_G.SCREENS.MultiplayerMenu:StopFinding()
		else
			open_message_menu("[CONNECTION_LOST]", "[CONNECTION_LOST_MSG]")
			_G.SCREENS.MultiplayerMenu.joining = nil		
			_G.SCREENS.MultiplayerMenu:StopFinding()
			
			
		end
		_G.SCREENS.MultiplayerMenu:ResetHostList()
		
		ResetButton()	
	else

		_G.SCREENS.MultiplayerMenu.joining = nil		
		_G.SCREENS.MultiplayerMenu:StopFinding()
				
		----self:hide_widget("icon_wireless_strength")	
		--SCREENS.ReceptionStrengthMenu:Close()
		local function DoNothing()
		end
		mp_leave_game(DoNothing)	
	end			
	
end


function MultiplayerMenu:ResetHostList()
	local option = self:get_list_value("list_games")
	table.remove(self.hosts,option)
	self:reset_list("list_games")
	for i,v in pairs(self.hosts) do
		self:set_list_option("list_games",v.host_name)
	end
	
end


function MultiplayerMenu:FindGames()	

	local function callback()			 
		 LOG("Find Games At "..self.ip_address)
		 mp_find_games(_G.CONNECTION_TYPE, self.ip_address, self:GetMPUsername(), "Player Identity", FindResult, FoundGame)	
	 
		 --and change the button
		 self:set_text('butt_find', '[STOP_FINDING]')	
		 -- and display the wireless icon
		 self:ShowWirelessIcons()
	end
	self:deactivate_widget("butt_create")
	self:reset_list("list_games")
	self.hosts = {}
	--reset
	self.numHosts = 0
	self.findinggames = true

	--begin searching for games locally
	if _G.CONNECTION_TYPE == NetworkConnectionType.TCPIP then
		LOG("Find Internet Games")
		SCREENS.IPMenu:Open(callback)
	else
		callback()
	end
		
end


function MultiplayerMenu:StopFinding()

	self:set_text('butt_find', '[FIND_GAMES]')
	_G.HideWirelessIcons()
	self:activate_widget("butt_create")
	--necessary???
	local function DoNothing()
	end
	mp_stop_finding_games(DoNothing)
	
	--reset
	self.findinggames = false
	
	
end	




function MultiplayerMenu:OnButton(buttonId, clickX, clickY)
	LOG("OnButton "..tostring(id))
	
	-- Create a new game
	if self.button_clicked==buttonId then --cancel out double clicks
		self.button_clicked = nil
		return Menu.MESSAGE_HANDLED
	else	
		self.button_clicked = buttonId			
	end


	if (buttonId == 1) then--CREATE

		 local function ConfirmWireless(yes_clicked)

			if yes_clicked then	
				self:ShowWirelessIcons()	
				
				--make sure the user has a name set - this should probably be kept saved as an option and re-entered upon entry of this screen
				if self:NameCheck(self:GetMPUsername()) then
					self:SetMPUsername()
					LOG("mp_create_game " .. string.format("%s's Game",self:GetMPUsername()))
					mp_create_game(_G.CONNECTION_TYPE, string.format("%s's Game",self:GetMPUsername()), self:GetMPUsername(), "Host Identity", 2, CreateResult)					
				else
					open_message_menu("[MASSIVE_USER_ERROR]", "[ENTER_MP_NAME]",ResetButton)
					--self.clicked = false
				end
				
				--and change the button
				--self:set_text('butt_find', '[FIND_GAMES]')
				--self.findinggames = false
			else
				ResetButton()
			end
		 end
		 
		local function OpenCreateGame()
		 	if self.findinggames then--don't need to ask
				ConfirmWireless(true)
		 	else
				open_yesno_menu("[DS_COMMS]", "[DS_COMMS_QUERY]", ConfirmWireless, "[YES]", "[NO]" )
			end
		end
		--self.clicked = true
		
		_G.DSOnly(OpenCreateGame)
		_G.NotDS(ConfirmWireless, true)
	
	-- Find games
	elseif (buttonId == 2) then-- and not self.joining then
		
		--if we arent already finding games then start finding games
		if (self.findinggames == false) then
			
			-- First clear our current listed games
 			local function ConfirmFindGames(confirm)
				if confirm then
					self:ShowWirelessIcons()
					self:FindGames()
				end
			end

			local function FindGames()
				open_yesno_menu("[DS_COMMS]", "[DS_COMMS_QUERY]", ConfirmFindGames, "[YES]", "[NO]" )
			end
			
			_G.DSOnly(FindGames)
			_G.NotDS(ConfirmFindGames, true)			
	
		else 
			self:StopFinding()
			----and change the button
			--self:set_text('butt_find', '[FIND_GAMES]')
           -- _G.HideWirelessIcons()
			--self:activate_widget("butt_create")
			--stop finding any games
			--mp_stop_finding_games(FindResult)--????????
			
			--reset
			--self.findinggames = false
		
		end

		self.button_clicked = nil		
		
	-- Join the selected index game
	elseif (buttonId == 3) then
		
		if not self:NameCheck(self:GetMPUsername())  then
			
			--output error
			open_message_menu("[MASSIVE_USER_ERROR]", "[ENTER_MP_NAME]",ResetButton)
			
		--make sure a game is selected
		elseif (self:get_list_value("list_games") > 0) and  #self.hosts > 0 then
		
			self.joining = true
			self:SetMPUsername()		
			
			local function ConfirmWireless(confirm)
				if confirm then
					self:ShowWirelessIcons()
					--attempt to join the game - note we wait for the callback to JoinResult (with the result of the join) before we actually join
					mp_join_game(self.hosts[self:get_list_value("list_games")].host_address, self:GetMPUsername(), "Player Identity", JoinResult)
				else
					ResetButton()
				end
			end
			local function OpenCreateGame()
				if self.findinggames then--don't need to ask
					ConfirmWireless(true)
				else
					open_yesno_menu("[DS_COMMS]", "[DS_COMMS_QUERY]", ConfirmWireless, "[YES]", "[NO]" )
				end
			end
			--self.clicked = true
			
			_G.DSOnly(OpenCreateGame)
			_G.NotDS(ConfirmWireless, true)			
			
			
			
			
		else
		
			--output error
			open_message_menu("[MASSIVE_USER_ERROR]", "[SELECT_GAME]",ResetButton)
			
		end
	
	-- Back button
	elseif (buttonId == 10) then
	
		--close the screen and go to the main menu
	
		if self.findinggames then		
			--and change the button
			self:StopFinding()
			--self:set_text('butt_find', '[FIND_GAMES]')
			
			--_G.HideWirelessIcons()			
			----stop finding any games
			--mp_stop_finding_games(FindResult)--?????
			----reset
			--self.findinggames = false		
		end		
		
		local function SPCallback(val)
			LOG("SPCallback("..tostring(val)..")")		
		end	
			
		--mp_leave_game(SPCallback)
		mp_single_player(SPCallback)		
				
		Graphics.FadeToBlack()
		local function continue()
			_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(_G.Hero)
		
			_G.Hero = nil			
			_G.CallScreenSequencer("MultiplayerMenu","MainMenu")
		end	
		
		if _G.Hero  then
		
				continue()			
			
		else
			_G.CallScreenSequencer("MultiplayerMenu","MainMenu")
		end			
		
	end
	
	return Menu.MESSAGE_HANDLED
end


function MultiplayerMenu:OnClose()
	
	
	return Menu.OnClose(self)
end


function MultiplayerMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end


-- return an instance of MultiplayerMenu
return ExportSingleInstance("MultiplayerMenu")
