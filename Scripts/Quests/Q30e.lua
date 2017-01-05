--
-- Attunement
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30e";
   log_text           = "[Q30e_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "Conv_Q30eA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S007=true,T033=true};

   preconditions = {
				[2] = {
				CONDITIONS.min_gold {amount=2000, text="[Q30e_2_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S005=true,T023=true};
                 action			= "[Q30e_1_0_ACTN]";
                 log_text		= "[Q30e_1_0_LOG]";
                 end_text        = "[Q30e_1_0_ENDMSG]";
				 end_convo		= "Conv_Q30eB";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location {
                 location        = {S005=true,T023=true};
                 action			= "[Q30e_2_0_ACTN]";
                 log_text		= "[Q30e_2_0_LOG]";
                 end_text        = "[Q30e_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_experience {amount=10, show=true},
				 ACTIONS.give_gold {amount=-2000, show=false},
                 ACTIONS.unlock_quest {quest="Q30f", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
