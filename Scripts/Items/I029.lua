-- I029
-- Prismatic Beam  - Does 5 points of damage to your enemy + 2 for every 15 points in Gunnery Skill (Max +24)

local function activate(item, world, player, obj,weapon,engine,cpu)
	local bonus = math.floor(player:GetCombatStat("gunnery")/15)
	if bonus > 12 then
		bonus = 12
	end
	item:DamagePlayer(player, world:GetEnemy(player),5+(2*bonus), false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local gun = player:GetAttribute("gunnery")

	local weight = math.random(1,60)

	local bonus = math.floor(gun/15) * 5

	if bonus >= 45 then
		bonus = 45
	end
	weight = weight + bonus

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS1";
	weapon_requirement = 14;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 2;
	cost = 5000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
