require "quests/Quest"


TestQuest = {}

-- quest system expects this function to exist
RunQuestConversation = RunQuestConversation or function() end

function TestQuest:test_quest()

	-- Q000 - "Sample Quest"
	--	quest starts at location L000
	--	when quest starts we play convo Q000_CONVO_START
	QUESTS["Q000"] = Quest {
		id					= "Q000";
		title				= "[Q000_TITLE]";
		icon				= "chalice";
		log_text			= "[Q000_LOG]";
		repeatable			= false;
		
		-- NYI
		show_rewards		= false;
		quest_type			= "main";

		start_convo			= "[Q000_CONVO_START]";
		end_convo			= "";
		incomplete_convo	= "";
		
		start_locations		= {L000=true;};
		end_location		= "L000";
		end_action_text		= "[Q000_END_ACTION]";
		
		end_state			= 2;
		objectives			= {
			[1] = {
				OBJECTIVES.go_to_location {
					location		= {L000=true;};
					log_text		= "[Q000_0_DESC]";
					action			= "[Q000_0_ACTION]";
					conversation	= "";
					next_state		= 2;
				};
			};
		};
		
		-- NYI
		preconditions		= {
		--	level_range {low=3, high=10}
		};
		
		
		end_actions = {
			[2] = {
				-- give_item {item="I000"},
				-- give_experience {amount=200},
				-- give_gold {amount=200},
				-- remove_item {item="I000"},
				ACTIONS.unlock_quest {quest = "Q001"},
				-- start_quest {quest = "Q002"},
				ACTIONS.cancel_quest {quest="Q003"},
				-- teleport_to {location="L001"},
			}
		};
		
		start_actions = {
		};
		abandon_actions ={};
	}



	class "Hero" (GameObject)
	Hero.AttributeDescriptions = AttributeDescriptionList()
	function Hero:__init()
		super("HERO")
		self:InitAttributes()
	end
	local Hero = ExportClass("Hero")
	RegisterClassFactory( "HERO", 
		function(key)
			assert( key == "HERO" )
			return Hero()
		end
	)
	
	
	
	-- make our class part of the quest system
	MakeQuestable(Hero)
	
	local hero = GameObjectManager:Construct("HERO")
	
	-- add our first test quest
	AddAvailableQuest(hero, "Q000")
	assert( GetAvailableQuestsAtLocation( hero, "L000" )[1] == "Q000" )


	-- 
	StartQuest( hero, "Q000" )
	assert( GetRunningQuests(hero)[1] == "Q000" )
	
	-- now check that our action is available
	local actions;
	actions = GetAvailableActions(hero, "L000")
	-- there should be only 1 action at the location
	assert( table.getn(actions) == 1 )
	assert( actions[1] == "[Q000_0_ACTION]" )
	
	PerformQuestAction( hero, actions[1] )
	
	-- we should no longer be on quest
	assert( hero:NumAttributes('running_quests') == 0 )
	
end
