--
-- Libertarian
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q38a";
   log_text           = "[Q38a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 11;
   start_convo        = "Conv_Q38aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S030=true,T166=true};

   preconditions = {
				[1] = {
				CONDITIONS.min_rumor {amount=12},
				};
				[2] = {
					CONDITIONS.min_faction {faction=13, amount=5, text="[Q38a_2_0_PRE]"},
					CONDITIONS.max_faction {faction=2, amount=1, text="[Q38a_2_1_PRE]"},
					};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location { --Quaris II
                 location        = {S001=true,T010=true};
                 action			= "[Q38a_1_0_ACTN]";
                 log_text		= "[Q38a_1_0_LOG]";
  				 end_convo        = "Conv_Q38aB";
                 next_state      = 2;
              },
           };
     [2]={
              OBJECTIVES.go_to_location { --Quaris IV
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_2_0_ACTN]";
                 log_text		= "[Q38a_2_0_LOG]";
                 end_text        = "[Q38a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
		[3]={
				OBJECTIVES.kill_monster { --MRI Blade
                 battleground    = "B001";
                 monster         = "HE01";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_3_0_ACTN]";
                 log_text		= "[Q38a_3_0_LOG]";
                 end_text        = "[Q38a_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
		[4]={
				OBJECTIVES.kill_monster { --MRI Psionic Array
                 battleground    = "B001";
                 monster         = "HE10";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_4_0_ACTN]";
                 log_text		= "[Q38a_4_0_LOG]";
                 end_text        = "[Q38a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
		[5]={
				OBJECTIVES.kill_monster { --MRI Mindship
                 battleground    = "B001";
                 monster         = "HE24";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_5_0_ACTN]";
                 log_text		= "[Q38a_5_0_LOG]";
                 end_text        = "[Q38a_5_0_ENDMSG]";
                 next_state      = 6;
              },
           };
		[6]={
				OBJECTIVES.kill_monster { --MRI Psionic Array (Again)
                 battleground    = "B001";
                 monster         = "HE10";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_6_0_ACTN]";
                 log_text		= "[Q38a_6_0_LOG]";
                 end_text        = "[Q38a_6_0_ENDMSG]";
                 next_state      = 7;
              },
           };
		[7]={
				OBJECTIVES.kill_monster { --MRI "Beta" Blade
                 battleground    = "B001";
                 monster         = "HC09";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_7_0_ACTN]";
                 log_text		= "[Q38a_7_0_LOG]";
                 end_text        = "[Q38a_7_0_ENDMSG]";
                 next_state      = 8;
              },
           };
		[8]={
				OBJECTIVES.kill_monster { --MRI Veteran Psionic Array
                 battleground    = "B001";
                 monster         = "HC10";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_8_0_ACTN]";
                 log_text		= "[Q38a_8_0_LOG]";
                 end_text        = "[Q38a_8_0_ENDMSG]";
                 next_state      = 9;
              },
           };
		[9]={
				OBJECTIVES.kill_monster { --MRI Captain
                 battleground    = "B001";
                 monster         = "HC11";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_9_0_ACTN]";
                 log_text		= "[Q38a_9_0_LOG]";
                 end_text        = "[Q38a_9_0_ENDMSG]";
                 next_state      = 10;
              },
           };
		[10]={
				OBJECTIVES.kill_monster { --MRI Command Center
                 battleground    = "B001";
                 monster         = "HC12";
                 location        = {S001=true,T008=true};
                 action			= "[Q38a_10_0_ACTN]";
                 log_text		= "[Q38a_10_0_LOG]";
                 end_text        = "[Q38a_10_0_ENDMSG]";
                 next_state      = 11;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [11]={
                 ACTIONS.give_psi {amount=100, show=true},
                 ACTIONS.give_item {item="I308", show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
