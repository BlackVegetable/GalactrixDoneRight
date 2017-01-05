--
-- Attunement V
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30i";
   log_text           = "[Q30i_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "Conv_Q30iA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S042=true,T114=true};

   preconditions = {
   				[2] = {
				CONDITIONS.min_gold {amount=450, text="[Q30i_2_0_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S002=true,T015=true};
                 action			= "[Q30i_1_0_ACTN]";
                 log_text		= "[Q30i_1_0_LOG]";
                 end_text        = "[Q30i_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S002=true,T015=true};
                 action			= "[Q30i_2_0_ACTN]";
                 log_text		= "[Q30i_2_0_LOG]";
                 end_text        = "[Q30i_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_experience {amount=40, show=true},
				 ACTIONS.give_gold {amount=-450, show=false},
                 ACTIONS.give_item {item="I300", show=true},
                 ACTIONS.unlock_quest {quest="Q31a", show=false},
                 ACTIONS.unlock_quest {quest="Q32a", show=false},
				 ACTIONS.unlock_quest {quest="Qr01", show=false},
				 ACTIONS.unlock_quest {quest="Qr02", show=false},
				 ACTIONS.unlock_quest {quest="Qr03", show=false},
				 ACTIONS.unlock_quest {quest="Qr04", show=false},
				 ACTIONS.unlock_quest {quest="Qr05", show=false},
				 ACTIONS.unlock_quest {quest="Qr06", show=false},
				 ACTIONS.unlock_quest {quest="Qr07", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
