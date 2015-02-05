use_safeglobals()



-------------------------------------------------------------------------------
--     Action Completion Events sent to hero
-------------------------------------------------------------------------------
local function OnEventEndBattle(hero, event)
	LOG("Hero End Battle")
	
	local enemy = event:GetAttribute("enemy")
	local questID = event:GetAttribute("questID")
	local objectiveID = event:GetAttribute("objectiveID")
	
	

	local function XBoxAchievement()
		if enemy == "HE28" then
			AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_PROGRESS_2)
		else			
			if _G.HEROES[enemy].faction == _G.FACTION_SOULLESS then
				AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_PROGRESS_1)
				
				if enemy == "HE30" then
					AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_GAMECOMPLETE)
				end				
				
			end					
		end
	end		
	
	
	if event:GetAttribute("result")==1 then
		event = GameEventManager:Construct("MonsterKilled")
		if not CollectionContainsAttribute(hero,"defeated",enemy) then
			hero:PushAttribute("defeated",enemy)
		end
		LOG("MonsterKilled")
		_G.XBoxOnly(XBoxAchievement)
	else
		event = GameEventManager:Construct("MonsterNotKilled")	
		LOG("MonsterNotKilled")	
	end
	
	event:SetAttribute("battleground", "B001")
	event:SetAttribute("monster", enemy)
	event:SetAttribute("questID",questID)
	event:SetAttribute("objectiveID",objectiveID)
	
	_G.ProcessQuestEvent(hero,event)
	
	hero:SetAttribute("battles_fought", math.mod(hero:GetAttribute("battles_fought") + 1,1000))
	
	
	
	
	--_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)

end



-------------------------------------------------------------------------------
--     Action Completion Events sent to hero
-------------------------------------------------------------------------------
local function OnEventEndMPBattle(hero, event)
	LOG(string.format("Hero EndMPBattle %s",hero:GetAttribute("name")))

	local result = event:GetAttribute("result")
	local mode = event:GetAttribute("mode")
	if result == 1 then
		if mode <= 1 then
			local num_won = math.min(_G.Hero:GetAttribute("mp_won") + 1,32000)
			hero:SetAttribute("mp_won",num_won)
			
			if num_won == 5 then
				local function XBoxAchievement()
					_G.AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_MP_1)
				end
				_G.XBoxOnly(XBoxAchievement)				
			elseif num_won == 50 then
				local function XBoxAchievement()
					_G.AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_MP_2)
				end
				_G.XBoxOnly(XBoxAchievement)			
			end
			
		end
		
	end	
	
	

	--_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)	
end



-------------------------------------------------------------------------------
--- Called after Hack Gate Mini Game
-------------------------------------------------------------------------------
local function OnEventEndHackGate(hero, event)
	local result = event:GetAttribute("result")
	local gate = event:GetAttribute("gate")
	if result == 1  and not CollectionContainsAttribute(hero,'hacked_gates',gate) then
		--LOG(string.format("Hacked gate %s",gate))
		hero:PushAttribute("hacked_gates",gate)
		if _G.JumpGateList then
			if _G.JumpGateList[gate] then
				--LOG("sethacked()")
				_G.JumpGateList[gate]:SetHacked()
				_G.JumpGateList[gate]:SetSystemView(hero:GetAttribute("curr_system"))
			end
		end
	end
	
	if result == 1 then
		local questID = event:GetAttribute("questID")
		local objectiveID = event:GetAttribute("objectiveID")
		local event2 = GameEventManager:Construct("MonsterKilled")
		event2:SetAttribute("battleground", "B002")
		event2:SetAttribute("monster", gate)
		event2:SetAttribute("questID",questID)
		event2:SetAttribute("objectiveID",objectiveID)
	
		local dont_save = _G.ProcessQuestEvent(hero,event2)
		
		
		
		
		local function XBoxAchievement()
			local numHacked = _G.Hero:NumAttributes("hacked_gates")
			if numHacked == 1 then
				AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_HACK_1)
			elseif numHacked == 30 then
				AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_HACK_2)
			end
		end
		_G.XBoxOnly(XBoxAchievement)		
		
		
		
		if not dont_save then
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)
		end
			
	end

end


local function OnEventEndEncounter(hero, event)
	LOG("Hero End Encounter")
	local encounterID = event:GetAttribute("encounter")
	
	local enemy = event:GetAttribute("enemy")
	if event:GetAttribute("result")==1 then
		local event = GameEventManager:Construct("MonsterKilled")
		event:SetAttribute("battleground", "B001")
		event:SetAttribute("monster", enemy)
		_G.ProcessQuestEvent(hero,event)
				
		if not CollectionContainsAttribute(hero,"defeated",enemy) then
			hero:PushAttribute("defeated",enemy)
		end		
		--prevent encounter of type enemy
		
		hero:SetAttribute("battles_fought", math.mod(hero:GetAttribute("battles_fought") + 1, 1000))
	
		_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)			
	end	
end

local function OnEventEndMine(hero, event)
	LOG("Hero End Mine")
	local result = event:GetAttribute("result")
	--Setup attributes/vars that block this mine from being over-mined
	
	local dont_save = false
	if result >= 0 then--if not QUIT
		local questID = event:GetAttribute("questID")
		local objectiveID = event:GetAttribute("objectiveID")
		local asteroid = event:GetAttribute("asteroid")
		local event2 = GameEventManager:Construct("MonsterKilled")
		event2:SetAttribute("battleground", "B006")
		event2:SetAttribute("monster", asteroid)
		event2:SetAttribute("questID",questID)
		event2:SetAttribute("objectiveID",objectiveID)
		dont_save = _G.ProcessQuestEvent(hero,event2)		
		
		if result == 1 then
			local numMined = _G.Hero:GetAttribute("num_mined")
			numMined = math.min((numMined + 1),99)
			_G.Hero:SetAttribute("num_mined",numMined)
			
			if numMined == 10 then
				local function XBoxAchievement()
					_G.AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_MINING)
				end
				_G.XBoxOnly(XBoxAchievement)				
			end
		end
	end
	
			
	if not dont_save then
		_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)
	end		
	
end

local function OnEventEndCraft(hero, event)
	LOG("Hero End Craft")
	local result = event:GetAttribute("result")
	local item = event:GetAttribute("itemID")
	if result == 1 then
		LOG(string.format("Player awarded %s",item))
		if string.char(string.byte(item)) == "S" then
			hero:AddShip(item, false)
		else
         local gotItem = false
         for i=1,hero:NumAttributes("items") do
            local invItem = _G.Hero:GetAttributeAt("items", i)
            if item == invItem then
               gotItem = true
               break
            end
         end
         
         if gotItem == false then
            hero:AddItem(item)
         else
            LOG("Player already has the item, item not awarded")
         end
      end
		
		local questID = event:GetAttribute("questID")
		local objectiveID = event:GetAttribute("objectiveID")
		local event2 = GameEventManager:Construct("MonsterKilled")
		event2:SetAttribute("battleground", "B010")
		event2:SetAttribute("monster", item)--item/ship crafted
		event2:SetAttribute("questID",questID)
		event2:SetAttribute("objectiveID",objectiveID)
		local dont_save = _G.ProcessQuestEvent(hero,event2)
				
		if not dont_save then
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)
		end				
	end	
end

local function OnEventEndRumor(hero, event)
	local rumor = event:GetAttribute("rumor")
	local result = event:GetAttribute("result")
	local reward = event:GetAttribute("reward")
	if result == 1 then
		local questID = event:GetAttribute("questID")
		local objectiveID = event:GetAttribute("objectiveID")
		local event2 = GameEventManager:Construct("MonsterKilled")
		event2:SetAttribute("battleground", "B011")
		event2:SetAttribute("monster", hero:GetAttribute("curr_loc"))
		event2:SetAttribute("questID", questID)
		event2:SetAttribute("objectiveID", objectiveID)
		hero:PushAttribute("unlocked_rumors", rumor)
		local dont_save = _G.ProcessQuestEvent(hero,event2)
		
		if hero:NumAttributes("unlocked_rumors")==1 then
			local function XBoxAchievement()
				_G.AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_RUMORS)
			end
			_G.XBoxOnly(XBoxAchievement)				
		end			
		
				
		if not dont_save then
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)
		end		
	end
end


-- bargain == haggle
local function OnEventEndBargain(hero, event)
	LOG("Hero End Bargin")
	local gems = event:GetAttribute("nil_gems")
	local result = event:GetAttribute("result")
	
	local multiplier = hero:GetHaggleTable()[55-gems]
	if not multiplier then
		multiplier = 1.0
	end
	LOG(string.format("Nil Gems = %d",gems))
	local questID = event:GetAttribute("questID")
	if questID == "" then	
		_G.LoadAssetGroup("AssetsInventory")	
		_G.LoadAssetGroup("AssetsItems")
		SCREENS.ShopMenu:Open(multiplier, hero.isBuying)
		hero.isBuying = nil
	end
	if result == 1 then
		local questID = event:GetAttribute("questID")
		local objectiveID = event:GetAttribute("objectiveID")
		local event2 = GameEventManager:Construct("MonsterKilled")
		event2:SetAttribute("battleground", "B008")
		event2:SetAttribute("monster", event:GetAttribute("location"))--location of bargain.
		event2:SetAttribute("questID",questID)
		event2:SetAttribute("objectiveID",objectiveID)
		
		local dont_save = _G.ProcessQuestEvent(hero,event2)
				
		if not dont_save then
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)
		end
		
		if (55-gems) <= 6 then
			local function XBoxAchievement()
				_G.AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_HAGGLING)
			end
			_G.XBoxOnly(XBoxAchievement)				
		end		
		
	end	
end

local HeroStateEndGame = 
{
	OnEventEndBattle = OnEventEndBattle,
	OnEventEndMPBattle = OnEventEndMPBattle,
	OnEventEndHackGate = OnEventEndHackGate,
	OnEventEndEncounter = OnEventEndEncounter,
 	OnEventEndMine = OnEventEndMine,
 	OnEventEndCraft = OnEventEndCraft,
 	OnEventEndRumor = OnEventEndRumor,
 	OnEventEndBargain = OnEventEndBargain,
}

return HeroStateEndGame
