--
-- Proving Grounds
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q30a";
   log_text           = "[Q300a_DESC]";
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
                 action			= "[Q300a_1_0_ACTN]";
                 log_text		= "[Q300a_1_0_LOG]";
                 end_text        = "[Q300a_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location {
                 location        = {S007=true,T037=true};
                 action			= "[Q300a_2_0_ACTN]";
                 log_text		= "[Q300a_2_0_LOG]";
                 end_text        = "[Q300a_2_0_ENDMSG]";
                 end_convo       = "Conv_Q300Aa";
                 next_state      = 3;
              },
           };
      [3]={
               OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HC01";
                 location        = {S000=true,T002=true};
                 action			= "[Q300a_3_0_ACTN]";
                 log_text		= "[Q300a_3_0_LOG]";
                 end_text        = "[Q300a_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
      [4]={
              OBJECTIVES.go_to_location_event {
                 location        = {S007=true,T033=true};
                 text            = "[Q300a_4_0_MSG]";
                 log_text		= "[Q300a_4_0_LOG]";
                 next_state      = 5;
              },
           };

   };

   start_actions = {
   };

   end_actions = {
      [5]={
                 ACTIONS.give_experience {amount=20, show=true},
                 ACTIONS.unlock_quest {quest="Q30b", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
