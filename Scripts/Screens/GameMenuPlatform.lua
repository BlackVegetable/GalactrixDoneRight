
local FX = import("FXContainer")
local CRH = import "CoroutineHelpers"

local BOARD_SECTION = 1
local ITEM_SECTION = 2

function GameMenu:SetGamepadIcon()
	--DoeS Nothing
end

function GameMenu:PlatformVars()
	self.exit_key = Keys.SK_ESCAPE
	self.preview_pattern_key = Keys.SK_SPACE
	if _G.DEBUGS_ON then
		self.victory_key = Keys.SK_F9
		self.lose_key = Keys.SK_F10
		self.gemcheat_key = Keys.SK_F1
	end

	--BEGIN_STRIP_DS
	self.GamePadSection = BOARD_SECTION
	self.leftRight = 0
	self.sideCursorPos = 0
	--END_STRIP_DS


	self.left_edge = GetScreenWidth() - 1024
	if self.left_edge > 0 then
		self.left_edge = (self.left_edge / 2)--171
	end
end

function GameMenu:SwitchPanels()
	-- do nothing for pc version
end



-------------------------------------------------------------------------------
--  Called when mouse is over buttonId
-----------------------------------------
function GameMenu:OnButtonAvailable(buttonId, x, y, on)
	LOG("OnButtonAvailable,id, on "..tostring(buttonId).." " .. tostring(on))
	if self.uiInited and self.world then
		local playerID = 3
		local itemIndex
		if buttonId >= 11 and buttonId <= 20 then
			playerID = 1
			itemIndex = buttonId - 10
		elseif buttonId >= 21 and buttonId <= 29 then
			playerID = 2
			itemIndex = buttonId - 20
		else
			return Menu.MESSAGE_NOT_HANDLED
		end
		LOG("OnButtonAvailable, playerID " .. playerID)
		if self.world:NumAttributes("Players") >= playerID then
			local player = self.world:GetAttributeAt("Players",playerID)
			local item = player:GetItemAt(itemIndex)
			if item ~= nil then
				if on then
					-- User 1 item
					LOG("Button ShowInfo")
					self.item_info = buttonId
					--player:GetItemAt(itemIndex):ShowInfo(self.world, playerID, itemIndex)
					_G.GLOBAL_FUNCTIONS["ItemPopup"](item.classIDStr, self.world.coords[playerID]["item"][itemIndex][1], self.world.coords[playerID]["item"][itemIndex][2])
				else
					LOG("Button Else")
					close_custompopup_menu()
				end
			end
		end
	end
	return Menu.MESSAGE_HANDLED
end


function GameMenu:OnMouseEnter(id, x, y, on)
	if self.world and self.world.state ~= _G.STATE_GAME_OVER then

		if id == 101 then--player1 status effects
			local player = self.world:GetAttributeAt("Players",1)
			local effectNum = self.effect_counters[1]
			if player:NumAttributes("Effects") >= effectNum then
				player:GetAttributeAt("Effects",effectNum):ShowInfo(200,70)
			end

		elseif id == 102 then--player2 status effects
			if self.world:NumAttributes("Players") > 1 then
				local player = self.world:GetAttributeAt("Players",2)
				local effectNum = self.effect_counters[2]
				if player:NumAttributes("Effects") >= effectNum then
					player:GetAttributeAt("Effects",effectNum):ShowInfo(760,70)
				end
			end
		elseif id == 103 then--board status effects
			local effectNum = self.effect_counters["bg"]
			if self.world:NumAttributes("Effects") >= effectNum then
				self.world:GetAttributeAt("Effects",effectNum):ShowInfo(488,70)
			end
		elseif id == 111 then -- hero popup - player 1
			local hero = self.world:GetAttributeAt("Players", 1)
			_G.GLOBAL_FUNCTIONS.HeroPopup(hero, 100, 100)
		elseif id == 112 then
			local hero = self.world:GetAttributeAt("Players", 2)
			_G.GLOBAL_FUNCTIONS.HeroPopup(hero, 700, 100)
		end
	end

	return Menu.MESSAGE_HANDLED
end

function GameMenu:OnMouseLeave(id, x, y, on)
	LOG("GameMenu:OnMouseLeave()")
	close_custompopup_menu()
	--[[
	if id == 101 then--player1 status effects
		local player = self.world:GetAttributeAt("Players",1)
		local effectNum = self.effect_counters[1]
		if player:NumAttributes("Effects") >= effectNum then
			player:GetAttributeAt("Effects",effectNum):ShowInfo(200,70)
		end

	elseif id == 102 then--player2 status effects
		if self.world:NumAttributes("Players") > 1 then
			local player = self.world:GetAttributeAt("Players",2)
			local effectNum = self.effect_counters[2]
			if player:NumAttributes("Effects") >= effectNum then
					player:GetAttributeAt("Effects",effectNum):ShowInfo(760,70)
			end
		end
	elseif id == 103 then--board status effects
		local effectNum = self.effect_counters["bg"]
		if self.world:NumAttributes("Effects") >= effectNum then
				self.world:GetAttributeAt("Effects",effectNum):ShowInfo(488,70)
		end
	end
	]]
	return Menu.MESSAGE_HANDLED
end




function GameMenu:CycleEffects()
	--Not used by PC version
end

function GameMenu:OnDraw(time)
 	--FX.Update(time)
	CRH.Update(time)
	return cGameMenu.OnDraw(self, time)
end

function GameMenu:OnTimer(time)

	self.time_delta = time - self.last_time



	if self.world and self.uiInited and self.world.state ~= STATE_GAME_OVER then
		if self.time_delta > self.world:GetAttribute("ui_tick") then
			self.last_time = time



			_G.GLOBAL_FUNCTIONS[string.format("Update%s", self.world.ui)]()


		end
		if not Sound.IsMusicPlaying() and self.world.GetMusic then
			LOG("change sound")
		   PlaySound(self.world:GetMusic())
		end

	end

	return cGameMenu.OnTimer(self, time)
end

function GameMenu:SetItemHeader(playerNum)
	--doesn't need to do anything on PC
end

-------------------------------------------------------------------------------
-- OnMouseRightButton
function GameMenu:OnMouseRightButton(id, x, y, up)
	if self.world.state == _G.STATE_USER_INPUT_GEM then
		LOG("Reset state")
		self.world.state = _G.STATE_IDLE
		_G.ShowMessage(self.world, "[ITEM_USE_CANCELLED]", "font_small_event", 512, 384)
	end

	--BEGIN_STRIP_DS
	WiiOnly(self.WiiOnMouseRightButton, self, id, x, y, up)
	--END_STRIP_DS
	return Menu.MESSAGE_HANDLED
end

-------------------------------------------------------------------------------
-- WiiOnMouseRightButton
--BEGIN_STRIP_DS
function GameMenu:WiiOnMouseRightButton(id, x, y, up)

	if up == false then
		return Menu.MESSAGE_HANDLED
	end

	if self.GamePadSection == BOARD_SECTION then
		self.GamePadSection = ITEM_SECTION
		self.sideCursorPos = 1

		SetIsGamepadActive(true)

		if self.world:GetAttributeAt("Players",1):GetAttribute("ai") == 0 then -- HUMAN PLAYER
			self.leftRight = 1
		end
		self:SelectItemButton()

	elseif self.GamePadSection == ITEM_SECTION then
		if self.sideCursorPos == 1 then
			self.sideCursorPos = 2
		elseif self.sideCursorPos == 2 then
			self.sideCursorPos = 3
		elseif self.sideCursorPos == 3 then
			self.sideCursorPos = 4
		elseif self.sideCursorPos == 4 then
			self.sideCursorPos = 5
		elseif self.sideCursorPos == 5 then
			self.sideCursorPos = 6
		elseif self.sideCursorPos == 6 then
			self.sideCursorPos = 7
		elseif self.sideCursorPos == 7 then
			self.sideCursorPos = 8
		elseif self.sideCursorPos == 8 then
			self.GamePadSection = BOARD_SECTION
		end
		self:DeactivateItemSelect()
		self:SelectItemButton()
	end

end


-------------------------------------------------------------------------------
--
function GameMenu:SelectItemButton()

	self:set_image(string.format("sel_item_%d", self.sideCursorPos), "img_gpcursor")

	if self.GamePadSection == BOARD_SECTION then
		self:DeactivateItemSelect()
	end

end

-------------------------------------------------------------------------------
-- DeactivateItemSelect
-- Turns off a specified item button
function GameMenu:DeactivateItemSelect()
	for i=1,8 do
		self:set_image(string.format("sel_item_%d", i), "")
	end
end

-------------------------------------------------------------------------------
-- OnGamepadMotion
function GameMenu:OnGamepadMotion(user, id, duration)
	local motion_name = ""
	local motiondir = ""

	if id == GamepadInput.WIIMOTE_MOTION_LEFT then
		motion_name = "WIIMOTE_MOTION_LEFT"

		if self.GamePadSection == ITEM_SECTION then
			local playerbutton
			if self.leftRight == 1 then
				playerbutton = 10
			end

			self:OnButton(playerbutton + self.sideCursorPos, 0, 0)

		end
		self.GamePadSection = BOARD_SECTION
		self:DeactivateItemSelect()

	elseif id == GamepadInput.WIIMOTE_MOTION_RIGHT then
		motion_name = "WIIMOTE_MOTION_RIGHT"

		if self.GamePadSection == ITEM_SECTION then
			local playerbutton
			if self.leftRight == 1 then
				playerbutton = 10
			end

			self:OnButton(playerbutton + self.sideCursorPos, 0, 0)

		end
			self.GamePadSection = BOARD_SECTION
			self:DeactivateItemSelect()

	end

	return Menu.MESSAGE_HANDLED
end
--END_STRIP_DS

function GameMenu:OnButton(buttonId, clickX, clickY)
	if self.uiInited then
	    if buttonId >= 11 and buttonId <= 18 and self.world.state==STATE_IDLE and not self.info_view then
			local itemIndex = buttonId - 10
			if self.world:NumAttributes("Players")>=1 then
				local player = self.world:GetAttributeAt("Players",1)
				local item = player:GetItemAt(itemIndex)

				-- check that an item does exist in that slot
				if item == nil then
					return Menu.OnButton(self, buttonId, clickX, clickY)
				end

				enemy = self.world:GetEnemy(_G.Hero)
				if _G.Hero:GetAttribute("player_id")==1 and self.world:GetAttribute('curr_turn')== 1 and item:ItemActive(player:GetAttribute("engine"),player:GetAttribute("weapon"),player:GetAttribute("cpu"), enemy, player:GetAttribute("psi")) then
					-- User 1 item
					LOG(string.format("activate Item %d",itemIndex))
					PlaySound("snd_buttclick")

					_G.Hero:ActivateItem(self.world, item)
					--local itemEvent = GameEventManager:Construct("ActivateItem")
					--itemEvent:SetAttribute("player_id",1)
					--itemEvent:SetAttribute("item",item)
					--GameEventManager:Send(itemEvent)

				end
				return Menu.MESSAGE_HANDLED
	    	end
		elseif buttonId >= 21 and buttonId <= 28 and self.world.state==STATE_IDLE and not self.info_view then
			local itemIndex = buttonId - 20
			if self.world:NumAttributes("Players") >= 2 then
				local player = self.world:GetAttributeAt("Players",2)
				local item = player:GetItemAt(itemIndex)
				if item then
					--LOG(string.format("Item check %d == %d",_G.Hero:GetAttribute("player_id"),self.world:GetAttribute('curr_turn')))

					--!!!! should not get to this point if item set to inactive!!!
					if _G.Hero:GetAttribute("player_id")==2 and self.world:GetAttribute('curr_turn')==2 then--and item:ItemActive(player:GetAttribute("engine"),player:GetAttribute("weapon"),player:GetAttribute("cpu")) then
						-- User 2 item		--multiplayer only
						_G.Hero:ActivateItem(self.world, item)
						--local itemEvent = GameEventManager:Construct("ActivateItem")
						--itemEvent:SetAttribute("player_id",2)
						--itemEvent:SetAttribute("item",item)
						--GameEventManager:Send(itemEvent)
					end
				end
				return Menu.MESSAGE_HANDLED
			end
		elseif self.info_view then
			self.info_view = false
			self:set_text("butt_info", "[SHOW_INFO]")
		elseif buttonId == 222 then -- this is for the DS, when they want to see the other player's spells
			self:StartAnimation("player_2_turn")
			self.show_items = 2
		elseif buttonId == 223 then -- this is for the DS, when they want to see the other player's spells
			self:StartAnimation("player_1_turn")
			self.show_items = 1
		elseif buttonId == 224 then
			if self.info_view then
				self.info_view = false
				self:set_text("butt_info", "[SHOW_INFO]")
			else
				self.info_view = true
				self:set_text("butt_info", "[CANCEL]")
			end
		end
	end

    return Menu.MESSAGE_NOT_HANDLED
	--return cGameMenu.OnButton(self, buttonId, clickX, clickY)
end

function GameMenu:CloseItemText()
	-- this is not needed on PC so leave blank
end

function GameMenu:UpdateEnergyUI(player)


	local i = player:GetAttribute("player_id")

	--self:set_progress("progbar_shield_"..i,(player:GetAttribute('shield')/player:GetAttribute('shield_max'))*100)


	self:set_text_raw(string.format("str_life_%d",i),tostring(player:GetAttribute('life')))
	self:set_progress(string.format("progbar_life_%d",i),((player:GetAttribute('life')/player:GetAttribute('life_max'))*100)+(1*((player:GetAttribute('life_max')-player:GetAttribute('life'))/player:GetAttribute('life_max'))*player:GetAttribute('life_max')/100))
	self:set_text_raw(string.format("str_shield_%d",i),tostring(player:GetAttribute('shield')))

	self:set_text_raw(string.format("str_weapon_%d",i),tostring(player:GetAttribute('weapon')))
	self:set_progress(string.format("progbar_weapon_%d",i),(player:GetAttribute('weapon')/player:GetAttribute('weapon_max'))*100)
	self:set_text_raw(string.format("str_cpu_%d",i),tostring(player:GetAttribute('cpu')))
	self:set_progress(string.format("progbar_cpu_%d",i),(player:GetAttribute('cpu')/player:GetAttribute('cpu_max'))*100)
	self:set_text_raw(string.format("str_engine_%d",i),tostring(player:GetAttribute('engine')))
	self:set_progress(string.format("progbar_engine_%d",i),(player:GetAttribute('engine')/player:GetAttribute('engine_max'))*100)
	self:set_text_raw(string.format("str_psi_%d",i),tostring(player:GetAttribute('psi')))
	self:set_text_raw(string.format("str_intel_%d",i),tostring(player:GetAttribute('intel')))

	local shields_remaining = player:GetAttribute('shield')/player:GetAttribute('shield_max')*10;

	local shieldStr = string.format("icon_shield_%d_",i)
	for j=10, shields_remaining +1 ,-1 do
		self:set_alpha(string.format("%s%d",shieldStr,j), 0)
	end

	for j=1,shields_remaining,1 do
		self:set_alpha(string.format("%s%d",shieldStr,j), 1)
	end
end

function GameMenu:HideWidgets()
	-- not needed for PC
end

function GameMenu:ShowWidgets()
	-- not needed for PC
end

function GameMenu:HideMiningWidgets()
	-- not needed for PC
end

function GameMenu:ShowMiningWidgets()
	-- not needed for PC
end

function GameMenu:HideHackingWidgets()
	-- not needed for PC
end

function GameMenu:ShowHackingWidgets()
	-- not needed for PC
end

function GameMenu:HideRumorWidgets()
	-- not needed for PC
end

function GameMenu:ShowRumorWidgets()
	-- not needed for PC
end

function GameMenu:HideHagglingWidgets()
	-- not needed for PC
end

function GameMenu:ShowHagglingWidgets()
	-- not needed for PC
end

function GameMenu:FlipScreens()
   -- do nothing on PC. Shouldn't be called because it's triggered by OnKey(DS_ShoulderButtons) but just in case...
end

function GameMenu:InitWirelessStatus()
   -- do nothing on PC
end

function GameMenu:UpdateItemsUI(player)
	LOG("UpdateItemsUI")
	local i = player:GetAttribute("player_id")
	local playerID = player:GetAttribute("player_id")
	playerID = playerID + 1
	if playerID > 2 then--Wrap Around
		playerID = 1
	end
	enemy = self.world:GetAttributeAt("Players", playerID)
	--local enemy = BattleGround:GetEnemy(player)

	for j=1, 8 do --for each item slot
		local player_item = player:GetItemAt(j)
		local offset = i*10+j

		if player_item then--if item in slot
			local active = true

			if player_item:GetAttribute("weapon_requirement") > 0 then
				if player:GetAttribute("weapon") >= player_item:GetAttribute("weapon_requirement") then
					self:set_image(string.format("item_%d_weapon_%d", j, i), "img_item_weapon_active")
				else
					self:set_image(string.format("item_%d_weapon_%d", j, i), "img_item_weapon_inactive")
					active = false
				end
			end
			if player_item:GetAttribute("engine_requirement") > 0 then
				if player:GetAttribute("engine") >= player_item:GetAttribute("engine_requirement") then
					self:set_image(string.format("item_%d_engine_%d", j, i), "img_item_engine_active")
				else
					self:set_image(string.format("item_%d_engine_%d", j, i), "img_item_engine_inactive")
					active = false
				end
			end
			if player_item:GetAttribute("cpu_requirement") > 0 then
				if player:GetAttribute("cpu") >= player_item:GetAttribute("cpu_requirement") then
					self:set_image(string.format("item_%d_cpu_%d", j, i), "img_item_cpu_active")
				else
					self:set_image(string.format("item_%d_cpu_%d", j, i), "img_item_cpu_inactive")
					active = false
				end
			end
			if player_item:GetAttribute("psi_requirement") > 0 then
				if player:GetAttribute("psi") < player_item:GetAttribute("psi_requirement") then
					active = false
				end
			end
			if player_item:GetAttribute("status_on_enemy") == 1 then
				if enemy:GetAttribute("shield") > 0 then
					active = false
				end
			end
			if player_item:GetAttribute("psi_requirement") < 0 then
				if player:GetAttribute("curr_ship"):GetAttribute("max_items") >= 6 then
					active = false
				end
			end
			if player_item:GetAttribute("passive") ~= 0 then
				active = false
			end

			--If item active
			if player_item.inactive > 0 then
				self:deactivate_widget(string.format("butt_item_%d_%d", j, i))
				self.active_items[i][j]=false
				self:set_alpha(string.format("item_%d_icon_%d", j, i),0.5)

				if player_item.inactive > player_item:GetAttribute("recharge") then
					self:set_progress(string.format("progbar_%d_recharge_%d", j, i),100)
					self:set_alpha(string.format("progbar_%d_recharge_%d", j, i),1.0)
					self:set_text_raw(string.format("item_%d_recharge_%d", j, i),tostring(player_item.inactive))
				else
					self:set_progress(string.format("progbar_%d_recharge_%d", j, i),100-((player_item.inactive/player_item:GetAttribute('recharge'))*100))
					self:set_alpha(string.format("progbar_%d_recharge_%d", j, i),1.0)

					self:set_text_raw(string.format("item_%d_recharge_%d", j, i),tostring(player_item.inactive))
				end

			else
				self:set_text(string.format("item_%d_recharge_%d", j, i),"")

				if active then--EFFICIENT WAY
					self:set_alpha(string.format("item_%d_icon_%d", j, i),1)
					if not self.active_items[i][j] then
						self:activate_widget(string.format("butt_item_%d_%d", j, i))
						self.active_items[i][j]=true
					end
				else
					self:deactivate_widget(string.format("butt_item_%d_%d", j, i))
					self:set_alpha(string.format("item_%d_icon_%d", j, i),0.5)
					self.active_items[i][j]=false
				end
				self:set_alpha(string.format("progbar_%d_recharge_%d", j, i),0.0)
			end

		end
	end


end


