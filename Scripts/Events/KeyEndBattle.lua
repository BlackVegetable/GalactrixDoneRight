-- KeyEndBattle
-- Send when use exits battle with OnKey Event - also for cheat keys

use_safeglobals()

class "KeyEndBattle" (GameEvent)

KeyEndBattle.AttributeDescriptions = AttributeDescriptionList()
KeyEndBattle.AttributeDescriptions:AddAttribute('int', 'result', {default=-1,serialize= 1})
KeyEndBattle.AttributeDescriptions:AddAttribute('int', 'sender', {default=1,serialize= 1})
KeyEndBattle.AttributeDescriptions:AddAttribute('int', 'host', {default=0,serialize= 1})


function KeyEndBattle:__init()
	super("KeyEndBattle")
	self:SetSendToSelf(true)
end

function KeyEndBattle:do_OnReceive()
	LOG("KeyEndBattle do_OnReceive")
	local world = _G.SCREENS.GameMenu.world
	local result = self:GetAttribute("result")
	
	local is_host = mp_is_host()
	
	if world and world.state ~= _G.STATE_GAME_OVER then
		if result >= 0 then
			world:HandleEndGame(result)	
		else
			world.state = STATE_GAME_OVER
			local function EndGameCallback()
				--LOG(string.format("%d =?= %d",host,_G.Hero:GetAttribute("player_id")))
				LOG("EndGameCallback - sourceMenu = "..tostring(_G.SCREENS.GameMenu.sourceMenu))
				local mp = world.mp		
				if is_host then
					local function transition()
						-- do nothing
					end
					SCREENS.CustomLoadingMenu:Open(nil, transition, nil, _G.SCREENS.GameMenu.sourceMenu, nil,nil,mp)
				
					local event = GameEventManager:Construct("GameEnd")
					event:SetAttribute("result",result)
					local nextTime = GetGameTime() + world:GetAttribute("game_end_delay")
					GameEventManager:SendDelayed( event, world, nextTime )
				else--Client in mp exiting only
					local function transition()
						--_G.CallScreenSequencer("GameMenu", _G.SCREENS.GameMenu.sourceMenu)	
						_G.GLOBAL_FUNCTIONS["EndGame"]()--quitting == no return event passed in		
					end
					SCREENS.CustomLoadingMenu:Open(nil, transition, nil, _G.SCREENS.GameMenu.sourceMenu, nil,nil,mp)
				end			
			
			end
			if _G.Hero and self:GetAttribute("sender") ~= _G.Hero:GetAttribute("player_id") then
				LoadAssetGroup("AssetsButtons")			
				open_message_menu("[RETURN_TO_SETUP]","[OPPONENT_LEFT]",EndGameCallback)
			else
				EndGameCallback()
			end
		end
	end
end

return ExportClass("KeyEndBattle")
