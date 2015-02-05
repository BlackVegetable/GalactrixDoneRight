--
-- Harassment: Pirates
--
require "quests/Quest"


local quest = Quest {

   id                 = "Qr02";
   log_text           = "[Qr02_DESC]";
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
   start_locations = {S012=true,T063=true}; --Degani VII

   preconditions = {
   };

   objectives = {
		[1]={
				OBJECTIVES.kill_monster { --Pirate Battlecruiser
                 battleground    = "B001";
                 monster         = "HE21";
                 location        = {S015=true,T074=true}; --Icarus IX
                 action			= "[Qr02_1_0_ACTN]";
                 log_text		= "[Qr02_1_0_LOG]";
                 end_text        = "[Qr02_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S012=true,T063=true};
                 action			= "[Qr02_2_0_ACTN]";
                 log_text		= "[Qr02_2_0_LOG]";
                 end_text        = "[Qr02_2_0_ENDMSG]";
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
				 ACTIONS.give_faction_status {faction=8, amount=15, show=false}, -- Gain 15 with Degani
				 ACTIONS.remove_faction_status {faction=13, amount=20, show=false}, -- Lose 20 + 10 with Pirates
				 ACTIONS.unlock_quest {quest="Qr02", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
