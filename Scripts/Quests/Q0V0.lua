--
-- This file is autogenerated by QuestXml2Lua
--
require "quests/Quest" 


local quest = Quest {

   id                 = "Q0V0";
   log_text           = "[Q0V0_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = true;
   can_abandon        = true;
   end_state          = 3;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S038=true,T192=true};

   preconditions = {
   };

   objectives = {
      [1]={
              OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HE35";
                 location        = {S068=true,T240=true};
                 text            = "[Q0V0_1_0_MSG]";
                 action			= "[Q0V0_1_0_ACTN]";
                 log_text		= "[Q0V0_1_0_LOG]";
                 end_text        = "[Q0V0_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location {
                 location        = {S038=true,T192=true};
                 action			= "[Q0V0_2_0_ACTN]";
                 log_text		= "[Q0V0_2_0_LOG]";
                 next_state      = 3;
              },
          };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_experience {amount=25, show=true},
                 ACTIONS.give_gold {amount=1000, show=true},
                 ACTIONS.give_faction_status {faction="5", amount=5, show=false},
                 ACTIONS.give_faction_status {faction="12", amount=-15, show=false},
                 ACTIONS.unlock_quest {quest="Q0V1", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest