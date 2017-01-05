--
-- Harassment: Quesada
--
require "quests/Quest"


local quest = Quest {

   id                 = "Qr01";
   log_text           = "[Qr01_DESC]";
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
   start_locations = {S028=true,T103=true};

   preconditions = {
   };

   objectives = {
		[1]={
				OBJECTIVES.kill_monster { --Quesadan Lightship
                 battleground    = "B001";
                 monster         = "HE22";
                 location        = {S071=true,T161=true}; --Theseus IV
                 action			= "[Qr01_1_0_ACTN]";
                 log_text		= "[Qr01_1_0_LOG]";
                 end_text        = "[Qr01_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S028=true,T103=true};
                 action			= "[Qr01_2_0_ACTN]";
                 log_text		= "[Qr01_2_0_LOG]";
                 end_text        = "[Qr01_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [3]={
                 ACTIONS.give_experience {amount=1, show=true},
				 --ACTIONS.give_gold {amount=4500, show=true},
				 ACTIONS.give_faction_status {faction=4, amount=15, show=false}, -- Gain 15 with Lumina
				 ACTIONS.remove_faction_status {faction=11, amount=20, show=false}, -- Lose 20 + 10 with Quesada
				 ACTIONS.unlock_quest {quest="Qr01", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
