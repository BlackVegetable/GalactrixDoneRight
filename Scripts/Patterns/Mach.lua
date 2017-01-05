-- BattleGround
--  this class defines the basic behaviour of the BattleGround objects
--
local Pattern = import("Patterns/Pattern")

class "Mach" (Pattern)

Mach.AttributeDescriptions = AttributeDescriptionList(Pattern.AttributeDescriptions)
Mach.AttributeDescriptions:AddAttribute('int', 'time_bonus', {default=0})
Mach.AttributeDescriptions:AddAttribute('string', 'name', {default=""})
Mach.AttributeDescriptions:AddAttribute('string', 'message', {default=""})
Mach.AttributeDescriptions:AddAttribute('GameObject', 'gem', {})
Mach.AttributeDescriptions:AddAttribute('int', 'len', {default=3})

function Mach:__init()
	super("Mach")
    self.pattern=nil
end





function Mach:OnEventAward(event)
	--self:SetParticle(battleGround,self.pattern,grid)
	--will get gemtype from i
	--will award bonus to player battleGround,grid,dir,player
	local player = event:GetAttribute("player")
	--local battleGround = event:GetAttribute("BattleGround")
	local battleGround = SCREENS.GameMenu.world
	local grid = event:GetAttribute("index")
	local dir = event:GetAttribute("direction")
	local displayMessages = event:GetAttribute("displayMessages")
	local playSound = 1
	if event:HasAttribute("play_sound") then
		playSound = event:GetAttribute("play_sound")
	end

	local myGrid = grid
	LOG("Match myGrid="..tostring(myGrid))
	local len = self:GetAttribute('len')
	local msg = self:GetAttribute('name')
	local extra_turn = self:GetAttribute('extra_turn')

	player:UpdateMatchStats(len)





	local total = 0

	local gem = battleGround:GetGem(myGrid)
	local gemFont = gem:GetAttribute("font")
	local effect = gem:GetAttribute("effect")
	local sound = gem:GetAttribute("sound")
	local startX = gem:GetX()
	local startY = gem:GetY()

	local playerId = player:GetAttribute('player_id')

	local event
	local enemy = battleGround:GetEnemy(player)

	local dest_id
	if effect == "damage" then
		dest_id = enemy:GetAttribute("player_id")
	else
		dest_id = player:GetAttribute("player_id")
	end
	if effect ~= ""  then
		if battleGround.coords[dest_id][effect] then

			local endX = battleGround.coords[dest_id][effect][1]
			local endY = battleGround.coords[dest_id][effect][2]

			for i=1,len do
				gem = battleGround:GetGem(myGrid)
				total = total + gem:GetAttribute("amount")




				--battleGround:WorldToScreen(gem:GetX(),gem:GetY()),battleGround:WorldToScreen(endX,endY)
				local startx,starty = battleGround:WorldToScreen(gem:GetX(),gem:GetY())
				local endx,endy = battleGround:WorldToScreen(endX,endY)

				if _G.BEAMS_ON and gem:GetAttribute("beam")~="" then
					local beam = BEAMS[gem:GetAttribute("beam")]
					--local points,colors,widths = beam:GetPoints(startx,starty,endx,endy)

					--LOG("CreateBeam startx: " .. startx .. " starty: " .. starty .. " endx: " .. endx .. " endy: " .. endy)

					beam:CreateBeam(battleGround,startx,starty,endx,endy)
				end

				myGrid = battleGround.hexAdjacent[myGrid][dir]    --find next grid in match
			end
		else
			LOG("NON BEAM MATCH "..tostring(effect).." "..tostring(battleGround.coords[dest_id][effect]))
		end
	end
	--gets center of match for displaying +3,+4 message
	local endX = gem:GetX()
	local endY = gem:GetY()

	local msgSpawnX = (endX - startX)
	local msgSpawnY = (endY - startY)/2
	if msgSpawnX ~= 0 then
		msgSpawnX = (msgSpawnX/2)
	end

	--4ofakind/5ofakind messages displayed here.--from center of match
	if msg ~= "" and displayMessages ==1 then
		_G.BigMessage(battleGround,msg,startX + msgSpawnX,startY)
	end

	--If Extra Turn
	if extra_turn ~= 0 then
		LOG(string.format("startY=%d, textY=%d",startY,battleGround.text_extra_y))
		local offset = startY-battleGround.text_extra_y
		local neg = -1
		if offset < 0 then
			neg = 1
		end
		if math.abs(offset) < 60 then
			offset = 70 * neg
		else
			offset = 0
		end
		LOG(string.format("offset=%d",offset))
		battleGround:AwardExtraTurn(offset)--(extra_turn)
	end



	if len > 1 then
		--Apply LEVEL BONUS to MATCH TOTAL
		LOG("Total "..tostring(total))
		if player.matchBonus[effect] ~= nil then
			total = total + player.matchBonus[effect]
			LOG("Total modified by stat: +" .. tostring(player.matchBonus[effect]))
		end
		--Add Match Length Bonus - then multiply by Board/Nova/SupaNova Multiplier
		total = (total  + self:GetAttribute("bonus")) * battleGround.multiplier

		local numEffects = battleGround:NumAttributes("Effects")
		if numEffects > 0 then
			for i=1,numEffects do
				if battleGround:GetAttributeAt("Effects",i).ModifyMatches then
					total = battleGround:GetAttributeAt("Effects",i):ModifyMatches(effect, total)
				end
			end
		end

		if player:NumAttributes("Effects") > 0 then
			for i=1, player:NumAttributes("Effects") do
				if player:GetAttributeAt("Effects", i).ModifyMatches then
					total = player:GetAttributeAt("Effects",i):ModifyMatches(effect, total)
				end
			end
		end
	end

	--Engineer Mining Bonus--
	if effect == "cargo_food" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_textiles" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_minerals" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_alloys" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_tech" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_luxuries" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_medicine" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_gems" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_gold" then
		total = total + player:GetAttribute("mining")
	elseif effect == "cargo_contraband" then
		total = total + player:GetAttribute("mining")
	end

--	local loadout = player:GetAttributeAt("ship_list",player:GetAttribute("ship_loadout"))
	local curr_ship = player:GetAttribute("curr_ship")
	local psi_bonus = 0

	if curr_ship:NumAttributes("battle_items") > 0 then
		for i=1,curr_ship:NumAttributes("battle_items") do
			if curr_ship:GetAttributeAt("battle_items", i):GetAttribute("name") == "[I333_NAME]" then
				psi_bonus = psi_bonus + 1
			end
		end
	end

	if effect == "psi" then
		total = total + psi_bonus
	end


	local msg = tostring(total)



	if playSound == 1 then
		PlaySound(sound)
	end

	-- Includes the damage bonus from Gunnery as well as level / 10

	local gun = player:GetCombatStat("gunnery")
	local gunBonus

	--Send Damage/Energy msg to enemy/hero
	if effect == "damage" then
		if len > 1 then
			if _G.GLOBAL_FUNCTIONS.RandomRounding(gun, 49) == "down" then
				gunBonus = math.floor(gun / 49)
			else
				gunBonus = math.ceil(gun / 49)
			end

			total = total + player.damage_bonus + gunBonus
			msg = tostring(total)
		end

		event = GameEventManager:Construct("ShipDamage")
		event:SetAttribute('amount',total)
		event:SetAttribute("BattleGround",battleGround)
		event:SetAttribute("source", player)
		--local nextTime = GetGameTime() --+ self:GetAttribute("award_delay")
		--LOG("Sending GameEvent")
		GameEventManager:Send( event, enemy)
		--LOG("Sent GameEvent")

		--BEGIN_STRIP_DS
		--Gamepad.Rumble(0, 0.6, 750)
		_G.SCREENS.GameMenu:RumblePlayer(enemy:GetAttribute("player_id"), 0.6, 750)
		--END_STRIP_DS

	elseif not player:HasAttribute(effect) then
		LOG("Unknown effect")
		return--No effect
	else
		event = GameEventManager:Construct("ReceiveEnergy")
		event:SetAttribute('effect',effect)
		event:SetAttribute('amount',total)
		--local nextTime = GetGameTime() --+ self:GetAttribute("award_delay")
		--MutateWithCollection(event, player, 'Effects')
		GameEventManager:Send( event, player)

		--BEGIN_STRIP_DS
		local playerId = player:GetAttribute('player_id')

		if battleGround:GetAttributeAt("Players",playerId):GetAttribute("ai") == 0 then -- HUMAN PLAYER
			--Gamepad.Rumble(0, 0.5, 450)
			_G.SCREENS.GameMenu:RumblePlayer(player:GetAttribute("player_id"), 0.5, 450)
		end
		--END_STRIP_DS

	end

	if displayMessages==1 then
		if len > 1 and total ~= 0 and gemFont ~= "" then
			--Display Energy/damage amount msg over Match
			_G.ShowMessage(battleGround,msg,gemFont,startX + msgSpawnX,startY + msgSpawnY,true)
		end
	end

	LOG("finished OnAwardEvent")
end




-------------------------------------------------------------------------------
--HackAward - recieved during hacking game
-------------------------------------------------------------------------------
function Mach:OnEventHackAward(event)

	--Do extra stuff here
	LOG("Mach received HackAward")
	local battleGround = SCREENS.GameMenu.world
	if battleGround:GetGem(event:GetAttribute("index")).id == 30 then--Time Gem
		battleGround:AwardExtraTime(self:GetAttribute("time_bonus"))
	end
	--if not battleGround.gateHacked then
		self:OnEventAward(event)
	--end
end

-------------------------------------------------------------------------------
-- MineAward - recieved during Mining game
-------------------------------------------------------------------------------
function Mach:OnEventMineAward(event)

	--Do extra stuff here
	--local battleGround = event:GetAttribute("BattleGround")
	--battleGround:AwardExtraTime(self:GetAttribute("time_bonus"))
	self:OnEventAward(event)

end
-------------------------------------------------------------------------------
--PsiAward - recieved during hacking game
-------------------------------------------------------------------------------
function Mach:OnEventPsiAward(event)

	--Do extra stuff here
	local battleGround = SCREENS.GameMenu.world
	--battleGround:AwardExtraTime(self:GetAttribute("time_bonus"))
	if not battleGround.gateHacked then
		self:OnEventAward(event)
	end
end

function Mach:OnEventRumorAward(event)
	local battleGround = SCREENS.GameMenu.world
	local grid = event:GetAttribute("index")
	local gem = battleGround:GetGem(grid)
	if gem.classIDStr == "GVRS" then
		battleGround:ForceGameLoss()
	end
	self:OnEventAward(event)
end

function Mach:OnEventBargainAward(event)
	self:OnEventAward(event)
end

function Mach:OnEventCraftAward(event)
	LOG("OnEventCraftAward")
	-- Custom behaviour is needed for matching of different component types
	local player = event:GetAttribute("player")
	local world = SCREENS.GameMenu.world
	local grid = event:GetAttribute("index")
	local dir = event:GetAttribute("direction")

	local len = self:GetAttribute('len')

	-- update player's match stats
	player:UpdateMatchStats(len)

	-- get information for particle creation
	local gem = world:GetGem(grid)
	if not gem then
		return
	end
	local sound = gem:GetAttribute("sound")
	local effect = gem:GetAttribute("effect")

	PlaySound(sound)

	if gem.classIDStr == "GUST" then
		if len >= 5 then--clear all biohazards
			local gemList = world:GetGemList("GUST")
		  	PlaySound("snd_gemimplosion")
			for i,v in pairs(gemList) do
				world:DestroyGem(v,true)
				_G.Hero.biohazardMatches = _G.Hero.biohazardMatches + 1
			end
		else--ordinary biohazard handling
			for i=1, len do
				_G.Hero.biohazardMatches = _G.Hero.biohazardMatches + 1
			end
		end
		return
	end

	local soundTable = { components_weap = false, components_eng = false, components_cpu = false }

	if _G.Hero:HasAttribute(effect) and _G.Hero:GetAttribute(effect.."_max") ~= 0 then
			if (not soundTable[effect]) and ((_G.Hero:GetAttribute(effect) + 1) >= (_G.Hero:GetAttribute(effect.."_max"))) and (_G.Hero:GetAttribute(effect) < _G.Hero:GetAttribute(effect.."_max")) then
				soundTable[effect] = true
				PlaySound(string.format("snd_%s_complete", effect))
			end
			_G.Hero:SetAttribute(effect, _G.Hero:GetAttribute(effect) + 1)
	end
	for i=2, len do
		grid = world.hexAdjacent[grid][dir]
		gem = world:GetGem(grid)
		effect = gem:GetAttribute("effect")
		if _G.Hero:HasAttribute(effect) and _G.Hero:GetAttribute(effect.."_max") ~= 0 then
			if (soundTable[effect] ~= true) and ((_G.Hero:GetAttribute(effect) + 1) >= (_G.Hero:GetAttribute(effect.."_max"))) and (_G.Hero:GetAttribute(effect) < _G.Hero:GetAttribute(effect.."_max")) then
				soundTable[effect] = true
				PlaySound(string.format("snd_%s_complete", effect))
			end
			_G.Hero:SetAttribute(effect, _G.Hero:GetAttribute(effect) + 1)
		end
		if i > 1 and i < len then
			LOG("GemID = " .. gem.classIDStr .. "    COM = " .. tostring(gem.CenterOfMatch))
		   if (gem.CenterOfMatch ~= true) then
				LOG("Proceeding with match")
				gem.CenterOfMatch = true
				--world:SpawnGem(grid, "GWEC")

				if gem.classIDStr == "GWCB" then
					world:SwitchGems(grid, "GWEC", false)
				elseif gem.classIDStr == "GECB" then
					world:SwitchGems(grid, "GENC", false)
				elseif gem.classIDStr == "GCCB" then
					world:SwitchGems(grid, "GCPC", false)
				end



			end

		end


	end

	if len >= 5 then
		local gemList = world:GetGemList("GUST")
		for i,v in pairs(gemList) do
			world:DestroyGem(v,true)
			_G.Hero.biohazardMatches = _G.Hero.biohazardMatches + 1
		end
	end

	-- limit maximums
	_G.Hero:SetAttribute("components_weap", math.min(_G.Hero:GetAttribute("components_weap"), _G.Hero:GetAttribute("components_weap_max")))
	_G.Hero:SetAttribute("components_eng",  math.min(_G.Hero:GetAttribute("components_eng"), _G.Hero:GetAttribute("components_eng_max")))
	_G.Hero:SetAttribute("components_cpu",  math.min(_G.Hero:GetAttribute("components_cpu"), _G.Hero:GetAttribute("components_cpu_max")))
end

return ExportClass("Mach")
