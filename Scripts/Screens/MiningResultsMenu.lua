use_safeglobals()


-- declare our menu
class "MiningResultsMenu" (Menu);

function MiningResultsMenu:__init()
	super()
	self:LoadGraphics()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\MiningResultsMenu.xml")

end


function MiningResultsMenu:OnOpen()
	LOG("MiningResultsMenu opened");
	
	SCREENS.GameMenu:HideMiningWidgets()
	
	self.clicked = false
	
	if self.victory then
		self:Victory()
	else
		self:Defeat()
	end
	
	local abandonedCargo = 0
	for i=1,5 do
		if self.cargoList[i] then
			local effect = _G.DATA.Cargo[self.cargoList[i].cargo].effect
			self:set_font(string.format("str_cargo%d_val", i), "font_numbers_green")
			self:set_text(string.format("str_cargo%d_val", i), string.format("+%d", _G.Hero:GetAttribute(effect)))
			
			abandonedCargo = abandonedCargo + self.dropped[self.cargoList[i].cargo]
			
		end
	end

	if abandonedCargo ~= 0 then
		self:activate_widget("str_cargo_lost")
		-- HACK -- BUG -- TODO
		-- We're making this line disappear in non-English versions of the game
		--  because we don't have the text for it
		if get_language() == 0 then
			self:set_text("str_cargo_lost", "[INSUFF_CAPCITY_MSG]")
		end
	else
		self:hide_widget("str_cargo_lost")
	end
	
	--self:set_text_raw("str_heading",translate_text("[MINE_SUCCESS]"))
	--self:set_text_raw("str_message",translate_text("[MINE_VICTORY]"))

	self:activate_widget("butt_continue")
	self:hide_widget("butt_yes")
	self:hide_widget("butt_no")
	self:hide_widget("str_retry")
	
	self:SetStats()
	
	if _G.Hero:NumAttributes("mined_asteroids") >= 3 then
		_G.Hero:EraseAttribute("mined_asteroids", _G.Hero:GetAttributeAt("mined_asteroids", 1))
	end
	_G.Hero:PushAttribute("mined_asteroids", _G.Hero:GetAttribute("curr_loc"))
	LOG("Pushed Attribute: " .. _G.Hero:GetAttribute("curr_loc"))
	for i=1, _G.Hero:NumAttributes("mined_asteroids") do
		LOG(string.format("Attribute %d: %s", i, _G.Hero:GetAttributeAt("mined_asteroids", i)))
	end	
	
	
		
	return Menu.OnOpen(self)
end

function MiningResultsMenu:OnClose()
	UnloadAssetGroup("AssetsButtons")
	return Menu.MESSAGE_HANDLED
end

function MiningResultsMenu:Open(victory,callback,cargoList, dropped_cargo, cost)

	self.victory = victory
	self.callback = callback
	self.cost = cost
	self.cargoList = cargoList
	self.dropped = dropped_cargo

	
	
	--self:set_image("icon_ship", string.format("img_%s", _G.Hero:GetAttributeAt("ship_list", _G.Hero:GetAttribute("ship_loadout")):GetAttribute("ship")))
	
	return Menu.Open(self)
end


function MiningResultsMenu:Defeat()
	--[[
	for i=1,5 do
		self:set_font("str_cargo"..i.."_val", "font_numbers_red")
		self:set_text("str_cargo"..i.."_val", "+0")
	end
	
	
	

	if abandonedCargo ~= 0 then
		self:activate_widget("str_cargo_lost")
		self:set_text_raw("str_cargo_lost", "You have insufficient capacity on your ships and were forced to abandon some cargo.")
	else
		self:hide_widget("str_cargo_lost")
	end	
	--]]
	
	
	--self:set_text_raw("str_cargo_lost", translate_text("[MINE_DEFEAT]"))
	self:set_text_raw("str_heading",translate_text("[MINE_FAIL]"))
	self:set_text_raw("str_message",translate_text("[MINE_DEFEAT]"))
	
	--[[
	self:activate_widget("str_retry")
	self:activate_widget("butt_yes")
	self:activate_widget("butt_no")
	self:hide_widget("butt_continue")
	--]]
	
	
	
	--self:SetStats()
	
	
end

function MiningResultsMenu:Victory()
	--[[
	local abandonedCargo = 0
	for i=1,5 do
		if self.cargoList[i] then
			local effect = _G.DATA.Cargo[self.cargoList[i].cargo].effect
			self:set_font("str_cargo"..i.."_val", "font_numbers_green")
			self:set_text("str_cargo"..i.."_val", "+" .. tostring(_G.Hero:GetAttribute(_G.DATA.Cargo[self.cargoList[i].cargo].effect)))
			if _G.Hero:GetAttribute(effect) < _G.Hero:GetAttribute(effect.."_max") then
				abandonedCargo = abandonedCargo + (_G.Hero:GetAttribute(effect.."_max") - _G.Hero:GetAttribute(effect))
			end
		end
	end

	if abandonedCargo ~= 0 then
		self:activate_widget("str_cargo_lost")
		self:set_text_raw("str_cargo_lost", "You have insufficient capacity on your ships and were forced to abandon some cargo.")
	else
		self:hide_widget("str_cargo_lost")
	end
	--]]
	
	self:set_text_raw("str_heading",translate_text("[MINE_SUCCESS]"))
	self:set_text_raw("str_message",translate_text("[MINE_VICTORY]"))
	
	--[[
	self:activate_widget("butt_continue")
	self:hide_widget("butt_yes")
	self:hide_widget("butt_no")
	self:hide_widget("str_retry")
	
	self:SetStats()
	
	if _G.Hero:NumAttributes("mined_asteroids") >= 3 then
		_G.Hero:EraseAttribute("mined_asteroids", _G.Hero:GetAttributeAt("mined_asteroids", 1))
	end
	_G.Hero:PushAttribute("mined_asteroids", _G.Hero:GetAttribute("curr_loc"))
	LOG("Pushed Attribute: " .. _G.Hero:GetAttribute("curr_loc"))
	for i=1, _G.Hero:NumAttributes("mined_asteroids") do
		LOG("Attribute " .. i ..": " .. _G.Hero:GetAttributeAt("mined_asteroids", i))
	end
	--]]
end

function MiningResultsMenu:SetStats()
	self:set_text_raw("str_chain",tostring(Hero.longest_chain))
	self:set_text_raw("str_fourofakinds",tostring(Hero.matchCount[4]))
	self:set_text_raw("str_fiveofakinds",tostring(Hero.matchCount[5]))
	self:set_text_raw("str_sixofakinds",tostring(Hero.matchCount[6]))
	self:set_text_raw("str_sevenofakinds",tostring(Hero.matchCount[7]))
	self:set_image("icon_ship", string.format("%s_L", _G.Hero:GetAttribute("curr_ship"):GetAttribute("portrait")))
	
	for i,v in pairs(self.cargoList) do
--		LOG("I = " .. tostring(i) .. "    v = " .. tostring(v))
		local tab = v
		for l,k in pairs(tab) do
--			LOG("l = " .. tostring(l) .. " k = " .. tostring(k))
		end		
	end
	
	--for i,v in pairs(self.cargoList) do
		
	--end
	local base_cargo = "img_cargo_big_"
	--if _G.GetScreenWidth()==256 then
	--	base_cargo = "img_cargo"
	--end
	
	for i=1,5 do
		if self.cargoList[i] then
			self:activate_widget(string.format("icon_cargo%d", i))
			self:activate_widget(string.format("str_cargo%d_val", i))
			self:set_image(string.format("icon_cargo%d", i), string.format("%s%s", base_cargo, tostring(self.cargoList[i].cargo)))
		else
			self:hide_widget(string.format("icon_cargo%d", i))
			self:hide_widget(string.format("str_cargo%d_val", i))
		end
	end
	
end

function MiningResultsMenu:OnButton(buttonId, clickX, clickY)

	local function transition()				
	end
	if not self.clicked then
		if buttonId == 1 then
			self.clicked = true
			self:Close()
			self.callback()
			SetFadeToBlack(false)
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "MiningResultsMenu")
		elseif buttonId == 0 then
			self.clicked = true
			self:Close()
			self.callback(false)
			--local function transition()
			--end
			SetFadeToBlack(false)
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "MiningResultsMenu")
		elseif buttonId == 2 then
			SCREENS.GameMenu:ShowMiningWidgets()
			self.clicked = true
			self:Close()
			self.callback(true)				
			--local function transition()
			--end
			SetFadeToBlack(false)
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "MiningResultsMenu")
		end
	end
	return Menu.MESSAGE_HANDLED
end

dofile("Assets/Scripts/Screens/MiningResultsMenuPlatform.lua")

-- return an instance of MiningResultsMenu
return ExportSingleInstance("MiningResultsMenu")
