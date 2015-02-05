--
-- Smuggling: Lumina
--
require "quests/Quest"


local quest = Quest {

   id                 = "Qr06";
   log_text           = "[Qr06_DESC]";
   icon               = "side";
   quest_type         = "side";
   repeatable         = true;
   can_abandon        = false;
   end_state          = 3;
   start_convo        = "";
   incomplete_convo   = "";
   level_min          = 1;
   level_max          = 999;
   start_message      = "";
   incomplete_message = "";
   start_locations = {S026=true,T097=true}; --Lupus VII

   preconditions = {
		[2] = {
			CONDITIONS.min_resource {resource="9", amount=120, text="You need 120 tons of Gold to trade."},
			};
		[3] = {
			CONDITIONS.min_resource {resource="10", amount=60, text="You need to deliver the 60 Contraband you were given."},
			};
   };

   objectives = {
		[1]={
              OBJECTIVES.go_to_location { --Trade 120 Gold for Contraband here
                 location        = {S026=true,T097=true};
                 action			= "[Qr06_1_0_ACTN]";
                 log_text		= "[Qr06_1_0_LOG]";
                 end_text        = "[Qr06_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S023=true,T108=true}; -- Polaris Base
                 action			= "[Qr06_2_0_ACTN]";
                 log_text		= "[Qr06_2_0_LOG]";
                 end_text        = "[Qr06_2_0_ENDMSG]";
                 next_state      = 3;
              },
           };
   };

   start_actions = {
   };

   end_actions = {
      [2]={
				 ACTIONS.remove_resource {resource=9, amount=-120, show=false},
				 ACTIONS.give_resource {resource=10, amount=60, show=true},
			};

      [3]={
				 ACTIONS.remove_resource {resource=10, amount=-60, show=false},
                 ACTIONS.give_experience {amount=1, show=true},
				 ACTIONS.give_gold {amount=4500, show=true},
				 ACTIONS.give_faction_status {faction=13, amount=15, show=false}, -- Gain 15 with Pirates
				 ACTIONS.remove_faction_status {faction=4, amount=15, show=false}, -- Lose 15 with Lumina
				 ACTIONS.unlock_quest {quest="Qr06", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
