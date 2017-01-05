use_safeglobals()

-- declare our menu

--require "Assets/Scripts/Screens/MultiplayerGameSetup"

class "SelectHeroMenu" (Menu);

function SelectHeroMenu:__init()
    super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\SelectHeroMenu.xml")

	_G.SCREEN_WIDTH = GetScreenWidth()
	_G.SCREEN_HEIGHT = GetScreenHeight()       
    self.alphaHelp = {}

	self:PlatformVars()
end


function SelectHeroMenu:OnClose()
    LOG("SinglePlayer screen closed");
	--SCREENS.SelectHeroMenu = nil
	self.go_to_menu = nil
	self.sourceMenu = nil
	
    return Menu.OnClose(self)
end





function SelectHeroMenu:OnButton(buttonId, clickX, clickY)

    if (buttonId == 101) then
        -- New Story
		--SetFadeToBlack(true)
		Graphics.FadeToBlack()
		_G.CallScreenSequencer("SelectHeroMenu", "CreateHeroMenu")      
        

	elseif (buttonId == 102) then				
		  -- Continue Story
		  --SetFadeToBlack(true)
		  Graphics.FadeToBlack()
		  _G.CallScreenSequencer("SelectHeroMenu", "SinglePlayerMenu")	
  	elseif (buttonId == 103) then--DeleteHero
		self:DeleteSelectedHero()
    elseif (buttonId == 100) then
		-- Back
		_G.Hero = nil
		if self.hero_1 then
			_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(self.hero_1)
    	end
		
		if self.hero_2 then
			_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(self.hero_2)
		end
		self:Shutdown()	
		Graphics.FadeToBlack()
		_G.CallScreenSequencer("SelectHeroMenu", "MainMenu")		
	elseif (buttonId == 130) then--prev hero
		self.selected_hero = self.selected_hero-1
		if self.selected_hero < 1 then
			self.selected_hero = #self.heroes_list 
		end
		
		local old_hero = _G.Hero
		_G.Hero = _G.GLOBAL_FUNCTIONS.LoadSavedHero(self.heroes_list[self.selected_hero])
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(old_hero)
		old_hero = nil
		
		self:UpdateHero()
	elseif (buttonId == 131) then--next hero
		self.selected_hero = self.selected_hero+1
		if self.selected_hero > #self.heroes_list then
			self.selected_hero = 1 
		end
		
		local old_hero = _G.Hero
		_G.Hero = _G.GLOBAL_FUNCTIONS.LoadSavedHero(self.heroes_list[self.selected_hero])
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(old_hero)
		old_hero = nil
		
		self:UpdateHero()	
		 
	elseif (buttonId == 141) then--DS BUTTONS VV
		if _G.GLOBAL_FUNCTIONS.CheckSaveData() then
			if self.hero_1 then
				purge_garbage()
				local old_hero = _G.Hero
				_G.Hero = self.hero_1
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(old_hero)
				old_hero = nil	
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(self.hero_2)
			
				self:Shutdown(1)	
				
				purge_garbage()
				Graphics.FadeToBlack()
				_G.CallScreenSequencer("SelectHeroMenu", "SinglePlayerMenu")		
			else

				Graphics.FadeToBlack()	
				_G.CallScreenSequencer("SelectHeroMenu", "CreateHeroMenu", 1)		
			end	
		end
	elseif (buttonId == 142) then
		if _G.GLOBAL_FUNCTIONS.CheckSaveData() then
			if self.hero_2 then
				local old_hero = _G.Hero
				_G.Hero = self.hero_2
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(old_hero)
				old_hero = nil				
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(self.hero_1)

				self:Shutdown(2)
				
				purge_garbage()
				--SetFadeToBlack(true)
				Graphics.FadeToBlack()
				_G.CallScreenSequencer("SelectHeroMenu", "SinglePlayerMenu")		
			else
				--SetFadeToBlack(true)
				Graphics.FadeToBlack()
				_G.CallScreenSequencer("SelectHeroMenu", "CreateHeroMenu", 2)		
			end				
		end
	elseif (buttonId == 151) then		
		self:EmptySlot(self.hero_1, 1)
		--self.hero_1 = nil	
	elseif (buttonId == 152) then
		self:EmptySlot(self.hero_2, 2)
		--self.hero_2 = nil
    end
	
	   
    return Menu.OnButton(self, buttonId, clickX, clickY)
end

function SelectHeroMenu:Shutdown(hero_selected)
	
	self.hero_2 = nil
	self.hero_1 = nil
	
	if self.saves then
		for k,v in ipairs(self.saves) do
			self.saves[k] = nil
		end
	end
	
	self.saves = nil
	self.heroes_list = nil
	self.selected_hero = nil		
end

function SelectHeroMenu:EmptySlot(hero, slot)
	if _G.GLOBAL_FUNCTIONS.CheckSaveData() then
		local heroName = hero:GetAttribute("name")
		local function DeleteHero(confirm)
			if confirm then
				--local save = SaveGameManager:Create(heroName, 1)		
				--SaveGameManager:Delete(save)
				LOG("SaveGameManager:Delete " .. heroName .. " slot " .. (slot-1))			
				SaveGameManager:Delete(heroName, slot-1)
				savegame = SaveGameManager:Create("Empty " .. tostring(slot), slot-1, 1)
				savegame:Save()			
				
				if hero == self.hero_1 then
					self.hero_1 = nil
					self:hide_widget("butt_slot_del_1")
				elseif hero == self.hero_2 then
					self.hero_2 = nil
					self:hide_widget("butt_slot_del_2")
				end		
				
				self:ShowHeroInfo(self.hero_1, 1)			
				self:ShowHeroInfo(self.hero_2, 2)			
			end
		end

		open_yesno_menu("[DELETEHERO]", substitute(translate_text("[CONFIRMDELETEHERO]"),heroName), DeleteHero, "[YES]", "[NO]" )	
	end
end

function SelectHeroMenu:DeleteSelectedHero()
	
	local heroName = self.heroes_list[self.selected_hero]
	local function DeleteHero(confirm)
		if confirm then
	
			_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(_G.Hero)
			_G.Hero = nil
			
			
			SaveGameManager:Delete(heroName) 
			LOG("SaveGameManager:Delete " .. heroName)	
			
			local saves = _G.GLOBAL_FUNCTIONS.EnumerateSaves(1, true) --SaveGameManager.Enumerate (forced)
			self.heroes_list = {}
			--self.selected_hero = 1
			
			LOG("Saves "..tostring(#saves))
			if #saves > 0 then
				for k,v in ipairs(saves) do
			
					LOG("index: " .. k .. " savename: " .. v)
			
					table.insert(self.heroes_list,v)		
				end
				while self.selected_hero > #self.heroes_list do
					self.selected_hero = self.selected_hero - 1
				end
			else
				self.selected_hero = 1
			end
			

			if not _G.Hero and #self.heroes_list >= self.selected_hero then
				_G.Hero = _G.GLOBAL_FUNCTIONS.LoadSavedHero(self.heroes_list[self.selected_hero])
			end
		
			if not _G.Hero then	
				_G.CallScreenSequencer("SelectHeroMenu", "CreateHeroMenu")      				
			else	
				if #self.heroes_list<= 1 then
					self:hide_widget("butt_portraitprev")	
					self:hide_widget("butt_portraitnext")
				else
					self:activate_widget("butt_portraitprev")	
					self:activate_widget("butt_portraitnext")
				end
				
				self:UpdateHero()				
			end
			
						
			
		end
	end

	open_yesno_menu("[DELETEHERO]", substitute(translate_text("[CONFIRMDELETEHERO]"),heroName), DeleteHero, "[YES]", "[NO]" )	
	--[[
	local save_list = SaveGameManager.Enumerate()   		   
	--]]   	
	
end


--[[
function SelectHeroMenu:OnButtonAvailable(buttonId, locX, locY, available)
    
    if (buttonId) then
        if (available) then
            self.alphaHelp[buttonId] = 1.0;
        else
            self.alphaHelp[buttonId] = 0.8;
        end
    end
    
    return Menu.MESSAGE_HANDLED;
end


function SelectHeroMenu:OnDraw(Time)
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

function SelectHeroMenu:InitHelp()
    self.alphaHelp[1] = 0;
    self.alphaHelp[2] = 0;
    self.alphaHelp[3] = 0;
    self.alphaHelp[5] = 0;
    self.alphaHelp[10] = 0;
end


function SelectHeroMenu:UpdateHero()

	if _G.Hero then
		self:set_image("icon_portrait",_G.Hero:GetAttribute("portrait"))
		self:set_text_raw("str_hero_name",_G.Hero:GetAttribute("name"))
		
		
		self:set_text_raw("str_hero_level",string.format("%s %d", translate_text("[LEVEL_]"), _G.Hero:GetLevel()))
		
	end
	
	
	
	
end





function SelectHeroMenu:ContinueStoryMode()	
	
	if _G.Hero:GetAttribute("in_system")==0 then
		
		--SCREENS.SolarSystemMenu:Open()
		_G.CallScreenSequencer("SelectHeroMenu", "SolarSystemMenu")
	else
		_G.CallScreenSequencer("SelectHeroMenu", "MapMenu")
		--SCREENS.MapMenu:Open()
	end		
end

function SelectHeroMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end

dofile("Assets/Scripts/Screens/SelectHeroMenuPlatform.lua")


-- return an instance of SelectHeroMenu
return ExportSingleInstance("SelectHeroMenu")
