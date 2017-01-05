--
-- Attunement III
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30g";
   log_text           = "[Q30g_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 4;
   start_convo        = "Conv_Q30gA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S000=true,T003=true};

   preconditions = {
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S009=true,T060=true};
                 action			= "[Q30g_1_0_ACTN]";
                 log_text		= "[Q30g_1_0_LOG]";
                 end_text        = "[Q30g_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S009=true,T057=true};
                 action			= "[Q30g_2_0_ACTN]";
                 log_text		= "[Q30g_2_0_LOG]";
                 end_text        = "[Q30g_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
	  [3]={
				OBJECTIVES.kill_monster {
				 battleground	= "B001";
				 monster		= "HE01";
				 location		= {S009=true,T057=true};
				 action			= "[Q30g_3_0_ACTN]";
				 log_text		= "[Q30g_3_0_LOG]";
				 end_text		= "[Q30g_3_0_ENDMSG]";
				 next_state		= 4;
				 },
				};



   };

   start_actions = {
   };

   end_actions = {
      [4]={
                 ACTIONS.give_experience {amount=25, show=true},
				 ACTIONS.remove_faction_status {faction="2", amount=-10, show=false},
                 ACTIONS.unlock_quest {quest="Q30h", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
