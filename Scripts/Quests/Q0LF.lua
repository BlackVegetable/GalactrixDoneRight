--
-- This file is autogenerated by QuestXml2Lua
--
require "quests/Quest" 


local quest = Quest {

   id                 = "Q0LF";
   log_text           = "[Q0LF_DESC]";
   icon               = "character";
   quest_type         = "character";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 4;
   start_convo        = "Conv_Q0LFa";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S059=true,T263=true};

   preconditions = {
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S029=true,T112=true};
                 action			= "[Q0LF_1_0_ACTN]";
                 log_text		= "[Q0LF_1_0_LOG]";
                 end_convo       = "Conv_Q0LFb";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE26";
                 location        = {S029=true,T112=true};
                 action			= "[Q0LF_2_0_ACTN]";
                 log_text		= "[Q0LF_2_0_LOG]";
                 end_text        = "[Q0LF_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.go_to_location {
                 location        = {S059=true,T263=true};
                 action			= "[Q0LF_3_0_ACTN]";
                 log_text		= "[Q0LF_3_0_LOG]";
                 end_convo       = "Conv_Q0LFc";
                 next_state      = 4;
              },
          };
   };

   start_actions = {
   };

   end_actions = {
      [4]={
                 ACTIONS.give_experience {amount=100, show=true},
                 ACTIONS.unlock_quest {quest="Q0LG", show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
