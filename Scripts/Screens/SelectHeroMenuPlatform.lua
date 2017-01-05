function SelectHeroMenu:PlatformVars()
	self.exit_key = Keys.SK_ESCAPE
	self.ai_battle_key = Keys.SK_F4
	self.edit_puzzle_key = Keys.SK_F1
	self.demo_sprite_key = Keys.SK_F6
end



--  Update()
--      Update button/string states
--      NOTE:   painfully this currently has to keep the mapping of button ids to tag names
--              this could be fixed by having tag names as str_help_%d where %d is the button it corrosponds to
function SelectHeroMenu:Update()
	--[[
    if (self:IsActiveAnimation()) then
        self:InitHelp()
    end

    self:set_alpha("str_help_new", self.alphaHelp[1])
    self:set_alpha("str_help_cnt", self.alphaHelp[2])
	self:set_alpha("str_help_skr", self.alphaHelp[3])
    self:set_alpha("str_help_inv", self.alphaHelp[5])
    self:set_alpha("str_help_back", self.alphaHelp[10])
	--]]
end

local function quit_confirm(confirmed)
    if (confirmed) then
        ForceExit()
    end
end

function SelectHeroMenu:OnKey(key)
	LOG("SelectHero OnKey")
    if key == self.exit_key then
        
	    open_yesno_menu("[QUIT]", "[QUITCONFIRM]", quit_confirm, "[YES]", "[NO]" )
	            
	    
	    return Menu.MESSAGE_HANDLED
	
	
	
	end    
	
    return Menu.MESSAGE_NOT_HANDLED
end


function SelectHeroMenu:Open()
	
	
	return Menu.Open(self)
end

function SelectHeroMenu:OnOpen()
	LOG("SelectHeroMenu:OnOpen()")
	_G.GLOBAL_FUNCTIONS.Backdrop.Open()

	local edgeHorizontal = _G.MAX_WIDESCREEN-GetScreenWidth()
	if edgeHorizontal > 0 then
		edgeHorizontal = (edgeHorizontal / 2)--171
	end
	
	LOG("width "..tostring(edgeHorizontal))
	local edgeVertical = 0 
	
	
	_G.MAX_HORIZONTAL = GetScreenWidth() + edgeHorizontal - _G.SAFE_HORIZONTAL
	_G.MAX_VERTICAL = GetScreenHeight() - _G.SAFE_VERTICAL  
	_G.MIN_HORIZONTAL = edgeHorizontal +_G.SAFE_HORIZONTAL
	
	_G.MIN_VERTICAL = _G.SAFE_VERTICAL	  
	
    LOG("SelectHeroMenu opened")
    
    self:InitHelp()
    self:Update()
	
    local last_save
	if Settings:ValueExists("last_save") then
		last_save = "-"..Settings:Read("last_save", "")
	end
	
	if _G.Hero then
		last_save = "-".._G.Hero:GetAttribute("name")
	end
	
	
	
	local saves = _G.GLOBAL_FUNCTIONS.EnumerateSaves(1) --SaveGameManager.Enumerate()
	self.heroes_list = {}
	self.selected_hero = 1
	
	LOG("Saves "..tostring(#saves))
	if #saves > 0 then
		for k,v in ipairs(saves) do
	
			LOG("index: " .. k .. " savename: " .. v)
	
			table.insert(self.heroes_list,v)
			if last_save and string.find(v,last_save) then
				self.selected_hero = #self.heroes_list
			end
	
		end
	end
	
	if not _G.Hero and #self.heroes_list >= self.selected_hero then
		_G.Hero = _G.GLOBAL_FUNCTIONS.LoadSavedHero(self.heroes_list[self.selected_hero])
	end

	if not _G.Hero then
		self:deactivate_widget("butt_continuestory")
		self:deactivate_widget("butt_delete")
		self:hide_widget("icon_frame0")
		self:hide_widget("icon_frame1")
		self:hide_widget("icon_frame2")
		self:hide_widget("icon_frame3")
		self:hide_widget("icon_frame_back")
		self:hide_widget("icon_portrait")
		self:hide_widget("str_hero_name")
		self:hide_widget("str_hero_level")
	else
		self:activate_widget("butt_continuestory")
		self:activate_widget("butt_delete")
		self:activate_widget("icon_frame0")
		self:activate_widget("icon_frame1")
		self:activate_widget("icon_frame2")
		self:activate_widget("icon_frame3")
		self:activate_widget("icon_frame_back")
		self:activate_widget("icon_portrait")
		self:activate_widget("str_hero_name")
		self:activate_widget("str_hero_level")
	end
	
	if #self.heroes_list<= 1 then
		self:hide_widget("butt_portraitprev")	
		self:hide_widget("butt_portraitnext")
	else
		self:activate_widget("butt_portraitprev")	
		self:activate_widget("butt_portraitnext")
	end
    
    self:UpdateHero()
    
    return Menu.OnOpen(self)
end