--
-- The Two Turrets
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q36a";
   log_text           = "[Q36a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 7;
   start_convo        = "Conv_Q36aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S012=true,T061=true};

   preconditions = {
				[1] = {
					CONDITIONS.min_rumor {amount=8},
					};
				[2] = {
					CONDITIONS.min_faction {faction=3, amount=3, text="[Q36a_2_0_PRE]"},
					CONDITIONS.max_faction {faction=1, amount=3, text="[Q36a_2_1_PRE]"},
					};
				[3] = {
					CONDITIONS.min_gold {amount=12000, text="[Q36a_3_0_PRE]"},
					};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location { -- Fornax Prime
                 location        = {S030=true,T166=true};
                 action			= "[Q36a_1_0_ACTN]";
                 log_text		= "[Q36a_1_0_LOG]";
				 end_convo        = "Conv_Q36aB";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location { -- Fornax Epsilon
                 location        = {S030=true,T169=true};
                 action			= "[Q36a_2_0_ACTN]";
                 log_text		= "[Q36a_2_0_LOG]";
                 end_text        = "[Q36a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.go_to_location { -- Fornax Port
                 location        = {S030=true,T167=true};
                 action			= "[Q36a_3_0_ACTN]";
                 log_text		= "[Q36a_3_0_LOG]";
                 end_convo       = "Conv_Q36aC";
                 next_state      = 4;
              },
           };
		[4]={
				OBJECTIVES.kill_monster { --Right side of Enforcer
                 battleground    = "B001";
                 monster         = "HC17";
                 location        = {S030=true,T167=true};
                 action			= "[Q36a_4_0_ACTN]";
                 log_text		= "[Q36a_4_0_LOG]";
                 end_text        = "[Q36a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
		[5]={
				OBJECTIVES.kill_monster { --Left side of Enforcer
                 battleground    = "B001";
                 monster         = "HC18";
                 location        = {S030=true,T167=true};
                 action			= "[Q36a_5_0_ACTN]";
                 log_text		= "[Q36a_5_0_LOG]";
                 end_text        = "[Q36a_5_0_ENDMSG]";
                 next_state      = 6;
              },
           };
      [6]={
              OBJECTIVES.go_to_location { -- Fornax Prime
                 location        = {S030=true,T166=true};
                 action			= "[Q36a_6_0_ACTN]";
                 log_text		= "[Q36a_6_0_LOG]";
                 end_text        = "[Q36a_6_0_ENDMSG]";
                 next_state      = 7;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
		[2]={
			ACTIONS.give_gold {amount=-12000, show=false},
			};

      [7]={
                 ACTIONS.give_psi {amount=40, show=true},
                 ACTIONS.give_item {item="I306", show=true}, -- PSI Havoc Drone
                 ACTIONS.unlock_quest {quest="Q38a", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
