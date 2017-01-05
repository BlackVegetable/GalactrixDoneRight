use_safeglobals()

-- declare our menu
class "CraftingResultsMenu" (Menu);

function CraftingResultsMenu:__init()
	super()

	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\CraftingResultsMenu.xml")
end


function CraftingResultsMenu:OnOpen()
	--LOG("CraftingResultsMenu opened. Victory: " .. tostring(self.victory));
	
	if string.char(string.byte(self.item)) ~= "S" then
		self:LoadItemPopup()
	else
		self:LoadShipPopup()
	end			
	
	SCREENS.GameMenu:HideMiningWidgets()
	
	self.clicked = nil
	
	if self.victory then	
		self:Victory()		
	else
		self:Defeat()
	end	
		
	return Menu.OnOpen(self)
end

function CraftingResultsMenu:OnAnimOpen(data)

	if data == 1 and self.victory then
	
		_G.GLOBAL_FUNCTIONS.CraftingCargoCost.SubtractCraftingCost(_G.Hero,self.item)	
	end
end

function CraftingResultsMenu:Open(victory,callback, itemID, gameData)
LOG("CraftingResultsMenu Open")
	self.victory = victory
	self.callback = callback
	self.item = itemID
	self.data = gameData
	
	self:LoadGraphics()
	
	return Menu.Open(self)
end

function CraftingResultsMenu:Defeat()
	self:set_text_raw("str_heading",translate_text("[FAILED]"))
	self:set_text_raw("str_message",translate_text("[CRAFT_DEFEAT]"))

	self:set_alpha("icon_ship", 0.5)
	self:set_alpha("icon_item", 0.5)
	
	self:activate_widget("str_retry")
	self:activate_widget("butt_yes")
	self:activate_widget("butt_no")
	self:hide_widget("butt_continue")

	self:SetStats()
end

function CraftingResultsMenu:Victory()
	self:set_alpha("icon_ship", 1)
	self:set_alpha("icon_item", 1)
	self:set_text_raw("str_heading",translate_text("[SUCCESS]"))
	self:set_text_raw("str_message",translate_text("[CRAFT_VICTORY]"))

	self:activate_widget("butt_continue")
	self:hide_widget("butt_yes")
	self:hide_widget("butt_no")
	self:hide_widget("str_retry")
	
	self:SetStats()
	
end

function CraftingResultsMenu:SetStats()
	--self:set_text_raw("str_psi",tostring(Hero:GetAttribute('psi')))
	self:set_text_raw("str_match_4_val",tostring(Hero.matchCount[4]))
	self:set_text_raw("str_match_5_val",tostring(Hero.matchCount[5]))
	--self:set_text_raw("str_novas_val",tostring(Hero.novas))
	self:set_text_raw("str_weap_comps_val", string.format("%d/%d", _G.Hero:GetAttribute("components_weap"), _G.Hero:GetAttribute("components_weap_max")))
	self:set_text_raw("str_eng_comps_val",  string.format("%d/%d", _G.Hero:GetAttribute("components_eng"),  _G.Hero:GetAttribute("components_eng_max")))
	self:set_text_raw("str_cpu_comps_val",  string.format("%d/%d", _G.Hero:GetAttribute("components_cpu"),  _G.Hero:GetAttribute("components_cpu_max")))
	
   
	self:set_text_raw("str_match_hazard_val", tostring(_G.Hero.biohazardMatches))
	self:set_text_raw("str_spawn_hazard_val", tostring(_G.Hero.biohazardSpawns))
	
	local percent = _G.Hero:GetAttribute("components_weap") + _G.Hero:GetAttribute("components_eng") + _G.Hero:GetAttribute("components_cpu")
	percent = percent / (_G.Hero:GetAttribute("components_weap_max") + _G.Hero:GetAttribute("components_eng_max") + _G.Hero:GetAttribute("components_cpu_max"))
	percent = math.floor(percent*100)
	self:set_text_raw("str_percent_complete_val", tostring(percent) .. "%")
	
	local myName = string.format("[%s_NAME]", self.item)
	local nameWidgetWidth = self:get_widget_w("str_name")
	myName = fit_text_to("font_button", myName, nameWidgetWidth)
	
	if string.char(string.byte(self.item)) == "S" then--Ship
		self:hide_widget("icon_item")
		self:hide_widget("str_desc")
		self:activate_widget("icon_ship")
		self:activate_widget("str_stat4_val")
		self:activate_widget("str_stat5_val")
		self:activate_widget("str_stat6_val")
		self:activate_widget("str_stat7_val")
		self:activate_widget("str_stat4")
		self:activate_widget("str_stat5")
		self:activate_widget("str_stat6")
		self:activate_widget("str_stat7")
		
		self:set_text("str_name", myName)
		self:set_text_raw("str_stat1_val", tostring(SHIPS[self.item].weapons_rating))
		self:set_text_raw("str_stat2_val", tostring(SHIPS[self.item].engine_rating))
		self:set_text_raw("str_stat3_val", tostring(SHIPS[self.item].cpu_rating))
		self:set_text_raw("str_stat4_val", tostring(SHIPS[self.item].max_items))
		self:set_text_raw("str_stat5_val", tostring(SHIPS[self.item].cargo_capacity))
		self:set_text_raw("str_stat6_val", tostring(SHIPS[self.item].hull))
		self:set_text_raw("str_stat7_val", tostring(SHIPS[self.item].shield))
		self:set_image("icon_ship", string.format("img_%s", self.item))
	else--Item
		
		self:hide_widget("icon_ship")
		self:hide_widget("str_stat4_val")
		self:hide_widget("str_stat5_val")
		self:hide_widget("str_stat6_val")
		self:hide_widget("str_stat7_val")
		self:hide_widget("str_stat4")
		self:hide_widget("str_stat5")
		self:hide_widget("str_stat6")
		self:hide_widget("str_stat7")
		self:activate_widget("icon_item")
		self:activate_widget("str_desc")
		
		self:set_text("str_name", myName)
		self:set_text_raw("str_stat1_val", tostring(ITEMS[self.item].weapon_requirement))
		self:set_text_raw("str_stat2_val", tostring(ITEMS[self.item].engine_requirement))
		self:set_text_raw("str_stat3_val", tostring(ITEMS[self.item].cpu_requirement))
		self:set_text("str_desc",          string.format("[%s_DESC]", self.item))
		self:set_image("icon_item",        string.format("%s", ITEMS[self.item].icon))
	end
		
end

function CraftingResultsMenu:OnClose()
	close_custompopup_menu()

	return Menu.MESSAGE_HANDLED
end

function CraftingResultsMenu:OnButton(buttonId, clickX, clickY)
	close_custompopup_menu()
	local function UnloadGraphics()
      -- unload any assetgroups in here
		UnloadAssetGroup("AssetsInventory")
	end		
	
	if not self.clicked then

		if buttonId == 1 then			
			self.clicked = true
			
			self.callback(false)	
			CallScreenSequencer("CraftingResultsMenu", UnloadGraphics)		
			local function transition()
				--remove_text_file("ItemText.xml")
			end		

			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "CraftingResultsMenu")
		elseif buttonId == 0 then--no
			self.clicked = true
						
			self.callback(false)
			CallScreenSequencer("CraftingResultsMenu", UnloadGraphics)				
			local function transition()		
				--remove_text_file("ItemText.xml")	
			end
				
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "CraftingResultsMenu")
		elseif buttonId == 2 then--yes -- retry
			self.clicked = true
			
			SCREENS.GameMenu:ShowMiningWidgets()		
			self.callback(true)
			CallScreenSequencer("CraftingResultsMenu", UnloadGraphics)				
			local function transition()				
			end
							
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", "CraftingResultsMenu", 500)
		end
	end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end

dofile("Assets/Scripts/Screens/CraftingResultsMenuPlatform.lua")

-- return an instance of CraftingResultsMenu
return ExportSingleInstance("CraftingResultsMenu")
