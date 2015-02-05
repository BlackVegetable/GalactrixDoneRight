
use_safeglobals()

local BattleGround = import("BattleGrounds/HexBattleGround")


class "B102" (BattleGround)

function B102:__init()
    super("B102")
end

B102.AttributeDescriptions = AttributeDescriptionList(BattleGround.AttributeDescriptions)


--This is here in case it's destroyed by client disconnecting.
function B102:PreDestroy()
	if _G.SCREENS then
		_G.SCREENS.GameMenu.world = nil	
	end
end

function B102:GetReturnEvent(event)
	local e = GameEventManager:Construct("EndMPBattle")
	LOG("EndBattle Constructed")
	e:SetAttribute("result",event:GetAttribute("result"))
	LOG("Set result "..tostring(event:GetAttribute("result")))
	local enemy = self:GetAttributeAt("Players",2).classIDStr
	LOG("Enemy "..enemy)
	e:SetAttribute("enemy",enemy)
	return e
end


function B102:OpenCombatResults(victory,callback, statHero, factionChange, planList, cargoList, shipPortrait)
	SCREENS.GameMenu:HideWidgets()

	LoadAssetGroup("AssetsButtons")	  
	--Graphics.FadeToBlack()	  
	
	SCREENS.MPLocalResultsMenu:Open(victory,callback, statHero, factionChange, planList, cargoList)		
end


function B102:AdjustFactions()
	--No Faction Standing alterations
end


function B102:AwardPlans(winner)
--No Plans Awarded	
end


function B102:AwardCargo(winner)
--No Cargo Awarded	
end

function B102:HandleEndGame(winner)
	local e
	local loser = self:GetEnemy(self:GetAttributeAt("Players", winner)):GetAttribute("player_id")
	
	self.state = STATE_GAME_OVER
	_G.GLOBAL_FUNCTIONS[string.format("Update%s", self.ui)]()
	_G.GLOBAL_FUNCTIONS.Pause.Close(false, false)
	_G.SCREENS.GameMenu.waiting_to_quit = false
	
	if winner == 1 then
		e = GameEventManager:Construct("VictoryMenu")
	else
		e = GameEventManager:Construct("LossMenu")
	end
	e:SetAttribute("winner_id", winner)
	e:SetAttribute("stat_hero", self:GetAttributeAt("Players", loser))
	GameEventManager:SendDelayed(e, self, GetGameTime() + self:GetAttribute("game_end_delay"))
end

return ExportClass("B102")