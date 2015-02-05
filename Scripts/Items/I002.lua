-- I002
-- Gravflux Array - Reverses gravity for 6 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FG05",world,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	-- use of this item is primarily random
	local numEffects = world:NumAttributes("Effects")
	for i=1,numEffects do
		if world:GetAttributeAt("Effects",i).classIDStr=="FG05" then
			return 1
		end
	end
	return math.random(1,75)
end

return {  psi_requirement = 0;


	icon = "img_IS5";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 1;
	recharge = 6;
	rarity = 9;
	cost = 590;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
