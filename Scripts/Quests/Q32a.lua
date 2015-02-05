--
-- Hunting Vagabonds
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q32a";
   log_text           = "[Q32a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 6;
   start_convo        = "Conv_Q32aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S002=true,T015=true};

   preconditions = {
   [2] = 		{
				CONDITIONS.min_faction {faction=11, amount=4, text="[Q32a_2_0_PRE]"},
			};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location {
                 location        = {S042=true,T114=true};
                 action			= "[Q32a_1_0_ACTN]";
                 log_text		= "[Q32a_1_0_LOG]";
                 end_text        = "[Q32a_1_0_ENDMSG]";
				 conversation		= "Conv_Q32aB";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location { -- Tau
                 location        = {S042=true,T115=true};
                 action			= "[Q32a_2_0_ACTN]";
                 log_text		= "[Q32a_2_0_LOG]";
				 end_text		= "[Q32a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
		[3]={
				OBJECTIVES.kill_monster {
                 battleground    = "B001";
                 monster         = "HC03";
                 location        = {S042=true,T115=true};
                 action			= "[Q32a_3_0_ACTN]";
                 log_text		= "[Q32a_3_0_LOG]";
                 end_text        = "[Q32a_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
		[4]={
				OBJECTIVES.kill_monster { -- Base
                 battleground    = "B001";
                 monster         = "HC03";
                 location        = {S007=true,T116=true};
                 action			= "[Q32a_4_0_ACTN]";
                 log_text		= "[Q32a_4_0_LOG]";
                 end_text        = "[Q32a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
      [5]={
              OBJECTIVES.go_to_location {
                 location        = {S042=true,T114=true};
                 action			= "[Q32a_5_0_ACTN]";
                 log_text		= "[Q32a_5_0_LOG]";
                 end_text        = "[Q32a_5_0_ENDMSG]";
                 next_state      = 6;
              },
           };

   };

   start_actions = {
   };

   end_actions = {
      [6]={
                 ACTIONS.give_psi {amount=30, show=true},
				 ACTIONS.give_item {item="I302", show =true},
                 ACTIONS.unlock_quest {quest="Q33a", show=false},
				 ACTIONS.unlock_quest {quest="Q35a", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
