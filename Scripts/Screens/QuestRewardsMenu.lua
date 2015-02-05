----------------------------------------------------------------------
-- QuestRewardsMenu
-- A dialog from which the user can create and name a new pet
----------------------------------------------------------------------

use_safeglobals()

class "QuestRewardsMenu" (Menu);


local firstUpdate
local editorString

local src
local menuList

dofile("Assets/Scripts/Screens/QuestRewardsMenuPlatform.lua")

----------------------------------------------------------------------
-- __init()
--
-- Loads the xml spec for the screen, which causes widgets to be 
-- added and animations to be parsed and added.
----------------------------------------------------------------------
function QuestRewardsMenu:__init()

	super()
   self:LoadGraphics()
	self:Initialize("Assets\\Screens\\QuestRewardsMenu.xml")
   
	
	self:PlatformVars()
end

function QuestRewardsMenu:SetHeading(heading)
	self:set_text("str_heading",heading)
end

function QuestRewardsMenu:SetQuestComplete()
	self:SetHeading("[QUEST_COMPLETE]")
end

function QuestRewardsMenu:SetInventoryTab(invTab)
	self.invTab = invTab
end

function QuestRewardsMenu:Open()
	

	self.rewards = { }
	self.callbacks = {}	
	
	self.invTab = nil
	if _G.is_open("SolarSystemMenu") then
		SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	end	

	
	return Menu.Open(self)
end


function QuestRewardsMenu:AddCallback(callback)
	if callback then
		table.insert(self.callbacks,callback)
	end
	
end


function QuestRewardsMenu:SetQuest(questID)
	self:set_text("str_mission", translate_text("["..questID.."_TITLE]"))
end

----------------------------------------------------------------------
-- OnOpen()
--
-- Just run an update for now
----------------------------------------------------------------------
function QuestRewardsMenu:OnOpen()
	self:SetHeading("")
	self:set_text("str_mission","")
	
	LOG("QuestRewardsMenu opened")
	PlaySound("snd_questcomplete")
	
	--BEGIN_STRIP_DS
	self:set_image("icon_crew", _G.Hero:GetAttribute("portrait").."_L")
	self:activate_widget("icon_crew")
	self:hide_widget("icon_crew_scaled")
	--END_STRIP_DS
	for i=1,4 do
		self:set_image("icon_reward"..i, "")
		self:hide_widget("icon_reward"..i)
		self:hide_widget("str_reward"..i)
	end
	

   self:set_image("icon_backdrop_top1", string.format("%s_M", _G.Hero:GetAttribute("portrait")))
	
	return Menu.OnOpen(self)

end

function QuestRewardsMenu:OnAnimOpen(data)
	if _G.is_open("SolarSystemMenu") then
			SCREENS.SolarSystemMenu:HideWidgets()
	end				
end


function QuestRewardsMenu:OnClose()
	--self:reset_list("list_rewards")
	self.rewards = { }

   self:UnloadGraphics()
   if not self.invTab then
   		--remove_text_file("ItemText.xml")
   end

	
	LOG("QuestRewardsMenu:OnClose()")
	for i,v in pairs(self.callbacks) do
		LOG("Callback")
		v()--Launch callbacks
	end
		
	
	

	return Menu.OnClose(self)
end




function QuestRewardsMenu:SetTitle(title)
	
	self:set_text("str_heading",title)
end

function QuestRewardsMenu:AddListItem(image, txt, bonus, isCrew, xScale, yScale)
	LOG("questrewards image " .. tostring(image))
--	LOG("Added list option = " .. tostring(text))
	LOG("Bonus = " .. tostring(bonus))
	--self:set_list_option("list_rewards",text)
	image = image or ""
	image = string.gsub(image,self.icon_filter,"")
	table.insert(self.rewards, { icon = image, text = txt, txtBonus = bonus, crew = isCrew})
	if txt == "[GAIN_INTEL]" then
		local intel = _G.Hero:GetAttribute("intel")
		local oldLevel = _G.Hero:GetLevel(intel - bonus)
		local newLevel = _G.Hero:GetLevel(intel)
		LOG("Old = " .. tostring(oldLevel) .. " new = " .. tostring(newLevel))
		
		
		if _G.GLOBAL_FUNCTIONS.DemoMode() and newLevel > 5 then
			newLevel = oldLevel
		end		
		if oldLevel < newLevel then
			_G.Hero:SetAttribute("stat_points", _G.Hero:GetAttribute("stat_points") + (5*(newLevel-oldLevel)))
			self.levelUp = true
		end
	elseif txt == "[GAIN_ITEM]" then
		_G.ShowTutorialFirstTime(11, _G.Hero)
	end
	self:UpdateList(xScale, yScale)

end

function QuestRewardsMenu:UpdateList()
	
	local function sorter(a,b)
		local textTable = { }
		textTable["[GAIN_INTEL]"]   = 1
		textTable["[GAIN_CREDITS]"] = 2
		textTable["[LOSE_FRIEND]"]  = 3
		textTable["[GAIN_FRIEND]"]  = 4
		local a_val, b_val
		LOG("a = " .. tostring(a) .. "   a.text = " .. tostring(a.text))
		a_val = textTable[a.text]
		b_val = textTable[b.text]
		if not a_val then
			LOG("Warning - unknown quest reward text index")
			return false
		elseif not b_val then
			LOG("Warning - unknown quest reward text index")
			return true
		end
		return a_val < b_val
	end
	
	self.rewards = _G.GLOBAL_FUNCTIONS.TableSort(self.rewards, sorter, true)
	--table.sort(self.rewards, sorter)
	local count=table.maxn(self.rewards)
   
	for i=1,4 do
		if self.rewards[i] then
         -- if there's only one or two reward items, use fields 2 and 3 rather than 1 and 2
         -- (just so they're spaced out a bit layout-wise)
         local j
         if count < 3 then
            j = i+1
         else
            j = i
         end
         
         local rewardIconTag = string.format("icon_reward%d", j)
         local rewardStringTag = string.format("str_reward%d", j)
         local rewardIconX = self:get_widget_x(rewardIconTag)
         local rewardStringX = self:get_widget_x(rewardStringTag)
         local rewardStringY = self:get_widget_y(rewardStringTag)
         local screenWidth = GetScreenWidth()
         			
         self:activate_widget(rewardIconTag)
			self:activate_widget(rewardStringTag)
			if self.rewards[i].crew or self.rewards[i].text == "[LOSE_FRIEND]" then
				LOG("Set crew image")
				LOG("Icon = " .. tostring(self.rewards[i].icon))
				--BEGIN_STRIP_DS
				if self.rewards[i].icon == "img_CED24_L" then
					self:set_image("icon_crew_scaled", self.rewards[i].icon)
					self:activate_widget("icon_crew_scaled")
					self:hide_widget("icon_crew")
				else
					self:set_image("icon_crew", self.rewards[i].icon)
					self:activate_widget("icon_crew")
					self:hide_widget("icon_crew_scaled")
				end
				--END_STRIP_DS
				self:hide_widget(rewardIconTag)
            
            
            
			else
				if self.rewards[i].icon then
					self:set_widget_size(rewardIconTag, self.icon_gem_width,self.icon_height)
				else
					self:set_widget_size(rewardIconTag, self.icon_width, self.icon_height)
				end
				self:set_image(rewardIconTag, self.rewards[i].icon)
            LOG(string.format("Reward %d icon: %s", j, self.rewards[i].icon))
			end

         rewardStringX = self:AdjustRewardText(i,j)
         
         local rewardText = substitute(translate_text(self.rewards[i].text), self.rewards[i].txtBonus)
		 LOG("rewardText @ "..tostring(rewardStringX))
         local maxTextWidth = self:get_widget_w(rewardStringTag) - 15 --- rewardStringX - 15  -- allow 15 pixels for border
         -- get_font(widgetTag) isn't available on DS so if the XML changes, this will need to change too
		 LOG("GET TEXT LENGTH = " .. tostring(get_text_length("font_system", rewardText)))
         if (get_text_length("font_system", rewardText) > maxTextWidth) then
         	LOG("fit_text_to "..tostring(maxTextWidth))
            rewardText = fit_text_to("font_system", rewardText , maxTextWidth)
         end
         
			self:set_text(rewardStringTag, rewardText)
		end
	end
end


----------------------------------------------------------------------
-- OnButton()
--
-- Handles button presses and opens the appropriate screen
-- Param: buttonID - id of the button pressed
-- Param: clickX - X coord in pixels of mouse at time of click
-- Param: clickY - Y coord in pixels of mouse at time of click
-- Returns: itself
----------------------------------------------------------------------
function QuestRewardsMenu:OnButton(buttonId, clickX, clickY)

	if (buttonId == -1) then--Close Quest Rewards
		
		Graphics.FadeToBlack()
						
		local function save_after_closing()
			local function GoToInventory()
				if self.levelUp then
					self:OpenLevelUp()
				elseif self.invTab then
					--BEGIN_STRIP_DS
					local function OpenInventoryNotDS()
						SCREENS.InventoryFrame:Open("SolarSystemMenu", self.invTab)
					end
					_G.NotDS(OpenInventoryNotDS)
					--END_STRIP_DS
					local function OpenInventoryDS()
						local function transition()
							_G.CallScreenSequencer("SolarSystemMenu", "InventoryFrame", "SolarSystemMenu", self.invTab,nil,nil, SCREENS.SolarSystemMenu.encounter_timer)
						end
						SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "InventoryFrame", nil, 2000)			
					end
					_G.DSOnly(OpenInventoryDS)		
				end				
				self.levelUp = nil			
			end
		
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, GoToInventory())	
			if _G.is_open("SolarSystemMenu") then
				SCREENS.SolarSystemMenu:ShowWidgets()
			end				
		end				
		CallScreenSequencer("QuestRewardsMenu", save_after_closing)

	end
	
	--return Menu.OnButton(self, buttonId, clickX, clickY)
	return Menu.MESSAGE_HANDLED;
end


----------------------------------------------------------------------
-- OnKey()
--
----------------------------------------------------------------------
function QuestRewardsMenu:OnKey(key)
	return Menu.OnKey(self, key)
end




-- return an instance of QuestRewardsMenu
return ExportSingleInstance("QuestRewardsMenu")
