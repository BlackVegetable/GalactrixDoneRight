
use_safeglobals()

class "DebugMenu" (Menu)

function DebugMenu:__init()
	super()
	self:Initialize("Assets\\Screens\\DebugMenu.xml")
end

function DebugMenu:OnOpen()
	self.faction = 1
	for i=1,7 do
		self:set_widget_value("check_crew"..i, 0)
	end
	
	for i=1,_G.Hero:NumAttributes("crew") do
		local id = _G.Hero:GetAttributeAt("crew", i)
		if id == "C000" then
			self:set_widget_value("check_crew1", 1)
		elseif id == "C001" then
			self:set_widget_value("check_crew2", 1)
		elseif id == "C002" then
			self:set_widget_value("check_crew3", 1)
		elseif id == "C003" then
			self:set_widget_value("check_crew4", 1)
		elseif id == "C004" then
			self:set_widget_value("check_crew5", 1)
		elseif id == "C005" then
			self:set_widget_value("check_crew6", 1)
		elseif id == "C006" then
			self:set_widget_value("check_crew7", 1)
		end
	end
	self:UpdateList()
	return Menu.MESSAGE_HANDLED
end

function DebugMenu:OnClose()
	_G.Hero:ClearAttributeCollection("crew")
	for i=1,7 do
		LOG("Widget Val = " .. tostring(self:get_widget_value("check_crew"..i)))
		if self:get_widget_value("check_crew"..i) == 1 then
			LOG("Push Val = " .. tostring("C00" .. tostring(i-1)))
			_G.Hero:PushAttribute("crew", "C00" .. tostring(i-1))
		end
	end
	self.faction = nil
	return Menu.MESSAGE_HANDLED
end

function DebugMenu:UpdateList()
	self:set_text("str_intel",      "Intel: " .. tostring(_G.Hero:GetAttribute("intel")))
	self:set_text("str_psi",        "Psi Points: " .. tostring(_G.Hero:GetAttribute("psi")))
	self:set_text("str_credits",    "Credits: " .. tostring(_G.Hero:GetAttribute("credits")))
	self:set_text("str_psi_powers", "Psi Powers: " .. tostring(_G.Hero:GetAttribute("psi_powers")))
	self:set_text("str_skill_points", "Skill Points: " .. tostring(_G.Hero:GetAttribute("stat_points")))
	self:set_image("icon_faction", _G.DATA.Factions[_G.Hero:GetAttributeAt("encountered_factions", self.faction)].icon)
end

function DebugMenu:OnButton(id, x, y)
	local init_quest = "Q000"
	
	_G.Hero:SetToSave()

	local amount, effect
	if id == 199 then
		self:Close()
		return Menu.MESSAGE_HANDLED
	elseif id == 211 then
		_G.Hero:ClearAttributeCollection("crew")
		for i=1,7 do
			_G.Hero:PushAttribute("crew", string.format("C%03f", i-1))
			self:set_widget_value("check_crew"..i, 1)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 212 then
		_G.Hero:ClearAttributeCollection("crew")
		for i=1,7 do
			self:set_widget_value("check_crew"..i, 0)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 201 then
		self:Close()
		_G.GLOBAL_FUNCTIONS.Mine("SolarSystemMenu",_G.Hero,LoadSatellite("T004"))
		return Menu.MESSAGE_HANDLED
	elseif id == 202 then
		self:Close()
		_G.LoadAssetGroup("AssetsInventory")	
		_G.LoadAssetGroup("AssetsItems")		
		_G.LoadAssetGroup("AssetsBattleGround")		
		_G.GLOBAL_FUNCTIONS.CraftItem("SolarSystemMenu", _G.Hero, nil, nil, nil)
		return Menu.MESSAGE_HANDLED
	elseif id == 203 then
		self:Close()
		_G.GLOBAL_FUNCTIONS.Rumor("SolarSystemMenu", _G.Hero, LoadSatellite("T029"), nil, nil)
		return Menu.MESSAGE_HANDLED
	elseif id == 204 then
		self:Close()
		_G.GLOBAL_FUNCTIONS.Bargain("SolarSystemMenu", _G.Hero, nil, nil, nil)
		return Menu.MESSAGE_HANDLED
	elseif id == 205 then
		self:Close()
		_G.GLOBAL_FUNCTIONS.Hack("SolarSystemMenu", _G.Hero, LoadGate("J001"), nil, nil)
		return Menu.MESSAGE_HANDLED
	elseif id == 42 then
		self:OnButton(127) -- credits
		self:OnButton(151) -- hack gates
		self:OnButton(161) -- give items
		self:OnButton(191) -- give plans
		self:OnButton(181) -- fast ship
		self:OnButton(176) -- all friendly
		_G.Hero:ClearAttributeCollection("crew")
		for i=1,7 do
			_G.Hero:PushAttribute("crew", string.format("C%03f", i-1))
			self:set_widget_value("check_crew"..i, 1)
		end
		return Menu.MESSAGE_HANDLED
	elseif id < 110 then
		effect = "intel"
		if id > 105 then
			amount = 10 * (10^(id-106))
		else
			amount = -10 * (10^(104-id))
		end
	elseif id < 120 then
		effect = "psi"
		if id > 115 then
			amount = 10 * (10^(id-116))
		else
			amount = -10 * (10^(114-id))
		end
	elseif id < 130 then
		effect = "credits"
		if id > 125 then
			amount = 10 * (10^(id-126))
		else
			amount = -10 * (10^(124-id))
		end
	elseif id < 140 then
		effect = "psi_powers"
		amount = id - 135
	elseif id > 210 and id < 220 then
		effect = "stat_points"
		amount = (id-215)*5
	elseif id < 150 then
		return Menu.MESSAGE_HANDLED
	elseif id == 151 then
		_G.Hero:ClearAttributeCollection("hacked_gates")
		for i,v in pairs(_G.DATA.JumpGatesTable) do
			_G.Hero:PushAttribute("hacked_gates",i)
		end
		for i,v in pairs(_G.JumpGateList) do
			v:SetAttribute("hacked", 1)
		end
		SCREENS.SolarSystemMenu:RefreshGateSprites()
		return Menu.MESSAGE_HANDLED		
	elseif id == 152 then
		_G.Hero:ClearAttributeCollection("hacked_gates")
		for i,v in pairs(_G.JumpGateList) do
			v:SetAttribute("hacked", 0)
		end
		SCREENS.SolarSystemMenu:RefreshGateSprites()
		return Menu.MESSAGE_HANDLED
	elseif id == 153 then
		_G.Hero:SetAttribute("gunnery", 1)
		_G.Hero:SetAttribute("engineer", 1)
		_G.Hero:SetAttribute("science", 1)
		_G.Hero:SetAttribute("pilot", 1)
		return Menu.MESSAGE_HANDLED
	elseif id == 154 then
		if _G.Hero:NumAttributes("ship_list") < 3 then
			local loadout = GameObjectManager:Construct("IL00")
			loadout:SetAttribute("ship", "SSHL")
			_G.Hero:PushAttribute("ship_list", loadout)
		end
		local cargoCapacity = 0
		for i=1,10 do
			_G.Hero:SetAttributeAt("cargo", i, 0)
		end
		for i=1,3 do
			if _G.Hero:NumAttributes("ship_list") >= i then
				cargoCapacity = cargoCapacity + SHIPS[_G.Hero:GetAttributeAt("ship_list",i):GetAttribute("ship")].cargo_capacity
			end
		end
		for i=1,10 do
			_G.Hero:SetAttributeAt("cargo", i, math.floor(cargoCapacity / 10))
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 161 then
		_G.Hero:ClearAttributeCollection("items")
		for i=1,161 do
			_G.Hero:PushAttribute("items", string.format("I%03d", tostring(i)))
			--_G.Hero:AddItem(string.format("I%03d", tostring(i)), false)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 176 then
		for i=1,_G.Hero:NumAttributes("faction_standings") do
			_G.Hero:SetAttributeAt("faction_standings", i, 100)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 177 then
		for i=1,_G.Hero:NumAttributes("faction_standings") do
			_G.Hero:SetAttributeAt("faction_standings", i, -100)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 181 then
		if _G.Hero:NumAttributes("ship_list") < 3 then
			local loadout = GameObjectManager:Construct("IL00")
			loadout:SetAttribute("ship", "SAGS")
			_G.Hero:PushAttribute("ship_list", loadout)
			_G.Hero:SetAttribute("ship_loadout", _G.Hero:NumAttributes("ship_list"))
			local ship =  _G.GLOBAL_FUNCTIONS.LoadShip("SAGS")
			_G.Hero:SetAttribute("curr_ship",ship)
			_G.Hero:AddChild(ship)
			ship.pilot = _G.Hero
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 182 then
		if _G.Hero:NumAttributes("ship_list") < 3 then
			local loadout = GameObjectManager:Construct("IL00")
			loadout:SetAttribute("ship", "SSGS")
			_G.Hero:PushAttribute("ship_list", loadout)
			_G.Hero:SetAttribute("ship_loadout", _G.Hero:NumAttributes("ship_list"))
			local ship = _G.GLOBAL_FUNCTIONS.LoadShip("SSGS")
			_G.Hero:SetAttribute("curr_ship", ship)
			_G.Hero:AddChild(ship)
			ship.pilot = _G.Hero
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 183 then
		_G.Hero:ClearAttributeCollection("ship_list")
		local loadout = GameObjectManager:Construct("IL00")
		loadout:SetAttribute("ship", "SMBL")
		_G.Hero:PushAttribute("ship_list", loadout)
		_G.Hero:SetAttribute("ship_loadout", 1)
		local ship = _G.GLOBAL_FUNCTIONS.LoadShip("SMBL")
		_G.Hero:SetAttribute("curr_ship", ship)
		_G.Hero:AddChild(ship)
		ship.pilot = _G.Hero
		return Menu.MESSAGE_HANDLED
	elseif id == 191 then
		for i=1,161 do
			_G.Hero:PushAttribute("plans", string.format("I%03d", i))
		end
		local shipList = {
			"SMBL",
			"STDS",
			"SSMT",
			"SCBS",
			"SPWS",
			"SLWS",
			"SELF",
			"SKTS",
			"SMPA",
			"SCTN",
			"STWS",
			"SDMS",
			"SCMA",
			"SLHC",
			"SVHC",
			"SSWS",
			"SSHL",
			"SJHS",
			"SPSS",
			"SQLS",
			"STDG",
			"SMRM",
			"SAGS",
			"SVDR",
			"SSHC",
			"SLAS",
			"STBS",
			"SSGS"
		}
		for i,v in ipairs(shipList) do
			_G.Hero:PushAttribute("plans", v)
		end		
		return Menu.MESSAGE_HANDLED
	elseif id == 201 then
		-- Quest player profile
		-- Fast ship, no crew, quests reset, gates all hacked, all psi powers
		self:OnButton(151, 0, 0)
		self:OnButton(181, 0, 0)
		_G.Hero:SetAttribute("psi_powers", 7)
		_G.Hero:ClearAttributeCollection("crew")
		for i=1,7 do
			self:set_widget_value("check_crew"..i, 0)
		end
		for i=1,_G.NUM_CARGOES do
			_G.Hero:SetAttributeAt("cargo", i, 0)
		end
		_G.Hero:ClearAttributeCollection("available_quests")
		_G.Hero:ClearAttributeCollection("running_quests")
		AddAvailableQuest(_G.Hero,init_quest)		
		self:UpdateList()
		return Menu.MESSAGE_HANDLED		
	elseif id == 202 then
		-- Minigame player profile
		-- Fast ship, all crew, all plans, all psi powers, no rumors
		self:OnButton(152, 0, 0)
		self:OnButton(191, 0, 0)
		self:OnButton(181, 0, 0)
		_G.Hero:SetAttribute("psi_powers", 7)
		_G.Hero:ClearAttributeCollection("crew")
		_G.Hero:ClearAttributeCollection("unlocked_rumors")
		_G.Hero:ClearAttributeCollection("mined_asteroids")
		for i=1,7 do
			_G.Hero:PushAttribute("crew", string.format("C%03f", i-1))
			self:set_widget_value("check_crew"..i, 1)
		end
		self:UpdateList()
		return Menu.MESSAGE_HANDLED
	elseif id == 203 then
		-- Default Profile
		-- resets stats, crew, items, plans, gates, ships, cargo, and quests
		_G.Hero:SetAttribute("gunnery", 1)
		_G.Hero:SetAttribute("engineer", 1)
		_G.Hero:SetAttribute("science", 1)
		_G.Hero:SetAttribute("pilot", 1)
		_G.Hero:SetAttribute("psi", 0)
		_G.Hero:SetAttribute("intel", 0)
		_G.Hero:SetAttribute("credits", 0)
		_G.Hero:SetAttribute("psi_powers", 0)
		_G.Hero:ClearAttributeCollection("crew")
		_G.Hero:ClearAttributeCollection("items")
		_G.Hero:ClearAttributeCollection("plans")
		self:OnButton(183, 0, 0)
		self:OnButton(152, 0, 0)
		for i=1,_G.Hero:NumAttributes("ship_list") do
			_G.Hero:GetAttributeAt("ship_list", i):ClearAttributeCollection("items")
		end
		for i=1,7 do
			self:set_widget_value("check_crew"..i, 0)
		end
		for i=1,_G.NUM_CARGOES do
			_G.Hero:SetAttributeAt("cargo", i, 0)
		end
		self:UpdateList()
		_G.Hero:ClearAttributeCollection("mined_asteroids")
		_G.Hero:ClearAttributeCollection("available_quests")
		_G.Hero:ClearAttributeCollection("running_quests")
		AddAvailableQuest(_G.Hero,init_quest)
		return Menu.MESSAGE_HANDLED
	elseif id == 999 then
		-- Award Achievement - give first ungiven achievement
		local achieveTable = {
		_G.XLAST.ACHIEVEMENT_ACHIEVE_PROGRESS_1,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_PROGRESS_2,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_GAMECOMPLETE,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_LEVELLING,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_SIDEQUESTS,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_HACK_1,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_HACK_2,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_MINING,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_HAGGLING,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_RUMORS,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_MP_1,
		_G.XLAST.ACHIEVEMENT_ACHIEVE_MP_2
		}
		for k,v in pairs(achieveTable) do
			if not HasAchievement(1, v) then
				AwardXAchievement(1, v)
				return Menu.MESSAGE_HANDLED
			end
		end
		return Menu.MESSAGE_HANDLED
	end
	
	if effect == "psi_powers" then
		_G.Hero:SetAttribute(effect, math.max(math.min(_G.Hero:GetAttribute(effect) + amount, 7),0))
	elseif effect == "stat_points" then
		_G.Hero:SetAttribute(effect, math.max(math.min(_G.Hero:GetAttribute(effect) + amount, 250), 0))
	else
		_G.Hero:SetAttribute(effect, math.max(_G.Hero:GetAttribute(effect) + amount, 0))
	end
	self:UpdateList()
	return Menu.MESSAGE_HANDLED
end

return ExportSingleInstance("DebugMenu")
