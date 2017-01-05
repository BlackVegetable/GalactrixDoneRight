
class "CargoTrader" (Menu)

function CargoTrader:__init()
	super()
	self:Initialize("Assets\\Screens\\CargoTrader.xml")
end

function CargoTrader:OnOpen()
	LOG("CargoTrader OnOpen()")
	--_G.LoadAssetGroup("AssetsButtons")--Already in SolarSystemMenu
	--_G.LoadAssetGroup("AssetsInsignias")--Already in SolarSystemMenu
	--_G.LoadAssetGroup("AssetsUI")

	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	
	
	self.lastTime = GetGameTime()
		
	self:InitCargoMultipliers()
	self.selectedCargo = 0
	self.cargoTraded = 0
	
	self:set_text_raw("str_shopname", translate_text(string.format("[%s_NAME]",_G.Hero:GetAttribute("curr_loc"))))
	self.system = _G.Hero:GetAttribute("curr_system")
	self:set_image("icon_faction", _G.DATA.Factions[_G.STARS[self.system].faction].icon)
	
	self:deactivate_widget("butt_trade1")
	self:deactivate_widget("butt_trade10")
	self:deactivate_widget("butt_tradeall")
	
	for i=1,10 do
		self:hide_widget("icon_highlight"..i)
	end
	
	
	self.soulless_system = false
	if SCREENS.SolarSystemMenu.sun:GetFaction()==_G.FACTION_SOULLESS then
		self.soulless_system = true
	end	
	
	

	self.cargo_values = {}	
	self:UpdateInfoFields()
	self:UpdateTable()
	
	_G.ShowTutorialFirstTime(24, _G.Hero)
	
	self:set_text("str_factionname", string.format(_G.DATA.Factions[_G.STARS[self.system].faction].name, "NAME"))
	self:hide_widget("str_info_faction")
	
	--BEGIN_STRIP_DS
	local function ShowSelections()
		self:activate_widget("icon_highlight1")
		self.selectedCargo = 1
		self:ShowSelected()
		self:SetButtons(self.selectedCargo)
	end
	
	-- SCF: Try to enable the dpad...
	if IsGamepadActive() then
		 MenuSystem.SetGamepadWidget(self, "str_heading")
	end
	
	_G.XBoxOnly(ShowSelections)
	--END_STRIP_DS
	
	return Menu.OnOpen(self)
end

function CargoTrader:OnClose()
	if self.cargoTraded >= 20 then
		local faction = _G.STARS[self.system].faction
		_G.Hero:SetAttributeAt("faction_standings", faction, math.min(100,_G.Hero:GetAttributeAt("faction_standings", faction) + math.floor(self.cargoTraded/20)))
	end
	
	local world = SCREENS.SolarSystemMenu.world
	for i,v in pairs(world.encounters) do
		local faction_standing = _G.Hero:GetFactionStanding(v.enemy:GetAttribute("faction"))
		--only update for positive standing
		if faction_standing == _G.STANDING_NEUTRAL then
			v.enemy.particle = "N"
		elseif faction_standing > _G.STANDING_NEUTRAL then
			v.enemy.particle = "F"			
		end
	end	
	
	
	_G.UnloadAssetGroup("AssetsInventory")
	--_G.UnloadAssetGroup("AssetsButtons")--Already in SolarSystemMenu
	--_G.UnloadAssetGroup("AssetsInsignias")--Already in SolarSystemMenu
	--_G.UnloadAssetGroup("AssetsUI")	
	close_custompopup_menu()
	
	self.system = nil
	self.cargoTraded = nil
	self.selectedCargo = nil
	clear(self.cargo_values)
	clear(self.cargoMultipliers)
	return Menu.OnClose(self)
end


function CargoTrader:InitCargoMultipliers()
	--Used to determine cargo costs/ and availability in systems
		self.cargoMultipliers = {}
		self.cargoMultipliers[_G.GOV_DICTATORSHIP]= {[_G.CARGO_FOOD]             = {cost=1.0,amount=1.0},
															  [_G.CARGO_TEXTILES]             = {cost=1.0,amount=1.0},
															  [_G.CARGO_MINERALS]             = {cost=1.0,amount=1.0},
															  [_G.CARGO_ALLOYS]               = {cost=1.0,amount=1.0},
															  [_G.CARGO_TECH]                 = {cost=1.0,amount=1.0},
															  [_G.CARGO_LUXURIES]             = {cost=1.0,amount=0.8},
															  [_G.CARGO_MEDICINE]             = {cost=1.1,amount=1.0},
															  [_G.CARGO_GEMS]                 = {cost=1.0,amount=1.0},
															  [_G.CARGO_GOLD]                 = {cost=1.0,amount=1.0},
															  [_G.CARGO_CONTRABAND]           = {cost=0.9,amount=1.0}}
		
		self.cargoMultipliers[_G.GOV_DEMOCRACY]= { [_G.CARGO_FOOD]               = {cost=1.0,amount=1.0},
														   [_G.CARGO_TEXTILES]               = {cost=1.0,amount=1.0},
														   [_G.CARGO_MINERALS]               = {cost=1.0,amount=1.0},
														   [_G.CARGO_ALLOYS]                 = {cost=1.0,amount=1.0},
														   [_G.CARGO_TECH]                   = {cost=1.0,amount=1.0},
														   [_G.CARGO_LUXURIES]               = {cost=1.0,amount=1.0},
														   [_G.CARGO_MEDICINE]               = {cost=1.0,amount=1.0},
														   [_G.CARGO_GEMS]                   = {cost=1.1,amount=1.0},
														   [_G.CARGO_GOLD]                   = {cost=1.1,amount=1.0},
														   [_G.CARGO_CONTRABAND]             = {cost=1.0,amount=1.0}}
		
		self.cargoMultipliers[_G.GOV_CORPORATE]= { [_G.CARGO_FOOD]               = {cost=1.0,amount=1.0},
															  [_G.CARGO_TEXTILES]             = {cost=1.0,amount=1.0},
															  [_G.CARGO_MINERALS]             = {cost=1.0,amount=1.0},
															  [_G.CARGO_ALLOYS]               = {cost=1.0,amount=1.0},
															  [_G.CARGO_TECH]                 = {cost=1.0,amount=1.0},
															  [_G.CARGO_LUXURIES]             = {cost=1.0,amount=1.2},
															  [_G.CARGO_MEDICINE]             = {cost=1.0,amount=1.0},
															  [_G.CARGO_GEMS]                 = {cost=1.2,amount=1.0},
															  [_G.CARGO_GOLD]                 = {cost=1.2,amount=1.0},
															  [_G.CARGO_CONTRABAND]           = {cost=1.0,amount=1.0}}
		
		self.cargoMultipliers[_G.GOV_FEUDAL]= { [_G.CARGO_FOOD]                  = {cost=1.1,amount=1.0},
														  [_G.CARGO_TEXTILES]                = {cost=1.1,amount=1.0},
														  [_G.CARGO_MINERALS]                = {cost=1.1,amount=1.0},
														  [_G.CARGO_ALLOYS]                  = {cost=1.1,amount=1.0},
														  [_G.CARGO_TECH]                    = {cost=1.2,amount=1.0},
														  [_G.CARGO_LUXURIES]                = {cost=1.0,amount=0.6},
														  [_G.CARGO_MEDICINE]                = {cost=1.2,amount=1.0},
														  [_G.CARGO_GEMS]                    = {cost=1.0,amount=1.0},
														  [_G.CARGO_GOLD]                    = {cost=1.0,amount=1.0},
														  [_G.CARGO_CONTRABAND]              = {cost=0.8,amount=1.2}}
		
		self.cargoMultipliers[_G.GOV_ANARCHIC]= { [_G.CARGO_FOOD]                = {cost=1.2,amount=0.6},
															[_G.CARGO_TEXTILES]               = {cost=1.2,amount=0.6},
															[_G.CARGO_MINERALS]               = {cost=1.2,amount=0.6},
															[_G.CARGO_ALLOYS]                 = {cost=1.2,amount=0.6},
															[_G.CARGO_TECH]                   = {cost=1.4,amount=0.6},
															[_G.CARGO_LUXURIES]               = {cost=1.2,amount=0.4},
															[_G.CARGO_MEDICINE]               = {cost=1.4,amount=0.6},
															[_G.CARGO_GEMS]                   = {cost=1.0,amount=0.6},
															[_G.CARGO_GOLD]                   = {cost=1.0,amount=0.6},
															[_G.CARGO_CONTRABAND]             = {cost=0.6,amount=1.4}}
		
		self.cargoMultipliers[_G.INDUSTRY_MINING]= { [_G.CARGO_FOOD]             = {cost=1.5,amount=0.5},
																[_G.CARGO_TEXTILES]            = {cost=1.3,amount=1.0},
																[_G.CARGO_MINERALS]            = {cost=0.5,amount=1.5},
																[_G.CARGO_ALLOYS]              = {cost=0.6,amount=1.4},
																[_G.CARGO_TECH]                = {cost=1.4,amount=0.8},
																[_G.CARGO_LUXURIES]            = {cost=0.7,amount=0.5},
																[_G.CARGO_MEDICINE]            = {cost=1.1,amount=0.4},
																[_G.CARGO_GEMS]                = {cost=0.7,amount=1.4},
																[_G.CARGO_GOLD]                = {cost=0.7,amount=1.4},
																[_G.CARGO_CONTRABAND]          = {cost=1.2,amount=1.0}}
		
		self.cargoMultipliers[_G.INDUSTRY_MILITARY]= { [_G.CARGO_FOOD]           = {cost=1.0,amount=0.4},
																	[_G.CARGO_TEXTILES]         = {cost=0.8,amount=0.4},
																	[_G.CARGO_MINERALS]         = {cost=0.7,amount=0.5},
																	[_G.CARGO_ALLOYS]           = {cost=1.1,amount=0.5},
																	[_G.CARGO_TECH]             = {cost=1.3,amount=1.2},
																	[_G.CARGO_LUXURIES]         = {cost=0.9,amount=0.2},
																	[_G.CARGO_MEDICINE]         = {cost=1.2,amount=0.2},
																	[_G.CARGO_GEMS]             = {cost=0.7,amount=0.4},
																	[_G.CARGO_GOLD]             = {cost=0.7,amount=0.3},
																	[_G.CARGO_CONTRABAND]       = {cost=1.5,amount=1.0}}
		
		self.cargoMultipliers[_G.INDUSTRY_AGRICULTURE]= { [_G.CARGO_FOOD]        = {cost=0.5,amount=1.5},
																		[_G.CARGO_TEXTILES]      = {cost=0.7,amount=1.4},
																		[_G.CARGO_MINERALS]      = {cost=1.1,amount=0.9},
																		[_G.CARGO_ALLOYS]        = {cost=1.1,amount=0.7},
																		[_G.CARGO_TECH]          = {cost=1.3,amount=0.6},
																		[_G.CARGO_LUXURIES]      = {cost=0.7,amount=0.9},
																		[_G.CARGO_MEDICINE]      = {cost=1.4,amount=1.1},
																		[_G.CARGO_GEMS]          = {cost=0.7,amount=0.5},
																		[_G.CARGO_GOLD]          = {cost=0.7,amount=0.5},
																		[_G.CARGO_CONTRABAND]    = {cost=1.0,amount=1.0}}
		
		self.cargoMultipliers[_G.INDUSTRY_INDUSTRIAL]= { [_G.CARGO_FOOD]         = {cost=1.1,amount=0.8},
																	  [_G.CARGO_TEXTILES]       = {cost=1.2,amount=1.0},
																	  [_G.CARGO_MINERALS]       = {cost=1.5,amount=1.1},
																	  [_G.CARGO_ALLOYS]         = {cost=1.4,amount=1.08},
																	  [_G.CARGO_TECH]           = {cost=0.94,amount=0.94},
																	  [_G.CARGO_LUXURIES]       = {cost=1.0,amount=1.0},
																	  [_G.CARGO_MEDICINE]       = {cost=1.0,amount=1.0},
																	  [_G.CARGO_GEMS]           = {cost=1.1,amount=1.1},
																	  [_G.CARGO_GOLD]           = {cost=1.0,amount=1.0},
																	  [_G.CARGO_CONTRABAND]     = {cost=1.1,amount=1.1}}
		
		self.cargoMultipliers[_G.INDUSTRY_ADMINISTRATIVE]= { [_G.CARGO_FOOD]     = {cost=1.3,amount=0.5},
																			[_G.CARGO_TEXTILES]   = {cost=1.2,amount=0.6},
																			[_G.CARGO_MINERALS]   = {cost=0.6,amount=0.4},
																			[_G.CARGO_ALLOYS]     = {cost=0.7,amount=0.5},
																			[_G.CARGO_TECH]       = {cost=1.5,amount=1.0},
																			[_G.CARGO_LUXURIES]   = {cost=1.5,amount=1.1},
																			[_G.CARGO_MEDICINE]   = {cost=1.0, amount=1.2},
																			[_G.CARGO_GEMS]       = {cost=1.4,amount=0.4},
																			[_G.CARGO_GOLD]       = {cost=1.5,amount=0.5},
																			[_G.CARGO_CONTRABAND] = {cost=1.3,amount=1.0}}		
	
end


function CargoTrader:GetCargoCost(hero,cargo,system)
	local faction = _G.STARS[system].faction
	local factionStanding = hero:GetFactionStanding(faction)
	
	local cost = _G.DATA.Cargo[cargo].cost -- get base cost
	LOG("Gov = " .. tostring(_G.STARS[system].gov))
	cost = cost * self.cargoMultipliers[_G.STARS[system].gov][cargo].cost -- apply government multiplier
	local tech = _G.STARS[system].tech
	if cargo == _G.CARGO_TECH or cargo == _G.CARGO_LUXURIES or cargo == _G.CARGO_MEDICINE then
		cost = cost * (1.0 - (tech * 0.005)) -- apply tech level multiplier
	end
	cost = cost * self.cargoMultipliers[_G.STARS[system].industry][cargo].cost -- apply industry multiplier
	cost = cost * _G.DATA.Standings[factionStanding].cost
	
	return cost
end

function CargoTrader:UpdateTable()
	self.cargo_values = {}
	for i=1, _G.NUM_CARGOES do		
		-- selling cargo
		local paymentPerUnit
		if self.soulless_system then
			paymentPerUnit = 0
		else
			paymentPerUnit = math.floor(self:GetCargoCost(_G.Hero, i, self.system) * 0.98)
		end
		local valuePerUnit = _G.DATA.Cargo[i].cost
		
		if _G.Hero:GetAttributeAt("cargo", i) == 0 then
			self:set_text_raw("str_amount_cargo"..i, "-")
			self:set_text_raw("str_value_cargo"..i, "-")
			self:set_font("str_value_cargo"..i, "font_info_gray")
			
			--BEGIN_STRIP_DS
			WiiOnly(self.set_font, self, "str_value_cargo"..i, "font_info_white")
			--END_STRIP_DS
			
			self.cargo_values[i]=paymentPerUnit
		else
			self:set_text_raw("str_amount_cargo"..i, tostring(_G.Hero:GetAttributeAt("cargo", i)))
			self:set_text_raw("str_value_cargo"..i, tostring(paymentPerUnit))
			self.cargo_values[i]=paymentPerUnit
			
			if paymentPerUnit > valuePerUnit then
				self:set_font("str_value_cargo"..i, "font_info_green")
			elseif paymentPerUnit < valuePerUnit then
				self:set_font("str_value_cargo"..i, "font_info_red")
			else
				self:set_font("str_value_cargo"..i, "font_info_gray")
				
				--BEGIN_STRIP_DS
				WiiOnly(self.set_font, self, "str_value_cargo"..i, "font_info_white")
				--END_STRIP_DS				
			end
		end
		
		
		
	end
end


function CargoTrader:OnButton(id, x, y)
	if id == 99 then
		self:Close()
	elseif id == 60 then
		-- trade 1 unit of cargo
		self:TradeCargo(1)
		self:SetButtons(self.selectedCargo)
	elseif id == 61 then
		-- trade 10 units of cargo
		self:TradeCargo(10)
		self:SetButtons(self.selectedCargo)
	elseif id == 62 then
		-- trade all cargo
		self:TradeCargo(_G.Hero:GetAttributeAt("cargo", self.selectedCargo))
		self:SetButtons(self.selectedCargo)
	end

	return Menu.MESSAGE_HANDLED
end

function CargoTrader:TradeCargo(amount)
	local cargoAmount = _G.Hero:GetAttributeAt("cargo", self.selectedCargo)
	local value = math.floor(self:GetCargoCost(_G.Hero, self.selectedCargo, self.system)*0.98)*amount
	_G.Hero:RemoveCargo(self.selectedCargo, amount)
	_G.Hero:OnEventGiveGold(nil,value)
	PlaySound("snd_cash")
	--_G.Hero:SetAttribute("credits", _G.Hero:GetAttribute("credits") + value)
	self.cargoTraded = self.cargoTraded + amount
	if self.cargoTraded >= 20 then
		self:activate_widget("str_info_faction")
		self:set_text_raw("str_info_faction", string.format("%s %s", translate_text("[FACTION_]"), string.format("+%d", math.min(100, math.floor(self.cargoTraded/20)))))
	end


	self:UpdateTable()
	self:UpdateInfoFields()
	self:SetButtons(self.selectedCargo)
end

function CargoTrader:SetButtons(cargoID)
	-- if no cargo selected, do nothing
	if cargoID == 0 then
		return
	end
	
	-- gather information about hero's cargo-related stats
	local money = _G.Hero:GetAttribute("credits")
	local currentCargo = 0
	for i=1, _G.NUM_CARGOES do
		currentCargo = currentCargo + _G.Hero:GetAttributeAt("cargo", i)
	end
	
	LOG(string.format("%s %d   %s %s", "Current cargo =", currentCargo, "Max Cargo =", tostring(self.maxCargo)))
	if not self.soulless_system then
		if _G.Hero:GetAttributeAt("cargo", cargoID) >= 10 then
			self:activate_widget("butt_tradeall")
			self:activate_widget("butt_trade10")
			self:activate_widget("butt_trade1")
		elseif _G.Hero:GetAttributeAt("cargo", cargoID) >= 1 then
			self:activate_widget("butt_tradeall")
			self:activate_widget("butt_trade1")
			self:deactivate_widget("butt_trade10")
		else
			self:deactivate_widget("butt_trade1")
			self:deactivate_widget("butt_trade10")
			self:deactivate_widget("butt_tradeall")
		end
	end
end

function CargoTrader:OnMouseLeftButton(id, x, y, up)
	LOG("Pressed")
	if up then
		self:hide_widget("icon_highlight"..self.selectedCargo)
		self:activate_widget("icon_highlight"..id)
		self.selectedCargo = id
		self:ShowSelected()
		self:SetButtons(self.selectedCargo)
	end
	
	return Menu.MESSAGE_HANDLED
end



dofile("Assets/Scripts/Screens/CargoTraderPlatform.lua")

return ExportSingleInstance("CargoTrader")