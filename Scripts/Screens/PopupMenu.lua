use_safeglobals()


-- declare our menu
class "PopupMenu" (Menu);


function PopupMenu:__init()
	super()
	
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\PopupMenu.xml")
	
	
	
end


--dofile("Assets/Scripts/Screens/PopupMenuPlatform.lua")
function PopupMenu:GetQuests()
	SCREENS.GetQuestsMenu:Open(self.satellite)
	self:Close()	
end

function PopupMenu:OnOpen()
	LOG("PopupMenu opened");
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	close_custompopup_menu()
	
	self:set_alpha("sbar_list", 0)
	self:reset_list("list_satellite")

	
	self:set_listbox_hover("list_satellite", true)

	self.close_timer = false
	
	self.itemValue = nil
	self.selected = false
	
	self.allow_all_options = (_G.SCREENS.SolarSystemMenu.sun.classIDStr=="S000" or (not _G.GLOBAL_FUNCTIONS.DemoMode()))
		--open_message_menu("[DISABLED]","[OPTION_DISABLED_MESSAGE]")	
	
	
	self.disabled_list = {}	
	
	if not self.allow_all_options then
		self.disabled_list = {["[HACK_GATE]"]=true,["[TRADE_CARGO]"]=true,["[MINE]"]=true,["[CRAFT_ITEM]"]=true,["[SHOP]"]=true}
	end	
		
	return Menu.OnOpen(self)
end


function PopupMenu:OnGamepadDPad(user, dpad, x, y)
	
	if y ~= 0 then
		local curr_selection = self:get_list_value("list_satellite")
		LOG("curr_selection "..tostring(curr_selection))
		if y == 1 then--Up
			curr_selection = curr_selection -1
			if curr_selection < 1 then
				curr_selection = self:get_list_option_count("list_satellite")
			end
		elseif y==-1 then
			curr_selection = curr_selection + 1
			if curr_selection > self:get_list_option_count("list_satellite") then
				curr_selection = 1
			end	
		end
		
	
		LOG("curr_selection "..tostring(curr_selection))
		self:set_list_value("list_satellite",curr_selection)
	end
	
	return Menu.MESSAGE_HANDLED
end



function PopupMenu:CreateList(satellite)
	local classIdStr = satellite.classIDStr	
	LOG("Create List "..classIdStr)
	self.satellite = satellite
	

	local starID
	if ClassIDToString(self.satellite:GetClassID())=="Gate" then
		starID = _G.SCREENS.SolarSystemMenu.sun.classIDStr
	end
	self:reset_list("list_satellite")
	
	self.questActionList = _G.GetAvailableObjectives( _G.Hero, satellite.classIDStr )	

	local satelliteMenu = satellite:GetPopupMenu()
	self.menuList = {}	
	
	local listItems = 0

	
	
	for k,v in pairs(self.questActionList) do
		if not starID or (starID and  v.location[starID]) then--gates require additional starID check
			self:set_list_option("list_satellite", v.action)
			if false then--Check Preconditions now?
				self:set_list_option_disabled("list_satellite", v.action)	
			end			
			listItems=listItems+1
			self.menuList[listItems] = translate_text(v.action)
		end
	end	
	
	
	for i,v in pairs(satelliteMenu) do
		self:set_list_option("list_satellite",v)
		if self.disabled_list[v] then
			self:set_list_option_disabled("list_satellite", v)	
		end		
		listItems=listItems+1
		self.menuList[listItems] = translate_text(v)
	end

		
	
	self:StartAnimation("DisplayList")
	
	if IsGamepadActive() and _G.SCREEN_WIDTH ~= 256 then
		self:set_listbox_hover("list_satellite", false)
		self:set_list_value("list_satellite",1)
	else
		self:set_listbox_hover("list_satellite", true)
	end
	return listItems
end





function PopupMenu:SelectListBoxItem(item)
	
	if not self.selected then
		SCREENS.SolarSystemMenu:UpdateUI()
		SCREENS.SolarSystemMenu:GetWorld():DeselectSatellite()	
	
		local classID = ClassIDToString(self.satellite:GetClassID())
		self.itemValue = self:get_list_option("list_satellite")
			
		self:StartAnimation("SelectItem")
		--if not self.close_timer then
			--self:Close()	
		--end
		self.selected = true	
	end
	
end


function PopupMenu:OnListbox(id, item)	
	LOG("On List Box "..tostring(id))

	PlaySound("snd_mapmenuclick")
	
	
			
	if id == 32 then
		
		self:SelectListBoxItem(item)
	end
	
	
	LOG("end OnListBox()")
	return Menu.MESSAGE_HANDLED
end






function PopupMenu:OnTimer(time)
	if self.close_timer then
		LOG("CloseTimer = "..tostring(self.close_timer))
		if self.close_timer == true then
			self.close_timer = time
		elseif time > (self.close_timer + 200) then 
			self:Close()		
		elseif (time - self.close_timer) < 0 then
			self:Close()
		end
	end
	return Menu.OnTimer(self,time)
end

function PopupMenu:OnGamepadButton(user, button, val)
	LOG("OnGamePadButton val="..tostring(val))
	if val==0 then
		return Menu.MESSAGE_HANDLED
	end
	if val == 1 and button == _G.BUTTON_B then
		-- close popup
		SCREENS.SolarSystemMenu:GetWorld():DeselectSatellite()
		self:Close()	
	elseif val == 1 and button == _G.BUTTON_A then
		self:SelectListBoxItem(self:get_list_value("list_satellite"))
	end
	
	return Menu.MESSAGE_HANDLED
end

function PopupMenu:OnAnimSelectItem()
	
	local allow_all_options = (_G.SCREENS.SolarSystemMenu.sun.classIDStr=="S000" or (not _G.GLOBAL_FUNCTIONS.DemoMode()))
	--open_message_menu("[DISABLED]","[OPTION_DISABLED_MESSAGE]")
	
	if self.disabled_list[self.itemValue] then
		self:Close()
		self:ShowOptionDisabledMessage()
		return Menu.MESSAGE_HANDLED
	end
	
	
	if self.itemValue == "[CLOSE]" then
		-- it will close
	elseif self.itemValue == "[INVENTORY]" then
		_G.LoadAssetGroup("AssetsInventory")		

		--BEGIN_STRIP_DS
		local function OpenInventoryNotDS()
			SCREENS.InventoryFrame:Open("SolarSystemMenu", 1)
		end
		_G.NotDS(OpenInventoryNotDS)
		--END_STRIP_DS
		local function OpenInventoryDS()
			local function wrapt()
				_G.CallScreenSequencer("SolarSystemMenu", "InventoryFrame", "SolarSystemMenu", 1,nil,nil, SCREENS.SolarSystemMenu.encounter_timer)
			end
			--SCREENS.CustomLoadingMenu:SetTarg(nil, wrapt, nil, "InventoryFrame", "SolarSystemMenu")
			SCREENS.CustomLoadingMenu:Open(nil, wrapt, nil, "InventoryFrame", "SolarSystemMenu")			
		end
		_G.DSOnly(OpenInventoryDS)		
		
	elseif self.itemValue == "[GET_QUESTS]" then
		self.close_timer = true
		self:GetQuests()		

	elseif self.itemValue == "[HACK_GATE]" then
		_G.GLOBAL_FUNCTIONS.Hack("SolarSystemMenu",_G.Hero,_G.Hero:GetAttribute("curr_loc"))	
	elseif self.itemValue == "[OPEN_GATE]" then
		SCREENS.SolarSystemMenu:OpenStarMap(self.satellite.classIDStr)
	elseif self.itemValue == "[MINE]" then	
		_G.GLOBAL_FUNCTIONS.Mine("SolarSystemMenu",_G.Hero,_G.Hero:GetAttribute("curr_loc"))	
	elseif self.itemValue == "[SHOP]" then
		--self:OpenShopMenu()
		--_G.GLOBAL_FUNCTIONS.ManageAssetGroups("ShopMenu")--This will not close SolarSystemMenu - but will unload its assets
		local function transition()
			_G.LoadAssetGroup("AssetsInventory")	
			_G.LoadAssetGroup("AssetsItems")		
			
			SCREENS.ShopMenu:Open()
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, "ShopMenu")
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "ShopMenu")
		--SCREENS.SampleBuy:Open()
	elseif self.itemValue == "[TRADE_CARGO]" then
			
		_G.LoadAssetGroup("AssetsInventory")		
		SCREENS.CargoTrader:Open()
	elseif self.itemValue == "[CRAFT_ITEM]"  then
		_G.GLOBAL_FUNCTIONS.CraftItem("SolarSystemMenu", _G.Hero)
	elseif self.itemValue == "[RUMOR_TEST]"  then
		_G.GLOBAL_FUNCTIONS.Rumor("SolarSystemMenu", _G.Hero, _G.Hero:GetAttribute("curr_loc"))
	elseif self.itemValue then
		PerformQuestAction(_G.Hero,self.itemValue)
		self.close_timer = true
		LOG("performQuestAction "..self.itemValue)
	end	

	--self.close_timer = true	
	if not self.close_timer then
		self:Close()	
	end	
	
	return Menu.MESSAGE_HANDLED
end

function PopupMenu:OnClose()
	LOG("PopupMenu:OnClose()")
	
	
	return Menu.MESSAGE_HANDLED
end

function PopupMenu:OnMouseLeftButton(id, x, y, up)
	if id == 100 then
		self:Close()
		SCREENS.SolarSystemMenu.state=_G.STATE_FLIGHT
		SCREENS.SolarSystemMenu:OnMouseLeftButton(id,x,y,up)
	end
	
	return Menu.OnMouseLeftButton(self,id,x,y,up)
end

dofile("Assets/Scripts/Screens/PopupMenuPlatform.lua")

-- return an instance of PopupMenu
return ExportSingleInstance("PopupMenu")
