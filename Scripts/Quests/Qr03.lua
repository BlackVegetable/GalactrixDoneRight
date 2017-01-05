--
-- Harassment: Trident
--
require "quests/Quest"


local quest = Quest {

   id                 = "Qr03";
   log_text           = "[Qr03_DESC]";
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
   start_locations = {S034=true,T178=true}; --Auriga X

   preconditions = {
   };

   objectives = {
		[1]={
				OBJECTIVES.kill_monster { --Trident Battleship
                 battleground    = "B001";
                 monster         = "HE29";
                 location        = {S065=true,T203=true}; --Libra VII
                 action			= "[Qr03_1_0_ACTN]";
                 log_text		= "[Qr03_1_0_LOG]";
                 end_text        = "[Qr03_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S034=true,T178=true};
                 action			= "[Qr03_2_0_ACTN]";
                 log_text		= "[Qr03_2_0_LOG]";
                 end_text        = "[Qr03_2_0_ENDMSG]";
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
				 ACTIONS.give_faction_status {faction=3, amount=15, show=false}, -- Gain 15 with Cytech
				 ACTIONS.remove_faction_status {faction=1, amount=20, show=false}, -- Lose 20 + 10 with Trident
				 ACTIONS.unlock_quest {quest="Qr03", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
