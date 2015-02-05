--
-- Smuggling: Plasmids
--
require "quests/Quest"


local quest = Quest {

   id                 = "Qr07";
   log_text           = "[Qr07_DESC]";
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
   start_locations = {S067=true,T248=true}; --Hydra VIII

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
                 location        = {S067=true,T248=true};
                 action			= "[Qr07_1_0_ACTN]";
                 log_text		= "[Qr07_1_0_LOG]";
                 end_text        = "[Qr07_1_0_ENDMSG]";
                 next_state      = 2;
              },
           };
		[2]={
              OBJECTIVES.go_to_location {
                 location        = {S064=true,T237=true}; -- Plasmia Prime
                 action			= "[Qr07_2_0_ACTN]";
                 log_text		= "[Qr07_2_0_LOG]";
                 end_text        = "[Qr07_2_0_ENDMSG]";
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
				 ACTIONS.remove_faction_status {faction=12, amount=15, show=false}, -- Lose 15 with Plasmids
				 ACTIONS.unlock_quest {quest="Qr07", show=false},
          };
   };

   abandon_actions = {
   };

}

return quest
