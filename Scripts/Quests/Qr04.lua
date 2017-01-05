--
-- Harassment: MRI
--
require "quests/Quest"


local quest = Quest {

   id                 = "Qr04";
   log_text           = "[Qr04_DESC]";
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
   start_locations = {S078=true,T152=true}; --Cepheus IX

   preconditions = {
   };

   objectives = {
		[1]={
				OBJECTIVES.kill_monster { --MRI Mindship
                 battleground    = "B001";
                 monster         = "HE24";
                 location        = {S000=true,T002=true}; --Erebus II
                 action			= "[Qr04_1_0_ACTN]";
                 log_text		= "[Qr04_1_0_LOG]";
                 end_text        = "[Qr04_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S078=true,T152=true};
                 action			= "[Qr04_2_0_ACTN]";
                 log_text		= "[Qr04_2_0_LOG]";
                 end_text        = "[Qr04_2_0_ENDMSG]";
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
				 ACTIONS.give_faction_status {faction=11, amount=15, show=false}, -- Gain 15 with Quesada
				 ACTIONS.remove_faction_status {faction=2, amount=20, show=false}, -- Lose 20 + 10 with MRI
				 ACTIONS.unlock_quest {quest="Qr04", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
