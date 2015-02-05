-- I301 --
-- Psionic Dual-Core -- Grants a "Dual-Core" Effect which regenerates 10% (or 3 whichever is greater) shields and 2 Green Energy per turn.

local function activate(item, world, player, obj,weapon,engine,cpu)

	item:AddEffect(world,player,"FC01",player,5,item.classIDStr)

end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 6;


	icon = "img_IEC1";
	weapon_requirement = 2;
	engine_requirement = 2;
	cpu_requirement = 2;
	recharge = 6;
	rarity = 5;
	cost = 1000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}



