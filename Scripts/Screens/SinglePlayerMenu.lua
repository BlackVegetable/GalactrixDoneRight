use_safeglobals()
-- declare our menu

--require "Assets/Scripts/Screens/MultiplayerGameSetup"

class "SinglePlayerMenu" (Menu);

function SinglePlayerMenu:__init()
    super()
	self:LoadGraphics()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\SinglePlayerMenu.xml")
   
    self.alphaHelp = {}

	self.stopMusic = nil
	
	self:PlatformVars()
end

function SinglePlayerMenu:OnOpen()
	LOG("SinglePlayerMenu:OnOpen()")
	self.stopMusic = nil
	
	_G.GLOBAL_FUNCTIONS.Backdrop.Open()

	self:set_text("butt_story","[STORY]")
	self:set_text("butt_battle","[QUICK_BATTLE]")
	
	local function PCDemo()
		self:deactivate_widget("butt_story")
		self:deactivate_widget("butt_inventory")
	end
	
	--_G.PCOnly(PCDemo)
	
	local edgeHorizontal = _G.MAX_WIDESCREEN-GetScreenWidth()
	if edgeHorizontal > 0 then
		edgeHorizontal = (edgeHorizontal / 2)--171
	end
	
	LOG("width "..tostring(edgeHorizontal))
	local edgeVertical = 0 

	_G.SCREEN_WIDTH = GetScreenWidth()
	_G.SCREEN_HEIGHT = GetScreenHeight()    	
	
	_G.MAX_HORIZONTAL = GetScreenWidth() + edgeHorizontal - _G.SAFE_HORIZONTAL
	_G.MAX_VERTICAL = GetScreenHeight() - _G.SAFE_VERTICAL  
	_G.MIN_HORIZONTAL = edgeHorizontal +_G.SAFE_HORIZONTAL
	
	_G.MIN_VERTICAL = _G.SAFE_VERTICAL	  
	
    LOG("SinglePlayerMenu opened")
    
    self:InitHelp()
    self:Update()
	
	self:set_text_raw("str_hero_name",_G.Hero:GetAttribute("name"))

    self:UpdateHero()
	
	_G.ClearAutoLoadTables()
	
	self:HideWidget()
	
	
	--Construct enemy_list for random Quick battle
	self.enemy_list = {"HE01","HE02","HE03"}
	local key_list = {}
	for i,v in pairs(self.enemy_list) do
		key_list[v]=true
	end
	
	for i=1, _G.Hero:NumAttributes("defeated") do
		local enemy = _G.Hero:GetAttributeAt("defeated",i)
		LOG("enemy_list "..tostring(enemy))
		if not key_list[enemy] then
			table.insert(self.enemy_list,enemy)
		end
	end
	key_list = nil	
	
	
	local function set_rich_presence()	
		SetXboxContext(1, XboxContext.X_CONTEXT_PRESENCE, _G.XLAST.CONTEXT_PRESENCE_PRES_MENUS)
	end
	_G.XBoxOnly(set_rich_presence)
	
	local user = PlayerToUser(1)
	self.sequence = {Gamepad.MapGenericInput(user,GamepadInput.GAMEPAD_BUTTON_4),Gamepad.MapGenericInput(user,GamepadInput.GAMEPAD_BUTTON_3),
		Gamepad.MapGenericInput(user,GamepadInput.GAMEPAD_BUTTON_4),Gamepad.MapGenericInput(user,GamepadInput.GAMEPAD_BUTTON_3)}
	self.sequence_id = 1	
	
	
	--self:deactivate_widget("butt_story")
	--self:deactivate_widget("butt_inventory")
	
    return Menu.OnOpen(self)
end

function SinglePlayerMenu:OnAnimOpen()
	Graphics.FadeFromBlack()
end

function SinglePlayerMenu:OnClose()
	LOG("SinglePlayerMenu:OnClose()")
	self.stopMusic = true
	return Menu.OnClose(self)	
end


function SinglePlayerMenu:OnButton(buttonId, clickX, clickY)
    if (buttonId == 91) then
        -- New Story
		self:CreateHero()        
        
    elseif (buttonId == 92) then
        -- Continue Story
		local curr_loc = _G.Hero:GetAttribute("curr_loc")
		LOG("CURRENT LOCATION" .. curr_loc)
		if curr_loc~="" and string.char(string.byte(curr_loc,1),string.byte(curr_loc,2)) == "HE" then
			_G.Hero:SetAttribute("curr_loc","")
		end

		self:ContinueStoryMode()
		return Menu.MESSAGE_HANDLED;
        
    elseif (buttonId == 93) then
        -- Quick Battle		
		
		--local function transition()
			ShowMemUsage("Quick Battle button 01")
			LOG("Before Enemy Creation memory at " .. tostring(gcinfo()))
		
			local enemy = self.enemy_list[math.random(1,#self.enemy_list)]
			
			--enemy = "HE28"--Debug only
			
			enemy = _G.GLOBAL_FUNCTIONS.LoadHero.LoadEnemy(enemy)
			enemy:LevelToHero(_G.Hero)
			LOG("After Enemy Creation at " .. tostring(gcinfo()))
		
			
		
			_G.GLOBAL_FUNCTIONS.Battle.Battle("SinglePlayerMenu",_G.Hero,enemy)
		--end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, nil)
		--SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil)
		
		
		
		--Sim(self,Hero)
        
    elseif (buttonId == 95) then
        -- Inventory Menu
		_G.CallScreenSequencer("SinglePlayerMenu", "InventoryFrame", "SinglePlayerMenu", 1)
		--self:Close()
    elseif (buttonId == 90) then
        -- Back
        --self:Close()
        --SCREENS.MainMenu:Open()
		
		-- Hero no longer required
		GLOBAL_FUNCTIONS.ClearChar.ClearHero(_G.Hero)
		_G.Hero = nil
		
		if _G.GLOBAL_FUNCTIONS.CheckSaveData() then
			if _G.GLOBAL_FUNCTIONS.DemoMode() then
				_G.CallScreenSequencer("SinglePlayerMenu", "MainMenu")
			else
				_G.CallScreenSequencer("SinglePlayerMenu", "SelectHeroMenu")
			end		
		end
   end
	
	   
    return Menu.OnButton(self, buttonId, clickX, clickY)
end

--[[
function SinglePlayerMenu:OnButtonAvailable(buttonId, locX, locY, available)
    
    if (buttonId) then
        if (available) then
            self.alphaHelp[buttonId] = 1.0;
        else
            self.alphaHelp[buttonId] = 0.8;
        end
    end
    
    return Menu.MESSAGE_HANDLED;
end


function SinglePlayerMenu:OnDraw(Time)
    -- TODO: make fading not dependant on frame rate.
    -- fade the alphas
    for id,alpha in pairs(self.alphaHelp) do
        -- id is buttonId and alpha is its alpha
        if (alpha >= 0.001 and alpha <= 0.8) then
            alpha = alpha - 0.02
            alpha = ForceRange(alpha, 0, 1)
            self.alphaHelp[id] = alpha
        end
    end
    -- Update alpha values of help strings
    self:Update();
    return Menu.OnDraw(self, Time);
end
]]

function SinglePlayerMenu:InitHelp()
    self.alphaHelp[1] = 0;
    self.alphaHelp[2] = 0;
    self.alphaHelp[3] = 0;
    self.alphaHelp[5] = 0;
    self.alphaHelp[10] = 0;
end


function SinglePlayerMenu:UpdateHero()

	if _G.Hero then
		self:set_image("icon_portrait",_G.Hero:GetAttribute("portrait"))
		self:set_text_raw("str_hero_name",_G.Hero:GetAttribute("name"))
		self:set_text_raw("str_hero_level",string.format("%s %d",translate_text("[LEVEL_]"), _G.Hero:GetLevel()))
		
		self:set_image("icon_backdrop_top1",_G.Hero:GetAttribute("portrait"))	
		local gender = "2"
		if _G.Hero:GetAttribute("male") == 1 then
			gender = "1"
		end
		self:set_image("icon_backdrop_top1",   "img_top_hero"..gender)
		self:set_image("icon_backdrop_bottom1","img_top_hero"..gender.."2")
	end
	
	
	
	
end

function SinglePlayerMenu:ContinueStoryMode()	
	
	local menuChoice
	if _G.Hero:GetAttribute("in_system") == 1 then
		menuChoice = "SolarSystemMenu"
	else
		menuChoice = "MapMenu"
	end
	
	--[[
	NOTE: the QINI condition is to handle the very specific case of the first cutscene followed by the first conversation followed by opening the solar system and showing the first tutorial....
	--]]
	local quests_t = _G.GetAvailableQuests(_G.Hero)
	if quests_t[1] == "Q000" then
		-- i feel dirty - lets never speak of this again
	
		local singleplayer_load_f = function()
			add_text_file("QuestText.xml")
			add_text_file("StarSystemText.xml")
			add_text_file("StarText.xml")
			add_text_file("FactionText.xml")
			add_text_file("CrewText.xml")

			SCREENS.SolarSystemMenu:Open()
		end
		
		local start_qini_conv = function()
			 _G.RunQuestConversation(_G.Hero, "Conv_Intro0", singleplayer_load_f)
		end
	
		local post_cutscene_f = function()
			SCREENS.CustomLoadingMenu:Open(nil, start_qini_conv, nil, "SolarSystemMenu")
		end
		
		local new_character_story_f = function()
			Sound.StopMusic();
			self.stopMusic = true
			self:Close()
			open_cutscene_menu("CutScenes/CS1.xml", post_cutscene_f)
		end
	
		SCREENS.CustomLoadingMenu:Open("SinglePlayerMenu", new_character_story_f)
	else
	
		local singleplayer_load_f = function()
			add_text_file("QuestText.xml")
			add_text_file("StarSystemText.xml")
			add_text_file("StarText.xml")
			add_text_file("FactionText.xml")
			add_text_file("CrewText.xml")
			
			_G.CallScreenSequencer("SinglePlayerMenu", menuChoice)
		end
	
		SCREENS.CustomLoadingMenu:Open("SinglePlayerMenu", singleplayer_load_f, nil, menuChoice)
	end
end


function SinglePlayerMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
		if not self.stopMusic then
			LOG("SinglePlayerMenu Start music again")
	   		PlaySound("music_overture")
		else
			LOG("STOPPED MUSIC: " .. tostring(self.stopMusic))
		end
	end	
	
	return Menu.MESSAGE_HANDLED
end

function SinglePlayerMenu:OnGamepadButton(user, button_id, button_state)
	LOG("SinglePlayerMenu OnGamepadButton " .. tostring(user) .. " " .. tostring(button_id) .. " " .. tostring(button_state))
	
	
	if button_state == 1 then
		LOG("Curr press in sequence "..tostring(self.sequence[self.sequence_id]))
		if self.sequence[self.sequence_id]==button_id then
			self.sequence_id = self.sequence_id + 1
			if self.sequence_id > #self.sequence then
				self.sequence_id = 1
					self:AIBattle()
				end
		else
			LOG("reset sequence_id")
			self.sequence_id = 1
		end
		return Menu.MESSAGE_HANDLED
	end
	
	
	return Menu.MESSAGE_NOT_HANDLED
end

function SinglePlayerMenu:AIBattle()
	--local enemy_list = _G.DATA.MP_Enemies
	local enemyA = self.enemy_list[math.random(1,#self.enemy_list)]--from heroes defeated enemies only
	local enemyB = self.enemy_list[math.random(1,#self.enemy_list)]
					
	_G.GLOBAL_FUNCTIONS.Battle.Battle("SinglePlayerMenu",_G.GLOBAL_FUNCTIONS.LoadHero.LoadEnemy(enemyA),_G.GLOBAL_FUNCTIONS.LoadHero.LoadEnemy(enemyB))							
	
end


dofile("Assets/Scripts/Screens/SinglePlayerMenuPlatform.lua")


-- return an instance of SinglePlayerMenu
return ExportSingleInstance("SinglePlayerMenu")
