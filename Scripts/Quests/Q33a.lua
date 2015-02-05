--
-- Information War
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q33a";
   log_text           = "[Q33a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 12;
   start_convo        = "Conv_Q33aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S042=true,T114=true};

   preconditions = {
   [2] = 		{
				CONDITIONS.min_faction {faction=4, amount=4, text="[Q33a_2_0_PRE]"},
				CONDITIONS.max_faction {faction=11, amount=3, text="[Q33a_2_1_PRE]"},
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S027=true,T101=true};
                 action			= "[Q33a_1_0_ACTN]";
                 log_text		= "[Q33a_1_0_LOG]";
                 end_text        = "[Q33a_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location { --Aquila Port
                 location        = {S027=true,T101=true};
                 action			= "[Q33a_2_0_ACTN]";
                 log_text		= "[Q33a_2_0_LOG]";
                 end_convo       = "Conv_Q33aB";
                 next_state      = 3;
              },
           };

		[3]={
              OBJECTIVES.go_to_location { --Mars
                 location        = {S022=true,T001=true};
                 action			= "[Q33a_3_0_ACTN]";
                 log_text		= "[Q33a_3_0_LOG]";
                 end_text       = "[Q33a_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
		[4]={
              OBJECTIVES.go_to_location { --Earth
                 location        = {S022=true,T000=true};
                 action			= "[Q33a_4_0_ACTN]";
                 log_text		= "[Q33a_4_0_LOG]";
                 end_text       = "[Q33a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
		[5]={
              OBJECTIVES.go_to_location { --Centauri Shipyard
                 location        = {S021=true,T082=true};
                 action			= "[Q33a_5_0_ACTN]";
                 log_text		= "[Q33a_5_0_LOG]";
                 end_text       = "[Q33a_5_0_ENDMSG]";
                 next_state      = 6;
              },
           };
		[6]={
              OBJECTIVES.go_to_location { --Polaris Base
                 location        = {S023=true,T108=true};
                 action			= "[Q33a_6_0_ACTN]";
                 log_text		= "[Q33a_6_0_LOG]";
                 end_text       = "[Q33a_6_0_ENDMSG]";
                 next_state      = 7;
              },
           };
		[7]={
				OBJECTIVES.kill_monster { --Seeker #1
                 battleground    = "B001";
                 monster         = "HC04";
                 location        = {S023=true,T108=true};
                 action			= "[Q33a_7_0_ACTN]";
                 log_text		= "[Q33a_7_0_LOG]";
                 end_text        = "[Q33a_7_0_ENDMSG]";
                 next_state      = 8;
              },
           };
		[8]={
              OBJECTIVES.go_to_location { --New Australis
                 location        = {S024=true,T089=true};
                 action			= "[Q33a_8_0_ACTN]";
                 log_text		= "[Q33a_8_0_LOG]";
                 end_text       = "[Q33a_8_0_ENDMSG]";
                 next_state      = 9;
              },
           };
		[9]={
              OBJECTIVES.go_to_location { -- Ramses III
                 location        = {S028=true,T103=true};
                 action			= "[Q33a_9_0_ACTN]";
                 log_text		= "[Q33a_9_0_LOG]";
                 end_text       = "[Q33a_9_0_ENDMSG]";
                 next_state      = 10;
              },
           };
		[10]={
				OBJECTIVES.kill_monster { --Seeker #2
                 battleground    = "B001";
                 monster         = "HC05";
                 location        = {S028=true,T103=true};
                 action			= "[Q33a_10_0_ACTN]";
                 log_text		= "[Q33a_10_0_LOG]";
                 end_text        = "[Q33a_10_0_ENDMSG]";
                 next_state      = 11;
              },
           };
		[11]={
              OBJECTIVES.go_to_location { -- Earth Return
                 location        = {S022=true,T000=true};
                 action			= "[Q33a_11_0_ACTN]";
                 log_text		= "[Q33a_11_0_LOG]";
                 end_text       = "[Q33a_11_0_ENDMSG]";
                 next_state      = 12;
              },
           };

   };

   start_actions = {
   };

   end_actions = {
      [12]={
                 ACTIONS.give_psi {amount=45, show=true},
				 ACTIONS.give_item {item="I303", show =true},
                 ACTIONS.unlock_quest {quest="Q37a", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
