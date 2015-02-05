--
-- This file is autogenerated by QuestXml2Lua
--
require "quests/Quest" 


local quest = Quest {

   id                 = "Q0GB";
   log_text           = "[Q0GB_DESC]";
   icon               = "character";
   quest_type         = "character";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 2;
   start_convo        = "Conv_Q0GBa";
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
              OBJECTIVES.go_to_location {
                 location        = {S063=true,T252=true};
                 action			= "[Q0GB_1_0_ACTN]";
                 log_text		= "[Q0GB_1_0_LOG]";
                 next_state      = 2;
              },
          };
   };

   start_actions = {
   };

   end_actions = {
      [2]={
                 ACTIONS.unlock_quest {quest="Q0GC", show=false},
                 ACTIONS.give_faction_status {faction="10", amount=10, show=false},
                 ACTIONS.give_experience {amount=50, show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
