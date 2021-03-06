--
-- This file is autogenerated by QuestXml2Lua
--
require "quests/Quest" 


local quest = Quest {

   id                 = "Q040";
   log_text           = "[Q040_DESC]";
   icon               = "main";
   quest_type         = "main";
   repeatable         = false;
   can_abandon        = false;
   end_state          = 6;
   start_convo        = "Conv_Q040a";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S066=true,T221=true};

   preconditions = {
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location_event {
                 location        = {S064=true,T237=true};
                 log_text		= "[Q040_1_0_LOG]";
                 end_convo       = "Conv_Q040b";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location {
                 location        = {S064=true,T237=true};
                 action			= "[Q040_2_0_ACTN]";
                 log_text		= "[Q040_2_0_LOG]";
                 end_convo       = "Conv_Q040c";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE27";
                 location        = {S064=true,T237=true};
                 action			= "[Q040_3_0_ACTN]";
                 log_text		= "[Q040_3_0_LOG]";
                 next_state      = 4;
              },
           };
      [4]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE17";
                 location        = {S064=true,T237=true};
                 action			= "[Q040_4_0_ACTN]";
                 log_text		= "[Q040_4_0_LOG]";
                 end_text        = "[Q040_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
      [5]={
              OBJECTIVES.go_to_location {
                 location        = {S064=true,T237=true};
                 action			= "[Q040_5_0_ACTN]";
                 log_text		= "[Q040_5_0_LOG]";
                 end_convo       = "Conv_Q040d";
                 next_state      = 6;
              },
          };
   };

   start_actions = {
   };

   end_actions = {
      [6]={
                 ACTIONS.unlock_quest {quest="Q0P0", show=false},
                 ACTIONS.unlock_quest {quest="Q041", show=false},
                 ACTIONS.give_experience {amount=100, show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
