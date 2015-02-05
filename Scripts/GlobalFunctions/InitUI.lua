
-------------------------------------------------------------------------------
--    InitUI  -- inits the UI for the battle game
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------

local butt_item = 0 -- Player #1... items 1-8
	
local icon_item_weapon = 2000 -- Player #n... items 1-8
local icon_item_engine = 2020 -- Player #n... items 1-8
local icon_item_cpu    = 2040 -- Player #n... items 1-8
local icon_item        = 2060 -- Player #n... items 1-8
local progress_recharge= 2080 -- Player #n... items 1-8
local str_item_recharge= 2100 -- Player #n... items 1-8
local icon_item_back   = 2120 -- Player #n... items 1-8 
local str_item_weapon  = 2140 -- Player #n... items 1-8
local str_item_engine  = 2160 -- Player #n... items 1-8
local str_item_cpu     = 2180 -- Player #n... items 1-8

function SetItemInSlot(item, playerNum, itemNum)
	LOG("SetItemInSlot "..tostring(itemNum))
	
	-- make this item visible
	local menu = SCREENS.GameMenu
	
	--local offset = playerNum*10 + itemNum
	
	-- set position
	
	--LOG(string.format("Item Pos: %d,%d",item:GetX(),item:GetY()))
	if item then
		--[[
		menu:set_alpha_id(butt_item + offset, 1)
	
		menu:set_alpha_id(icon_item_back+offset,1)		
		item:SetPos(menu.world:WorldToGrid(menu.world.coords[playerNum]["item"][itemNum][1],menu.world.coords[playerNum]["item"][itemNum][2]))
		menu:set_image_id(icon_item+offset, item:GetAttribute("icon"))
		
		if item:GetAttribute("weapon_requirement") > 0 then
			menu:set_text_id(str_item_weapon+offset,  tostring(item:GetAttribute("weapon_requirement")))
			menu:set_image_id(icon_item_weapon+offset, string.format("img_item_weapon_inactive"))
		else
			menu:hide_widget_id(str_item_weapon+offset)
		end
		if item:GetAttribute("engine_requirement") > 0 then
			menu:set_text_id(str_item_engine+offset,  tostring(item:GetAttribute("engine_requirement")))
			menu:set_image_id(icon_item_engine+offset, string.format("img_item_engine_inactive"))
		else
			menu:hide_widget_id(str_item_engine+offset)
		end
		if item:GetAttribute("cpu_requirement") > 0 then
			menu:set_text_id(str_item_cpu+offset,  tostring(item:GetAttribute("cpu_requirement")))
			menu:set_image_id(icon_item_cpu+offset, string.format("img_item_cpu_inactive"))
		else
			menu:hide_widget_id(str_item_cpu+offset)
		end
		--]]
		
		
			-- make this item visible
			menu:set_alpha(string.format("butt_item_%d_%d",itemNum,playerNum), 1)
		
			menu:set_alpha(string.format("item_back_%d_%d",itemNum,playerNum),1)		
			-- set position
			item:SetPos(menu.world:WorldToGrid(menu.world.coords[playerNum]["item"][itemNum][1],menu.world.coords[playerNum]["item"][itemNum][2]))
			
			--LOG(string.format("Item Pos: %d,%d",item:GetX(),item:GetY()))
			
			menu:set_image(string.format("item_%d_icon_%d",itemNum,playerNum), item:GetAttribute("icon"))
			--menu:deactivate_widget("butt_item_"..itemNum.."_"..playerNum)
			for k,v in pairs(menu.energyList) do
				local reqstr = string.format("%s_requirement",v)
				if item:GetAttribute(reqstr) > 0 then
					local itemstr = string.format("item_%d_%s_%d",itemNum,v,playerNum)
					menu:set_text_raw(string.format("%s_req",itemstr),tostring(item:GetAttribute(reqstr)))
					menu:set_image(itemstr, string.format("img_item_%s_inactive",v))
				else
					menu:hide_widget(string.format("item_%d_%s_%d_req",itemNum,v,playerNum))
				end
			end
				
	else
		menu:hide_widget(string.format("butt_item_%d_%d",itemNum,playerNum))
		menu:hide_widget(string.format("item_%d_icon_%d",itemNum,playerNum))
		menu:hide_widget(string.format("item_%d_weapon_%d_req",itemNum,playerNum))
		menu:hide_widget(string.format("item_%d_engine_%d_req",itemNum,playerNum))
		menu:hide_widget(string.format("item_%d_cpu_%d_req",itemNum,playerNum))
		--menu:hide_widget_id(str_item_cpu+offset)
		
	end
	
end

function InitPlayerName(player, ship, playerNum)
	local menu = SCREENS.GameMenu
	
	menu:set_image(string.format("icon_ship_%d",playerNum), string.format("%s_B",ship:GetAttribute("portrait")))--Set Ship Battle Portrait

	local bgID = ClassIDToString(menu.world:GetClassID())
	if (playerNum==1 and bgID ~= "B101") or ClassIDToString(menu.world:GetClassID())=="B001" then--enemy portraits only show for quest battle
		if player:GetAttribute("portrait") ~= "" then
			menu:set_image(string.format("icon_player_%d",playerNum), string.format("%s_B",player:GetAttribute("portrait")))--Set Player Battle Portrait
		end
	elseif ClassIDToString(menu.world:GetClassID())=="B102" then -- Local (Head to Head) MP game
		if player:GetAttribute("portrait") ~= "" then
			menu:set_image(string.format("icon_player_%d",playerNum), string.format("%s_B",player:GetAttribute("portrait")))--Set Player Battle Portrait
		end
	end
	
	local nameWidget = string.format("str_player_name_%d",playerNum)
	local myWidth = menu:get_widget_w(nameWidget)
	local myName = player:GetAttribute("name")
	myName = fit_text_to("font_system", myName , myWidth)

	menu:set_text(nameWidget,myName)
	
	return true
end

function InitUI()
	LOG("InitUI()")
	
	local menu = SCREENS.GameMenu
	
	menu.active_items = {{},{}}
	
	menu.uiInited = true

	-- set alpha to 0 for each slot (does this do anything?)
	for i=1, 2 do --foreach player slot
		for j=1,8 do --foreach item slot
			--local itemStr = string.format("butt_item_%d_%d",j,i)
			--menu:set_alpha(itemStr,0)
			--menu:deactivate_widget(itemStr)			
			
			local progRechargeStr = string.format("progbar_%d_recharge_%d",j,i)
			menu:set_alpha(progRechargeStr, 0.0)			
			
			local itemBackStr = string.format("item_back_%d_%d",j,i)
			menu:set_alpha(itemBackStr,0.65)			
		end
	end

	
	
	--Foreach Player
	for i=1, menu.world:NumAttributes('Players') do
		LOG("player "..tostring(i))
		local player = menu.world:GetAttributeAt('Players',i)
		local ship = player:GetAttribute("curr_ship")

		-- Set player/ship name on the UI
		InitPlayerName(player, ship, i)
		
		menu:SetItemHeader(i)
	
		menu:UpdateEnergyUI(player)		
		--Load up items from loadout for current battle
		
		--LOG(string.format("Item creation for Player %s", player:GetAttribute("name")))
		for j=1, 8 do --for each item slot
			local player_item = player:GetItemAt(j)
			--if player_item then--if item in slot
				SetItemInSlot(player_item, i, j)
			--end
		end	
	end	

	return true
end


return InitUI