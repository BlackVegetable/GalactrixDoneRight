--
-- Attunement IV
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30h";
   log_text           = "[Q30h_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "Conv_Q30hA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S009=true,T057=true};

   preconditions = {
   [2] = {
				CONDITIONS.min_faction {faction=11, amount=3, text="[Q30h_2_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S042=true,T114=true};
                 action			= "[Q30h_1_0_ACTN]";
                 log_text		= "[Q30h_1_0_LOG]";
                 end_text        = "[Q30h_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S042=true,T114=true};
                 action			= "[Q30h_2_0_ACTN]";
                 log_text		= "[Q30h_2_0_LOG]";
                 end_text        = "[Q30h_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
				 ACTIONS.give_psi {amount=20, show=true},
                 ACTIONS.give_experience {amount=20, show=true},
                 ACTIONS.unlock_quest {quest="Q30i", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
