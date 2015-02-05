--
-- Proving Grounds IV
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30d";
   log_text           = "[Q30d_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 4;
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
                 action			= "[Q30d_1_0_ACTN]";
                 log_text		= "[Q30d_1_0_LOG]";
                 end_text        = "[Q30d_1_0_ENDMSG]";
				 end_convo		= "Conv_Q30dA";
                 next_state      = 2;
              },
           };
      [2]={
				OBJECTIVES.kill_monster {
                 battleground    = "B002";
                 monster         = "J015";
                 location        = {S007=true,J015=true};
                 action			= "[Q30d_2_0_ACTN]";
                 log_text		= "[Q30d_2_0_LOG]";
                 end_text        = "[Q30d_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
		[3]={
				OBJECTIVES.go_to_location {
                 location        = {S007=true,T033=true};
                 action			= "[Q30d_3_0_ACTN]";
                 log_text		= "[Q30d_3_0_LOG]";
                 next_state      = 4;
				},
			};
   };

   start_actions = {
   };

   end_actions = {
      [4]={
                 ACTIONS.give_experience {amount=20, show=true},
                 ACTIONS.unlock_quest {quest="Q30e", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
