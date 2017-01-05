use_safeglobals()


-- declare our menu
class "MiningIntroMenu" (Menu);

function MiningIntroMenu:__init()
	super()
	self:LoadGraphics()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\MiningIntroMenu.xml")

end


function MiningIntroMenu:OnOpen()
	LOG("MiningIntroMenu opened");
	
	self:InitUI()
		
	return Menu.OnOpen(self)
end


function MiningIntroMenu:Open(player,cost,cargoList,callback,encounter_timer)
	LOG("MiningIntroMenu:Open()")
		
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
		
	self.player = player
	self.cost = cost
	self.cargoList = cargoList
	
	if callback then		
		self.callback = callback
	end
	
	if encounter_timer then
		self.encounter_timer = encounter_timer
	end
	
	return Menu.Open(self)
end


function MiningIntroMenu:InitUI()
	LOG("init UI miningintro")
	local base_cargo = "img_cargo_big_"
	
	local function DS_Processing()
		base_cargo = "img_cargo"
		if get_language() == 4 then
			self:set_font("str_heading", "font_system")
			self:set_widget_position("str_heading", 0, 204)
		end
	end
	
	_G.DSOnly(DS_Processing)
	
	for i,v in pairs(self.cargoList) do		
		self:set_text_raw("str_cargo_"..tostring(i),translate_text("["..string.upper(_G.DATA.Cargo[v.cargo].effect).."_NAME]").."  x  "..tostring(v.min))
		self:set_image("icon_cargo_"..tostring(i),base_cargo..tostring(v.cargo))
	end
	
	if self.cost > 0 then
		self:set_text_raw("str_cost", translate_text("[MINING_COST_]").." " ..tostring(self.cost) .." "..translate_text("[CREDITS]"))
	end
	
	self:SetPlayerShip()
	
	self:activate_widget("butt_yes")
	
end

function MiningIntroMenu:OnButton(buttonId, clickX, clickY)

	if buttonId == 3 then
		SCREENS.InventoryFrame:Open("MiningIntroMenu", 4)

		--SCREENS.InventoryFrame:SetSource("SolarSystemMenu")
		return Menu.MESSAGE_HANDLED
	elseif buttonId == 1 then
		local function transition()
			self:Close()
			self.callback(true)
			
			self.callback = nil
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, "GameMenu", "SolarSystemMenu")
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", "SolarSystemMenu")
		return Menu.MESSAGE_HANDLED
	elseif buttonId == 0 then
		local function transition()
			self.callback(false)
			
			self.callback = nil
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, nil, "MiningIntroMenu")
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "MiningIntroMenu")
		return Menu.MESSAGE_HANDLED
	end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end


function MiningIntroMenu:SetPlayerShip()
	local ship = _G.Hero:GetAttribute("curr_ship")
	--BEGIN_STRIP_DS
	self:set_image("icon_ship", ship:GetAttribute("portrait"))	--256x256 portrait
	--END_STRIP_DS
	self:set_image("icon_ship_ds", ship:GetAttribute("portrait") .. "_L")	--256x256 portrait
end	

dofile("Assets/Scripts/Screens/MiningIntroMenuPlatform.lua")

-- return an instance of MiningIntroMenu
return ExportSingleInstance("MiningIntroMenu")
