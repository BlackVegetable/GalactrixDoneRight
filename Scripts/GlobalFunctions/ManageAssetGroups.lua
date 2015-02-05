
-------------------------------------------------------------------------------
--    ManageAssetGroups - loads and unloads AssetGroups (mainly for the DS)
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------
function ManageAssetGroups(menuName)
	--LOG(string.format("ManageAssetGroups(%s)",menuName))
	LOG("ManageAssetGroups " .. menuName .. " time " .. GetGameTime())
	
 local assetGroups = {"AssetsBattleGround",
		"AssetsStarMap",
		"AssetsSolarSystem",
		"AssetsInventory",
		"AssetsUI",
		"AssetsCombatIntro",
		"AssetsInsignias",
		"AssetsItems",
		"AssetsButtons",
		"AssetsTutorial",
		"AssetsTraining"}
		
	--"AssetsConversations",--Removed from assetsGroups -handled strictly by RunQuestConversation function.
		
	local assetGroupsLoad = {}
	if menuName == "SplashMenu" or menuName == "MainMenu" or menuName == "SinglePlayerMenu" or menuName == "CreateHeroMenu" or menuName == "SelectHeroMenu" or menuName == "HelpOptionsMenu" then
		assetGroupsLoad = {"AssetsButtons", "AssetsUI"}
	elseif menuName == "MapMenu" or menuName == "SystemInfoMenu" then
		assetGroupsLoad = {"AssetsStarMap", "AssetsInsignias", "AssetsButtons", "AssetsSolarSystem"}
	elseif menuName == "SolarSystemMenu" then
		assetGroupsLoad = {"AssetsSolarSystem", "AssetsInsignias", "AssetsButtons"}		
	elseif menuName == "GameMenu" then
		assetGroupsLoad = {"AssetsBattleGround"}
	elseif menuName == "CombatIntroMenu" then
		assetGroupsLoad = {"AssetsCombatIntro", "AssetsButtons", "AssetsInsignias"}
	elseif menuName == "CombatResultsMenu" then
		assetGroupsLoad = {"AssetsInsignias", "AssetsButtons", "AssetsItems"}		
	elseif menuName == "EncounterIntroMenu" then
		assetGroupsLoad = {"AssetsButtons", "AssetsCombatIntro", "AssetsInsignias"}	
	elseif menuName == "CraftingIntroMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons"}	
	elseif menuName == "CraftingResultsMenu" then
		assetGroupsLoad = {"AssetsItems", "AssetsInventory", "AssetsButtons"}	
	elseif menuName == "BargainIntroMenu" then
		assetGroupsLoad = {"AssetsButtons"}	
	elseif menuName == "BargainResultsMenu" then
		assetGroupsLoad = {"AssetsButtons"}	
	elseif menuName == "MiningIntroMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons", "AssetsCombatIntro"}
	elseif menuName == "MiningResultsMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons"}
	elseif menuName == "HackIntroMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons"}
	elseif menuName == "RumorIntroMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons"}
	elseif menuName == "RumorResultsMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons"}
	elseif menuName == "InvCargo" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvCrew" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InventoryFrame" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvFactions" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvFitout" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvHero" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvQuests" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvShips" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "InvStats" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems", "AssetsButtons", "AssetsUI", "AssetsSolarSystem","AssetsCombatIntro"}
	elseif menuName == "CargoTrader" then
		assetGroupsLoad = {"AssetsInventory","AssetsCombatIntro"}	
	elseif menuName == "ShopMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsItems","AssetsCombatIntro"}	
	elseif menuName == "MultiplayerMenu" then
		assetGroupsLoad = {"AssetsUI", "AssetsButtons"}			
	elseif menuName == "MultiplayerGameSetup" then
		assetGroupsLoad = {"AssetsUI", "AssetsButtons", "AssetsCombatIntro", "AssetsInventory"}	
	elseif menuName == "MPResultsMenu" then
		assetGroupsLoad = {"AssetsInventory", "AssetsButtons"}		
	elseif menuName == "QuestRewardsMenu" then
		assetGroupsLoad = {"AssetsInventory","AssetsButtons"}			
	elseif menuName == "HowToPlayMenu" then
		assetGroupsLoad = {"AssetsButtons", "AssetsUI"}
	elseif menuName == "ControlsMenu" then
		assetGroupsLoad = {"AssetsButtons", "AssetsUI"}				
	elseif menuName == "CreditsMenu" then
		assetGroupsLoad = {"AssetsButtons", "AssetsUI"}			
	elseif menuName == "LevelUpMenu" then
		assetGroupsLoad = {"AssetsButtons", "AssetsUI"}		
	end		
	
	if #assetGroupsLoad == 0 and menuName then
		assert(false, "No handling of AssetGroups for " .. menuName .. " so it wont load any asset groups")
	end
		
	-- Unload all unneeded AssetGroups first
	for k,v in pairs (assetGroups) do
		local found = false
		for i, n in pairs (assetGroupsLoad) do
			if assetGroupsLoad[i] == assetGroups[k] then
				found = true
			end
		end
		
		if not found then
			LOG("Unload AssetGroup " .. assetGroups[k])
			if assetGroups[k] == "AssetsButtons" then
				close_message_menu()
				close_yesno_menu(false,false)
			end
			UnloadAssetGroup(assetGroups[k])
		end
		
	end	
	
	-- Load needed AssetGroups	
	LOG("Now Load the AssetGroups")
	for i, n in pairs (assetGroupsLoad) do
		LOG("Load AssetGroup " .. assetGroupsLoad[i])
		LoadAssetGroup(assetGroupsLoad[i])
	end	
	
	 LOG("ManageAssetGroups endtime " .. GetGameTime())
	return true		
end

return ManageAssetGroups