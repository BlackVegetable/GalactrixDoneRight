--
-- Attunement II
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30f";
   log_text           = "[Q30f_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "Conv_Q30fA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S005=true,T023=true};

   preconditions = {
				[2] = {
				CONDITIONS.min_resource {resource="8", amount=30, text="[Q30f_2_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S000=true,T003=true};
                 action			= "[Q30f_1_0_ACTN]";
                 log_text		= "[Q30f_1_0_LOG]";
                 end_text        = "[Q30f_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
				OBJECTIVES.go_to_location {
					location	= {S000=true,T003=true};
					action		= "[Q30f_2_0_ACTN]";
					log_text	= "[Q30f_2_0_LOG]";
					end_text	= "[Q30f_2_0_ENDMSG]";
					next_state  = 3;
				},
			};
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_experience {amount=20, show=true},
				 ACTIONS.remove_resource {resource="8", amount=-30, show=false},
                 ACTIONS.unlock_quest {quest="Q30g", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
