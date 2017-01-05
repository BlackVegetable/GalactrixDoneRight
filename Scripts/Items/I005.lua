-- I005
-- Orbital Array - Opponent's gravity rotates constantly for 6 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FG04",world,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	-- use randomly
	--return math.random(1,85)
	local enemy = world:GetEnemy(player)
	local numEffects = enemy:NumAttributes("Effects")

	for i=1,numEffects do
		if enemy:GetAttributeAt("Effects",i).classIDStr=="FG04" then
			return 1
		end
	end
	return math.random(1,75)

end

return {  psi_requirement = 0;


	icon = "img_IS2";
	weapon_requirement = 4;
	engine_requirement = 3;
	cpu_requirement = 0;
	recharge = 8;
	rarity = 9;
	cost = 1000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;
	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
