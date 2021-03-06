--
-- This file is autogenerated by QuestXml2Lua
--
require "quests/Quest" 


local quest = Quest {

   id                 = "Q0SH";
   log_text           = "[Q0SH_DESC]";
   icon               = "character";
   quest_type         = "character";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S061=true,T306=true};

   preconditions = {
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S056=true,T297=true};
                 action			= "[Q0SH_1_0_ACTN]";
                 log_text		= "[Q0SH_1_0_LOG]";
                 end_text        = "[Q0SH_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location {
                 location        = {S056=true,T297=true};
                 action			= "[Q0SH_2_0_ACTN]";
                 log_text		= "[Q0SH_2_0_LOG]";
                 end_text        = "[Q0SH_2_0_ENDMSG]";
                 end_convo       = "Conv_Q0SHa";
                 next_state      = 3;
              },
          };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_resource {resource="11", amount=7, show=false},
                 ACTIONS.give_experience {amount=100, show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
