use_safeglobals()



local function OnEventShowCutscene(hero,event)
	local cutscene = event:GetAttribute("cutscene")

	if cutscene and cutscene ~= "" then
		hero.cut_scene = cutscene
	end
	LOG(string.format("OnEventShowCutscene %s",cutscene))
end



local function OnEventShowMessage(hero,event)
	local message = event:GetAttribute("message")

	if message and  message ~= "" then
		hero:OpenQuestRewards()
		SCREENS.QuestRewardsMenu:set_text_raw("str_message", message)
	end
	LOG(string.format("OnEventShowMessage %s",message))
end



local function OnEventGiveResource(hero,event)
	local resource = event:GetAttribute("resource")
	local amount = event:GetAttribute("amount")
	local show  = event:GetAttribute("show")==1

	local resourceNum = tonumber(resource)
	if resourceNum then

		if resourceNum <= _G.NUM_CARGOES then--Give Cargo
			local dropped = hero:AddCargo(resourceNum,amount)
			dropped = dropped[resourceNum]
			amount = amount - dropped
			if amount > 0 and show then
				hero:OpenQuestRewards()
				LOG("Warning - GiveResource uses hardcoded English string")
				SCREENS.QuestRewardsMenu:AddListItem(string.format("img_cargo_big_%s",resource),string.format("%s %s %s",translate_text("[YOU_RECIEVED]"), amount,translate_text(string.format("[%s_NAME]",string.upper(_G.DATA.Cargo[resourceNum].effect)))))
			end
		elseif resourceNum == 11 then--Receive Psi Power
			-- award psi powers
			hero:SetAttribute("psi_powers", amount)

			if amount == 7 then
				local function XBoxAchievement()
					_G.AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_SIDEQUESTS)
				end
				_G.XBoxOnly(XBoxAchievement)
			end


		elseif resourceNum == 14 and not CollectionContainsAttribute(hero,"encountered_factions",amount) then
			--ADD ENCOUNTERED FACTIONS
			--really only used to add FACTION_SOULLESS when the player knows about them.
			hero:PushAttribute("encountered_factions", amount)

		end
	end
	hero:SetToSave()

	LOG(string.format("OnEventGiveResource %s %s %d",tostring(show),resource,amount))
end

local function OnEventRemoveResource(hero,event)
	local resource = event:GetAttribute("resource")
	local amount = event:GetAttribute("amount")
	local show  = event:GetAttribute("show")==1

	local resourceNum = tonumber(resource)
	if resourceNum then
		if resourceNum <= _G.NUM_CARGOES then
			local dropped = hero:RemoveCargo(resourceNum,amount)
			amount = math.abs(amount) - dropped
			if amount > 0 and show then
				hero:OpenQuestRewards()
				SCREENS.QuestRewardsMenu:AddListItem(string.format("img_cargo_big_%s",resource),string.format("You Lost %s %s",amount,translate_text(_G.DATA.Cargo[resourceNum].name)))
			end
		end
	end

	hero:SetToSave()

	LOG(string.format("OnEventRemoveResource %s %s %d",tostring(show),resource,amount))
end

local function OnEventGiveItem(hero,event)
	local newItemID = event:GetAttribute("item")
	LOG(string.format("GiveItem(%s)",newItemID))

	local show = event:GetAttribute("show")==1


	local itemType = string.char(string.byte(newItemID,1))
	if itemType == "I" then
		hero:AddItem(newItemID,show)
	elseif itemType == "S" then
		hero:AddShip(newItemID,show)
	elseif itemType == "P" then
		hero:AddPlan(string.gsub(newItemID,"P","",1),show)
	else
		LOG(string.format("Unable to add item %s",newItemID))
	end

end



local function OnEventRemoveItem(hero,event,itemID)
	if not itemID then
		itemID = event:GetAttribute("item")
	end
	local show  = false
	if event then
		show = event:GetAttribute("show")==1
	end

	local itemType = string.char(string.byte(itemID,1))
	if itemType == "I" then
		hero:RemoveItem(itemID,show)
	elseif itemType == "S" then
		--hero:AddShip(itemID,show)
	elseif itemType == "P" then
		--hero:AddPlan(string.gsub(itemID,"P","I",1),show)
	end

end



local function OnEventGiveFriend(hero,event)
	local friend = event:GetAttribute("friend")
	local show  = event:GetAttribute("show")==1
	LOG(string.format("OnEventGiveFriend %s %s",tostring(show),friend))

	if not _G.CollectionContainsAttribute(hero,"crew",friend) then
		hero:PushAttribute("crew", friend)
	end

	if show then
		hero:OpenQuestRewards()
		SCREENS.QuestRewardsMenu:AddListItem(string.format("%s_L",CREW[friend].portrait), "[GAIN_FRIEND]", translate_text(CREW[friend].name), true)
		SCREENS.QuestRewardsMenu:SetInventoryTab(5)--CrewList
	end


	hero:SetToSave()

end

local function OnEventRemoveFriend(hero,event)
	local friend = event:GetAttribute("friend")
	local show  = event:GetAttribute("show")==1
	LOG(string.format("OnEventRemoveFriend %s %s",tostring(show),friend))
	hero:EraseAttribute("crew", friend)

	for i=1, hero:NumAttributes("crew") do
		LOG("Crew = " .. tostring(hero:GetAttributeAt("crew", i)))
	end

	if show then
		hero:OpenQuestRewards()
		SCREENS.QuestRewardsMenu:AddListItem(string.format("%s_L",CREW[friend].portrait), "[LOSE_FRIEND]", translate_text(CREW[friend].name))
	end
	hero:SetToSave()
end



local function OnEventGiveExperience(hero,event)
	LOG("OnEventGiveExperience() ")
	local amount = event:GetAttribute("amount")
	local show  = event:GetAttribute("show")==1

	local intel = hero:GetAttribute("intel")
	hero:SetAttribute("intel",intel+amount)

	if show then
		hero:OpenQuestRewards()
		LOG("GainIntel")
		SCREENS.QuestRewardsMenu:AddListItem("img_white_gem","[GAIN_INTEL]",amount)
	end

	LOG(string.format("OnEventGiveExperience %s %d",tostring(show),amount))
	hero:SetToSave()
end

local function OnEventGivePsi(hero,event)
	LOG("OnEventAwardPsi() ")
	local amount = event:GetAttribute("amount")
	local show = event:GetAttribute("show")==1

	local psi = hero:GetAttribute("psi")
	hero:SetAttribute("psi",psi+amount)

	if show then
		hero:OpenQuestRewards()
		LOG("GainPsi")
		SCREENS.QuestRewardsMenu:AddListItem("img_purple_gem","[GAIN_PSI]",amount)
	end

	LOG(string.format("OnEventGivePsi %s %d",tostring(show),amount))
	hero:SetToSave()
end


local function OnEventGiveGold(hero,event, amount)
	local show
	if not amount then
		amount = event:GetAttribute("amount")
		show  = event:GetAttribute("show")==1
	end

	local credits = hero:GetAttribute("credits")
	if amount >= 0 then
		credits = math.min(credits + amount,_G.MAX_CREDITS)
	else
		credits = math.max(credits + amount, 0)
	end

	if _G.GLOBAL_FUNCTIONS.DemoMode() then
		credits = math.min(credits,2000)
	end

	hero:SetAttribute("credits",credits)

	if show then
		hero:OpenQuestRewards()
		SCREENS.QuestRewardsMenu:AddListItem("img_credit", "[GAIN_CREDITS]", amount)
	end

	LOG(string.format("OnEventGiveGold %s %d",tostring(show),amount))
	hero:SetToSave()
end

--used only to unhack gates
local function OnEventHideLocation(hero,event)
	local location = event:GetAttribute("location")
	local show  = event:GetAttribute("show")==1
	LOG(string.format("OnEventHideLocation %s %s",tostring(show),location))

	--hero:EraseAttribute("hacked_gates", location)
	--_G.JumpGateList[location]:SetAttribute("hacked", 0)
	--SCREENS.SolarSystemMenu:RefreshGateSprites()
	SCREENS.SolarSystemMenu:UnhackGate(location,true)
	hero:SetToSave()
end

--Used only to make asteroid mineable again.
local function OnEventShowLocation(hero, event)
	local location = event:GetAttribute("location")
	local show  = event:GetAttribute("show")==1

	hero:EraseAttribute("mined_asteroids", location)
	SCREENS.SolarSystemMenu:GetWorld().SatelliteList[location]:SetSystemView()
	hero:SetToSave()
end


local function OnEventGiveFactionStatus(hero,event)
	local faction = tonumber(event:GetAttribute("faction"))
	if faction and faction == 0 then
		return
	end
	local amount = event:GetAttribute("amount")
	local show  = event:GetAttribute("show")==1
	LOG(string.format("OnEventGiveFactionStatus %s %d %d",tostring(show),faction,amount))
	local standing = hero:GetAttributeAt("faction_standings",faction)
	standing = math.min(100, math.max(-100, standing + amount))
	hero:SetAttributeAt("faction_standings",faction,standing)
	if show then
		hero:OpenQuestRewards()
		SCREENS.QuestRewardsMenu:AddListItem(_G.DATA.Factions[faction].icon,string.format("+%d %s %s",amount,translate_text(_G.DATA.Factions[faction].name),translate_text("[REPUTATION]")), "")
	end
	hero:SetToSave()
end

local function OnEventRemoveFactionStatus(hero,event)
	local faction = tonumber(event:GetAttribute("faction"))
	if faction and faction == 0 then
		return
	end
	local amount = event:GetAttribute("amount")
	local show  = event:GetAttribute("show")==1
	LOG(string.format("OnEventRemoveFactionStatus %s %d %d",tostring(show),faction,amount))

	local standing = hero:GetAttributeAt("faction_standings",faction)
	standing = math.min(100, math.max(-100, standing - amount))
	hero:SetAttributeAt("faction_standings",faction,standing)
	if show then
		hero:OpenQuestRewards()
		SCREENS.QuestRewardsMenu:AddListItem(_G.DATA.Factions[faction].icon,string.format("-%d %s %s", amount, translate_text(_G.DATA.Factions[faction].name), translate_text("[REPUTATION]"), ""))
	end

	hero:SetToSave()
end


--Start Quest Battle
local function OnEventStartBattle(hero,event)
	LOG("OnEventStartBattle")
	local battleground = event:GetAttribute("battleground")

	local questID = event:GetAttribute("questID")
	local objectiveID = event:GetAttribute("objectiveID")
	local location = hero:GetAttribute("curr_loc")

	if battleground == "B001" then
		local monster = event:GetAttribute("monster")
		local params = {}
		local numParams = event:NumAttributes("params")

		for i=1, numParams do
			params[i] = event:GetAttributeAt("params",i)
			if params[i]=="" then
				params[i] = nil
			end
		end

		local player2
		if monster then
			player2 = _G.GLOBAL_FUNCTIONS.LoadHero.LoadEnemy(monster,params[1],params[2],params[3],params[4],params[5],params[6],params[7],params[8],params[9])
		end
		player2:LevelToHero(hero)
		player2:UpdateLevel(params[10],params[11],params[12],params[13])

		SCREENS.SolarSystemMenu.state = _G.STATE_ENCOUNTER
		_G.GLOBAL_FUNCTIONS.Battle.QuestBattle("SolarSystemMenu",questID,objectiveID,hero,player2)

		local function transition()
		end
		--SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "CombatIntroMenu", nil, 500)
	elseif battleground == "B006" then--Mine
		-- get location from "hero"
		_G.GLOBAL_FUNCTIONS.Mine("SolarSystemMenu", hero, location,questID,objectiveID)

	elseif battleground == "B002" then--Hack
		_G.GLOBAL_FUNCTIONS.Hack("SolarSystemMenu", hero, location,questID,objectiveID)

	elseif battleground == "B010" then--Craft
		_G.GLOBAL_FUNCTIONS.CraftItem("SolarSystemMenu", hero, questID,objectiveID)

	elseif battleground == "B008" then--Haggle/Bargain
		_G.GLOBAL_FUNCTIONS.Bargain("SolarSystemMenu", hero, location,questID,objectiveID)

	elseif battleground == "B011" then--Rumor
		_G.GLOBAL_FUNCTIONS.Rumor("SolarSystemMenu", hero, location,questID,objectiveID)
	end
end


--Needed for crafting Mission
local function OnEventSetEncounter(hero,event)
	local battleground = event:GetAttribute("battleground")
	if battleground == "B010" then
		_G.GLOBAL_FUNCTIONS.CraftItem("SolarSystemMenu", hero)
	end
end


--PRECONDITION FUNCTIONS

local function HasFriend(hero,crewID)
	LOG(string.format("HasFriend %s",crewID))
	if CollectionContainsAttribute(hero,"crew",crewID) then
		LOG("Return true")
		return true
	end
	return false
end


local function HasItem(hero,itemID)
	LOG(string.format("HasItem %s",itemID))
	local itemType = string.char(string.byte(itemID,1))
	if itemType=="I" then
	if CollectionContainsAttribute(hero,"items",itemID) then
		LOG("Return true")
		return true
	end
	elseif itemType == "S" then
		for i=1,hero:NumAttributes("ship_list") do
			if hero:GetAttribute("ship_list",i):GetAttribute("ship")== itemID then
				return true
			end
		end
	elseif itemType == "P" then
		if CollectionContainsAttribute(hero,"plans",itemID) then
			LOG("Return true")
			return true
		end
	end
	return false
end

local function HasItemEquip(hero,itemID)
	LOG(string.format("HasItemEquip %s",itemID))
	local loadout = Hero:GetAttributeAt("ship_list",Hero:GetAttribute("ship_loadout"))
	if CollectionContainsAttribute(loadout,"items",itemID) then
		LOG("Return true")
		return true
	end
	return false
end


local function GetResource(hero,resourceID)
	local amount = 0
	if resourceID <= _G.NUM_CARGOES then
		amount = hero:GetAttributeAt("cargo",resourceID)
	elseif resourceID == 12 then--Ships
		amount = hero:NumAttributes("ship_list")
	end

	return amount
end


local HeroStateQuest =
{
	OnEventShowCutscene = OnEventShowCutscene,
	OnEventShowMessage = OnEventShowMessage,
	OnEventGiveResource = OnEventGiveResource,
	OnEventRemoveResource = OnEventRemoveResource,
	OnEventGiveItem = OnEventGiveItem,
	OnEventRemoveItem = OnEventRemoveItem,
	OnEventGiveFriend = OnEventGiveFriend,
	OnEventRemoveFriend = OnEventRemoveFriend,
	OnEventGiveExperience = OnEventGiveExperience,
	OnEventGivePsi = OnEventGivePsi,
	OnEventGiveGold = OnEventGiveGold,
	OnEventHideLocation = OnEventHideLocation,
	OnEventShowLocation = OnEventShowLocation,
	OnEventGiveFactionStatus = OnEventGiveFactionStatus,
	OnEventRemoveFactionStatus = OnEventRemoveFactionStatus,

	OnEventStartBattle = OnEventStartBattle,
	OnEventSetEncounter = OnEventSetEncounter,

	GetResource = GetResource,
	HasItemEquip = HasItemEquip,
	HasItem = HasItem,
	HasFriend = HasFriend,

}
return HeroStateQuest

