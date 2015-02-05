--
-- There's Time to Pay
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q37a";
   log_text           = "[Q37a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 2;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S022=true,T000=true};

   preconditions = {
				[1] = {
				CONDITIONS.min_resource {resource="8", amount=900, text="[Q37a_3_0_PRE]"},
				CONDITIONS.min_rumor {amount=20},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S022=true,T000=true};
                 action			= "[Q37a_1_0_ACTN]";
                 log_text		= "[Q37a_1_0_LOG]";
                 end_text        = "[Q37a_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [2]={
                 ACTIONS.give_psi {amount=175, show=true},
				-- ACTIONS.remove_resource {resource="8", amount=-25, show=false},
                 ACTIONS.give_item {item="I307", show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
