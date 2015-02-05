-- I304
-- Psi Entropy Field - Causes ships to take 2hp/sp damage when matching purple gems for 6 turns.  Costs 5 PSI, doesn't end turn.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FC14",world,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 6;


	icon = "img_IFT1";
	weapon_requirement = 1;
	engine_requirement = 1;
	cpu_requirement = 1;
	recharge = 4;
	rarity = 3;
	cost = 1500;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
