use_safeglobals()


local function OnArriveAtEndNode(hero)
	LOG("OnArriveAtEndNode() "..hero.curr_star)

	--local gate = hero:GetLastGate()
	local gate = hero.last_gate
	if gate then
		LOG(string.format("Set loc %s",gate))
		hero:SetAttribute("curr_loc", gate)
		hero:SetAttribute("curr_loc_obj",_G.JumpGateList[gate])
	end

	--SCREENS.MapMenu:GetWorld():EndMove()
	hero:SetAttribute("curr_system", hero.curr_star)
	hero:ResetEncounters()
	LOG("ArriveAtEndStar "..tostring(hero.curr_star))
	SCREENS.MapMenu:GetWorld():ArriveAtEndStar()

	if hero.star_encounter then
		local AlertEncounter = 3
		SCREENS.MapMenu:GetWorld():OnActionStar(_G.StarList[hero.curr_star],3)
	end
end





local function OnArriveAtNode(hero, node)
	local classIDStr = ClassIDToString(node:GetClassID())



	hero.star_encounter = false

	local world = SCREENS.MapMenu:GetWorld()
	local encounterChance = 0

	hero.last_star = hero.curr_star
	hero.curr_star = node.classIDStr
	hero:SetAttribute("curr_system", hero.curr_star)
	hero:ResetEncounters()


	local gate = hero.last_gate
	if gate then
		LOG(string.format("Set loc %s",gate))
		hero:SetAttribute("curr_loc", gate)
	end

	hero:SetToSave()
	--LOG(string.format("Star to Star: %s to %s",hero.last_star,hero.curr_star))

	--[[
	local faction = node:GetFaction()
	if (hero:GetFactionData(faction) == _G.FACTION_UNKNOWN) and (faction ~= _G.FACTION_NONE) then
		hero:PushAttribute("encountered_factions", faction)
	end
	--]]

	local standing = hero:GetFactionStanding(node:GetFaction())
	local contraband = hero:GetAttributeAt("cargo",_G.CARGO_CONTRABAND)

	--This May Be Taken Out
	--Increases probability of Encounter based on Faction standing
	if contraband == 0 and node:GetFaction() > 0 then
		--LOG(string.format("Faction standing = %d",hero:GetAttributeAt("faction_standings",node:GetFaction())))
		encounterChance = - hero:GetAttributeAt("faction_standings",node:GetFaction())

		encounterChance = encounterChance - math.ceil(encounterChance * 0.40) -- Reduce Encounter chance by 40 percent (BV Balance Mod)
		if hero:GetAttribute("psi_powers") >= 7 then -- Replacement for no encounters at 7th power (BV Balance Mod)
			encounterChance = encounterChance - math.ceil(encounterChance * 0.20) -- Reduces chance by a multiplicitave 20 percent (BV Balance Mod)
		end
	end

	if contraband ~= 0 then
		if hero:GetAttribute("psi_powers") < 7 then
			encounterChance = math.max(30, encounterChance)--Contraband chance only
		end
		if hero:GetAttribute("psi_powers") >= 7 then
			encounterChance = math.max(24, encounterChance)  -- Contraband chance decreased with final PSI power as well.
		end
	end

	if _G.DATA.Factions[node:GetFaction()].forceEncounters == true then
		encounterChance = 100
	end

	if (contraband > 0 or standing < _G.STANDING_NEUTRAL) then -- and hero:GetAttribute("psi_powers") < 7 then

		if math.random(1,100) < encounterChance and not _G.is_open("TutorialMenu") then
			--LOG(string.format("Encounter chance = %d",encounterChance))
			world:MapEncounter(node)
		end
	end

	world:ArriveAtStar(node)


end

local function GetLastGate(hero)
	LOG("GetLastGate()")
	local gate
	--[[
	local curr_star = hero:GetAttribute("curr_system")
	local numGates = _G.StarList[curr_star]:NumAttributes("jumpgates")
	--LOG("NumGates "..tostring(numGates))
	for i=1, numGates do
		local jg = StarList[curr_star]:GetAttributeAt("jumpgates",i)
		local star1 = _G.DATA.JumpGatesTable[jg][1]
		local star2 = _G.DATA.JumpGatesTable[jg][2]

		LOG("Star1 = " .. tostring(star1) .. "   Star2 = " .. tostring(star2))
		LOG("LastS = " .. tostring(hero.last_star) .. "   CurrS = " .. tostring(hero.curr_star))
		if (star1 == hero.last_star and star2 == hero.curr_star) or
			(star1 == hero.curr_star and star2 == hero.last_star) then

			--LOG(string.format("Set loc %s",jg))
			gate = jg
			break
		end
	end
	--]]
	LOG("Returned = " .. tostring(gate))
	--hero.last_gate = gate
	return hero.last_gate
	--return gate
end


--hero has arrived at an enemy in Solar System map
local function HeroArrived(hero)
	--Do nothing
	LOG(string.format("Hero Arrived at encounter %s",hero.encounter.classIDStr))

	_G.Hero:SetAttribute("curr_loc",hero.classIDStr)
	_G.Hero:SetAttribute("curr_loc_obj",hero)--set location to enemy
	SCREENS.SolarSystemMenu.state = _G.STATE_ENCOUNTER
	SCREENS.SolarSystemMenu.enemy = hero
	_G.GLOBAL_FUNCTIONS.EncounterBattle("SolarSystemMenu",hero.encounter,_G.Hero,hero)
end

local function SetStarMapView(hero, sprite,map)
	if not sprite then
		sprite = "H"
	end
	if hero:GetAttribute("curr_ship") ~= nil then
		hero:SetView(hero:GetAttribute("curr_ship"):GetStarMapView(sprite))
	end
	if hero:GetAttribute("ai") ~= 1 then--Hero ship
		local view = GameObjectViewManager:Construct("Sprite","ZSPL")
		view:StartAnimation("stand")
		--view:SetSortingValue(-4)
		hero:AddOverlay("hero_ship", view, 0, 0)
	end
	LOG("SetStarMapView")
end



local function SetSystemView(hero, sprite)
	if not sprite then
		sprite = "H"
	end
	hero.particle = sprite
	if hero == _G.Hero then
		LOG("Hero.particle set ")
	end
	LOG("SetSystemView sprite="..hero.particle)
	if hero:GetAttribute("curr_ship") ~= nil then
		local view = hero:GetView()
		local dir
		if view then
			LOG("View Not NULL")
			--dir = view:GetDir()
		end
		hero.view = hero:GetAttribute("curr_ship"):GetSystemView(sprite)
		if dir then
			hero.view:SetDir(dir)
		end
		hero:SetView(hero.view)
	end

	--[[
	if hero:GetAttribute("ai") ~= 1 then--Hero ship
		local view = GameObjectViewManager:Construct("Sprite","ZSPL")
		view:StartAnimation("stand")
		view:SetSortingValue(-14)
		hero:AddOverlay("hero_ship", view, 0, 0)
	end
	--]]

end




local HeroStateMaps =
{
	OnArriveAtEndNode = OnArriveAtEndNode,
	OnEventMovementFinished = OnEventMovementFinished,
	OnArriveAtNode = OnArriveAtNode,
	GetLastGate = GetLastGate,
	HeroArrived = HeroArrived,
	SetStarMapView = SetStarMapView,
	SetSystemView = SetSystemView,
}
return HeroStateMaps
