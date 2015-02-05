--
-- Dual Core
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q31a";
   log_text           = "[Q31a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "Conv_Q31aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S002=true,T015=true};

   preconditions = {
				[3] = {
				CONDITIONS.min_resource {resource="9", amount=25, text="[Q31a_3_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S075=true,T140=true};
                 action			= "[Q31a_1_0_ACTN]";
                 log_text		= "[Q31a_1_0_LOG]";
                 end_text        = "[Q31a_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S075=true,T140=true};
                 action			= "[Q31a_2_0_ACTN]";
                 log_text		= "[Q31a_2_0_LOG]";
                 end_text        = "[Q31a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_psi {amount=15, show=true},
				 ACTIONS.remove_resource {resource="9", amount=-25, show=false},
                 ACTIONS.unlock_quest {quest="Q31b", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
