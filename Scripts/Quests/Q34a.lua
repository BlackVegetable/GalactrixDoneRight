--
-- Your Food or Your Life
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q34a";
   log_text           = "[Q34a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 10;
   start_convo        = "Conv_Q34aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S075=true,T140=true};

   preconditions = { -- Got screwed up here
   [3] = 		{
				CONDITIONS.min_faction {faction=8, amount=4, text="[Q34a_2_0_PRE]"},
				CONDITIONS.max_faction {faction=13, amount=1, text="[Q34a_2_1_PRE]"},
				CONDITIONS.min_gold {amount=500, text="Not enough credits"},
			};
   [4] = 		{
				CONDITIONS.min_faction {faction=8, amount=4, text="[Q34a_3_0_PRE]"},
				CONDITIONS.max_faction {faction=13, amount=1, text="[Q34a_3_1_PRE]"},
				CONDITIONS.min_gold {amount=1000, text="Not enough credits"},
				};
   [5] = 		{
				CONDITIONS.min_faction {faction=7, amount=4, text="[Q34a_4_0_PRE]"},
				CONDITIONS.max_faction {faction=13, amount=1, text="[Q34a_4_1_PRE]"},
				CONDITIONS.min_gold {amount=2000, text="Not enough credits"},
				};
   [6] = 		{
				CONDITIONS.min_faction {faction=6, amount=4, text="[Q34a_5_0_PRE]"},
				CONDITIONS.max_faction {faction=13, amount=1, text="[Q34a_5_1_PRE]"},
				CONDITIONS.min_gold {amount=4000, text="Not enough credits"},
				};
   [7] = 		{
				CONDITIONS.min_faction {faction=4, amount=4, text="[Q34a_6_0_PRE]"},
				CONDITIONS.max_faction {faction=13, amount=1, text="[Q34a_6_1_PRE]"},
				CONDITIONS.min_gold {amount=8000, text="Not enough credits"},
				};
   [8] = 		{
				CONDITIONS.min_faction {faction=4, amount=4, text="[Q34a_7_0_PRE]"},
				CONDITIONS.max_faction {faction=13, amount=1, text="[Q34a_7_1_PRE]"},
				CONDITIONS.min_gold {amount=5, text="Not enough credits"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location { -- Degani Prime
                 location        = {S012=true,T061=true};
                 action			= "[Q34a_1_0_ACTN]";
                 log_text		= "[Q34a_1_0_LOG]";
                 end_convo        = "Conv_Q34aB";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location { -- Degani VII
                 location        = {S012=true,T063=true};
                 action			= "[Q34a_2_0_ACTN]";
                 log_text		= "[Q34a_2_0_LOG]";
                 end_text        = "[Q34a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.go_to_location { -- Aquarius IV
                 location        = {S013=true,T067=true};
                 action			= "[Q34a_3_0_ACTN]";
                 log_text		= "[Q34a_3_0_LOG]";
                 end_text        = "[Q34a_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
      [4]={
              OBJECTIVES.go_to_location { -- Tucana V
                 location        = {S017=true,T135=true};
                 action			= "[Q34a_4_0_ACTN]";
                 log_text		= "[Q34a_4_0_LOG]";
                 end_text        = "[Q34a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
      [5]={
              OBJECTIVES.go_to_location { -- Elea VII
                 location        = {S011=true,T048=true};
                 action			= "[Q34a_5_0_ACTN]";
                 log_text		= "[Q34a_5_0_LOG]";
                 end_text        = "[Q34a_5_0_ENDMSG]";
                 next_state      = 6;
              },
           };
      [6]={
              OBJECTIVES.go_to_location { -- Earth
                 location        = {S022=true,T000=true};
                 action			= "[Q34a_6_0_ACTN]";
                 log_text		= "[Q34a_6_0_LOG]";
                 end_text        = "[Q34a_6_0_ENDMSG]";
                 next_state      = 7;
              },
           };
      [7]={
              OBJECTIVES.go_to_location { -- Mars
                 location        = {S022=true,T001=true};
                 action			= "[Q34a_7_0_ACTN]";
                 log_text		= "[Q34a_7_0_LOG]";
                 end_text        = "[Q34a_7_0_ENDMSG]";
                 next_state      = 8;
              },
           };
		[8]={
				OBJECTIVES.kill_monster { --Pirate Minelayer [LEPUS VI]
                 battleground    = "B001";
                 monster         = "HC06";
                 location        = {S016=true,T132=true};
                 action			= "[Q34a_8_0_ACTN]";
                 log_text		= "[Q34a_8_0_LOG]";
                 end_text        = "[Q34a_8_0_ENDMSG]";
                 next_state      = 9;
              },
           };
      [9]={
              OBJECTIVES.go_to_location { -- Degani Prime
                 location        = {S012=true,T061=true};
                 action			= "[Q34a_9_0_ACTN]";
                 log_text		= "[Q34a_9_0_LOG]";
                 end_text        = "[Q34a_9_0_ENDMSG]";
                 next_state      = 10;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
	  [2]={
			ACTIONS.give_gold {amount=-500, show=false},
			};
	  [3]={
			ACTIONS.give_gold {amount=-1000, show=false},
			};
	  [4]={
			ACTIONS.give_gold {amount=-2000, show=false},
			};
	  [5]={
			ACTIONS.give_gold {amount=-4000, show=false},
			};
	  [6]={
			ACTIONS.give_gold {amount=-8000, show=false},
			};
	  [7]={
			ACTIONS.give_gold {amount=-5, show=false},
			};

      [10]={
                 ACTIONS.give_psi {amount=60, show=true},
				 ACTIONS.give_resource {resource="1", amount=300, show=true},
                 ACTIONS.give_item {item="I304", show=true},
                 ACTIONS.unlock_quest {quest="Q36a", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
