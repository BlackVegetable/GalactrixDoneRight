



local function GetCraftingReqs(itemID,is_ship)
	local weap,eng,cpu
	if is_ship then	
		weap = SHIPS[itemID].weapons_rating
		eng  = SHIPS[itemID].engine_rating
		cpu  = SHIPS[itemID].cpu_rating
	else--Item
		weap = ITEMS[itemID].weapon_requirement
		eng  = ITEMS[itemID].engine_requirement
		cpu  = ITEMS[itemID].cpu_requirement
		
		if ITEMS[itemID].rarity == 10 then
			weap = weap * 2
			eng  = eng  * 2
			cpu  = cpu  * 2
		end
	end
	return weap,eng,cpu
end


local function GetCraftingDifficulty(itemID,is_ship,w,e,c)
	--[[--old code
	local cost
	if string.char(string.byte(item)) == "S" then
		cost = SHIPS[item].cost
		if cost < 120001 then
			return 1
		elseif cost < 300001 then
			return 2
		elseif cost < 700001 then
			return 3
		else
			return 4
		end		
	else
		cost = ITEMS[item].cost
		if cost < 1501 then
			return 1
		elseif cost < 4001 then
			return 2
		elseif cost < 8001 then
			return 3
		else
			return 4
		end
	end
	--]]
	if is_ship == nil then
		is_ship = string.char(string.byte(itemID)) == "S"
		w,e,c = GetCraftingReqs(itemID,is_ship)	
	end
	
	local cost= w + e + c				
	if not is_ship then
		local num_types = 0
		if w > 0 then
			num_types = num_types + 1
		end
		if e > 0 then
			num_types = num_types + 1
		end
		if c > 0 then
			num_types = num_types + 1
		end					
		local extra = math.floor((3-num_types)*cost/3)
		--cost = ITEMS[itemID].cost
		cost = cost + extra
	end
	return cost
		
end

local function sortByDifficulty(a,b)
	local a_ship = string.char(string.byte(a)) == "S"
	local b_ship = string.char(string.byte(b)) == "S"
	
	--a is ship  & b is item
	if a_ship and not b_ship then
		return false
	elseif b_ship and not a_ship then
		return true
	else	
		local cost1, cost2
		cost1 = _G.GLOBAL_FUNCTIONS.Plans.GetCraftingDifficulty(a)
		cost2 = _G.GLOBAL_FUNCTIONS.Plans.GetCraftingDifficulty(b)	
		return cost1 < cost2
	end
end


local function GetDisplayDifficulty(actual_dif,is_ship)
	local display_diff = 0
		
	if is_ship then
		if actual_dif < 62 then
			return 1
		elseif actual_dif < 75 then
			return 2
		elseif actual_dif < 92 then
			return 3
		else
			return 4
		end		
	else		
		if actual_dif < 10 then
			return 1
		elseif actual_dif < 16 then
			return 2
		elseif actual_dif < 22 then
			return 3
		else
			return 4
		end	
	end
end

local function UpdatePlanData(menu,itemID,widget_id)
		
	local myName = translate_text(string.format("[%s_NAME]", itemID))
	local myWidth = menu:get_widget_w(string.format("item%d_name", widget_id))
	--local function adjust_name()
		myName = fit_text_to("font_info_white", myName, myWidth)
	--end
	--_G.XBoxOnly(adjust_name)
	
	local is_ship = string.char(string.byte(itemID)) == "S"
	
	
	--Display Crafting Requirements
	local weap,eng,cpu = GetCraftingReqs(itemID,is_ship)	
	if weap == 0 then
		menu:hide_widget(string.format("item%d_weap_val", widget_id))
		menu:hide_widget(string.format("item%d_weap_bg",  widget_id))
	else
		menu:activate_widget(string.format("item%d_weap_val", widget_id))
		menu:activate_widget(string.format("item%d_weap_bg",  widget_id))
		menu:set_text_raw(string.format("item%d_weap_val", widget_id), tostring(weap))
	end
	if eng == 0 then
		menu:hide_widget(string.format("item%d_eng_val", widget_id))
		menu:hide_widget(string.format("item%d_eng_bg",  widget_id))
	else
		menu:activate_widget(string.format("item%d_eng_val", widget_id))
		menu:activate_widget(string.format("item%d_eng_bg",  widget_id))
		menu:set_text_raw(string.format("item%d_eng_val", widget_id), tostring(eng))
	end
	if cpu == 0 then
		menu:hide_widget(string.format("item%d_cpu_val", widget_id))
		menu:hide_widget(string.format("item%d_cpu_bg",  widget_id))
	else
		menu:activate_widget(string.format("item%d_cpu_val", widget_id))
		menu:activate_widget(string.format("item%d_cpu_bg",  widget_id))
		menu:set_text_raw(string.format("item%d_cpu_val", widget_id), tostring(cpu))
	end	
	
	--Set Name/font color
	if is_ship then
		menu:set_text(string.format("item%d_name", widget_id), myName)
		menu:set_font(string.format("item%d_name", widget_id), "font_info_gold")
	else--ITEM
		menu:set_text(string.format("item%d_name", widget_id), myName)
		menu:set_font(string.format("item%d_name", widget_id), "font_info_white")		
	end
	
	--Hide all difficulty indicators
	for k=1,4 do
		menu:hide_widget(string.format("item%d_gem_%d", widget_id, k))
	end
	
	
	
	--Set all Difficulty indicators
	local difficulty = GetDisplayDifficulty(GetCraftingDifficulty(itemID,is_ship,weap,eng,cpu),is_ship)
	LOG(string.format("Difficulty of %s = %d",itemID,difficulty))
	for k=1, difficulty  do
		menu:activate_widget(string.format("item%d_gem_%d", widget_id, k))
		if is_ship then
			menu:set_image(string.format("item%d_gem_%d", widget_id, k), "img_craft_yellow")
		else
			menu:set_image(string.format("item%d_gem_%d", widget_id, k), "img_craft_white")
		end
	end
	
	
	--Highlight current item
	if itemID == menu.current_item then
		menu:activate_widget(string.format("item%d_light", widget_id))
	else
		menu:hide_widget(string.format("item%d_light", widget_id))
	end	
	
	
	
end





return {["GetCraftingDifficulty"]=GetCraftingDifficulty;
	["UpdatePlanData"] = UpdatePlanData;
	["GetCraftingReqs"] = GetCraftingReqs;
	["sortByDifficulty"] = sortByDifficulty;}