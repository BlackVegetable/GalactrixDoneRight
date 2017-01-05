--
-- Dual Core II
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q31b";
   log_text           = "[Q31b_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 2;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S075=true,T140=true};

   preconditions = {
				[2] = {
				CONDITIONS.min_resource {resource="8", amount=25, text="[Q31b_2_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S075=true,T140=true};
                 action			= "[Q31b_1_0_ACTN]";
                 log_text		= "[Q31b_1_0_LOG]";
                 end_text        = "[Q31b_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [2]={
                 ACTIONS.give_psi {amount=10, show=true},
				 ACTIONS.remove_resource {resource="8", amount=-25, show=false},
                 ACTIONS.give_item {item="I301", show=true},
                 ACTIONS.unlock_quest {quest="Q34a", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
