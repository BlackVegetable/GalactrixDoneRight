--
-- Seriously? Plasmids?
--
require "quests/Quest"


local quest = Quest {

   id                 = "Q39a";
   log_text           = "[Q39a_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = false;
   can_abandon        = true;
   end_state          = 8;
   start_convo        = "Conv_Q39aA";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S038=true,T192=true};

   preconditions = {
				[1] = {
				CONDITIONS.min_rumor {amount=16},
				};
		[2] = 		{
				CONDITIONS.min_faction {faction=1, amount=4, text="[Q39a_2_0_PRE]"}, --Trident Friendly
				CONDITIONS.max_faction {faction=12, amount=3, text="[Q39a_2_1_PRE]"}, --Plasmids Neutral
			};
				[3] = {
				CONDITIONS.min_gold {amount=3000, text="Not enough credits"},
				};
				[4] = {
				CONDITIONS.min_gold {amount=1500, text="Not enough credits"},
				};
				[5] = {
				CONDITIONS.min_gold {amount=8000, text="Not enough credits"},
				CONDITIONS.min_faction {faction=7, amount=3, text="[Q39a_5_0_PRE]"}, --Keck Neutral
				};
				[6] = {
				CONDITIONS.min_gold {amount=20000, text="Not enough credits"},
				CONDITIONS.min_faction {faction=12, amount=3, text="[Q39a_6_0_PRE]"}, --Plasmids Neutral
				};
   };

   objectives = {
      [1]={
              OBJECTIVES.go_to_location { -- Aries Prime
                 location        = {S041=true,T200=true};
                 action			= "[Q39a_1_0_ACTN]";
                 log_text		= "[Q39a_1_0_LOG]";
                 end_convo        = "Conv_Q39aB";
                 next_state      = 2;
              },
           };
      [2]={
              OBJECTIVES.go_to_location { -- Aries Sigma
                 location        = {S041=true,T201=true};
                 action			= "[Q39a_2_0_ACTN]";
                 log_text		= "[Q39a_2_0_LOG]";
				 end_text       = "[Q39a_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
      [3]={
              OBJECTIVES.go_to_location { -- Taurus I
                 location        = {S039=true,T212=true};
                 action			= "[Q39a_3_0_ACTN]";
                 log_text		= "[Q39a_3_0_LOG]";
				 end_text       = "[Q39a_3_0_ENDMSG]";
                 next_state      = 4;
              },
           };
      [4]={
              OBJECTIVES.go_to_location { -- Eporium of Keck
                 location        = {S073=true,T122=true};
                 action			= "[Q39a_4_0_ACTN]";
                 log_text		= "[Q39a_4_0_LOG]";
				 end_text       = "[Q39a_4_0_ENDMSG]";
                 next_state      = 5;
              },
           };
      [5]={
              OBJECTIVES.go_to_location { -- Hydra VIII
                 location        = {S067=true,T248=true};
                 action			= "[Q39a_5_0_ACTN]";
                 log_text		= "[Q39a_5_0_LOG]";
				 end_text       = "[Q39a_5_0_ENDMSG]";
                 next_state      = 6;
              },
           };
		[6]={
				OBJECTIVES.kill_monster { --Plasmid Joyriders
                 battleground    = "B001";
                 monster         = "HC19";
                 location        = {S069=true,T245=true}; -- Pegasus Kappa
                 action			= "[Q39a_6_0_ACTN]";
                 log_text		= "[Q39a_6_0_LOG]";
                 end_text        = "[Q39a_6_0_ENDMSG]";
                 next_state      = 7;
              },
           };
      [7]={
              OBJECTIVES.go_to_location { -- Aries Prime
                 location        = {S041=true,T200=true};
                 action			= "[Q39a_7_0_ACTN]";
                 log_text		= "[Q39a_7_0_LOG]";
                 end_text		= "[Q39a_7_0_ENDMSG]";
                 next_state      = 8;
              },
           };

   };

   start_actions = {
   };

   end_actions = {
  	  [2]={
			ACTIONS.give_gold {amount=-3000, show=false}, -- Vague Coordinates
			};
  	  [3]={
			ACTIONS.give_gold {amount=-1500, show=false}, -- Virtual Marbles
			};
  	  [4]={
			ACTIONS.give_gold {amount=-8000, show=false}, -- Jamming Device
			};
  	  [5]={
			ACTIONS.give_gold {amount=-20000, show=false}, -- Improbability Drive
			};


      [8]={
                 ACTIONS.give_psi {amount=125, show=true},
                 ACTIONS.give_item {item="I309", show=true},
          };
   };

   abandon_actions = {
   };

}

return quest
