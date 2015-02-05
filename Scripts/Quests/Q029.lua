--
-- This file is autogenerated by QuestXml2Lua
--
require "quests/Quest" 


local quest = Quest {

   id                 = "Q029";
   log_text           = "[Q029_DESC]";
   icon               = "main";
   quest_type         = "main";
   repeatable         = false;
   can_abandon        = false;
   end_state          = 6;
   start_convo        = "Conv_Q029a";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S015=true,T075=true};

   preconditions = {
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S015=true,T075=true};
                 action			= "[Q029_1_0_ACTN]";
                 log_text		= "[Q029_1_0_LOG]";
                 end_convo       = "Conv_Q029b";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE39";
                 location        = {S015=true,T075=true};
                 action			= "[Q029_2_0_ACTN]";
                 log_text		= "[Q029_2_0_LOG]";
                 end_text        = "[Q029_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE40";
                 location        = {S015=true,T075=true};
                 action			= "[Q029_3_0_ACTN]";
                 log_text		= "[Q029_3_0_LOG]";
                 end_text        = "[Q029_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
      [4]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE28";
                 location        = {S015=true,T075=true};
                 action			= "[Q029_4_0_ACTN]";
                 log_text		= "[Q029_4_0_LOG]";
                 next_state      = 5;
              },
           };
      [5]={
              OBJECTIVES.go_to_location {
                 location        = {S015=true,T075=true};
                 action			= "[Q029_5_0_ACTN]";
                 log_text		= "[Q029_5_0_LOG]";
                 end_convo       = "Conv_Q029c";
                 next_state      = 6;
              },
          };
   };

   start_actions = {
   };

   end_actions = {
      [6]={
                 ACTIONS.give_friend {friend="C001", show=true},
                 ACTIONS.unlock_quest {quest="Q030", show=false},
                 ACTIONS.give_experience {amount=100, show=true},
                 ACTIONS.remove_friend {friend="C000", show=true},
                 ACTIONS.show_cutscene {cutscene="CS6"},
          };
   };

   abandon_actions = {
   };

}

return quest
