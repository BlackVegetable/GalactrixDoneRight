--
-- Proving Grounds II
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30b";
   log_text           = "[Q30b_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S007=true,T033=true};

   preconditions = {
				[3] = {
				CONDITIONS.min_resource {resource="4", amount=20, text="[Q30b_3_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S007=true,T037=true};
                 action			= "[Q30b_1_0_ACTN]";
                 log_text		= "[Q30b_1_0_LOG]";
                 end_text        = "[Q30b_1_0_ENDMSG]";
				 end_convo		= "Conv_Q30bA";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location {
                 location        = {S007=true,T033=true};
                 action			= "[Q30b_2_0_ACTN]";
                 log_text		= "[Q30b_2_0_LOG]";
                 end_text        = "[Q30b_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_experience {amount=20, show=true},
				 ACTIONS.give_gold {amount=300, show=true},
				 ACTIONS.remove_resource {resource="4", amount=-20, show=false},
                 ACTIONS.unlock_quest {quest="Q30c", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
