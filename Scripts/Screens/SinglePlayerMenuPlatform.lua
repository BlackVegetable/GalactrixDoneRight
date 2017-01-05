function SinglePlayerMenu:PlatformVars()
	self.exit_key = Keys.SK_ESCAPE
	if _G.DEBUGS_ON then
		self.ai_battle_key = Keys.SK_F4
		self.edit_puzzle_key = Keys.SK_F1
		self.demo_sprite_key = Keys.SK_F6
	end
	self.soak_test_key = Keys.SK_F2
	
	if not _G.is_open("BackdropMenu") then
		_G.GLOBAL_FUNCTIONS.Backdrop.Open()
	end	
end

function SinglePlayerMenu:LoadGraphics()
	-- leave blank for pc
end

function SinglePlayerMenu:UnloadGraphics()
	-- leave blank for pc
end

local function quit_confirm(confirmed)
    if (confirmed) then
        ForceExit()
    end
end


function SinglePlayerMenu:OnKey(key)
	if key == self.soak_test_key then -- soak_test_key not set on platforms other than PC
		--require("SmokeTests").RunLoopingBattle(2)
    elseif key == self.exit_key then
	    open_yesno_menu("[QUIT]", "[QUITCONFIRM]", quit_confirm, "[YES]", "[NO]" )
	            
	    
	    return Menu.MESSAGE_HANDLED
	
	elseif key == self.ai_battle_key then--AI battle
		self:AIBattle()
	end    
	
    return Menu.MESSAGE_NOT_HANDLED
end

function SinglePlayerMenu:HideWidget()

			
end

function SinglePlayerMenu:CreateHero()
	SCREENS.CreateHeroMenu:Open()
end

--  Update()
--      Update button/string states
--      NOTE:   painfully this currently has to keep the mapping of button ids to tag names
--              this could be fixed by having tag names as str_help_%d where %d is the button it corrosponds to
function SinglePlayerMenu:Update()
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