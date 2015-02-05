--
-- Vortraag Enough
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q35a";
   log_text           = "[Q35a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 9;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S042=true,T114=true};

   preconditions = {
		[1] = {
				CONDITIONS.min_rumor {amount=4},
			};
		[2] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
		[3] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
		[4] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
		[5] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
		[6] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
		[7] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
		[8] = 		{
				CONDITIONS.min_faction {faction=5, amount=3, text="[Q35a_2_0_PRE]"},
			};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location { -- Vortraag Prime
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_1_0_ACTN]";
                 log_text		= "[Q35a_1_0_LOG]";
                 end_convo       = "Conv_Q35aA";
                 next_state      = 2;
              },
           };
		[2]={
				OBJECTIVES.kill_monster { -- Balanced Erin
                 battleground    = "B001";
                 monster         = "HC13";
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_2_0_ACTN]";
                 log_text		= "[Q35a_2_0_LOG]";
                 end_text        = "[Q35a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.go_to_location { -- Vortraag Prime
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_3_0_ACTN]";
                 log_text		= "[Q35a_3_0_LOG]";
                 end_convo       = "Conv_Q35aB";
                 next_state      = 4;
              },
           };
		[4]={
				OBJECTIVES.kill_monster { -- Dr. Horrible
                 battleground    = "B001";
                 monster         = "HC14";
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_4_0_ACTN]";
                 log_text		= "[Q35a_4_0_LOG]";
                 end_text        = "[Q35a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
      [5]={
              OBJECTIVES.go_to_location {
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_5_0_ACTN]";
                 log_text		= "[Q35a_5_0_LOG]";
                 end_convo       = "Conv_Q35aC";
                 next_state      = 6;
              },
           };
		[6]={
				OBJECTIVES.kill_monster { -- Shotgun Jimmy
                 battleground    = "B001";
                 monster         = "HC15";
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_6_0_ACTN]";
                 log_text		= "[Q35a_6_0_LOG]";
                 end_text        = "[Q35a_6_0_ENDMSG]";
                 next_state      = 7;
              },
           };
      [7]={
              OBJECTIVES.go_to_location {
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_7_0_ACTN]";
                 log_text		= "[Q35a_7_0_LOG]";
                 end_convo       = "Conv_Q35aD";
                 next_state      = 8;
              },
           };
		[8]={
				OBJECTIVES.kill_monster { -- Stat-Kill
                 battleground    = "B001";
                 monster         = "HC16";
                 location        = {S038=true,T192=true};
                 action			= "[Q35a_8_0_ACTN]";
                 log_text		= "[Q35a_8_0_LOG]";
                 end_text        = "[Q35a_8_0_ENDMSG]";
                 next_state      = 9;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [9]={
                 ACTIONS.give_psi {amount=50, show=true},
				 ACTIONS.give_item {item="I305", show =true},
				 ACTIONS.unlock_quest {quest="Q39a", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
