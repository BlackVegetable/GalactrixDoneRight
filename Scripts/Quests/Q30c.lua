--
-- Proving Grounds III
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30c";
   log_text           = "[Q30c_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 5;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S007=true,T033=true};

   preconditions = {

   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S007=true,T037=true};
                 action			= "[Q30c_1_0_ACTN]";
                 log_text		= "[Q30c_1_0_LOG]";
                 end_text        = "[Q30c_1_0_ENDMSG]";
				 end_convo		= "Conv_Q30cA";
                 next_state      = 2;
              },
           };
      [2]={
				OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HC02";
                 location        = {S004=true,T038=true};
                 action			= "[Q30c_2_0_ACTN]";
                 log_text		= "[Q30c_2_0_LOG]";
                 end_text        = "[Q30c_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
	  [3]={
				OBJECTIVES.kill_monster {
				 battleground	= "B001";
				 monster		= "HC02";
				 location		= {S004=true,T038=true};
				 action			= "[Q30c_3_0_ACTN]";
				 log_text		= "[Q30c_3_0_LOG]";
				 end_text		= "[Q30c_3_0_ENDMSG]";
				 next_state		= 4;
				 },
				};
		[4]={
				OBJECTIVES.go_to_location {
                 location        = {S007=true,T033=true};
                 action			= "[Q30c_4_0_ACTN]";
                 log_text		= "[Q30c_4_0_LOG]";
                 next_state      = 5;
				},
			};
   };

   start_actions = {
   };

   end_actions = {
      [5]={
                 ACTIONS.give_experience {amount=25, show=true},
                 ACTIONS.unlock_quest {quest="Q30d", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
