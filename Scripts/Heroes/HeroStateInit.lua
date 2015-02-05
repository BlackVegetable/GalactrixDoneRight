use_safeglobals()


local function SetupAttributes(attribs)

	attribs:AddAttribute('string',  'name',                 {default="", serialize=1} )

	attribs:AddAttribute('int',     'mining',               {default=0, serialize=1, max=5} )
	attribs:AddAttribute('int',     'gunnery',              {default=1, serialize=1, max=200} )
	attribs:AddAttribute('int',     'engineer',             {default=1, serialize=1, max=200} )
	attribs:AddAttribute('int',     'science',              {default=1, serialize=1, max=200} )
	attribs:AddAttribute('int',     'pilot',                {default=1, serialize=1, max=200} )
	attribs:AddAttribute('int',     'intel',                {default=0, serialize=1, max=65536} )
	attribs:AddAttribute('int',     'credits',              {default=100, serialize=1} )

	attribs:AddAttribute('int',     'player_id',            {default=0} )
	attribs:AddAttribute('int',     'mp_id',            	{default=0} )
	attribs:AddAttribute('int',     'gui_id',               {default=0} )
	attribs:AddAttribute('int',     'ai',                   {default=0} )
	attribs:AddAttribute('int',     'team',                 {default=1} )--needed?

	attribs:AddAttribute('int',     'life',                 {default=120} )
	attribs:AddAttribute('int',     'shield',               {default=10} )
	attribs:AddAttribute('int',     'engine',               {default=0} )
	attribs:AddAttribute('int',     'cpu',                  {default=0} )
	attribs:AddAttribute('int',     'psi',                  {default=0,serialize=1} )
	attribs:AddAttribute('int',     'weapon',               {default=0} )
	attribs:AddAttribute('int',     'timer',                {default=0} )

	attribs:AddAttribute('int',     'seq_pos',              {default=0} )
	attribs:AddAttribute('int',     'seq_length',           {default=30} )

	attribs:AddAttribute('int',     'life_max',             {default=120} )
	attribs:AddAttribute('int',     'shield_max',           {default=20} )
	attribs:AddAttribute('int',     'engine_max',           {default=20} )
	attribs:AddAttribute('int',     'cpu_max',              {default=20} )
	attribs:AddAttribute('int',     'weapon_max',           {default=20} )

	attribs:AddAttribute('int',     'faction',              {default=_G.FACTION_MRI} ) --used by enemies only
	attribs:AddAttribute('string', 'init_ship',{default="SMBL"})--Ship to start with

	--Default Items for this Character
	attribs:AddAttribute('string', 'item_1',{default=""})
	attribs:AddAttribute('string', 'item_2',{default=""})
	attribs:AddAttribute('string', 'item_3',{default=""})
	attribs:AddAttribute('string', 'item_4',{default=""})
	attribs:AddAttribute('string', 'item_5',{default=""})
	attribs:AddAttribute('string', 'item_6',{default=""})
	attribs:AddAttribute('string', 'item_7',{default=""})
	attribs:AddAttribute('string', 'item_8',{default=""})

	attribs:AddAttribute('int',                  'longest_chain',         {default=0} )

	attribs:AddAttribute('int', 			     'male',			{default=1,serialize=1, max=2})--Gender 1/0
	attribs:AddAttribute('int',              'portraitID',   {default=1,serialize=1, max=2})--unique identifier for the portrait
	attribs:AddAttribute('string', 			  'portrait',		{default="",serialize=1})--stores the Hero portrait
	--attribs:AddAttribute('string', 			  'hi_portrait',	{default="",serialize=1})--stores the hero's hi-res portrait (used?)
	attribs:AddAttribute('string', 			  'curr_system',	{default="S000", serialize=1, fixed=4})--Default starting system for Hero = Erebus
	attribs:AddAttribute('string', 			  'curr_loc',		{default="J002", serialize=1, fixed=4})--Default starting Satellite of Hero
	attribs:AddAttribute('GameObject', 		  'curr_loc_obj',	{})--Default starting Satellite of Hero
	attribs:AddAttributeCollection('string', 'hacked_gates', {serialize=1, fixed=4})--4CCs of each gate hacked by the hero
	attribs:AddAttributeCollection('string', 'plans', 			{serialize=1, fixed=4})--list of items/ships for which this hero has the plans

	attribs:AddAttribute('GameObject', 		      'curr_ship', 	          {})--Current Ship

	attribs:AddAttributeCollection('string',     'items', 		          {serialize=1, fixed=4})--strings for each item earned/bought by Hero
	attribs:AddAttributeCollection('string',     'crew', 	                {serialize=1, fixed=4})--4CCs of each crew member the hero has
	attribs:AddAttributeCollection('string',     'defeated', 	          {serialize=1, fixed=4})--4CCs of all enemies the hero has defeated (used?)
	attribs:AddAttribute('int', 			         'in_system',             {default=1,serialize=1,max=1})--1 if it is currently in a star system
	attribs:AddAttribute('int', 			         'show_gates', 	          {default=0,serialize=1,max=1})--1 if it is currently in a star system
	attribs:AddAttributeCollection('GameObject', 'ship_list',             {serialize=1})--List of Item Loadout for each ship
	attribs:AddAttribute('int', 			         'ship_loadout',          {default=1,serialize=1,max=3})-- which loadout defines the current ship
	attribs:AddAttributeCollection('int', 	      'cargo', 		          {serialize=1, max=18000})--list of quantities of each cargo
	--attribs:AddAttributeCollection('int', 	      'cargo_value', 	       {serialize=1})--list of amount paid for each cargo (unused)

	attribs:AddAttributeCollection('int', 	      'faction_standings',     {serialize=1})--stores -100 to 100 for each faction index, indicates faction reputation
	attribs:AddAttributeCollection('int', 	      'encountered_factions',  {serialize=1,max=14})--stores 1 into a faction index if that faction has been encountered

	attribs:AddAttribute('int',                  'psi_powers',            {default=0, serialize=1,max=7})--records the highest unlocked psi power

	attribs:AddAttributeCollection('GameObject', 'Effects',               {})--Status Effects on player

	attribs:AddAttributeCollection('string',     'mined_asteroids',       {serialize=1,fixed=4})


	--attribs:AddAttributeCollection('string',     'save_file',       {default=""})
	--XBOX Achievement trackers
	attribs:AddAttribute('int', 'num_mined', {default=0, serialize=1, max=100})
	attribs:AddAttribute('int', 'mp_won', {default=0, serialize=1, max=32000})

	--Attributes for cargo gained in battle

	attribs:AddAttribute('int',     'cargo_food',                  {default=0} )
	attribs:AddAttribute('int',     'cargo_textiles',              {default=0} )
	attribs:AddAttribute('int',     'cargo_minerals',              {default=0} )
	attribs:AddAttribute('int',     'cargo_alloys',                {default=0} )
	attribs:AddAttribute('int',     'cargo_tech',                  {default=0} )
	attribs:AddAttribute('int',     'cargo_luxuries',              {default=0} )
	attribs:AddAttribute('int',     'cargo_medicine',              {default=0} )
	attribs:AddAttribute('int',     'cargo_gems',                  {default=0} )
	attribs:AddAttribute('int',     'cargo_gold',                  {default=0} )
	attribs:AddAttribute('int',     'cargo_contraband',            {default=0} )


	attribs:AddAttribute('int',     'cargo_food_max',              {default=0} )
	attribs:AddAttribute('int',     'cargo_textiles_max',          {default=0} )
	attribs:AddAttribute('int',     'cargo_minerals_max',          {default=0} )
	attribs:AddAttribute('int',     'cargo_alloys_max',            {default=0} )
	attribs:AddAttribute('int',     'cargo_tech_max',              {default=0} )
	attribs:AddAttribute('int',     'cargo_luxuries_max',          {default=0} )
	attribs:AddAttribute('int',     'cargo_medicine_max',          {default=0} )
	attribs:AddAttribute('int',     'cargo_gems_max',              {default=0} )
	attribs:AddAttribute('int',     'cargo_gold_max',              {default=0} )
	attribs:AddAttribute('int',     'cargo_contraband_max',        {default=0} )


	--Attributes for components gathered in crafting

	attribs:AddAttribute('int',     'components_weap',             {default=0} )
	attribs:AddAttribute('int',     'components_eng',              {default=0} )
	attribs:AddAttribute('int',     'components_cpu',              {default=0} )

	attribs:AddAttribute('int',     'components_weap_max',         {default=0} )
	attribs:AddAttribute('int',     'components_eng_max',          {default=0} )
	attribs:AddAttribute('int',     'components_cpu_max',          {default=0} )

	-- Attributes for rumor unlocking
	attribs:AddAttribute('int',     'stat_points',                 {default=0,serialize=1,max=250})
	attribs:AddAttributeCollection('string', 'unlocked_rumors',    {serialize=1,fixed=4})
	attribs:AddAttribute('int',     'battles_fought',              {default=0,serialize=1,max=1000})

	-- attribs:AddAttributeCollection('GameObject', 'orbiters')
	-- attribs:AddAttributeCollection('GameObject', 'NPCs')

	-- map commodities to cost and quantity
	--attribs:AddAttributeMap('GameObject', 'int', 'prices')
	--attribs:AddAttributeMap('GameObject', 'int', 'quantity')
	-- END ATTRIBUTE DESCRIPTIONS
end

local function Initialize(hero)
 	hero:InitAttributes()
	hero.curr_star = hero:GetAttribute("curr_system")

	-- temporary stat bonuses used in battles
	hero.statBonus = { gunnery = 0, engineer = 0, science = 0, pilot = 0, cargo = 0 }

 --Init Faction Standings At Zero
	--   Index from 1, the first non-NULL faction
	for i=1,_G.NUM_FACTIONS do
		--local standing = math.random(5,100)

		--hero:PushAttribute("faction_standings",standing)
		if i == _G.FACTION_MRI then
			hero:PushAttribute("faction_standings", 40)
		elseif i == _G.FACTION_PIRATES or i == _G.FACTION_SOULLESS then
			hero:PushAttribute("faction_standings", -50)
		else
			hero:PushAttribute("faction_standings", 0)
		end

--		if i ~= _G.FACTION_SOULLESS then--ignore soulless
--			hero:PushAttribute("encountered_factions",i)
--		end
	end

	hero:PushAttribute("encountered_factions", _G.FACTION_MRI)
	hero:PushAttribute("encountered_factions", _G.FACTION_CYTECH)
	hero:PushAttribute("encountered_factions", _G.FACTION_LUMINA)
	hero:PushAttribute("encountered_factions", _G.FACTION_TRIDENT)
	hero:PushAttribute("encountered_factions", _G.FACTION_PIRATES)

	for i=1,_G.NUM_CARGOES do
		hero:PushAttribute("cargo", 0)
		--hero:PushAttribute("cargo_value", 0)
	end

	hero.particle = "H"

	hero.damage_bonus = 0

	hero:ResetEncounters()

	hero.classIDStr = "Hero"
	hero.encounters={}

	hero.sorting_value = 0
end



--[[

local function InitBattleStats(hero)

	LOG("InitBattleStats()")
	local ship = hero:GetAttribute("curr_ship")
	hero:SetAttribute("life_max",ship:GetAttribute("hull") + (hero:GetLevel()-1))--derived from level/stats
	hero:SetAttribute("life",hero:GetAttribute("life_max"))
	hero:SetAttribute("shield_max",ship:GetAttribute("shield") + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),2.0)))
	hero:SetAttribute("shield",ship:GetAttribute("shield") + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),1.0)))
	hero:SetAttribute("weapon_max",15 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("gunnery"),2.0)))
	hero:SetAttribute("weapon",5 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("gunnery"),1.0)))
	hero:SetAttribute("engine_max",15 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("engineer"),2.0)))
	hero:SetAttribute("engine",5 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("engineer"),1.0)))
	hero:SetAttribute("cpu_max",15 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("science"),2.0)))
	hero:SetAttribute("cpu",5 + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("science"),1.0)))
	hero:SetAttribute("seq_pos",1)
	hero:SetAttribute("cargo_food",0)
	hero:SetAttribute("cargo_textiles",0)
	hero:SetAttribute("cargo_minerals",0)
	hero:SetAttribute("cargo_alloys",0)
	hero:SetAttribute("cargo_tech",0)
	hero:SetAttribute("cargo_luxuries",0)
	hero:SetAttribute("cargo_medicine",0)
	hero:SetAttribute("cargo_gems",0)
	hero:SetAttribute("cargo_gold",0)
	hero:SetAttribute("cargo_contraband",0)
	hero.longest_chain = 0
	hero.damage_done = 0
	hero.damage_received = 0
	hero.novas = 0
	hero.supanovas = 0
	hero.matchCount = {0,0,0,0,0,0,0,0, intel = 0, psi = 0}
	hero.matchBonus = {weapon = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("gunnery"),0.2)),
							 engine = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("engineer"),0.2)),
							 cpu =    math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("science"),0.2)),
							 shield = math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),0.2))
							 }


	local numItems = ship:NumAttributes("battle_items")
	for i=1, numItems do
		ship:GetAttributeAt("battle_items",i).inactive = 0
	end

	hero:ClearAttributeCollection("Effects")
	--hero:GetAttribute("curr_ship"):UpdateItems(hero:GetAttributeAt("ship_list", 1))

end

--]]
local function InitShip(hero, shipType)

	local ship = _G.GLOBAL_FUNCTIONS.LoadShip(shipType)--Default Ship
	hero:SetAttribute("curr_ship", ship)
	ship.pilot = hero

	local loadout = GameObjectManager:Construct("IL00")
	loadout:SetAttribute("ship", shipType)
	hero:PushAttribute("ship_list", loadout)
	hero:SetAttribute("ship_loadout", 1)

	for i=1, 8 do
		local item = hero:GetAttribute(string.format("item_%d",i))
		if item  and item ~= "" then
			loadout:PushAttribute("items",item)--add ship default item to loadout config
		end
	end

	return ship
end




local HeroStateInit =
{
	SetupAttributes = SetupAttributes,
	Initialize = Initialize,
	InitBattleStats = InitBattleStats,
	InitShip = InitShip,
}
return HeroStateInit

