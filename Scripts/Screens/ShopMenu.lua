
use_safeglobals()

class "ShopMenu" (Menu);

function ShopMenu:__init()
	super()
	self:Initialize("Assets\\Screens\\ShopMenu.xml")
end

function ShopMenu:OnOpen()
	LOG("ShopMenu Opened()")
	
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	--add_text_file("ItemText.xml")
	
	self:set_text_raw("str_credits", substitute(translate_text("[N_CREDITS]"), tostring(_G.Hero:GetAttribute("credits"))))
	self:set_image("icon_faction", _G.DATA.Factions[SCREENS.SolarSystemMenu.sun:GetFaction()].icon)

	self.sellTable = { }
	for i=1,_G.Hero:NumAttributes("items") do
		table.insert(self.sellTable, _G.Hero:GetAttributeAt("items", i))
	end
	LOG("Num ships = " .. tostring(_G.Hero:NumAttributes("ship_list")))
	for i=1, _G.Hero:NumAttributes("ship_list") do
		table.insert(self.sellTable, _G.Hero:GetAttributeAt("ship_list", i):GetAttribute("ship"))
		LOG("Inserted into sell table: " .. tostring(_G.Hero:GetAttributeAt("ship_list", i):GetAttribute("ship")))
	end
	if self.buying == nil then
		self.buying = true
	end
	self:set_text("str_shopname", string.format("[%s_NAME]",_G.Hero:GetAttribute("curr_loc")))
	math.randomseed(_G.Hero:GetAttribute("battles_fought") + tonumber(string.byte(self:get_text("str_shopname"),2)))
	self.buyTable = self:GenerateItems()

	self.sellTable = self:SortList(self.sellTable, false)
	self.buyTable  = self:SortList(self.buyTable, true)
	
	_G.ShowTutorialFirstTime(22, _G.Hero)	
	
	if not self.costMultiplier then
		-- set initial mode
		self.costMultiplier = 1.0
		self:hide_widget("str_haggle_bonus")
		if CollectionContainsAttribute(_G.Hero, "crew", "C004") then
			self:activate_widget("butt_haggle")
			--_G.ShowTutorialFirstTime(23, _G.Hero)--This is old - had incorrect text - was removed - 23 now Rumor Tutorial
		else
			self:hide_widget("butt_haggle")
		end
	else
		self:activate_widget("str_haggle_bonus")
		--self:deactivate_widget("butt_haggle")
		self:set_text("str_haggle_bonus", string.format("%.2f%% %s", (1-self.costMultiplier)*100, translate_text("[BONUS]")))		
	end
	
	self:UpdateList(0, self.buyTable)
	self:SetModeBuying(self.buying, true)

	self:hide_widget("butt_prev")
	if #self.buyTable > 8 then
		self:activate_widget("butt_next")
	else
		self:hide_widget("butt_next")
	end
	
	if IsGamepadActive() then
		self:activate_widget("grp_gp")
		self.selectedIndex = 1
		self:set_widget_position("icon_gp_light", 231, 228)
	else
		self:hide_widget("grp_gp")
	end
	
	-- Buy items/Sell Items buttons
   self:deactivate_widget("butt_buy")
	self:activate_widget("butt_sell")

   self:ItemDeselected() -- for DS
   
	self.lastTime = GetGameTime()
	
	return Menu.MESSAGE_HANDLED
end

function ShopMenu:SortList(list, force)
	local function costComparison(a,b)
		local cost1, cost2
		if string.char(string.byte(a)) == "S" then
			cost1 = SHIPS[a].cost
		else
			cost1 = ITEMS[a].cost
		end
		if string.char(string.byte(b)) == "S" then
			cost2 = SHIPS[b].cost
		else
			cost2 = ITEMS[b].cost
		end
		return cost1 < cost2
	end
	
	list = _G.GLOBAL_FUNCTIONS.TableSort(list, costComparison, force)
	return list
end

function ShopMenu:OnClose()
	--remove_text_file("ItemText.xml")
	
	if self.showInfo then
		close_custompopup_menu()
	end
	
	self.lastTime = GetGameTime()

	clear(self.sellTable)
	self.buyTable      = nil
	self.selectedIndex = nil
	self.showInfo      = nil
	
	--_G.UnloadAssetGroup("AssetsInventory")
	--_G.UnloadAssetGroup("AssetsItems")
	--_G.UnloadAssetGroup("AssetsBattleGround")
	
	return Menu.MESSAGE_HANDLED
end

function ShopMenu:Open(multiplier, isBuying)
	--self.newList = newList
	self.costMultiplier = multiplier
	if isBuying ~= nil then
		self.buying = isBuying
	end
	
	return Menu.Open(self)
end

function ShopMenu:UpdateBuyList(firstID)
	self.first_list_val = firstID
	for i=1,math.min(#self.buyTable - firstID, 9) do
		local id = self.buyTable[i + firstID]
		local isShip = (string.char(string.byte(id)) == "S")
		self:UpdatePadData(i, id, false, isShip)
	end
	
	for i=#self.buyTable+1 - firstID,9 do
		self:HideWidgets(i)
	end
end

function ShopMenu:UpdateSellList(firstID)
	if((_G.Hero:NumAttributes("items")+_G.Hero:NumAttributes("ship_list")-firstID < 9) and (_G.Hero:NumAttributes("items")+_G.Hero:NumAttributes("ship_list") > 9))then -- if we've sold some cargo, leaving the cargo cells off by one
		firstID = firstID-1
	end
	
	LOG("First ID: "..firstID)
	LOG("Total: ".._G.Hero:NumAttributes("items")+_G.Hero:NumAttributes("ship_list"))
	self.first_list_val = firstID
	
	self:set_scrollbar_range("scroll_items", 0, _G.Hero:NumAttributes("items")+_G.Hero:NumAttributes("ship_list")-9)	--make certain the scrollbar range corresponds with the number of items minus 9
	
	for i=1, math.min(#self.sellTable - firstID, 9) do
		local id = self.sellTable[i+firstID]
		local isShip = (string.char(string.byte(id)) == "S")
		self:UpdatePadData(i, id, true, isShip)
	end
	
	for i= #self.sellTable+1 - firstID, 9 do
		self:HideWidgets(i)
	end


end

function ShopMenu:UpdateList(firstID, data)
	self.first_list_val = firstID
	for i=1, math.min(#data - firstID, 9) do
		local id = data[i+firstID]
		local isShip = (string.char(string.byte(id)) == "S")
		self:UpdatePadData(i, id, not self.buying, isShip)
	end
	
	for i=#data+1-firstID, 9 do
		self:HideWidgets(i)
	end
end

function ShopMenu:GetCost(id, selling, ship)
	local baseCost
	
	if ship then
		baseCost = SHIPS[id].cost
	else
		baseCost = ITEMS[id].cost
	end
	
	local function round(val)
		local remainder = math.fmod(val,1)
		if remainder < 0.5 then
			val = math.floor(val)
		else
			val = math.ceil(val)
		end
		return val
	end
	if selling then--Apply second hand discount
		baseCost = round(baseCost * 0.55)	
	end
	
	local haggleBonus = round((1 - self.costMultiplier) * baseCost)
	--local remainder = round(haggleBonus)
	LOG(string.format("id=%s,baseCost=%s, costMulitplier=%s, bonus = %s",id,tostring(baseCost),tostring(self.costMultiplier),tostring(haggleBonus)))
	--if remainder < 0.1 then
	--	haggleBonus = math.floor(haggleBonus)
	--else
	--	haggleBonus = math.ceil(haggleBonus)
	--end
	if selling then
		return baseCost + haggleBonus
	else
		--local haggleBonus = math.floor((1 - self.costMultiplier)*baseCost)
		return baseCost - haggleBonus
	end
end

function ShopMenu:ResetHaggleBonus()
	self.costMultiplier = 1
	self:hide_widget("str_haggle_bonus")
	if self.buying then
		self:UpdateBuyList(self.first_list_val)
	else
		self:UpdateSellList(self.first_list_val)
	end
end

function ShopMenu:BuyItem(id, index)
	local cost = self:GetCost(id, false, false)
	if cost <= _G.Hero:GetAttribute("credits") then
		local function ConfirmBuy(yes)
			close_custompopup_menu()
			if yes then				
				_G.Hero:AddItem(id)
				_G.Hero:SpendCredits(cost)
				self:set_text_raw("str_credits", substitute(translate_text("[N_CREDITS]"), tostring(_G.Hero:GetAttribute("credits"))))
				table.remove(self.buyTable, index)
				--self:UpdateBuyList(self.first_list_val)
				self:UpdateList(self.first_list_val, self.buyTable)
				table.insert(self.sellTable, id)
				
				self.sellTable = self:SortList(self.sellTable)
				self:ResetHaggleBonus()
			end
		end
		open_yesno_menu("[BUY]", "[BUY_QUERY]", ConfirmBuy, "[YES]", "[NO]" )
	end
end

function ShopMenu:SellItem(id, index)
	local cost = self:GetCost(id, true, false)
	local function ConfirmSale(yes)
		close_custompopup_menu()
		if yes then
			--_G.Hero:SetAttribute("credits", _G.Hero:GetAttribute("credits") + math.floor(ITEMS[id].cost + (ITEMS[id].cost*(1-self.costMultiplier))))
			_G.Hero:OnEventGiveGold(nil,cost)
			self:set_text_raw("str_credits", substitute(translate_text("[N_CREDITS]"), tostring(_G.Hero:GetAttribute("credits"))))
			_G.Hero:RemoveItem(id)
			table.remove(self.sellTable, index)
			
			-- must insert into correct position (sorted by cost)
			local i = 1
			local sort_cost
			if string.char(string.byte(self.buyTable[i])) == "S" then
				sort_cost = SHIPS[self.buyTable[i]].cost
			else
				sort_cost = ITEMS[self.buyTable[i]].cost
			end
			while self.buyTable[i] and sort_cost < ITEMS[id].cost do
				i = i + 1
			end
			table.insert(self.buyTable, i, id)
			
			self:UpdateSellList(self.first_list_val)
			
			self:ResetHaggleBonus()
		end
	end

	local itemEquipped = false
	for i=1,_G.Hero:NumAttributes("ship_list") do
		for k=1,_G.Hero:GetAttributeAt("ship_list", i):NumAttributes("items") do
			if _G.Hero:GetAttributeAt("ship_list", i):GetAttributeAt("items", k) == id then
				itemEquipped = true
			end
		end
	end
	if itemEquipped then
		open_yesno_menu("[SELL]", "[SALE_ITEM_WARN_QUERY]", ConfirmSale, "[YES]", "[NO]" )
	else
		open_yesno_menu("[SELL]", "[SALE_QUERY]", ConfirmSale, "[YES]", "[NO]" )
	end
end

function ShopMenu:BuyShip(id, index)
	local cost = self:GetCost(id, false, true)
	if cost <= _G.Hero:GetAttribute("credits") then
		local function ConfirmBuy(yes)
			if yes then
				close_custompopup_menu()
				local loadout = GameObjectManager:Construct("IL00")
				loadout:SetAttribute("ship", id)
				_G.Hero:PushAttribute("ship_list", loadout)
				--_G.Hero:SetAttribute("credits", _G.Hero:GetAttribute("credits") - math.floor(SHIPS[id].cost - (SHIPS[id].cost * (1-self.costMultiplier))))
				_G.Hero:SpendCredits(cost)
				self:set_text_raw("str_credits", substitute(translate_text("[N_CREDITS]"), tostring(_G.Hero:GetAttribute("credits"))))
				self:UpdateList(self.first_list_val, self.buyTable)
				table.insert(self.sellTable, id)
				
				self.sellTable = self:SortList(self.sellTable)
				self:ResetHaggleBonus()
			end
		end
		if _G.Hero:NumAttributes("ship_list") >= 3 then
			open_message_menu("[BUY_FAILED]", "[TOO_MANY_SHIPS]")
		else
			open_yesno_menu("[BUY]", "[BUY_QUERY]", ConfirmBuy, "[YES]", "[NO]" )
		end
	end
end

function ShopMenu:SellShip(id, index)
	local cost = self:GetCost(id, true, true)
	local loadout = _G.Hero:GetAttribute("ship_loadout")
	local function ConfirmSale(yes)
		if yes then
			-- deduct credits
			--_G.Hero:SetAttribute("credits", _G.Hero:GetAttribute("credits") + math.floor(SHIPS[id].cost + (SHIPS[id].cost*(1-self.costMultiplier))))
			_G.Hero:OnEventGiveGold(nil,cost)
			self:set_text_raw("str_credits", substitute(translate_text("[N_CREDITS]"), tostring(_G.Hero:GetAttribute("credits"))))
			-- remove the correct ship from the hero's list
			for i=1, math.min(3, _G.Hero:NumAttributes("ship_list")) do
				if _G.Hero:GetAttributeAt("ship_list", i):GetAttribute("ship") == id then
					_G.Hero:RemoveAttributeAt("ship_list", i)
					break
				end
			end
			-- clear the ship from the shop data
			table.remove(self.sellTable, index)
			self:UpdateSellList(self.first_list_val)
			-- if hero sold their current ship, equip them with another one from their list
			if loadout > _G.Hero:NumAttributes("ship_list") then
				while loadout > _G.Hero:NumAttributes("ship_list") do
					_G.Hero:SetAttribute("ship_loadout", loadout - 1)
					loadout = loadout - 1
				end
				--[[
				local ship = _G.GLOBAL_FUNCTIONS.LoadShip(_G.Hero:GetAttributeAt("ship_list", loadout):GetAttribute("ship"))
				_G.Hero:SetAttribute("curr_ship", ship)
				]]--
			end

			local ship = _G.Hero:GetAttribute("curr_ship")
			_G.GLOBAL_FUNCTIONS.ClearShip(ship)
			ship = _G.GLOBAL_FUNCTIONS.LoadShip(_G.Hero:GetAttributeAt("ship_list", loadout):GetAttribute("ship"))
			_G.Hero:SetAttribute("curr_ship", ship)
			ship.pilot=_G.Hero
			local dir = _G.Hero:GetView():GetDir()
			_G.Hero:SetSystemView()
			local view = _G.Hero:GetView()
			view:SetDir(dir)
			SCREENS.SolarSystemMenu:ShowWidgets()
			self:ResetHaggleBonus()
		end
	end
	if _G.Hero:NumAttributes("ship_list") > 1 then
		local maxCapacity = 0
		local currentCargo = 0
		for i=1,_G.Hero:NumAttributes("ship_list") do
			maxCapacity = maxCapacity + SHIPS[_G.Hero:GetAttributeAt("ship_list",i):GetAttribute("ship")].cargo_capacity
		end
		for i=1,_G.NUM_CARGOES do
			currentCargo = currentCargo + _G.Hero:GetAttributeAt("cargo", i)
		end
		if tonumber(maxCapacity - SHIPS[id].cargo_capacity) < currentCargo then
			open_message_menu("[SALE_FAILED]", "[CARGO_WARNING]")
		elseif _G.Hero:GetAttributeAt("ship_list", loadout):GetAttribute("ship") == self.sellTable[index] then
			local numOfThisType = 0;
			for i = 1, _G.Hero:NumAttributes("ship_list") do
				if _G.Hero:GetAttributeAt("ship_list", i):GetAttribute("ship") == self.sellTable[index] then
					numOfThisType = numOfThisType +1
				end
			end
			if(numOfThisType > 1)then
				open_yesno_menu("[SELL]", "[SALE_QUERY]", ConfirmSale, "[YES]", "[NO]" )
			else
				open_yesno_menu("[SELL]", "[SALE_SHIP_WARN_QUERY]", ConfirmSale, "[YES]", "[NO]" )
			end
		else
			open_yesno_menu("[SELL]", "[SALE_QUERY]", ConfirmSale, "[YES]", "[NO]" )
		end
	else
		open_message_menu("[SALE_FAILED]", "[SALE_LAST_SHIP]")
	end
end

function ShopMenu:OnMouseLeftButton(id, x, y, up)
	if id == 0 then
		close_custompopup_menu()
		self:DisableBuySellButton()
		return Menu.MESSAGE_HANDLED
	end
	if up then
		PlaySound("snd_mapmenuclick")
	end

   self:ItemSelected(id)
   
	return Menu.MESSAGE_HANDLED
end

function ShopMenu:OnGamepadButton(user, button, value)
	if value == 0 then
		if button == _G.BUTTON_A then
			self:OnMouseLeftButton(-self.first_list_val + self.selectedIndex, 0, 0, true)
		elseif button == _G.BUTTON_Y then
			self.showInfo = not self.showInfo
			if self.showInfo then
				self:OnMouseEnter(self.selectedIndex - self.first_list_val, 0, 0)
			else
				close_custompopup_menu(self.selectedIndex - self.first_list_val)
			end
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function ShopMenu:OnMouseEnter(id, x, y)
	LOG("Mouse over: " .. id)
	if id == 0 then
		--close_custompopup_menu()
		return Menu.OnMouseEnter(self, id, x, y)
	end
	local itemID
	if self.buying then
		itemID = self.buyTable[id+self.first_list_val]
	else
		itemID = self.sellTable[id + self.first_list_val]
	end
	
	if itemID then
		if string.char(string.byte(itemID)) == "S" then
			_G.GLOBAL_FUNCTIONS.ShipPopup(itemID, x+231, y+228+((id-1)*35))
		else
			_G.GLOBAL_FUNCTIONS.ItemPopup(itemID, x+231, y+228+((id-1)*35), "ShopMenu", id)
		end
	end
	return Menu.OnMouseEnter(self, id, x, y)
end

function ShopMenu:OnButton(id, x, y)
	if id == 90 then  -- Buy/Sell button on DS (as in Buy or Sell item not Buy/Sell mode toggle)
      if self.buying then
   		if string.char(string.byte(self.buyTable[self.selectedItem+self.first_list_val])) == "S" then
   			self:BuyShip(self.buyTable[self.selectedItem+self.first_list_val], self.selectedItem + self.first_list_val)
   		else
   			self:BuyItem(self.buyTable[self.selectedItem+self.first_list_val], self.selectedItem + self.first_list_val)
   		end
   	else
   		if string.char(string.byte(self.sellTable[self.selectedItem + self.first_list_val])) == "S" then
   			self:SellShip(self.sellTable[self.selectedItem + self.first_list_val], self.selectedItem + self.first_list_val)
   		else
   			self:SellItem(self.sellTable[self.selectedItem + self.first_list_val], self.selectedItem + self.first_list_val)
   		end
   	end
      
      self:ItemDeselected()

   elseif id == 95 then -- Prev button on DS
		if self.buying then
			self:UpdateList(self.first_list_val - 8, self.buyTable)
		else
			self:UpdateSellList(self.first_list_val - 8)
		end
		if self.first_list_val - 8 < 0 then
			self:hide_widget("butt_prev")
		end
		self:activate_widget("butt_next")
      self:ItemDeselected()
		PlaySound("snd_mapmenuclick")
		
	  ClearAutoLoadTables()
	  collectgarbage()	  		
	elseif id == 96 then -- Next button on DS
		local tableSize
		if self.buying then
			self:UpdateList(self.first_list_val + 8, self.buyTable)
			tableSize = #self.buyTable
		else
			self:UpdateSellList(self.first_list_val + 8)
			tableSize = #self.sellTable
		end
		if self.first_list_val + 8 > tableSize then
			self:hide_widget("butt_next")
		end
		self:activate_widget("butt_prev")
      self:ItemDeselected()
		PlaySound("snd_mapmenuclick")
		
	  ClearAutoLoadTables()
	  collectgarbage()	  		
	elseif id == 97 then -- Buy/Sell mode toggle
		self:SetModeBuying(not self.buying)
--[[
      elseif id == 197 then -- buy button on ds
		self:SetModeBuying(true)	
		self:deactivate_widget("butt_buy")
		self:activate_widget("butt_sell")
		close_custompopup_menu()
	elseif id == 198 then -- sell button on ds
		self:SetModeBuying(false)
		self:deactivate_widget("butt_sell")
		self:activate_widget("butt_buy")	
		close_custompopup_menu()			
]]--
   elseif id == 98 then -- Haggle button
		_G.GLOBAL_FUNCTIONS.Bargain("SolarSystemMenu", _G.Hero)
	elseif id == 99 then -- Cancel/Close button
		local function transition()
			close_custompopup_menu()
			self:Close()
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, nil, "ShopMenu")
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "ShopMenu")
	end
	
	return Menu.MESSAGE_HANDLED
end

function ShopMenu:OnScrollbar(id, value)
	if not up then
		PlaySound("snd_butthover")
	end
	
	if self.buying then
		self:UpdateList(value, self.buyTable)
	else
		self:UpdateSellList(value)
	end
	return Menu.MESSAGE_HANDLED
end

function ShopMenu:SetModeBuying(isBuying, showBonus)
	self.buying = isBuying
   -- For DS
   self:SetBuySellButton(self.buying) 
   self:ItemDeselected()
   --
	self:hide_widget("butt_prev")
	if self.selectedIndex then
		self.selectedIndex = 1
		self:set_widget_position("icon_gp_light", 231, 228)
	end
	if isBuying then
		self:set_text("butt_toggle", "[SELL_ITEMS]")
		self:set_text("str_action_desc", "[SHOP_INSTRUCTIONS_BUY]")
		self:set_text("str_heading", "[BUY_ITEMS]")
		self:set_text("str_gp_a", "[BUY]")
		self:set_scrollbar_range("scroll_items", 0, #self.buyTable-9)
		self:set_scrollbar_value("scroll_items",0)
		self:UpdateList(0, self.buyTable)
		if #self.buyTable > 8 then
			self:activate_widget("butt_next")
		else
			self:hide_widget("butt_next")
		end
	else
		_G.ShowTutorialFirstTime(27, _G.Hero)	
		self:set_text("butt_toggle", "[BUY_ITEMS]")
		self:set_text("str_action_desc", "[SHOP_INSTRUCTIONS_SELL]")
		self:set_text("str_heading", "[SELL_ITEMS]")
		self:set_text("str_gp_a", "[SELL]")
		self:set_scrollbar_range("scroll_items", 0, _G.Hero:NumAttributes("items")+_G.Hero:NumAttributes("ship_list")-9)
		self:set_scrollbar_value("scroll_items",0)
		self:UpdateSellList(0)
		if #self.sellTable > 8 then
			self:activate_widget("butt_next")
		else
			self:hide_widget("butt_next")
		end
	end
end

function ShopMenu:GenerateItems()
	local shopID = _G.Hero:GetAttribute("curr_loc")
	local baseTable = SATELLITES[shopID].shop_list
	local buyTable = { }
	
	for k,v in pairs(baseTable) do
		local insert = true
		for i=1, _G.Hero:NumAttributes("items") do
			if _G.Hero:GetAttributeAt("items", i) == v then
				insert = false
				break
			end
		end
		if insert then
			table.insert(buyTable, v)
		end
	end
	--[[
	for i=1, _G.Hero:NumAttributes("items") do
		for k,v in pairs(baseTable) do
			if not (_G.Hero:GetAttributeAt("items", i) == v) then
			end
		end
	end
	]]--

	return buyTable
end

function ShopMenu:OnGamepadDPad(user, dpad, x, y)
	if (x ~= 0 and y ~= 0) or (x == 0 and y == 0) then
		-- ignore diagonal input and dpad returning to rest
		return Menu.MESSAGE_NOT_HANDLED
	end
	
	local move = 0
	local numItems
	if self.buying then
		numItems = #self.buyTable
	else
		numItems = #self.sellTable
	end
	
	if y ~= 0 then
		move = -y
	else
		move = x*10
	end

	if self.selectedIndex + move >= numItems then
		move = numItems - self.selectedIndex
	elseif self.selectedIndex + move < 1 then
		move = -(self.selectedIndex - 1)
	end

	
	self.selectedIndex = self.selectedIndex + move
	local curr_light = 1 - self.first_list_val + self.selectedIndex
	local increment, data
	if curr_light > 9 then
		increment = curr_light - 9
	elseif curr_light < 3 and self.first_list_val > 0 then
		increment = math.max(-self.first_list_val, -3+curr_light)
	end
	if increment then
		if self.buying then
			data = self.buyTable
		else
			data = self.sellTable
		end
		self:UpdateList(self.first_list_val + increment, data)	
	end

	self:set_widget_position("icon_gp_light", 231, 228 - ((1-self.selectedIndex + self.first_list_val) * 35))
	if self.showInfo then
		close_custompopup_menu()
		self:OnMouseEnter(self.selectedIndex - self.first_list_val, 0, 0)
	end
	self:set_scrollbar_value("scroll_items",self.first_list_val)
	return Menu.MESSAGE_HANDLED
end

function ShopMenu:OnGamepadJoystick(user, joystick, x_dir, y_dir)
	if self.lastTime < GetGameTime() - 250 then
		if y_dir >= 100 then
			self:OnGamepadDPad(user, 0, 0, 1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		elseif y_dir <= -100 then
			self:OnGamepadDPad(user, 0, 0, -1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

dofile("Assets/Scripts/Screens/ShopMenuPlatform.lua")


return ExportSingleInstance("ShopMenu")
