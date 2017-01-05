
-- this contains the apps callbacks for application events


use_safeglobals()

require "fnoverlays"


local function setup_cursor()
	SetIsMouseActive(true)
	
	local cursor = Interface.GetCurrentCursor()
	if cursor then
		cursor:SetGraphic("curs_main")
		cursor:SetActive(true)
	end
end

function _G.OnStart()
	LOG("OnStart")
	-- Open backdrop menu
	_G.GLOBAL_FUNCTIONS.Backdrop.Open()
	
	-- Choose one of these logos
	local myLogo = "CutScenes/Logo_us.xml"
	--local myLogo = "CutScenes/Logo.xml"
	
	
	open_cutscene_menu(myLogo,
		function()
			-- dont know which will finish first
			if _G.app_loading_complete == true then
				SCREENS.SplashMenu:Open()
			else
				_G.logo_cutscene_complete = true
			end
		end)

	-- Allow this func to be GCed
	_G.OnStart = nil;
end

function _G.OnLoaded()
    -- Add any game-specific text files here
   -- add_text_file("StarText.xml")
    --add_text_file("StarSystemText.xml")
	--add_text_file("QuestText.xml")
	add_text_file("ItemText.xml")	
	--add_text_file("EffectText.xml")
 	--add_text_file("RumorText.xml")	
	add_text_file("ShipText.xml")
	
	SetIsGamepadActive(false)

	-- Register any conversation offsets in this project	
	register_conversation_offset("CED24_L",100,-10)	
	register_conversation_offset("CED24_LS",100,-10)	
	register_conversation_offset("CLOR_L",130,-15)
	register_conversation_offset("CLOR_LS",150,-15)	
	register_conversation_offset("CMEL_L",100,-10)
	register_conversation_offset("CSLY_LS",60,-10)		
	register_conversation_offset("CSLY_L",60,-5)	
	register_conversation_offset("CPSYL_L",60,-10)		
	register_conversation_offset("CPSYL_LS",60,-10)			
	register_conversation_offset("HERO1_M_L",-40,-10)	
	register_conversation_offset("HERO1_F_L",-60,-10)		
	register_conversation_offset("HERO2_M_L",-30,-10)		
	register_conversation_offset("HERO2_F_L",-60,-10)	
	register_conversation_offset("CSAB_LS",20,-10)		
	register_conversation_offset("CSAB_L",20,-10)			
	register_conversation_offset("CPEZT_L",10,90)			
	register_conversation_offset("CPEZT_LS",50,90)			
	register_conversation_offset("CSILE_L",50,90)			
	register_conversation_offset("CEMPTY1_L",-200,0)			
	--register_conversation_offset("CEMPTY_L",40,330)			
	register_conversation_offset("CEMPTY_L",-200,0)		
	
	
	SaveGameManager:Initialise()
	
	-- dont know which will finish first
	if _G.logo_cutscene_complete == true then
		SCREENS.SplashMenu:Open()
	else
		_G.app_loading_complete = true
	end
	
	setup_cursor()
	
	-- Allow this func to be GCed
	_G.OnLoaded = nil;
end

function _G.OnEnd()
	-- we have to clear our tables that hold game objects
	-- otherwise we will have orphans that will trip the orphan detection
	LOG "destroying lua screens"
	_G.SCREENS = nil
	
	local function CleanupMPResult(result)
		--do nothing for now
	
		--mp_cleanup_network_objects()		
	end
	
	mp_clean_up(CleanupMPResult)
	
	-- for some reason it takes a few GCes before the GameMenus get destroyed...
	-- The game objects need to be destroyed before lua is destroyed
	purge_garbage()
end


-- time is time since program started in Game Time
local lasttime;
function _G.OnTick(time)
	
	-- run continuous functions
	-- this will do stuff like sizing elements over time.
	-- (should this be called every frame instead of on tick events?)
	-- tick_continuous(time) -- moved to stdlib


	-- set gc threshold to 700k
	-- realistically we will need to respond to low mem
	-- more intelligently. eg by unloading unused lua resources
	-- Its probably a good idea to have a funciton that can be called occasionally
	-- that checks if we are near low mem and calls collectgarbage
	-- that way whenever an event occurs where a small pause is acceptable
	-- we can kick the garbage collecter if its needed.
	collectgarbage()--700)


	lasttime = lasttime or time;
	if (time > lasttime+5000) then
 		local mem1 = gcinfo();
		LOG("lua mem usage at " .. mem1 .. "KB. " );
		lasttime = time
	end
	

end


function _G.OnDraw(time)
	_G.tick_stdlib(time)
end


-- Clears the AutoLoad tables, a good time to call this function is whenever you close a screen.
function _G.ClearAutoLoadTables()
	LOG("ClearAutoLoadTables called from " .. debug.traceback())
	
	for k,v in pairs(_G.MASTER_TABLE) do
		clear(v)
	end
	
	--_G.purge_garbage()
end


