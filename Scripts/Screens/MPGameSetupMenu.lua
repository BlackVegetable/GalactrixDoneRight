-- declare our menu
class "MPGameSetupMenu" (Menu);

function MPGameSetupMenu:__init()
    super()
    
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\MPGameSetupMenu.xml")

end


function MPGameSetupMenu:OnOpen()
    LOG("MPGameSetupMenu opened");
    
	--self:hide_widget("gp_gamercard")
	self:hide_widget("str_oppready")
	self:hide_widget("chk_ready")
	self:hide_widget("chk_handicap")
	--self:hide_widget("butt_back");
	
	self:set_list_option("drop_timelimit", "None");
	self:set_list_option("drop_timelimit", "16 sec");
	self:set_list_option("drop_timelimit", "12 sec");
	self:set_list_option("drop_timelimit", "8 sec");
	self:set_list_option("drop_timelimit", "4 sec");
	self:set_list_value("drop_timelimit", 1);
	
	SCREENS.MPTypeMenu:Close();
    
    return Menu.OnOpen(self)
end

function MPGameSetupMenu:OnButton(buttonId, clickX, clickY)
    if (buttonId == 0) then
    	self:Close();
    end
	
    return Menu.OnButton(self, buttonId, clickX, clickY)
end

-- return an instance of MPGameSetupMenu
return ExportSingleInstance("MPGameSetupMenu")